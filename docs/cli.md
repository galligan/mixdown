# Mixdown CLI

## Usage

### Commands

- `mixdown init`: scaffolds a new Mixdown project in the current repository
  - `--force`: overwrite existing files
- `mixdown create`
  - `mixdown create mix my-new-mix`: creates a new mix `my-new-mix.mxml` in `./mixdown/studio/mixes`
  - `mixdown create profile my-new-profile`: creates a new profile `my-new-profile.yaml` in `./mixdown/studio/profiles`
- `mixdown generate`: generate files to the output directory
- `mixdown render`: render mixes to the output directory
- `mixdown validate`: Lint mixes, splices, profiles, templates
- `mixdown runs`
  - `mixdown runs list`: lists all runs in the current repository
    - `--long`: include file sizes/hashes
  - `mixdown runs show <id>`: shows a run by ID
  - `mixdown runs prune`: keeps only the most recent run
    - `--dry-run`: show what would be deleted
    - `--force`: delete runs without confirmation
    - `--keep`: number of runs to keep
    - `--all`: delete all runs
- `mixdown preview`
- `mixdown diff`: show the changes between the current state and latest run
  - `--from <id>`: show the changes between the current state and a specific run
    - `--to <id>`: show the changes between two specific runs
- `mixdown plugin`
  - `mixdown plugin list`: lists all plugins in the current repository
    - `--missing`: list plugins that are referenced but not installed
  - `mixdown plugin add <name>`: adds a plugin to the current repository
  - `mixdown plugin remove <name>`: removes a plugin from the current repository
- `mixdown splice`
  - `mixdown splice list`: lists all splices in the current repository

### Utility Commands

- `mixdown audit`: audit the current repository for Mixdown files
- `mixdown upgrade`: upgrades Mixdown to the latest version
- `mixdown version`: shows the current version of Mixdown and the version of the latest release
- `mixdown docs`: opens the Mixdown documentation in the browser
- `mixdown help`: shows help for the Mixdown CLI

### Options

- `-v`, `--verbose`: output verbose logging
- `-V`, `--version`: show version
- `-q`, `--quiet`: suppress all output
- `-h`, `--help`: show help
- `--strict`: fail on warnings
- `--json`: output in JSON format
- `--debug`: output debug logging
- `--trace`: output trace logging
