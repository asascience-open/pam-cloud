# Notes and References

## Structurizr/C4


```bash
# develop and watch
cd docs/architecture
structurizr local .    # Defaults to localhost:8080
```


```bash
# export svg/png
cd docs/architecture
structurizr export --format svg --workspace ./workspace.json  --output ./images
structurizr export --format png --workspace ./workspace.json  --output ./images
```

## Mkdocs

edit mkdocs.yml
mkdocs serve
mkdocs build
mkdocs gh-deploy

## D2

```bash
cd pam-cloud/
d2_utils.sh --help
./d2_utils.sh compile-all png 
./d2_utils.sh compile-all svg
```

## Architecture Decision Records

See [adr-tools GitHub repo](https://github.com/npryce/adr-tools/tree/master) for syntax help.

```bash
# New decision
adr new Replicate makara database structure in postgres
```

```bash
# Generate table of contents
cd docs/architecture
adr generate toc -p decisions/ >! adr-decisions.md
```
