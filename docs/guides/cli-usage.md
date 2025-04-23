# Mixdown CLI

> [!NOTE]
> This guide is a work in progress.

## Usage

Mixdown provides a command-line interface for initializing projects, managing configuration, compiling mixes into artifacts, and validating source files

## Core Commands

- `mixdown init`: Scaffolds a new Mixdown project structure (prompts/, .mixdown/config.yaml, etc.) in the current repository
  - `--force`: Overwrite existing Mixdown configuration and directories
- `mixdown build`: Compiles all .mixd files found in prompts/instructions/ into tool-specific artifacts, writing them to prompts/artifacts/builds/{build_id}/ and updating the prompts/artifacts/latest symlink
  - `--tool <tool_id>`: Build artifacts only for the specified tool(s). (Comma-separated)
  - `--mix <mix_name>`: Build artifacts only for the specified mix(es). (Comma-separated)
  - `--output <path>`: Override the default output directory (prompts/artifacts)
  - `--no-cache`: Disable build cache for this run
- `mixdown validate`: Lints .mixd files, profiles (.profile.yaml, .data.yaml), and templates (.template.mixd) for syntax errors, schema adherence, broken includes, and unknown tags/placeholders based on .mixdown/config.yaml
  - `--tool <tool_id>`: Perform tool-specific validation if supported by the provider
- `mixdown preview`: Renders the specified mix for a target tool to standard output without writing any files. Useful for debugging
  - `<mix_name>`: The name of the mix to preview
  - `--tool <tool_id>`: The tool to preview the mix for
- `mixdown create`: Helper to create new source files with basic structure
  - `mixdown create mix my-new-mix`: Creates prompts/instructions/my-new-mix.mixd
  - `mixdown create profile my-new-profile`: Creates prompts/includes/my-new-profile.profile.yaml
  - `mixdown create template my-template`: Creates prompts/templates/my-template.template.mixd
- `mixdown runs`: Commands for managing build history
  - `mixdown runs list`: Lists recent builds stored in prompts/artifacts/builds/
  - `--long`: Include file sizes/hashes
  - `mixdown runs show <build_id>`: Shows details about a specific build
  - `mixdown runs prune`: Removes older builds based on keep_builds setting in .mixdown/config.yaml
    - `--dry-run`: Show which builds would be deleted
    - `--force`: Delete builds without confirmation
    - `--keep <n>`: Override keep_builds setting for this run
    - `--all`: Delete all historical builds except latest
- `mixdown diff`: Shows changes between the working directory's potential artifacts and the latest build, or between two specific builds
  - `--tool <tool_id>`: Show diff only for a specific tool
  - `--from <build_id>`: Compare working directory against a specific build
  - `--to <build_id>`: Compare two specific builds (--from is required)
- `mixdown plugin`: Commands for managing plugin providers
  - `mixdown plugin list`: Lists discovered and configured plugin providers
    - `--missing`: List providers configured in .mixdown/config.yaml but not found
  - `mixdown plugin add <package_name>`: Adds a provider package (@mixdown/plugin-*) as a dev dependency and updates config (TBD)
  - `mixdown plugin remove <package_name>`: Removes a provider package and updates config (TBD)

## Utility Commands

- `mixdown audit`: Audits the repository for Mixdown files and potential configuration issues (TBD)
- `mixdown upgrade`: Upgrades Mixdown CLI and core packages to the latest version (TBD)
- `mixdown version`: Shows the current version of Mixdown CLI and core packages
- `mixdown docs`: Opens the Mixdown documentation website in the browser (TBD)
- `mixdown help [command]`: Shows help for the Mixdown CLI or a specific command

## Global Options

- `-v, --verbose`: Output verbose logging
- `-V, --version`: Show version number
- `-q, --quiet`: Suppress all output except errors
- `-h, --help`: Show help message
- `--strict`: Exit with non-zero code on warnings during validate or build
- `--json`: Output results in JSON format (where applicable)
- `--debug`: Output detailed debug logging
- `--trace`: Output extensive trace logging
- `--config <path>`: Specify a path to a custom config file instead of .mixdown/config.yaml
