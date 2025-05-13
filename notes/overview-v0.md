# 💽 Mixdown – v0 Overview

> *One prompt. Every tool. Zero drift.*

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Purpose \& Vision](#purpose--vision)
  - [Overview](#overview)
  - [The Problem](#the-problem)
  - [Our Solution](#our-solution)
- [Core Concepts](#core-concepts)
- [Key Features](#key-features)
  - [Mixdown-flavored Markdown](#mixdown-flavored-markdown)
  - [Compiler \& Integration](#compiler--integration)
- [Target Providers](#target-providers)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Quick Start](#quick-start)
- [Syntax Reference](#syntax-reference)
  - [Design Goals](#design-goals)
  - [Sections](#sections)
    - [Section Tag Parsing](#section-tag-parsing)
    - [Multi-line Tags for Readability](#multi-line-tags-for-readability)
    - [Section Attributes](#section-attributes)
  - [Mixdown Frontmatter](#mixdown-frontmatter)
  - [Placeholder Instructions](#placeholder-instructions)
  - [Insertions](#insertions)
  - [Links](#links)
  - [Remixes](#remixes)
    - [Remix Attributes](#remix-attributes)
  - [Whitespace Handling](#whitespace-handling)
- [Code Examples](#code-examples)
- [Directory Structure](#directory-structure)
- [Future Releases](#future-releases)
- [Appendix](#appendix)
  - [Comprehensive Attribute Reference Table](#comprehensive-attribute-reference-table)

## Purpose & Vision

### Overview

Mixdown is a **CommonMark-compliant prompt compiler** that lets you author a single *mix* file in Markdown and compile it into tool-specific instruction files (`.cursor/rules.mdc`, `./CLAUDE.md`, `.roo/rules.md`, and more). Think of it as **Terraform for AI prompts**: write once, target many, your agents, no matter the tool, on the (literal) same page.

### The Problem

- Agentic rules files are **fragmented** across IDEs and agentic tools, following different formats, and in disparate locations, leading to duplication and drift.
- Manual copy-paste workflows break **source-of-truth** guarantees and slow (or halt) experimentation with new agentic tools (that might even be better suited for the task).
- Lack of a **cohesive format for rules** hinders creation, testing, versioning…you name it.

### Our Solution

Mixdown introduces a single source-of-truth rules syntax written in pure Markdown (with a dash of specialized syntax), which is processed into tool-specific files by a compiler that:

1. Parses the mix into an AST (abstract syntax tree) to ensure a consistent format.
2. Uses **tool-specific compilers** (as plugins) to transform the AST into per-tool rules files (artifacts).
3. Writes per-tool **artifacts** to their respective locations, with the necessary filenames, formats, etc. all accounted for.

Result: *write once, render rules files for any tool, with zero drift.*

## Core Concepts

**Mix**
: Source Markdown instructions files that are compiled into tool-specific artifacts.

**Artifacts**
: Target-specific output files (e.g., `.cursor/rules/project-conventions.mdc`, `./conventions.md`, etc.) rendered from the source mix.

**Sections**
: Delimited (and reusable/repurposeable) blocks of content with optional attributes, written as Markdown-compliant 1:1 translations of XML tags (e.g., `{{instructions}}...{{/instructions}}`).

**Remix**
: Re-usable content inclusion mechanism (`{{> my-partial }}`) that can incorporate content from another mix/section/partial/template.

**Insertions**
: Dynamic values replaced inline at build time (`{{ $target }}`, `{{ $alias }}`, `{{ $.frontmatter.key }}`).

**Target**
: A supported tool (e.g. `cursor`, `windsurf`, `claude-code`), provided by plugins, which define tool-specific criteria for compiling mixes to rules files.

## Key Features

### Mixdown-flavored Markdown

- **100% Preview-able Markdown** – Renders cleanly in GitHub, VS Code, etc.; passes markdown-lint.
- **Granular Sections** – Filter sections within a single mix for per-target inclusion/exclusion.
- **Build-time Insertions** – Aliases and frontmatter data injection.

### Compiler & Integration

- **Plugin Architecture** – Add new targets via `MixdownPluginProvider` without touching core.
- **CLI & API** – `mixdown build`, `mixdown validate`, and `POST /compile` endpoint.

## Target Providers

| ID | Tool | Type |
|----|------|------|
| `cursor` | Cursor | IDE |
| `windsurf` | Windsurf | IDE |
| `claude-code` | Claude Code | CLI |
| `roo-code` | Roo Code | VS Code Extension |
| `cline` | Cline | VS Code Extension |
| `openai-codex` | OpenAI Codex | CLI |

## Getting Started

### Installation

```bash
npm install -g mixdown        # global CLI
# or project-local
npm install --save-dev mixdown
```

### Quick Start

```bash
mixdown init          # scaffolds .mixdown/ directory structure
cd .mixdown/instructions
echo "---\ndescription: Rules for this project\n---\n{{system}}Hi!{{/system}}" > my-rule.md
cd ../..

mixdown build         # writes artifacts to .mixdown/artifacts/
```

## Syntax Reference

### Design Goals

| Goal | Description |
|------|-------------|
| ✨ **Simplicity** | Reduce bespoke format/structure for each tool to just one. |
| 🧹 **Lintability** | Files must pass standard markdown-lint without hacks. |
| 👀 **Previewability** | Render legibly in GitHub, VS Code, Obsidian, etc. |
| 🧩 **Extensibility** | Advanced behaviors declared via attributes instead of new syntax. |

### Sections

Sections are the core building block of Mixdown and are a direct stand in for XML `<section>` tags. They are used to create reusable content blocks that provide clarity for agents, and can be included in other sections or mixes.

```markdown
{{instructions title="Critical Instructions" +cursor -claude-code}}
- IMPORTANT: You must follow these coding standards...
{{/instructions}}
```

- **Section Tags Syntax**:
  - **1:1 Markdown-to-XML Translation** – Write sections as `{{section-name}}` and they will render as `<section_name>` in the output.
  - **Open/Close** `{{section-name ... }}` [ section content ] `{{/section-name}}`
- **Section Tag Names**:
  - `kebab-case` is recommended for section names (to avoid accidental Markdown emphasis rendering)
  - Regardless of the naming convention, XML tag names in artifacts will render as `<snake_case>` (which is configurable)
- **Multi-line Tags** are allowed for readability, and the parser preserves this formatting:

```markdown
{{instructions
  title="Rules & Instructions"
  description="Section description."
}}
```

#### Section Tag Parsing

```markdown
<!-- Mixdown input -->
{{section-one}}
Content A
{{/section-one}}

{{section-two +* -claude-code}}
Content B
{{/section-two}}

---

Renders for all configured tools (except `claude-code` in this example) as:
<!-- XML output -->
<section-one>
Content A
</section-one>
<section-two>
Content B
</section-two>
```

While Claude Code will render as:

```markdown
<section-one>
Content A
</section-one>
```

#### Multi-line Tags for Readability

Attributes can be split across lines for readability. The parser preserves this formatting when writing XML tags:

```markdown
<!-- Multi-line section tag in Mixdown format -->
{{instructions
  title="Rules"
  \description="These are the rules for the instructions section."
}}
This is the content of the instructions section.
{{/instructions}}

<!-- Note: Including the `\` backslash prefix tells Mixdown to preserve the attribute on render -->

---

Renders as:
<!-- XML output -->
<instructions
  description="These are the rules for the instructions section.">
  This is the content of the instructions section.
</instructions>
```

#### Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `title` | string | Primary name/title for the section. |
| `description` | string | Short blurb retained in rendered XML (if allowed). |
| `+/-target` | flag | Include/exclude for specific targets (e.g., `+cursor -windsurf`). |
| `no-tag` | boolean | Skip XML wrapping. |
| `\key` | flag | Include the attribute in rendered XML. |
| *Custom* | any | Passed through untouched. |

**Using bare XML tags:**

When `allow-bare-xml-tags` is set to `true` in frontmatter or `.mixdown.config.json`, you can use bare XML tags for section names. The artifacts will be rendered verbatim, but note:

> [!WARNING]
> Bare XML tags are not valid Markdown, so Markdown previewers may be likely to render them differently or not at all.

```markdown
<!-- XML tags with `allow-bare-xml-tags` set to `true` -->
<section_name>
  ...
</section_name>

Renders as:

<section_name>
  ...
</section_name>
```

### Mixdown Frontmatter

```yaml
---
# .mixdown/instructions/my-rule.md
mixdown:
  version: 0.1.0 # optional, version number for the Mixdown format used
description: "Rules for this project" # optional, may be useful for tools that use descriptions, such as Cursor, Windsurf, etc.
globs: ["**/*.{txt,md,mdc}"] # optional, globs re-written based on target-specific needs
# Target filter examples using standard keys:
target:
  include: ["cursor", "windsurf"]
  exclude: ["claude-code"]
# Provide target-specific frontmatter which is included in their respective artifacts:
cursor:
  alwaysApply: false
windsurf:
  trigger: globs
# Add additional metadata to the mix:
name: my-rule # optional, defaults to filename
version: 2.0 # optional, version number for this file
created: 2025-05-13 # optional, date of creation, automatically included by default
updated: 2025-05-14 # optional, date of last update, automatically included by default
labels: ["core", "security"] # optional, categorization tags for the mix, available for future use
---
```

Frontmatter is used to provide metadata about the mix file and control how it's compiled. Basic frontmatter includes:

- `mixdown.version`: Metadata about the Mixdown format used
- `name`: Unique identifier for the mix (optional, defaults to filename)
- `description`: Optional description of the mix, rendered for tools that use them (e.g. Cursor, Windsurf, etc.)
- `globs`: Optional globs to be rewritten based on target-specific needs
- `target`: Control which targets receive this mix
  - Options include any target providers registered in `.mixdown.config.json`
- `version`: Version information
- `labels`: Categorization tags
- `[cursor|windsurf|claude-code|...]`: Target-specific key/value pairs

### Placeholder Instructions

When writing prompts or instructions, you can use placeholders as self-contained prompts to direct an AI to fill in. Mixdown supports both single-bracket `[placeholder text]` or single-brace `{placeholder text}` syntax.

- ✅ Do this:
  - `[requirements]`
  - `{requirements}`
- ❌ Don't do this:
  - `[[requirements]]`
  - `{{requirements}}`
  - `<requirements>`

> [!IMPORTANT]
> Remember, placeholder values should be simply considered instructions for the AI, and the output may not always be exactly what you expect. They're probabalistic, not deterministic.

Feel free to experiment with different language choice, formats, and even attributes to see what works best for your use case. Examples:

```markdown
[requirements|Title Case]
[requirements format="Title Case"]
[requirements in Title Case]
```

### Insertions

Insertions are dynamic values that are replaced inline at build time.

| Type | Syntax | Notes |
|------|--------|-------|
| **Alias** | `{{ $name }}` | Alias lookup in `.mixdown.config.json` under `aliases` key. |
| **Frontmatter value** | `{{ $.key }}` | Access values from thecurrent file's frontmatter. |

**Built-in System Insertions**:

- `{{ $target }}` → current target ID in kebab-case (`cursor`, `claude-code`, etc.)
- `{{ $target.name }}` → display name from the provider manifest (e.g. `Cursor`, `Claude Code`, etc.)

**Raw Output:** 

Triple-brace `{{{...}}}` to skip processing of the content and render it in the raw Mixdown syntax.

- This is useful for writing documentation or rules that need to show Mixdown-flavored Markdown (mix.md) literally
- Wrapping a section in triple curly braces preserves all Mixdown syntax and content exactly as written
- Example:

```markdown
{{{example no-tag +cursor}}}
  {{instructions}}
{{{/example}}}
```

### Links

Standard Markdown links work as expected:

- Regular links: `[Text](url)`
- Links to other mix files: `[Text](other-mix.md)`
- Links to project files: `[Text](/path/to/file.js)`

You can also use the Mixdown link syntax:

```markdown
{{link mix-name}}
{{link ["Link Title"] mix-name}}
```

### Remixes

Remixes allow you to embed reusable content (partials), mixes, or mix sections in rendered artifacts. They are denoted by the `{{> ...}}` syntax.

```markdown
<!-- Embed /_partials/legal.md -->
{{> _legal}} or {{> _partials/legal}}

<!-- Embed a specific section from the `conventions.md` mix file -->
{{> conventions#section-name}}

<!-- Embed a section from within the existing file -->
{{> #section-name}}

<!-- Remix a mix with multiple specific sections -->
{{> my-rules sections="section-name,!section-name-to-exclude"}}
```

#### Remix Attributes

| Attribute | Purpose |
|-----------|---------|
| `sections` | Filter specific sections with include/exclude pattern. |
| Other section attributes | All section attributes can be applied to remixes. |

### Whitespace Handling

Mixdown has specific rules for whitespace to ensure consistent parsing and output:

- Space after opening `{{` and before closing `}}` is optional
  - Example: `{{instructions}}` is equivalent to `{{ instructions }}`
- Attributes must be separated by spaces or newlines
- No spaces are allowed around the `=` sign in attribute declarations
- Whitespace adjacent to brackets is removed on render, while new lines are preserved

## Code Examples
<!-- TODO: Pick up from here -->
**Section with attributes:**

```markdown
{{instructions \title="Core Rules" +cursor -windsurf}}
All code must follow consistent formatting.

Testing is required for all new features.
{{/instructions}}
```

**Remixing content:**

```markdown
{{> _partials/coding-standards}}

{{> mix-file#specific-section}}
```

**Using insertions:**

```markdown
Project: {{ $project }}
Version: {{ $.version }}
```

**Using raw output:**

```markdown
{{{example no-tag}}}
To include a section in Mixdown use: {{section-name}}
{{{/example}}}
```

## Directory Structure

```text
project/
├── .mixdown/
│   ├── artifacts/
│   │   └── builds/         # compiled outputs
│   ├── instructions/       # Mix files (*.md)
│   │   └── _partials/      # reusable content
│   └── mixdown.config.json # compiler config
```

## Future Releases

Features planned for v0.x releases:

- Self-closing section tags (`{{section-name ... /}}`)
- Target groups for easier filtering of multiple targets
- Template support with placeholder filling
- Mode support for tools like Roo Code
- Slash command support for Claude Code
- Strict mode for validation
- Data insertions with YAML data files
- Advanced title/heading handling with modifiers

## Appendix

### Comprehensive Attribute Reference Table

The following table provides a complete list of all supported attributes in Mixdown v0:

| Attribute            | Type    | Default    | Section | Remix | Frontmatter | Description |
|----------------------|---------|------------|---------|-------|--------------|-------------|
| `name`               | string  | none       | ✅      | ✅    | ✅           | Name or identifier (frontmatter: mix identifier, required) |
| `title`              | string  | none       | ✅      | ❌    | ❌           | Title for the section |
| `description`        | string  | none       | ✅      | ❌    | ✅           | Short description of content |
| `+/-target`          | flag    | none       | ✅      | ✅    | ❌           | Include/exclude for specific targets |
| `\key`               | flag    | none       | ✅      | ✅    | ❌           | Include attribute in rendered XML |
| `no-tag`            | boolean | false      | ✅      | ✅    | ❌           | Skip XML tag wrapping |
| `allow-bare-xml-tags`| boolean | false      | ❌      | ❌    | ✅           | Allow using bare XML tags |
| `sections`           | list    | none       | ❌      | ✅    | ❌           | Filter specific sections in remixes |
| `version`            | string  | none       | ❌      | ❌    | ✅           | Mix version |
| `labels`             | array   | `[]`       | ❌      | ❌    | ✅           | Categorization tags |
| `targets.include`    | array   | `[]`       | ❌      | ❌    | ✅           | Target inclusion list |
| `targets.exclude`    | array   | `[]`       | ❌      | ❌    | ✅           | Target exclusion list |
| `globs`              | array   | `[]`       | ✅      | ❌    | ✅           | File patterns for tool-specific support |
| `alwaysApply`        | boolean | false      | ✅      | ❌    | ✅           | Whether rule should always be applied |

**Notes:**

- All string attributes can be target-scoped with `+target?key="value"` syntax
- Frontmatter target blocks override global values (e.g., `cursor: { description: "..." }`)
- The `\key` flag specifically indicates that the attribute should be included in the XML output

*© 2025 Mixdown contributors – MIT License.*