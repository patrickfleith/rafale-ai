# rafale-ai

AI for defense.

## Install

```bash
pip install rafale-ai
```

## Development

```bash
uv sync              # create .venv and install dev dependencies
uv run pytest        # run tests
uv run ruff check .  # lint
uv build             # build sdist + wheel into dist/
```

## Automatic releases

Every pull request merged into `main` runs `.github/workflows/release.yml`.
The workflow bumps the patch version (for example, `0.1.0` → `0.1.1`), updates
`pyproject.toml` and `uv.lock`, runs lint and tests, and builds the wheel and source
distribution. It pushes a release commit and a `vX.Y.Z` tag, then publishes to PyPI
with the official PyPA publishing action and provenance attestations.
Closed, unmerged PRs and direct pushes do not create releases. Release runs queue
so that closely spaced merges each receive a version bump (up to GitHub's limit
of 100 pending runs).

Before merging the workflow into `main`, configure:

1. A GitHub environment named `pypi`, restricted to `main`. Leave required
   reviewers disabled if publishing should be fully automatic.
2. A [PyPI Trusted Publisher](https://docs.pypi.org/trusted-publishers/adding-a-publisher/)
   for `rafale-ai` with owner `patrickfleith`, repository `rafale-ai`, workflow
   filename `release.yml`, and environment `pypi`. If the project does not exist
   yet, create a pending publisher through your PyPI account's Publishing page.
   No PyPI API token or repository secret is needed.
3. Repository rules that allow `github-actions[bot]` to push release commits to
   `main` and create `v*` tags. Rules requiring PRs, signed commits, or checks on
   every push must permit the release automation, or the release will fail.

If a release fails, fix the cause and rerun the failed workflow in GitHub Actions.
An existing release commit is reused without another bump; files already
on PyPI are skipped. If a concurrent merge caused the atomic push to fail, rerunning
recomputes the version from the latest `main`. The workflow checks out only merged
code from `main`, including when the PR originated from a fork.

## License

Apache License 2.0. See [LICENSE](LICENSE).
