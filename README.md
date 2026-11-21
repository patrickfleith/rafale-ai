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
uv publish           # upload to PyPI (needs a PyPI token)
```

## License

Apache License 2.0. See [LICENSE](LICENSE).
