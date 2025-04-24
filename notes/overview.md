# 💽 Mixdown – Comprehensive Project Overview

> *One prompt. Every tool. Zero drift.*

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Purpose \& Vision](#purpose--vision)
    - [Elevator Pitch](#elevator-pitch)
    - [Problem Statement](#problem-statement)
    - [Solution Overview](#solution-overview)
- [Core Concepts](#core-concepts)
- [Key Features](#key-features)
    - [Authoring Features](#authoring-features)
    - [Compiler \& Integration](#compiler--integration)
- [Target Providers](#target-providers)
- [Getting Started](#getting-started)
    - [Installation](#installation)
    - [Quick Start](#quick-start)
- [Syntax Cheatsheet](#syntax-cheatsheet)
- [Full Syntax Reference (Specification)](#full-syntax-reference-specification)
    - [Design Goals](#design-goals)
    - [Sections](#sections)
        - [Sections Tag Parsing](#sections-tag-parsing)
        - [Section Nesting](#section-nesting)
        - [Multi-line Section Tags](#multi-line-section-tags)
        - [Self-Closing Section Tags](#self-closing-section-tags)
        - [Section Attributes](#section-attributes)
        - [Section Exporting](#section-exporting)
    - [Attributes](#attributes)
        - [Attribute Parsing](#attribute-parsing)
        - [Shortcuts for Filtering Targets](#shortcuts-for-filtering-targets)
        - [Heading Attribute Options](#heading-attribute-options)
    - [Target Groups](#target-groups)
        - [Default Target Groups](#default-target-groups)
        - [Custom Target Groups](#custom-target-groups)
        - [Target Group Usage](#target-group-usage)
    - [Front-Matter](#front-matter)
    - [Placeholders](#placeholders)
    - [Mixins](#mixins)
        - [Mixin Attributes](#mixin-attributes)
        - [Mixin Advanced Usage](#mixin-advanced-usage)
- [Code Examples (Practical Snippets)](#code-examples-practical-snippets)
    - [Auto-Closing vs. Explicit Nesting](#auto-closing-vs-explicit-nesting)
    - [Target-Filter Shortcuts](#target-filter-shortcuts)
    - [Rich Section Attributes](#rich-section-attributes)
    - [Placeholder Types in Action](#placeholder-types-in-action)
    - [Mixin Include with Section Filtering](#mixin-include-with-section-filtering)
    - [Front-Matter Migration Cheat-Sheet](#front-matter-migration-cheat-sheet)
- [Directory Structure (Monorepo)](#directory-structure-monorepo)
    - [Documentation](#documentation)
- [System Architecture](#system-architecture)
    - [Component Highlights](#component-highlights)
- [Security, Testing \& Performance](#security-testing--performance)
- [Roadmap (High Level)](#roadmap-high-level)
    - [Future Directions](#future-directions)
- [Contributing \& Community](#contributing--community)
- [References](#references)
- [Appendix](#appendix)
    - [Comprehensive Attribute Reference Table](#comprehensive-attribute-reference-table)
    - [Legacy Format](#legacy-format)
        - [Why This Change?](#why-this-change)
        - [At-a-Glance Changes](#at-a-glance-changes)
        - [Front-Matter Migration Cheat-Sheet](#front-matter-migration-cheat-sheet-1)

## Purpose & Vision

### Elevator Pitch

Mixdown is a **CommonMark-compliant prompt compiler** that lets you author a single *mix* file in plain Markdown and compile it into tool-specific instruction artifacts (Cursor `.mdc`, Claude Code `CLAUDE.md`, Roo Code `.md`, and more). Think of it as **Terraform for AI prompts**—declare once, target many, keep every teammate (human *and* bot) on the same authoritative rules.

### Problem Statement

- Instruction formats are **fragmented** across IDEs and agentic tools, leading to duplication and drift.
- Manual copy-paste workflows break **source-of-truth** guarantees and slow experimentation with new tools.
- Lack of a **machine-readable prompt spec** hinders automation, testing, and versioning.

### Solution Overview

Mixdown introduces a single source-of-truth **mix** file written (just a `.md` file) in pure Markdown plus YAML front-matter. The Mixdown compiler:

1. Parses the mix into an AST (sections, placeholders, mixins).
2. Delegates rendering to *plugin providers*—one per target tool.
3. Writes per-tool **artifacts** to predictable locations under `prompts/artifacts/builds/`.
4. Optionally exposes a **CLI** and **HTTP/MCP API** so CI pipelines or agents can fetch fresh rules on demand.

Result: *author once, distribute everywhere, zero drift.*

## Core Concepts

**Mix** [↗](#full-syntax-reference-specification)
: Source Markdown file that is compiled into artifacts.

**Artifact** [↗](#full-syntax-reference-specification)
: Target-specific output file (e.g., `.cursor/rules/foo.mdc`).

**Section** [↗](#sections)
: Delimited block `{{section}}...{{/section}}` with optional attributes.

**Mixin** [↗](#mixins)
: Re-usable include (`{{$my-include}}`) that can embed another mix/segment/template.

**Placeholder** [↗](#placeholders)
: Dynamic token replaced at build time (`{@alias}`, `{=data.key}`, `[ fill this in ]`).

**Target** [↗](#target-providers)
: A supported tool (Cursor, Roo Code, etc.) identified by a `kebab-case` ID, e.g. `cursor`, `roo-code`.

**Target Group** [↗](#target-groups)
: Named set of targets (`@cursor`, `@ide`, `@cli`) for attribute filtering.

> [!IMPORTANT]
> **Note for VS Code users:**
> Definition lists may not render correctly in VS Code's built-in Markdown preview.
> This is expected behavior and will display correctly on GitHub and other CommonMark-compliant renderers.

## Key Features

### Authoring Features

- **100% CommonMark** – Renders cleanly in GitHub & VS Code; passes markdown-lint.
- **Granular Sections** – Export, filter, or replace section headings per-target.
- **Powerful Placeholders** – Aliases, YAML data injections, runtime values (`{@git-branch}`) with sandboxed resolvers.

### Compiler & Integration

- **Plugin Architecture** – Add new targets via `MixdownPluginProvider` without touching core.
- **CLI & API** – `mixdown build`, `mixdown validate`, and `POST /compile` endpoint return ZIP artifacts, unzipped into `artifacts/builds/`.
- **Snapshot Testing** – Contract tests ensure mix edits don't silently change generated artifacts.

## Target Providers

| ID | Tool | Type |
|----|------|------|
| `cursor` | Cursor | IDE |
| `claude-code` | Claude Code | CLI |
| `roo-code` | Roo Code | VS Code Ext |
| `aider` | Aider | CLI |
| `openai-codex` | OpenAI Codex | CLI |
| `windsurf` | Windsurf | IDE |

*Want a new target? Implement `toolProvider` and publish `@mixdown/plugin-<your-tool>`. See `docs/provider-development.md`.*

## Getting Started

### Installation

```bash
npm install -g mixdown        # global CLI
# or project-local
npm install --save-dev mixdown
```

### Quick Start

```bash
mixdown init          # scaffolds prompts/ & .mixdown/
cd prompts/instructions
echo "---\nname: hello\n---\n{{system}}Hi!{{/system}}" > hello.md
cd ../..

mixdown build         # writes artifacts under prompts/artifacts/
```

The latest build is always symlinked at `prompts/artifacts/latest/`.

## Syntax Cheatsheet

| Token / Feature | Example | Notes |
|-----------------|---------|-------|
| **Section** | `{{instructions heading="Rules" export="cli"}}...{{/instructions}}` | Attributes control heading & export. |
| **Front-matter** | `---\nname: foo\n---` | YAML at file top. |
| **Mixin Include** | `{{$legal no-heading}}` | Embed another mix/include. |
| **Internal Link** | `{>rules\|Read more}` | Auto-resolves per target path. |
| **Alias Placeholder** | `{@project}` | Resolved via alias chain. |
| **Data Placeholder** | `{=user.email}` | Injects YAML data. |
| **Static Fill-In** | `[ fill this in ]` | Marker for LLM to complete. |

Full spec lives in `docs/spec.md`.

## Full Syntax Reference (Specification)

### Design Goals

| Goal | Description |
|------|-------------|
| ✨ **Simplicity** | Reduce bespoke tokens to the minimum necessary. |
| 🧹 **Lintability** | Files must pass standard markdown-lint without hacks. |
| 👀 **Previewability** | Render legibly in GitHub, VS Code, Obsidian, etc. |
| 🧩 **Extensibility** | Advanced behaviors declared via attributes instead of new syntax. |

### Sections

Sections are the core building block of Mixdown and stand-in for . They are used to create reusable content blocks that can be included in other sections or mixes.

```md
{{instructions heading="Rules" export="cli"}}
Please follow these coding standards...
{{/instructions}}
```

- **Section Tags Syntax**:
    - **Open** `{{name ...}}`  
    - **Close** `{{/name}}` (optional if another section starts)  
    - **Self-close** `{{name ... /}}` (Attributes must precede the `/`)
- **Section Tag Naming**:
    - `kebab-case` is recommended for section names
        - `snake_case` is also ok, but note that Markdown previews will treat the underscores as emphasis.
        - `spaced out` is works if you prefer to separate words with spaces.
    - Regardless of the naming convention, XML tag names in artifacts will render as `<snake_case>`

**Multi-line Tags** are allowed for readability, and the parser preserves this formatting:

```md
{{instructions
  heading="Rules"
  description="Section description."
}}
```

#### Sections Tag Parsing

If a new section starts before the previous is closed, the previous section is **auto-closed**. For example:

```md
<!-- Mixdown format -->
{{section1}}
Content A
{{section2}}
Content B

---

Renders as:
<!-- XML output -->
<section1>
Content A
</section1>
<section2>
Content B
</section2>
```

#### Section Nesting

To nest sections, use **explicit closing** tags. Otherwise, each new section auto-closes the previous:

```md
<!-- Mixdown format -->
{{outer}}
{{inner}}Inner content{{/inner}}
{{/outer}}

---

Renders as:
<!-- XML output -->
<outer>
<inner>Inner content</inner>
</outer>
```

#### Multi-line Section Tags

Attributes can be split across lines for readability. The parser preserves this formatting when writing XML tags:
<!-- TODO -->

```md
<!-- Multi-line section tag in Mixdown format -->
{{instructions
  heading="Rules"
  description="These are the rules for the instructions section."
  include-attributes="heading,description"}}
This is the content of the instructions section.
{{/instructions}}

---

Renders as:
<!-- XML output -->
<instructions
  heading="Rules"
  description="These are the rules for the instructions section.">
This is the content of the instructions section.
</instructions>
```

#### Self-Closing Section Tags

Use `{{name ... /}}` for sections with only attributes and no inner content.

Multiline tags are also supported with self-closing tags:

```md
<!-- Mixdown format -->
{{note
  id="important"
  heading="Important Note"
  include-attributes="id,heading"
/}}

---

Renders as:
<!-- XML output -->
<note
  id="important"
  heading="Important Note"
/>
```

#### Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `id` | string | Unique reference for `{>file#id}` links. |
| `as` | string | Override the default section tag name in rendered XML. |
| `heading` | string / `heading?h2="..."` | Inject a heading at the start of the section content and optionally specify heading level. |
| `description` | string | Short blurb retained in rendered XML (if allowed). |
| `filter` | list | Include/exclude targets (`filter="target=ide,!windsurf"`). |
| `export` | list | Export section as its own artifact for listed targets. |
| `format` | enum | Force rendered section output markdown to be formatted as `code`, `language`, `blockquote`, etc. |
| `no-xml` | flag | Skip XML wrapping. Optional target list: `no-xml="ide"`. |
| `include-attributes` | list | Whitelist attributes preserved in rendered XML. |
| `remove-first-heading` | flag | Strip first intra-section heading. |
| *Custom* | any | Passed through untouched. |

> [!TIP]
> **Target-specific overrides**: append `@<target>` / `@<group>` (e.g. `heading@cursor="Cursor Rules"`). Precedence: explicit target → target group → default.

#### Section Exporting

The `export` attribute allows you to export a section as a separate artifact for one or more specific targets. This is useful when you want a section to appear as its own file (artifact) for certain tools, while being inlined or omitted for others.

- **How it works:**
  - When a section includes `export="<target>[,<target2>,!<target3>]"`, Mixdown generates a separate artifact (file) for each listed target.
  - The exported artifact is written to the appropriate directory for the target (e.g., `.cursor/rules/section-id.mdc` for Cursor).
  - The section is removed or inlined in the main artifact for that target, depending on the provider's rules.

- **Syntax:**
  - `export="cursor"` — Export this section as a separate file for Cursor only.
  - `export="cursor,!windsurf"` — Export for Cursor, but not for Windsurf.
  - You can use target groups: `export="@cli"`.

- **Link Resolution:**
  - Internal links to exported sections (e.g., `{>my-rule#core-rules}`) are resolved differently per target:
    - For Cursor, the link points to the exported artifact (e.g., `mdc:core-rules.mdc`).
    - For Roo Code, the link may point to the section within the main file (e.g., `agent-instructions.md#core-rules`).

- **Example:**

  ```md
  # My Rule

  {{core-rules export="cursor" heading="Core Coding Rules"}}
  All commits *must* follow Conventional Commits.
  {{/core-rules}}
  ```

  - For Cursor, this generates a separate file `.cursor/rules/core-rules.mdc` containing:
    ```md
    # Core Coding Rules
    All commits *must* follow Conventional Commits.
    ```
    and links to `{>my-rule#core-rules}` resolve to `mdc:core-rules.mdc`.
  - For Roo Code, the section remains inlined in the main file, and links resolve to `agent-instructions.md#core-rules`.

- **Best Practices:**
  - Use `export` to avoid duplication and drift between tools that require different artifact structures.
  - Use clear, unique section names/IDs for exported sections to ensure predictable artifact paths.
  - Combine `export` with `heading` and target-specific overrides for maximum flexibility.

### Attributes

#### Attribute Parsing

- **Key-Value vs. Boolean Flags:**
    - Key-value attributes use `key=value`. If the value contains spaces, quotes are required (e.g., `heading="Cursor Heading"`).
    - Attributes without `=` are boolean flags considered `true` (e.g., `no-xml`).
- **Scoping attributes with `@<target>` / `@<group>`:**
    - Add `@<target>` or `@<group>` to scope an attribute to a specific target or group (e.g., `heading@cursor="Cursor Heading"`).
    - Precedence: explicit target > target group > default.
- **Modifiers with `?`:**
    - Some attributes (like `heading`) support modifiers (e.g., `heading?h2="Rules"`).
- **Precedence and Overrides:**
    - Target-specific attributes override group or default values.
    - When multiple attributes apply, the most specific wins.
- **Custom Attributes:**
    - Any custom attribute is allowed and will be passed through to the rendered XML, but is not interpreted by Mixdown (e.g., `my-attribute=my-value`).

**Examples:**

```md
{{instructions no-xml heading="Rules" heading@cursor="Cursor Rules"}}
```

```md
{{rules export="cli" skip@cursor}}
```

#### Shortcuts for Filtering Targets

You can use shortcuts for filtering sections by target or group within sections and dynamic placeholders:

- `@@<target>` — Only include for specified target (e.g., `@@cursor`, `@@ide`)
- `!@<target>` — Exclude for specified target (e.g., `!@cli`, `!@roo-code`)

**Examples:**

```md
{{instructions @@ide}}
Visible only in IDE targets.
{{/instructions}}

{{instructions !@cli}}
Hidden from CLI targets.
{{/instructions}}
```

#### Heading Attribute Options

The `heading` attribute controls the heading that appears at the start of a section's content. It is highly flexible and supports several modifiers and overrides:

- **Basic Use:**
    - `heading="My Section Heading"` injects a heading at the top of the section.

    ```md
    {{instructions heading="Rules" no-xml}}
    Section content.
    {{/instructions}}
    
    Renders as:
    
    # Rules
    Section content.
    ```

- **Heading Level Modifiers:**
    - Use `?h[1-6]` to force a specific heading level (e.g., `heading?h2="Rules"` → `## Rules`).
    - Use `?h+` to increment the current heading level (e.g., if parent is `##`, this becomes `###`).
    - Use `?h-` to decrement the current heading level (e.g., if parent is `###`, this becomes `##`).
    - Example:

    ```md
    {{section heading?h3="Subsection" no-xml}}
    Content.
    {{/section}}

    Renders as:

    ### Subsection
    Content.
    ```

- **Replace First Heading:**
    - Use `heading?replace="New Heading"` to replace the first heading found in the section content with the value of `heading`.
        - Note: This is useful primarily when embedding a mixin with an existing heading.
    - If no value is provided (`heading?replace`), the section name is used as the heading.
    - Example:

    ```md
    {{rules heading?replace="Core Rules" no-xml}}
    ## Old Heading
    Content.
    {{/rules}}

    Renders as:

    # Core Rules
    Content.
    ```

- **Target/Group-Specific Overrides:**
    - Use `heading@<target>` or `heading@<group>` to override the heading for a specific target or group.
    - Example:

    ```md
    {{instructions heading="General Rules" heading@cursor="Cursor Rules" no-xml}}
    Content.
    {{/instructions}}

    For Cursor, this renders as:
    <!-- .cursor/rules/instructions.md -->
    # Cursor Rules
    Content.

    For other targets, it renders as:

    # General Rules
    Content.
    ```

- **Notes on Heading Levels:**
    - Heading levels are clamped to the `.mixdown/config.yaml` min/max (e.g., h1–h6).
    - If a file starts with a section, the default heading level is `h<min>` unless overridden.
    - Heading level inheritance follows the parent section or document context.
- **Best Practices:**
    - Use explicit heading modifiers for clarity in deeply nested or reused sections.
    - Use target-specific overrides to tailor documentation for different tools.

### Target Groups

Target groups are named sets of targets that can be used for attribute filtering and scoping. They allow you to apply attributes or filters to multiple targets at once.

#### Default Target Groups

| Group               | Members (example)            | Note |
|---------------------|------------------------------|------|
| `ide`               | cursor, windsurf, zed        | Graphical editors / IDEs |
| `vs-code-fork`      | cursor, windsurf             | Sub‑set of IDE tools that are forks of VS Code |
| `vs-code-extension` | roo-code, cline              | VS Code extensions |
| `cli`               | claude-code, openai-codex    | Terminal‑centric tools |
| `desktop`           | cursor, vs‑code              | Native desktop apps |
| `mobile`            | *none by default*            | Populated when mobile targets ship |
| `ci`                | *none by default*            | For future CI providers |
| `cloud`             | *none by default*            | For future cloud-based agent providers |
| `all`               | *wildcard* (`*`)             | Every registered target; no need to declare |

#### Custom Target Groups

- You can define or override groups in `.mixdown/config.yaml`:

```yaml
# .mixdown/config.yaml
target-groups:
  core:
    include: [cursor, roo-code]
  ide:
    include: [zed]
    exclude: [windsurf]
```

#### Target Group Usage

- Use group names in attribute scopes (e.g., `heading@ide="Heading for IDEs"`).
- Use in filter/export attributes (e.g., `filter="@cli,!windsurf"`).
- Use shortcuts in `{{sections}}` to filter sections by target group (e.g., `{{instructions @@ide}}`).

### Front-Matter

```yaml
---
# /prompts/instructions/my-rule.md
name: my-rule
version: 1.0.0
labels: ["core", "security"]
# Target filter examples:
# targets: ["cursor", "!windsurf", "@cli"]
---
```

Provider plugins declare allowed and required front-matter keys within their manifests using the `types.<artifact>.allowedkeys` and `types.<artifact>.required-keys` arrays respectively (see example in Section 7.9). Missing `required-keys` will raise build errors, ensuring necessary metadata is present for each artifact type. In some cases, such as `globs`, the target may require a key to be present, but a value is not required.

*Target-specific overrides*:

```yaml
---
description: General description
cursor:
  description: Cursor-specific description
---
```

### Placeholders

| Type | Syntax | Notes |
|------|--------|-------|
| **Static (AI note)** | `[ fill this in ]` | Human or AI-fillable placeholder |
| **Alias** | `{@name}` | Alias lookup chain: front-matter → project → global. |
| **Data** | `{=user.name}` | Injects YAML data from `prompts/data/user.yaml`. |
| **Internal Link** | `{>file#section\|Alias}` | Path auto-resolved per target. |

**Built-in Alias Placeholders**:

- `{@<target>}` → current target ID  
- `{@<target>.name}` → display name from the provider manifest
<!-- TODO -->
**Placeholder Types:**

- **Static Placeholder:** `[ fill this in ]`
    - Used for human or AI fill-in. Not replaced by Mixdown.
    - You may add attributes: `[ placeholder attr="value" ]`
    - Spacing and word separation are flexible: `[ placeholder ]`, `[placeholder]`, `[separating-with-dashes]`.
- **Dynamic Placeholders:**
    - **Alias:** `{@name}` — Looks up alias in front-matter, project, or global scope.
    - **Data:** `{=user.name}` — Injects YAML data from `prompts/data/user.yaml`.
    - **Internal Link:** `{>file#section|Alias}` — Links to another mix or section.
    - **Escaping:** Prefix with `\` to render as-is (e.g., `\{@alias}`).

**Examples:**

```md
- Name: {@user.name}
- Email: {=user.email}
- See: {>my-rule#core-rules|Core Rules}
- Please fill out: [ your escalation steps ]
```

### Mixins

Mixins allow you to include reusable content, mixes, or templates inline.

```md
<!-- Embed /prompts/includes/legal.md and suppress its heading -->
{{$include:legal no-heading}}

<!-- Embed /prompts/mixes/common-rules.md and include only section-1 and exclude section-2 -->
{{$mix:common-rules sections="section-1,!section-2"}}
```

#### Mixin Attributes

| Attribute | Purpose |
|-----------|---------|
| `as="alternate-name"` | Rename mixin on render; allows for flexibility in XML tag naming. |
| `no-heading` | Suppress top heading of source. |
| `no-mixins` | Strip nested mixins inside source. |
| `include-frontmatter` | Bring source front-matter into caller. |
| `alias-from="source"` | Choose alias resolution scope (`source` or `current`). |
| `sections="section-1,!section-2"` | Filter specific sections. |

#### Mixin Advanced Usage
<!-- TODO -->
- Mixins can be nested, filtered, and aliased.
- You can include only certain sections, suppress headings, or control alias resolution.
- Example:

```md
{{$mix:incident-protocol
  as="protocol"
  no-heading
  sections="summary,steps"
}}
```

## Code Examples (Practical Snippets)

### Auto-Closing vs. Explicit Nesting

Authoring:

```md
{{example}}
This is an examples section.
{{example}}
This is an example *inside* the examples section.
{{example}}
Another example inside the examples section.
```

Rendered (auto-closed):

```md
<example>
This is an examples section.
</example>

<example>
This is an example *inside* the examples section.
</example>

<example>
Another example inside the examples section.
</example>
```

Proper nesting with explicit closures:

```md
{{examples}}
Intro to examples.
  {{example}}First nested example.{{/example}}
  {{example}}Second nested example.{{/example}}
{{/examples}}
```

Rendered:

```md
<examples>
Intro to examples.
  
  <example>First nested example.</example>
  <example>Second nested example.</example>
</examples>
```

### Target-Filter Shortcuts

```md
{{instructions @@ide}}
Visible only in IDE targets like Cursor or Windsurf.
{{/instructions}}

{{instructions !@ide}}
Hidden from IDEs; visible everywhere else.
{{/instructions}}

{{instructions @@cli}}
Visible only in CLI targets (Aider, Claude Code).
{{/instructions}}
```

### Rich Section Attributes

```md
{{rules
  id="core-rules"
  heading="Core Coding Rules"
  export="cursor"
  include-attributes="heading"
}}
All commits *must* follow Conventional Commits.
{{/rules}}
```

- **Cursor** sees `core-rules.mdc` as a separate file.  
- **Roo Code** inlines the content with a `## Core Coding Rules` heading.

### Placeholder Types in Action

```md
### User Info
- Name: {@user.name}
- Email: {=user.email}
- Current Git Branch: {@git-branch}
- Please fill out: [ your escalation steps ]
```

Aliases resolve in the documented order (mix → project → global), data is pulled from `prompts/data/user.yaml`, and the bracketed instruction remains for the LLM.

### Mixin Include with Section Filtering

```md
{{$mix:incident-protocol
  as="protocol"
  no-heading
  sections="summary,steps"
}}
```

This embeds the *summary* and *steps* sections from `incident-protocol.md`, suppresses its heading, and aliases the section name to `protocol` in the caller mix.

### Front-Matter Migration Cheat-Sheet

Old XML flavour ➜ new YAML flavour:

```xml
<mixdown version="0.1.0">
<meta>
name: legacy-rule
</meta>
<mix>...</mix>
</mixdown>
```

becomes

```yaml
---
mixdown:
  version: 0.1.0
name: legacy-rule
---
```

## Directory Structure (Monorepo)

```text
mixdown/
├── prompts/
│   ├── artifacts/
│   │   ├── builds/{id}/   # build-specific outputs
│   │   └── latest/        # symlink to latest build
│   ├── instructions/      # Mix files (*.md)
│   ├── includes/          # reusable content & data
│   └── templates/         # document templates
├── .mixdown/              # compiler config, cache, reports
├── packages/              # pnpm workspaces
│   ├── core/              # core compiler
│   ├── cli/               # Ink-based CLI
│   ├── api/               # Express/MCP API
│   ├── plugin-cursor/     # first-party provider
│   └── plugin-claude-code/| first-party provider
└── docs/                  # deep dives & spec
```

### Documentation

```text
mixdown/
├── advanced-usage.md                     # advanced usage
├── cli.md                                # CLI reference
├── config.md                             # Mixdown configuration
├── glossary.md                           # Mixdown glossary of terms
├── includes.md                           # includes reference
├── mixes.md                              # mixes reference
├── mixins.md                             # mixins reference
├── quick-reference.md                    # quick reference guide
├── roadmap.md                            # Mixdown project roadmap
├── templates.md                          # templates reference
├── docs/                                 # project documentation
│   ├── architecture/                     # system architecture
│   │   ├── data-flow.md                  # data flow diagram
│   │   ├── design-decisions.md           # design decisions
│   │   └── architecture-overview.md      # architecture overview
│   ├── contributing/                     # contributing guidelines
│   │   ├── CHANGESETS.md                 # changelog
│   │   ├── CONTRIBUTING.md               # contributing guidelines
│   │   └── DEVELOPMENT.md                # development guidelines
│   ├── developer/                        # developer documentation
│   │   ├── plugin-development.md         # plugin provider development
│   │   └── provider-manifest.md          # provider manifest schema
│   ├── project/                          # project documentation
│   │   └── prd.md                        # project requirements document
│   └── spec/                             # detailed technical specifications
│       ├── attributes-spec.md            # attributes specification
│       ├── config-schema.md              # configuration schema
│       ├── includes-spec.md              # includes specification
│       ├── linting-spec.md               # linting rules specification
│       ├── mix-spec.md                   # mix specification
│       ├── mixdown-syntax.md             # syntax reference
│       ├── mixin-spec.md                 # mixin specification
│       ├── placeholders-spec.md          # placeholders specification
│       ├── plugin-spec.md                # plugin specification
│       ├── sections-spec.md              # sections specification
│       ├── template-spec.md              # template specification
│       └── advanced-usage.md             # advanced usage documentation
└── README.md                             # deep dives & spec
```

## System Architecture

```mermaid
flowchart LR
  subgraph User
    A[Developer / CI]
  end
  A -->|CLI: mixdown build| B(Core Compiler)
  A -.->|HTTP: /compile| C(API Server)
  C --> B
  B --> D[Plugin Provider Registry]
  D --> P1[@plugin-cursor]
  D --> P2[@plugin-claude-code]
  B --> E[Artifact Writer]
  E --> F[prompts/artifacts/builds/{id}]
```

### Component Highlights

1. **Core Compiler** – Parses, resolves placeholders & mixins, produces AST.
2. **Plugin Providers** – Map AST → tool-specific markdown; declare directories & extensions.
3. **CLI** – Ink UI with non-interactive flag support (`--json`).
4. **API Server** – Express + OpenAPI validator; returns ZIP artifacts, MCP-compliant.
5. **Artifact Writer** – Persists outputs, creates `latest` symlink, embeds checksum headers.

## Security, Testing & Performance

| Area | Approach |
|------|----------|
| **Security** | XML parser sandbox (`ignoreEntities: true`), path sanitization, placeholder shell-outs whitelisted. |
| **Testing** | Jest ≥ 80 % coverage; snapshot tests for plugin renders; Supertest E2E for API. |
| **Performance** | Stream parser; <250 ms compile for 500-line mix on M-series CPU. |

## Roadmap (High Level)

| Phase | Deliverables |
|-------|--------------|
| 0.1 | Core compiler, Cursor & Claude providers, `init`/`build`/`validate` CLI, `/compile` API. |
| 0.2 | Roo Code & Windsurf providers, provider SDK docs. |
| 0.3 | Prompt test harness, security hardening, >90 % coverage. |
| 0.4 | Mix registry (`mixdown add @acme/rails-rules`), web playground. |

Track detailed tasks in `.agent/tasks.md` and project plan docs.

### Future Directions

<!-- TODO -->

- Plugin providers can declare their own target versions in manifests for consistent behavior across versions.
- Potential for a Mixdown language server for enhanced editor support.
- More advanced linting and validation tools.
- Support for mobile and cloud target groups as they are introduced.

## Contributing & Community

1. **Fork → `pnpm i` → `pnpm dev`**.
2. Follow conventional commits; run `pnpm changeset add` for version bumps.
3. Add unit & contract tests for new features.
4. Submit PR—CI must pass snapshot tests.

See [`docs/contributing.md`](docs/contributing.md) for full guidelines.

## References

- `docs/spec.md` – Full syntax specification.
- `docs/provider-development.md` – Build a new plugin provider.
- `simplifying-mixdown-syntax.backup.md` – Design rationale & deep-dive.
- `README.md` – Project README (public landing).

## Appendix

### Comprehensive Attribute Reference Table

The following table provides a complete list of all supported attributes in Mixdown, their types, default values, and scope support:

| Attribute | Type | Default | Section | Mixin | Front-matter | Description |
|-----------|------|---------|---------|-------|--------------|-------------|
| `id` | string | none | ✅ | ❌ | ❌ | Unique reference for sections |
| `heading` | string | none | ✅ | ❌ | ❌ | Inject heading above section |
| `description` | string | none | ✅ | ❌ | ✅ | Short description of content |
| `filter` | list | none | ✅ | ❌ | ❌ | Include/exclude targets |
| `export` | list | none | ✅ | ❌ | ❌ | Export as separate artifact |
| `format` | enum | none | ✅ | ❌ | ❌ | Force specific content format |
| `no-xml` | flag | true | ✅ | ❌ | ❌ | Skip XML wrapping |
| `include-attributes` | list | none | ✅ | ❌ | ❌ | Whitelist attributes in rendered XML |
| `remove-first-heading` | flag | true | ✅ | ❌ | ❌ | Strip first intra-section heading |
| `as` | string | none | ❌ | ✅ | ❌ | Rename mixin section name on render for flexibility in XML tag naming. |
| `no-heading` | flag | true | ❌ | ✅ | ❌ | Suppress top heading of source |
| `no-mixins` | flag | true | ❌ | ✅ | ❌ | Strip nested mixins in source |
| `include-frontmatter` | flag | false | ❌ | ✅ | ❌ | Bring source front-matter into caller |
| `alias-from` | enum | "current" | ❌ | ✅ | ❌ | Alias resolution scope |
| `sections` | list | none | ❌ | ✅ | ❌ | Filter specific sections |
| `name` | string | none | ❌ | ❌ | ✅ | Mix identifier (required) |
| `version` | string | none | ❌ | ❌ | ✅ | Mix version (required) |
| `labels` | array | `[]` | ❌ | ❌ | ✅ | Categorization tags |
| `targets` | array | `[]` | ❌ | ❌ | ✅ | Filter applicable targets |
| `heading-level` | object | config | ❌ | ❌ | ✅ | Override heading settings |

**Notes:**

- All attributes with string values can be scoped with target/group suffixes (e.g., `heading@cursor="Cursor-specific heading"`)
- Flag attributes default to `true` when specified without a value
- Target-specific front-matter keys override global values (e.g., `cursor: { description: "..." }`)

### Legacy Format

The previous Mixdown syntax has been deprecated.

#### Why This Change?

The original Mixdown syntax mixed custom XML with Markdown, which:

- Violated markdown-lint rules and rendered poorly in tooling.
- Introduced a steep learning curve for newcomers.
- Complicated provider parsing and plugin development.

The new **CommonMark-only** approach uses braces (`{{section}}`) so every file is valid Markdown, previewable anywhere, and trivially linted.

#### At-a-Glance Changes

| Old Concept | New Concept | Rationale |
|-------------|-------------|-----------|
| `<section>` XML tags | `{{section}}` braces | Keeps Markdown valid & removes mixed markup. |
| `<meta>` block | Standard YAML front-matter | Aligns with ecosystem norms (Jekyll, MDX). |
| `$[link:example]`, `$[alias:name]` | `{>file}`, `{@name}` | Unified placeholder syntax. |
| `$[include]` / `mix` / `template` | `{{$include}}` mixins | Single mental model for includes. |
| `tool=` attr | `target=` attr | Clarifies these refer to build targets. |

#### Front-Matter Migration Cheat-Sheet

Old XML flavour ➜ new YAML flavour:

```xml
<mixdown version="0.1.0">
<meta>
name: legacy-rule
</meta>
<mix>...</mix>
</mixdown>
```

becomes

```yaml
---
mixdown:
  version: 0.1.0
name: legacy-rule
---
```

*© 2024 Mixdown contributors – MIT License.*