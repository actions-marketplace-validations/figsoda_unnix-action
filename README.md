# unnix-action

Github action for [unnix]

### Install packages from `unnix.kdl`.

This will download [unnix] if it does not already exist in the environment.

```yaml
- uses: figsoda/unnix-action@v0.1.0
```

### Install packages from `path/to/unnix.kdl`

```yaml
- uses: figsoda/unnix-action@v0.1.0
  with:
    directory: path/to
```

### Pin unnix to a specific version

```yaml
- uses: figsoda/unnix-action@v0.1.0
  with:
    version: 0.1.0
```

[unnix]: https://github.com/figsoda/unnix
