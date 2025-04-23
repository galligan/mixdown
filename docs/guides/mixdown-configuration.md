# Mixdown Configuration Guide

## Introduction

`mixdown.config.yaml` is the single place where you tell Mixdown:

- Where your source prompts live
- How build artifacts are stored & named
- The filename conventions you prefer (labels, path prefixes)
- Which tool‑providers (plugins) are active and how they should write files

If you never touch the file, Mixdown works with sane defaults. This guide explains what each block does so you can tune things as your project grows.

---

## Table of contents

- [Introduction](#introduction)
- [Table of contents](#table-of-contents)
- [1. File location](#1-file-location)
- [2. High‑level structure](#2-highlevel-structure)
- [3. Project block](#3-project-block)
- [4. Aliases](#4-aliases)
- [5. `mixdown:` — directories \& builds](#5-mixdown-directories--builds)
  - [How paths resolve](#how-paths-resolve)
- [6. Naming conventions](#6-naming-conventions)
  - [Path affix (directory names → filename)](#path-affix-directory-names--filename)
  - [Label affix (from `labels:` array in a mix)](#label-affix-from-labels-array-in-a-mix)
- [7. Developer settings (`dev:`)](#7-developer-settings-dev)
- [8. Runtime includes](#8-runtime-includes)
- [9. Plugins](#9-plugins)
  - [Disabling a provider temporarily](#disabling-a-provider-temporarily)
- [10. Mix‑level overrides (quick recap)](#10-mixlevel-overrides-quick-recap)
- [11. Common recipes](#11-common-recipes)
- [12. Troubleshooting checklist](#12-troubleshooting-checklist)

---

## 1. File location

```txt
project‑root/
├─ prompts/               # instructions/, includes/, templates/ …
└─ prompts/mixdown.config.yaml   ← you are here
```

All paths in the YAML are **project‑relative** unless noted otherwise.

## 2. High‑level structure

```yaml
project:        # human‑readable project metadata
mixdown:        # directories, build lifecycle, naming rules
dev:            # validator, cache, CI, telemetry
includes:       # runtime helper commands
aliases:        # text snippets you can inject in mixes
plugins:        # discovery paths + per‑tool overrides
```

> [!TIP]
> Mixdown merges settings in three layers
> *global (this file) ← plugin block ← mix file override*
> so a mix author can always take control for a one‑off rule.

## 3. Project block

```yaml
project:
  name: mixdown-demo
  default_tools: ["cursor", "claude-code"]   # used if a mix omits include/exclude
  default_output_type: rule                  # rule | command | prompt
```

*You rarely need to touch this once set.*

## 4. Aliases

```yaml
aliases:
  legal:   "[include:project.legal]"
  privacy: "[include:project.privacy]"
```

Inside a mix: `$[alias:legal]`

## 5. `mixdown:` — directories & builds

```yaml
mixdown:
  source_dir: prompts                 # where instructions/ lives
  public_dir: artifacts               # prompts/artifacts/
  builds_dir: builds                  # prompts/artifacts/builds/

  keep_builds: 7                      # keep last 7 builds; 0 = keep all
  build_pattern: "yyyyMMdd-HHmmss'Z'" # timestamp format for build folder
  symlink_mode: latest                # none | latest | all

  reports:
    keep_reports: true                # generate JSON report for every build
    dir: .mixdown/reports
```

### How paths resolve

```text
build_store = prompts/artifacts/builds/{timestamp}/
latest_link = prompts/artifacts/latest → build_store
report.json = .mixdown/reports/{timestamp}.json
```

## 6. Naming conventions

### Path affix (directory names → filename)

```yaml
mixdown:
  naming:
    path_affix:
      depth: 0            # 0 = off, 1 = last dir, 2 = last‑2 …
      placement: prefix   # prefix | suffix
      separator: "-"      # "-" | "_" | "."
```

> [!TIP]
> **Example**: `prompts/instructions/docs/api/auth.mixd` + depth 1 → **`api-auth.mdc`**

### Label affix (from `labels:` array in a mix)

```yaml
mixdown:
  naming:
    label_affix:
      scope: all          # all | first | last | 2,3…
      placement: suffix
      separator: "-"
```

> [!TIP]
> **Example**: `labels: [prod, v2]` + suffix → **`auth-prod-v2.mdc`**

## 7. Developer settings (`dev:`)

```yaml
dev:
  validator:
    strict: false
    ignore_unknown_tags: true
    lint_placeholders: true

  cache:
    enabled: true
    dir: .mixdown/cache
    checksum_algo: sha256

  ci:
    fail_on_output_diff: true
    diff_base: origin/main

  telemetry:
    enabled: false         # override in CI:  MIXDOWN_TELEMETRY=1
```

## 8. Runtime includes

```yaml
includes:
  runtime:
    enabled: true
    allow_shell_exec: false
    builtins:
      git_branch: 'git rev-parse --abbrev-ref HEAD'
      package_version: "node -p \"require(\'./package.json\').version\""
      random_uuid: uuidgen
```

Use in any mix: `$[include:@git_branch]`.

## 9. Plugins

```yaml
plugins:
  search_paths:
    - ../node_modules
    - ../packages

  "@mixdown/plugin-cursor":
    dir: .cursor
    types:
      rule:
        output:
          dir: rules
          extension: mdc
        path_affix:              # override global naming for Cursor only
          depth: 1

  "@mixdown/plugin-claude-code":
    dir: .
    types:
      rule:
        single_file: CLAUDE.md   # single‑file tools ignore naming affixes
```

### Disabling a provider temporarily

```yaml
"@mixdown/plugin-roo-code":
  enabled: false
```

## 10. Mix‑level overrides (quick recap)

```yaml
---
labels: [docs, api]

cursor:
  path_affix:
    depth: 1
  label_affix:
    placement: prefix            # api-docs-auth.mdc
---
```

## 11. Common recipes

- **Rename Cursor rules folder**

  ```yaml
  "@mixdown/plugin-cursor":
    types:
      rule:
        output:
          dir: instructions
  ```

- **Mirror `prompts/instructions/` sub‑dirs into single‑file tools**
  - Set `path_affix.depth: 1` globally.
- **Turn off all label prefixes**
  - `mixdown.naming.label_affix.scope: 0` *or* delete the block.
- **Disable path affix just for Roo**

  ```yaml
  "@mixdown/plugin-roo-code":
    types:
      mode_rule:
        path_affix: false
  ```

## 12. Troubleshooting checklist

1. **Filename collision** – Mixdown warns if two mixes resolve to the same output path for a tool.
2. **Unknown XML tags** – set `validator.ignore_unknown_tags: true` while experimenting.
3. **Symlink issues on Windows** – use `symlink_mode: none` or run terminal as Admin.

The defaults get most teams shipping in minutes.  **Customize only what you need**, commit the file to version control, and every developer or CI runner will build identical prompt artifacts. Happy mixing 💽!
