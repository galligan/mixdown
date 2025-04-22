# Refactor Diff Summary

This document summarizes code changes between commit `dd7bb45` (docs: add mvp documentation) and HEAD, ordered by quantity of line changes.

## README.md (267 changes)

```diff
diff --git a/README.md b/README.md
index f0fb400..cd025fd 100644
--- a/README.md
+++ b/README.md
@@ -11,6 +11,8 @@ Well, if you're reading this, you're probably already familiar with at least one
 
 The problem is, they all have different formats, behavior, and capabilities, which can become a huge
 pain to manage. This can be frustrating, and might even lead you to just sticking to one tool. But that's no fun, and you'll be missing out on all the awesome capabilities and differences each tool has to offer! That's where Mixdown comes in…
 
+**Terminology note**: Mixdown uses the term **artifact** to mean the concrete file(s) it emits for each target tool (Cursor rules, Claude commands, etc.). You'll find them in `prompts/artifacts/`.
+
 With Mixdown, you can apply the "Don't Repeat Yourself" principle to your agentic code tools' rules files, instructions, etc. Instead of writing slightly different versions of the same instructions for each tool, you create a single "mix" file. A mix is the "gold master" for your instructions, from which individual tool-specific files are created in their respective format, to the appropriate places, etc.
 
 <!-- TODO: Maybe consider this as an alternative -->
@@ -19,22 +21,19 @@ Mixdown is "Terraform for AI prompts": declare your ideal prompt rules once, tar
 
 ## What's with the name?
 
-We borrowed "Mixdown" from the music product world because it nails the vibe so well. Think of a mixdown as the moment a song stops being a pile of takes and starts being the version everyone hears. That's what this toolbox does for prompt engineering: it fuses disparate rules into one golden master, then automatically "bounces" the perfect format for Cursor, Windsurf, Claude Code, and beyond.
-
-Many of the functions & features of Mixdown are inspired by terms used in music production, both because of some overlap in the concepts (remixing, sampling, etc.) and because it's, well, fun. Look for the 💽 emoji throughout the docs to see why a term was picked.
+We borrowed "Mixdown" from the music product world because it nails the vibe so well. Think of a mixdown as the moment a song stops being a pile of takes and starts being the version everyone hears. That's what this toolbox does for prompt engineering: it fuses disparate rules into one golden master, then automatically generates the perfect format for Cursor, Windsurf, Claude Code, and beyond.
 
 ### Mixdown Supported Tools
 
-- IDEs
-  - [Cursor](https://www.cursor.com/)
-  - [Windsurf](https://windsurf.dev/)
-- VS Code Extensions
-  - [Roo Code](https://roocode.dev/)
-  - [Cline](https://cline.dev/)
-- Terminal-based tools
-  - [Aider](https://aider.chat/)
-  - [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
-  - [OpenAI Codex](https://github.com/openai/codex)
+| 🚦 | Tool ID | Tool Name | Type | Status |
+|---------|---------|------|------|--------|
+| ✅ | `cursor` | [Cursor](https://www.cursor.com/) | IDE | Supported |
+| 🟡 | `claude-code` | [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) | Terminal-based tool | In Progress |
+| 🟡 | `cline` | [Cline](https://cline.dev/) | VS Code Extension | In Progress |
+| 🟡 | `roo-code` | [Roo Code](https://roocode.dev/) | VS Code Extension | In Progress |
+| 🔵 | `aider` | [Aider](https://aider.chat/) | Terminal-based tool | Planned |
+| 🔵 | `openai-codex` | [OpenAI Codex](https://github.com/openai/codex) | Terminal-based tool | Planned |
+| 🔵 | `windsurf` | [Windsurf](https://windsurf.dev/) | IDE | Planned |
```

And many more changes throughout the document updating terminology and reorganizing project structure information.

- **288752e** - docs: update to more generic terminology
- **2df901d** - docs(readme): update output terminology

## docs/config.md (255 changes)

```diff
diff --git a/docs/config.md b/docs/config.md
new file mode 100644
index 0000000..1c9d2a8
--- /dev/null
+++ b/docs/config.md
@@ -0,0 +1,255 @@
+# Mixdown Configuration Guide
+
+## Introduction
+
+`mixdown.config.yaml` is the single place where you tell Mixdown:
+
+- Where your source prompts live
+- How build artifacts are stored & named
+- The filename conventions you prefer (labels, path prefixes)
+- Which tool‑providers (plugins) are active and how they should write files
+
+If you never touch the file, Mixdown works with sane defaults. This guide explains what each block does so you can tune things as your project grows.
+
+---
+
+## Table of contents
+
+- [Introduction](#introduction)
+- [Table of contents](#table-of-contents)
+- [1. File location](#1-file-location)
+- [2. High‑level structure](#2-highlevel-structure)
+- [3. Project block](#3-project-block)
+- [4. Aliases](#4-aliases)
+- [5. `mixdown:` — directories \& builds](#5-mixdown-directories--builds)
+  - [How paths resolve](#how-paths-resolve)
+- [6. Naming conventions](#6-naming-conventions)
+  - [Path affix (directory names → filename)](#path-affix-directory-names--filename)
+  - [Label affix (from `labels:` array in a mix)](#label-affix-from-labels-array-in-a-mix)
+- [7. Developer settings (`dev:`)](#7-developer-settings-dev)
+- [8. Runtime includes](#8-runtime-includes)
+- [9. Plugins](#9-plugins)
+  - [Disabling a provider temporarily](#disabling-a-provider-temporarily)
+- [10. Mix‑level overrides (quick recap)](#10-mixlevel-overrides-quick-recap)
+- [11. Common recipes](#11-common-recipes)
+- [12. Troubleshooting checklist](#12-troubleshooting-checklist)
```

This is a completely new file that provides comprehensive documentation for the configuration system.

- **f8605e8** - feat(config): relocate, improve, document changes to config

## .mixdown/config.yaml (129 changes)

```diff
diff --git a/.mixdown/config.yaml b/.mixdown/config.yaml
new file mode 100644
index 0000000..df76557
--- /dev/null
+++ b/.mixdown/config.yaml
@@ -0,0 +1,129 @@
+# prompts/mixdown.config.yaml
+# -------------------------------------------------------------------
+# Global settings for the Mixdown compiler / CLI.
+# Most keys are optional; uncomment / tweak as your repo evolves.
+# -------------------------------------------------------------------
+
+# ---------- project configuration ------------------------------------
+project:
+  name: mixdown
+  default_tools: ["cursor", "windsurf", "claude-code"] # fallback if a mix omits include/exclude
+  default_output_type: rule                            # "rule" | "command" | "prompt"
+
+# ---------- aliases --------------------------------------------------
+  aliases:                        # expands the value when $[alias] is used
+    legal: "[include:project.legal]" # injects the value for the `legal` key in the `project` profile
+    privacy: "[include:project.privacy]"
+
+# ---------- Mixdown configuration ------------------------------------
+mixdown:
+
+  # ---------- directory layout ---------------------------------------
+  source_dir: prompts           # root directory that contains instructions, includes, templates, etc.
+  public_dir: artifacts         # where artifacts are stored (relative to source_dir)
+  builds_dir: builds            # where build artifacts are stored (relative to public_dir)
+  # The CLI will resolve:
+  #   build_store = path.join(source_dir, public_dir, builds_dir)
+  #   latest_link = path.join(source_dir, public_dir, "latest")
```

This is a new configuration file that replaces the old one, with a more structured and comprehensive approach.

- **f8605e8** - feat(config): relocate, improve, document changes to config

## .mixdown/studio/config.yaml (54 changes)

```diff
diff --git a/.mixdown/studio/config.yaml b/.mixdown/studio/config.yaml
deleted file mode 100644
index 45a7858..0000000
--- a/.mixdown/studio/config.yaml
+++ /dev/null
@@ -1,54 +0,0 @@
-# .mixdown/studio/config.yaml
-# -------------------------------------------------------------------
-# Global settings for the Mixdown compiler / CLI.
-# Most keys are optional; uncomment / tweak as your repo evolves.
-# -------------------------------------------------------------------
-
-project:
-  name:               "mixdown"
-  default_toolset:    ["cursor", "windsurf", "claude-code"]  # fallback if a mix omits include/exclude
-  default_output_type: "rule"                                # "rule" | "command"
-
-output:
-  root:     "../output"       # relative to this config file (kept git‑ignored)
-  runs_dir: "runs"            # sub‑folder containing immutable snapshots
-  keep_runs: 7                # garbage‑collect older runs; 0 = keep all
-  dir_pattern: "yyyy-MM-dd'T'HH-mm-ss'Z'"  # run‑id naming (use 'run-{hash}' if preferred)
-  symlink_latest: true        # write/update 'latest' → runs/<id> symlink
-  keep_reports: true          # still write runs/<id>/report.json even in --dry-run
-
-validator:
-  strict: false               # true = fail build on any warning
-  ignore_unknown_tags: false  # true = allow custom XML tags without schema update
-  lint_placeholders: true     # warn on missing or malformed [...]/$[...] placeholders
```

This file was completely removed as part of the configuration reorganization.

- **f8605e8** - feat(config): relocate, improve, document changes to config

## File Renames/Relocations (0 content changes)

The following files were renamed or relocated without content changes:

- **0455c40** - chore(templates): relocate and rename templates
  - Templates moved to prompts/templates/ with .template.mixd extension
  - Affected: code-review, implementation-plan, plan, security-report, thoughts templates
- **c8dfcf1** - chore(profiles): relocate and rename profiles
  - Profiles moved from .mixdown/studio/profiles/ to prompts/includes/ with .profile.yaml extension
  - Affected: org, project, user profiles
- **646eb89** - chore: relocate and rename sample rules
  - Sample rules moved from .mixdown/studio/mixes/ to prompts/instructions/
  - Affected: my-rule.mxml, sample-core-coding-guidelines.mxml 