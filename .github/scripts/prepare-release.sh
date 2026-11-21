#!/usr/bin/env bash
set -euo pipefail

: "${PR_NUMBER:?PR_NUMBER must identify the merged pull request}"
[[ "$PR_NUMBER" =~ ^[0-9]+$ ]] || { echo "Invalid PR_NUMBER" >&2; exit 1; }

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git fetch origin main --tags

# A committed trailer makes reruns reuse this PR's release, even after newer releases.
release_commit=$(git log origin/main --format=%H -1 --grep="^Release-PR: ${PR_NUMBER}$")
if [[ -n "$release_commit" ]]; then
    git checkout --detach "$release_commit"
else
    git checkout -B main origin/main
    uv version --bump patch
    git add pyproject.toml uv.lock
    version=$(uv version --short)
    git commit -m "chore(release): v${version}" -m "Release-PR: ${PR_NUMBER}"
fi

version=$(uv version --short)
tag="v${version}"

uv sync --locked
uv run --locked ruff check .
uv run --locked pytest
# Use the release commit timestamp for reproducible builds on reruns.
export SOURCE_DATE_EPOCH
SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)
uv build

if [[ -z "$release_commit" ]]; then
    git tag "$tag"
    # Both refs succeed together. If main advanced, rerun the failed workflow.
    git push --atomic origin HEAD:refs/heads/main "refs/tags/${tag}"
else
    test "$(git rev-parse "${tag}^{commit}")" = "$release_commit"
fi
