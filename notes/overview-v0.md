# 💽 Mixdown – v0 Overview

> *Write prompts once, render tool-specific rules, zero drift.*

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Purpose \& Vision](#purpose--vision)
  - [Overview](#overview)
  - [The Problem](#the-problem)
  - [Our Solution](#our-solution)
- [Core Concepts](#core-concepts)
- [Key Features](#key-features)
  - [Mixdown Syntax](#mixdown-syntax)
  - [Compiler \& Integration](#compiler--integration)
- [Target Providers](#target-providers)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Quick Start](#quick-start)
- [Syntax Reference](#syntax-reference)
  - [Design Goals](#design-goals)
  - [Sections](#sections)
    - [Section Tags Syntax](#section-tags-syntax)
    - [Section Tag Names](#section-tag-names)
    - [Section Tag Parsing](#section-tag-parsing)
    - [Target-scoped attribute overrides](#target-scoped-attribute-overrides)
    - [Multi-line Tags for Readability](#multi-line-tags-for-readability)
    - [Section Attributes](#section-attributes)
    - [Rendered Content](#rendered-content)
    - [Using bare XML tags](#using-bare-xml-tags)
  - [Mixdown Frontmatter](#mixdown-frontmatter)
  - [Links](#links)
    - [External \& Mixdown File Internal Links](#external--mixdown-file-internal-links)
    - [Linking to Project Files](#linking-to-project-files)
  - [Insertions](#insertions)
  - [Remixes](#remixes)
    - [Remix Attributes](#remix-attributes)
  - [Remixes vs. Inclusions](#remixes-vs-inclusions)
  - [Stems](#stems)
  - [Rendering Raw Mixdown Syntax](#rendering-raw-mixdown-syntax)
  - [Instruction Placeholders](#instruction-placeholders)
    - [Placeholder Formatting](#placeholder-formatting)
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
2. Uses **tool-specific compilers** (as plugins) to transform the AST into per-tool rules files (records).
3. Writes per-tool **records** to their respective locations, with the necessary filenames, formats, etc. all accounted for.

Result: *Write prompts once, render tool-specific rules, zero drift.*

## Core Concepts

- **Mix**
  - Source instruction files, written in 100% previewable Markdown.
  - Written in Mixdown Syntax and use `{{...}}` tags to direct the compiler.
  - Compiled into tool-specific rules files:
    - `./mixdown/instructions/my-rule.md` → `.cursor/rules/my-rule.mdc`
- **Target**
  - A supported tool, such as `cursor`, `windsurf`, or `claude-code`.
  - Defines tool-specific criteria for compiling mixes to rules files.
  - Provided through plugins.
- **Record**
  - Target-specific (tool) output files, rendered from the source mix.
  - Examples for a mix called `project-conventions.md`:
    - Cursor → `.cursor/rules/project-conventions.mdc`
    - Claude Code → `./CLAUDE.md#project-conventions`
    - OpenAI Codex → `./conventions.md`.
- **Tag**
  - Syntax: `{{...}}`
  - Used throughout Mixdown to direct the compiler.
  - Similar to `<xml-tags>`, but fully Markdown-previewable.
- **Section**
  - Syntax: `{{instructions}}...{{/instructions}}`
  - Delimited, reusable blocks of content with optional attributes.
  - 1:1 translations of XML tags, but readable in Markdown previewers
    - `{{instructions}}` → `<instructions>`
- **Remix**
  - Syntax: `{{> my-rule }}`
  - Embed content from another mix, section, stem, or template.
- **Insertion**
  - Syntax: `{{$key}}` or `$key` if used within a `{{...}}` tag.
  - Dynamic values replaced inline at build time.
  - Examples: `{{$target}}`, `{{$.frontmatter.key}}`, `{{$alias}}`

## Key Features

### Mixdown Syntax

- **100% Preview-able Markdown:** Renders cleanly in GitHub, VS Code, etc.; passes markdown-lint.
- **Granular Sections:** Filter sections within a single mix for per-target inclusion/exclusion.
- **Build-time Insertions:** Aliases and frontmatter data injection.

### Compiler & Integration

- **Plugin Architecture:** Add new targets via `MixdownPluginProvider` without touching core.
- **CLI & API:** `mixdown build`, `mixdown validate`, and `POST /compile` endpoint.

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
npm install -g @mixdown/cli        # global CLI
# project-local
npm install --save-dev @mixdown
# or with the CLI
npx @mixdown/cli init
```

### Quick Start

```bash
mixdown init      # scaffolds .mixdown/ directory structure

mixdown import    # imports existing rules files into the mixdown format

mixdown build     # writes records to .mixdown/records/
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
{{instructions +cursor -claude-code}}
- IMPORTANT: You must follow these coding standards...
{{/instructions}}
```

#### Section Tags Syntax

- **1:1 Markdown-to-XML Translation**: Write sections as `{{section-name}}` and they will be converted to `<section_name>` in the output.
- **Open/Close** `{{section-name ... }}` [ section content ] `{{/section-name}}`

#### Section Tag Names

- `kebab-case` is recommended for section names (to avoid accidental Markdown emphasis rendering)
- Regardless of the naming convention, XML tag names in records will be formatted as `<snake_case>` (which is configurable)

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

Output for all configured tools (except `claude-code` in this example):
<!-- XML output -->
<section-one>
Content A
</section-one>
<section-two>
Content B
</section-two>
```

While Claude Code output will be:

```markdown
<section-one>
Content A
</section-one>
```

#### Target-scoped attribute overrides

Any string attribute can be given a per-target override by suffixing the target ID with a **`?`** delimiter:

```markdown
{{instructions cursor?name="cursor_instructions"}}
...
{{/instructions}}
```

In this example the section will use the name "cursor_instructions" when compiled for the *cursor* target. The same pattern works with groups once they arrive (e.g. `ide?name="ide_instructions"`).

Note: You can also use the `+target` syntax to both include the section for specific targets *and* apply target-specific overrides.

#### Multi-line Tags for Readability

Attributes can be split across lines for readability. The parser preserves this formatting when writing XML tags:

```markdown
<!-- Multi-line section tag in Mixdown format -->

{{instructions
  \name="important_rules"
}}
This is the content of the instructions section.
{{/instructions}}

<!-- Note: Including the `\` backslash prefix tells
  Mixdown to preserve the attribute on render -->

---

Output:
<instructions
  name="important_rules">
  This is the content of the instructions section.
</instructions>
```

#### Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `+/-target` | flag | Include/exclude for specific targets (e.g., `+cursor -windsurf`). |
| `\key` | flag | Include the attribute in rendered XML. |
| `rendered` | string | Controls how content is processed and displayed (see [Rendered Content](#rendered-content) below). |
| *Custom* | any | Passed through untouched. |

#### Rendered Content

The `rendered` attribute provides flexible control over how content is formatted in the final output. This attribute is available for sections, remixes, and inclusions.

```markdown
{{instructions rendered="unwrapped"}}
Content without surrounding XML tags
{{/instructions}}

{{> conventions#style-guide rendered="inline"}}

{{> @code-example rendered="code:javascript"}}
```

**Rendered Attribute Values:**

| Value | Description |
|-------|-------------|
| `default` | Normal rendering with XML tags (default behavior) |
| `unwrapped` | No XML tags (equivalent to former `no-tag=true`) |
| `inline` | Content rendered inline (preserves formatting otherwise) useful with [stems](#stems) |
| `raw` | Render everything as raw Mixdown syntax |
| `raw:content` | Only render content as raw, process tags normally |
| `raw:tags` | Only render tags as raw, process content normally |
| `code[:language]` | Render content as a code block in the specified language |

Multiple values can be combined with commas where compatible:

```markdown
{{instructions rendered="unwrapped,inline"}}
This content will appear without tags and inline
{{/instructions}}
```

**Rendering as Code Blocks:**

The `code[:language]` value renders content as a code block in the specified language. For example:

```markdown
{{section rendered="code:javascript"}}
function hello() {
  console.log("Hello, world!");
}
{{/section}}
```

When used with stems, if the language is omitted (`rendered="code"`), the system will automatically determine the language based on the stem file's extension:

```markdown
{{> @my-script.js rendered="code"}}
<!-- Will output as JavaScript code block -->

{{> @styles.css rendered="code"}}
<!-- Will output as CSS code block -->
```

If the file extension is not recognized (and isn't a `.md` file), it will default to `txt`. Explicitly specifying a language will always override the automatic detection:

```markdown
{{> @config.json rendered="code:yaml"}}
<!-- Will output as YAML code block despite being a JSON file -->
```

#### Using bare XML tags

> [!WARNING]
> Bare XML tags are not valid Markdown, so Markdown previewers may be likely to render them differently or not at all.

When `allow-bare-xml-tags` is set to `true` in frontmatter or `.mixdown.config.json`, you can use bare XML tags for section names. The records will be rendered verbatim, but note:

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
  path: "./custom/output/path"
# Provide target-specific frontmatter which is included in their respective records:
cursor:
  alwaysApply: false
  target:
    path: "./custom/.cursor/rules"
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
- `target`: Control how this mix is processed for targets
  - `include`/`exclude`: Control which targets receive this mix
  - `path`: Specify a custom output path for records
  - Options include any target providers registered in `.mixdown.config.json`
- `version`: Version information
- `labels`: Categorization tags
- `[cursor|windsurf|claude-code|...]`: Target-specific key/value pairs
  - Can include `target.path` to override the global path for specific targets

### Links

#### External & Mixdown File Internal Links

Standard Markdown links work as expected external links, and links to other mix files:

- Regular links: `[Text](url)`
- Links to other mix files: `[Text](other-mix.md)`

Mixdown also provides a `{{link}}` tag to allow for more expressive link syntax.

```markdown
{{link mix-name}}
{{link ["Link Title"] mix-name}}
```

> [!NOTE]
> Standard Markdown links will work in previews as expected within the `.mixdown/instructions` directory, but `{{link ...}}` will not.

#### Linking to Project Files

Linking to project files is done with with the link tag and a relative path to the project root, starting with a `/`:

```markdown
{{link ["Link Title"] /path/to/file.ts}}

The above will render as a link relative to the compiled record's directory. For example, if the compiled record is written to `.cursor/rules/project-conventions.mdc`, the link will be rendered as:

[Link Title](../../path/to/file/.ts)
```

### Insertions

Insertions are dynamic values using the `{{$...}}` syntax. They are replaced inline at build time.

| Type | Syntax | Notes |
|------|--------|-------|
| **Alias** | `{{$key}}` | Alias lookup in `.mixdown.config.json` under `aliases` key. |
| **Frontmatter value** | `{{$.key}}` | Access values from thecurrent file's frontmatter. |
| **Target** | `{{$target}}` or `{{$target.id}}` | Display name from the provider manifest (e.g. `Cursor`, `Claude Code`). The current target ID in kebab-case can be accessed by adding `.id` to the end (`cursor`, `claude-code`, etc.) |

**Built-in System Insertions**:

- `{{$target}}` → display name from the provider manifest (e.g. `Cursor`, `Claude Code`, etc.)
- `{{$target.id}}` → current target ID in kebab-case (`cursor`, `claude-code`, etc.)

### Remixes

Remixes allow you to reuse content across multiple mixes by embedding mixes, sections within a mix, or stems into rendered records. They are denoted by the `{{> ...}}` syntax.

```markdown
<!-- Embeds `/_stems/legal.md` -->
{{> @legal}}

<!-- Embed a specific section from the `conventions.md` mix file -->
{{> conventions#section-name}}

<!-- Embed a section from within the existing file -->
{{> #section-name}}

<!-- Remix a mix with multiple specific sections -->
{{> my-rules sections="section-name,!section-name-to-exclude"}}
```

Example:

Let's say that we have a mix file called `conventions.md` that contains a section called `style-guide`. We can remix it into another mix file called `my-rules.md` and include only the `style-guide` section:

```markdown
<!-- my-rules.md -->
Important: Be sure to follow the style guide:

{{> conventions#style-guide}}

---

The above will render as:

Important: Be sure to follow the style guide:

<style_guide>
  ( contents of #conventions.md#style-guide )
</style_guide>
```

#### Remix Attributes

All [section attributes](#section-attributes) can be applied to remixes. Remixes also support the following additional attributes:

- `sections="included,!excluded"` allows you to filter which sections from the mix are included/excluded on render.
- `rendered` can provide some flexibility for how remixes will be rendered
  - `rendered="unwrapped"` will remove the surrounding tag from the output.
  - `rendered="inline"` will attempt to render the content inline.
  - `rendered="code"` will format the content as a code block. When used with stems, the language will be derived from the stem file's extension.

Examples:

```markdown
{{> my-rules sections="!less-important-considerations"}}

<!-- 👆 This would include all sections from `my-rules.md`
     except for `less-important-considerations`. -->

{{> my-rules sections="important-considerations"}}

<!-- 👆 This would include only the `important-considerations`
     section from `my-rules.md`. -->
```

### Remixes vs. Inclusions

While they may seem similar, remixes and inclusions have different use cases and will be interpreted differently by the compiler:

- **Remixes** `{{> ...}}` **will** render the surrounding tag in the final output.
- **Inclusions** `{{$...}}` are replaced outright and **will not** render the surrounding tag in the final output.

### Stems

Stems are modular, reusable content components, stored in the `/_stems` directory. Like audio production stems that provide isolated tracks, Mixdown stems provide isolated content blocks that can be mixed into multiple instruction files.

- Stems are converted to `<stem_name>` tags in the final output. This can be disabled using the `rendered="unwrapped"` attribute.

Example:

```markdown
<!-- Stem: `/_stems/remember.md` -->
1. Always follow the code conventions.
2. Never commit directly to `main`
3. Use conventional commit messages.

---

<!-- Mix: `my-rules.md` -->
# My Rules

...rest of mix content...

{{> @remember}}

---

<!-- Output: `.cursor/rules/my-rules.mdc` -->

# My Rules

...rest of rules file...

<remember>
1. Always follow the code conventions.
2. Never commit directly to `main`
3. Use conventional commit messages.
</remember>
```

### Rendering Raw Mixdown Syntax

Triple-brace `{{{...}}}` to skip processing of the content and render it in the raw Mixdown syntax.

- This is useful for writing documentation or rules that need to show Mixdown-flavored Markdown (mix.md) literally
- Wrapping a section in triple curly braces preserves all Mixdown syntax and content exactly as written
- Example:

```markdown
> Triple braces will preserve the Mixdown syntax on render.
> Adding `rendered="unwrapped"` will remove those section tags from the output.
> Adding `+cursor` will only include the section for the `cursor` target.

{{{examples rendered="unwrapped" +cursor}}}
  {{example}}
  - Instructions
  - Rules
  {{/example}}
{{{/examples}}}

The above will render (in Cursor only) as:

{{example}}
- Instructions
- Rules
{{/example}}

Without the `rendered="unwrapped"` attribute, it would render as:

<examples>
  <example>
    - Instructions
    - Rules
  </example>
</examples>
```

### Instruction Placeholders

When writing prompts or instructions, you can use placeholders as self-contained prompts to direct an AI to fill in. Mixdown recommends using single-bracket `[placeholder text]`, but single-brace `{placeholder text}` syntax is supported. Just be careful, as one extra brace will cause the compiler to treat it as a Mixdown tag.

- ✅ Do this:
  - `[requirements]` / `[ requirements ]`
  - `{requirements}` / `{ requirements }`
- ❌ Don't do this:
  - `[[requirements]]`
  - `{{requirements}}`
  - `<requirements>`

> [!IMPORTANT]
> Remember, placeholder values should be simply considered instructions for the AI, and the output may not always be exactly what you expect. They're probabilistic, not deterministic.

#### Placeholder Formatting

Feel free to experiment with different language choice, formats, and even attributes to see what works best for your use case:

```markdown
[requirements|Title Case]
[requirements format="Title Case"]
[requirements in Title Case]
```

While the AI may not always follow the instructions in the placeholder precisely, it's worth experimenting.

### Whitespace Handling

Mixdown has specific rules for whitespace to ensure consistent parsing and output:

- Space after opening `{{` and before closing `}}` is optional
  - Example: `{{instructions}}` is equivalent to `{{ instructions }}`
- No spaces are allowed around the `=` sign in attribute declarations
- Attributes must be separated by spaces or newlines
  - Whitespace adjacent to brackets is removed on render, while new lines are preserved

## Code Examples

**Section with attributes:**

```markdown
{{instructions \name="core_rules" +cursor -windsurf}}
All code must follow consistent formatting.

Testing is required for all new features.
{{/instructions}}

Output in Cursor (but not Windsurf):

<instructions name="core_rules">
All code must follow consistent formatting.

Testing is required for all new features.
</instructions>
```

**Remixing content:**

```markdown
{{> @coding-standards}}

{{> my-mix#specific-section}}
```

**Using insertions:**

```markdown
Project: {{ $project }}
Version: {{ $.version }}
```

**Using raw output:**

```markdown
{{{example rendered="unwrapped"}}}
To include a section in Mixdown use: {{section-name}}
{{{/example}}}
```

## Directory Structure

```text
project/
├── .mixdown/
│   ├── records/
│   │   └── builds/         # compiled outputs
│   ├── instructions/       # Mix files (*.md)
│   │   └── _stems/         # reusable content modules
│   └── mixdown.config.json # compiler config
```

## Future Releases

Features planned for v0.x releases:

- Self-closing section tags
- Target groups for easier filtering of multiple targets
- Template support with placeholder filling
- Mode support for tools like Roo Code
- Slash command support for Claude Code
- Strict mode for validation

## Appendix

### Comprehensive Attribute Reference Table

The following table provides a complete list of all supported attributes in Mixdown v0:

| Attribute            | Type    | Default    | Section | Remix | Frontmatter | Description |
|----------------------|---------|------------|---------|-------|--------------|-------------|
| `name`               | string  | none       | ✅      | ✅    | ✅           | Name or identifier (frontmatter: mix identifier, required) |
| `description`        | string  | none       | ❌      | ❌    | ✅           | Short description of content (frontmatter only) |
| `+/-target`          | flag    | none       | ✅      | ✅    | ❌           | Include/exclude for specific targets |
| `rendered`           | string  | "default"  | ✅      | ✅    | ❌           | Controls how content is processed and displayed |
| `allow-bare-xml-tags`| boolean | false      | ❌      | ❌    | ✅           | Allow using bare XML tags |
| `sections`           | list    | none       | ❌      | ✅    | ❌           | Filter specific sections in remixes |
| `version`            | string  | none       | ❌      | ❌    | ✅           | Mix version |
| `labels`             | array   | `[]`       | ❌      | ❌    | ✅           | Categorization tags |
| `target.include`     | array   | `[]`       | ❌      | ❌    | ✅           | Target inclusion list |
| `target.exclude`     | array   | `[]`       | ❌      | ❌    | ✅           | Target exclusion list |
| `target.path`        | string  | none       | ❌      | ❌    | ✅           | Custom output path for records |
| `globs`              | array   | `[]`       | ❌      | ❌    | ✅           | File patterns for tool-specific support (frontmatter only) |
| `alwaysApply`        | boolean | false      | ❌      | ❌    | ✅           | Whether rule should always be applied (frontmatter only) |
| `\key`               | flag    | none       | ✅      | ✅    | ❌           | Include attribute in rendered XML |

**Notes:**

- All string attributes can be target-scoped with `+target?key="value"` syntax
- Frontmatter target blocks override global values (e.g., `cursor: { description: "..." }`)
- Target-specific paths can be set with `cursor: { target: { path: "./custom/path" } }`
- The `\key` flag specifically indicates that the attribute should be included in the XML output

*© 2025 Mixdown contributors – MIT License.*
