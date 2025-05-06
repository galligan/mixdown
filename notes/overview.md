# 💽 Mixdown – Comprehensive Project Overview

> *One prompt. Every tool. Zero drift.*

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Purpose \& Vision](#purpose--vision)
    - [Elevator Pitch](#elevator-pitch)
    - [Problem Statement](#problem-statement)
    - [Solution Overview](#solution-overview)
- [Core Concepts](#core-concepts)
    - [Terminology Notes](#terminology-notes)
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
        - [Title and Heading Attribute Options](#title-and-heading-attribute-options)
    - [Target Groups](#target-groups)
        - [Default Target Groups](#default-target-groups)
        - [Custom Target Groups](#custom-target-groups)
        - [Target Group Usage](#target-group-usage)
    - [Front-Matter](#front-matter)
        - [Target-Specific Front Matter](#target-specific-front-matter)
    - [Placeholder Instructions](#placeholder-instructions)
        - [Placeholder Formatting](#placeholder-formatting)
    - [Insertions](#insertions)
    - [Links](#links)
    - [Embeds](#embeds)
        - [Embed Attributes](#embed-attributes)
        - [Self-Closing Embed Tags](#self-closing-embed-tags)
        - [Embed Advanced Usage](#embed-advanced-usage)
    - [Whitespace Handling](#whitespace-handling)
- [Code Examples (Practical Snippets)](#code-examples-practical-snippets)
    - [Auto-Closing vs. Explicit Nesting](#auto-closing-vs-explicit-nesting)
    - [Target-Filter Shortcuts](#target-filter-shortcuts)
    - [Rich Section Attributes](#rich-section-attributes)
    - [Insertion Types in Action](#insertion-types-in-action)
    - [Embed with Section Filtering](#embed-with-section-filtering)
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

## Purpose & Vision

### Elevator Pitch

Mixdown is a **CommonMark-compliant prompt compiler** that lets you author a single *mix* file in plain Markdown and compile it into tool-specific instruction artifacts (Cursor `.mdc`, Claude Code `CLAUDE.md`, Roo Code `.md`, and more). Think of it as **Terraform for AI prompts**—declare once, target many, keep every teammate (human *and* bot) on the same authoritative rules.

### Problem Statement

- Instruction formats are **fragmented** across IDEs and agentic tools, leading to duplication and drift.
- Manual copy-paste workflows break **source-of-truth** guarantees and slow experimentation with new tools.
- Lack of a **machine-readable prompt spec** hinders automation, testing, and versioning.

### Solution Overview

Mixdown introduces a single source-of-truth **mix** file written (just a `.md` file) in pure Markdown plus YAML front-matter. The Mixdown compiler:

1. Parses the mix into an AST (sections, placeholders, embeds).
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
: Delimited block `{{# section }}...{{/section}}` with optional attributes.

**Embed** [↗](#embeds)
: Re-usable content inclusion mechanism (`{{> my-partial }}`) that can incorporate content from another mix/section/template.

**Insertion** [↗](#insertions
: Dynamic value replaced at build time (`{{ $alias }}`, `{{ $.data.key }}`, `[ fill this in ]`).

**Target** [↗](#target-providers)
: A supported tool (Cursor, Roo Code, etc.) identified by a `kebab-case` ID, e.g. `cursor`, `roo-code`.

**Target Group** [↗](#target-groups)
: Named set of targets (`ide`, `cli`) for attribute filtering.

> [!IMPORTANT]
> **Note for VS Code users:**
> Definition lists may not render correctly in VS Code's built-in Markdown preview.
> This is expected behavior and will display correctly on GitHub and other CommonMark-compliant renderers.

### Terminology Notes

To maintain consistency throughout the documentation and codebase:

- **Embed vs. embed**:
    - "Embed" (noun, capitalized) refers to the inclusion mechanism itself (the `{{> partial }}` feature).
    - "embed" (verb, lowercase) is the action of including content from one file in another.

## Key Features

### Authoring Features

- **100% CommonMark** – Renders cleanly in GitHub & VS Code; passes markdown-lint.
- **Granular Sections** – Export, filter, or replace section headings per-target.
- **Powerful Build-time Insertions** – Aliases, YAML data injections, and more, with sandboxed resolvers.

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
echo "---\nname: hello\n---\n{{system}}Hi!{{/system}}" > hello.md # TODO: We need to come up with a better example. This isn't valid.
cd ../..

mixdown build         # writes artifacts under prompts/artifacts/
```

The latest build is always symlinked at `prompts/artifacts/latest/`.

## Syntax Cheatsheet

| Token / Feature | Example | Notes |
|-----------------|---------|-------|
| **Section** | `{{# instructions title="Rules" export="cli" }}...{{/instructions}}` | Attributes control titles & export. |
| **Front-matter** | `---\ntitle: foo\n---` | YAML at file top. |
| **Embed** | `{{> legal !heading }}` | Embed another partial. |
| **Section Embed** | `{{#> legal }}` | Embed as a section. |
| **Internal Link** | `[Read more](rules.md)` | Standard Markdown links. |
| **Absolute Link** | `[Example](//src/example.ts)` | Links to project files. |
| **Alias Insertion** | `{{ $project }}` | Resolved via alias chain. |
| **Data Insertion** | `{{ $.user.email }}` | Injects YAML data. |
| **Placeholder Instructions** | `[ fill this in ]` | Marker for LLM to complete. |

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

Sections are the core building block of Mixdown and are a direct stand in for XML `<section>` tags. They are used to create reusable content blocks that can be included in other sections or mixes.

```markdown
{{# instructions title="Rules & Instructions" export="cli" }}
Please follow these coding standards...
{{/instructions}}
```

- **Section Tags Syntax**:
    - **Open** `{{# section-name ... }}`
    - **Close** `{{/section-name}}` (optional if another section starts)
    - **Self-close** `{{# section-name ... /}}` (Attributes must precede the `/`)
- **Section Tag Names**:
    - The `#` prefix makes it clear that this is a section tag
    - `kebab-case` is recommended for section names
        - `snake_case` is also ok, but note that Markdown previews will treat the underscores as emphasis.
        - `spaced out` is works if you prefer to separate words with spaces.
    - Regardless of the naming convention, XML tag names in artifacts will render as `<snake_case>`
- **Section Names as Headings**:
    - A quoted string can be used for sections, which will render as a heading: `{{# "Section Name" }}`
        - This is the equivalent of writing `{{# section-name title="Section Name" }}`
<!-- TODO: Add clarity around heading rendering when `title` is used -->
**Multi-line Tags** are allowed for readability, and the parser preserves this formatting:

```markdown
{{# instructions
  title="Rules & Instructions"
  description="Section description."
}}
```

#### Sections Tag Parsing

If a new section starts before the previous is closed, the previous section is **auto-closed**. For example:

```markdown
<!-- Mixdown format -->
{{# section1 }}
Content A
{{# section2 }}
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

```markdown
<!-- Mixdown format -->
{{# outer }}
{{# inner }}Inner content{{/inner}}
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

```markdown
<!-- Multi-line section tag in Mixdown format -->
{{# instructions
  title="Rules"
  description="These are the rules for the instructions section."
  include-attributes="title,description" }}
This is the content of the instructions section.
{{/instructions}}

---

Renders as:
<!-- XML output -->
<instructions
  title="Rules"
  description="These are the rules for the instructions section.">
This is the content of the instructions section.
</instructions>
```

#### Self-Closing Section Tags

Use `{{# name ... /}}` for sections with only attributes and no inner content.

Multiline tags are also supported with self-closing tags:

```markdown
<!-- Mixdown format -->
{{# note
  title="Important Note"
  include-attributes="title"
/}}

Renders as:
<!-- XML output -->
<note
  title="Important Note"
/>
```

#### Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `title` | string | Primary name/title for the section which can render as a Markdown heading. |
| `description` | string | Short blurb retained in rendered XML (if allowed). |
| `+/-target` | flag | Include/exclude for specific targets (e.g., `+cursor -windsurf`). |
| `export` | list | Export section as its own artifact for listed targets. |
| `format` | enum | Force rendered section output markdown to be formatted as `code`, `language`, `blockquote`, etc. |
| `!xml` | flag | Skip XML wrapping. Optional target list: `!xml="ide"`. |
| `include-attributes` | list | Whitelist attributes preserved in rendered XML. |
| `!heading` | flag | Strip first intra-section heading. |
| *Custom* | any | Passed through untouched. |

> [!TIP]
> **Target-specific overrides**:
>
> Using `+` delimiter: `key+<target>` (e.g., `title+cursor="Cursor Rules"`)
>
> Precedence: explicit target → target group → default.

#### Section Exporting

The `export` attribute allows you to export a section as a separate artifact for one or more specific targets. This is useful when you want a section to appear as its own file (artifact) for certain tools, while being inlined or omitted for others. Unlike filtering attributes, `export` is inclusion-only — you specify which targets should receive the exported section.

- **How it works:**
    - When a section includes `export="<target>[,<target2>]"`, Mixdown generates a separate artifact (file) for each listed target.
    - The exported artifact is written to the appropriate directory for the target (e.g., `.cursor/rules/section-id.mdc` for Cursor).
    - The section is removed or inlined in the main artifact for that target, depending on the provider's rules.
- **Syntax:**
    - `export="cursor"` — Export this section as a separate file for Cursor only.
    - `export="cursor,claude-code"` — Export for multiple targets (comma-separated).
    - You can use target groups: `export="cli"` or `export="desktop"`.
- **Link Resolution and Validation:**
    - Internal links to exported sections are resolved differently per target:
        - For Cursor, the link points to the exported artifact (e.g., `mdc:core-rules.mdc`).
        - For Roo Code, the link may point to the section within the main file (e.g., `agent-instructions.md#core-rules`).
    - The compiler validates all internal links during compilation, emitting warnings for unresolved links.
    - In strict mode, unresolved links will cause build failures.
- **Cross-Mix Link Resolution:**
    - Links targeting other mix files (`[text](other-mix.md)`) are automatically resolved.
    - The compiler builds an index of all mix front-matter `name` values at start of compilation.
    - For cross-mix section references (`[text](other-mix.md#section-name)`), the compiler validates both the mix file and the section existence.
- **Export-Aware Link Transformation:**
    - Provider plugins can implement the hook `transformLink(href, context)` to rewrite links based on the export mapping.
    - This enables links to automatically adapt to the target's expected format and organization.
    - Example: `[Rules](mix.md#rules)` might become `[Rules](mdc:rules.mdc)` for Cursor, but stay `[Rules](mix.md#rules)` for Roo Code.

- **Example:**

  ```markdown
  # My Rule

  {{# core-rules export="cursor" title="Core Coding Rules" }}
  All commits *must* follow Conventional Commits.
  {{/core-rules}}
  ```

    - For Cursor, this generates a separate file `.cursor/rules/core-rules.mdc` containing:

    ```markdown
    # Core Coding Rules
    All commits *must* follow Conventional Commits.
    ```

    and links to `[my rule](core-rules.md)` resolve to `mdc:core-rules.mdc`.
    - For Roo Code, the section remains inlined in the main file, and links resolve to `agent-instructions.md#core-rules`.

- **Best Practices:**
    - Use `export` to avoid duplication and drift between tools that require different artifact structures.
    - Use clear, unique section names/IDs for exported sections to ensure predictable artifact paths.
    - Combine `export` with `name` and target-specific overrides for maximum flexibility.
    - Remember that `export` is inclusion-only — if you need to exclude targets, use filtering attributes instead.

### Attributes

#### Attribute Parsing

- **Key-Value vs. Boolean Flags:**
    - Key-value attributes use `key=value`. If the value contains spaces, quotes are required (e.g., `title="Cursor Heading"`).
    - Attributes with a `!` prefix are boolean flags considered `true` (e.g., `!xml` to skip XML wrapping).
- **Targeting with `+/-` delimiters:**
    - Use `+<target>` to include for a specific target (e.g., `+cursor` or `+ide`).
    - Use `-<target>` to exclude for a specific target (e.g., `-windsurf` or `-cli`).
    - Combine targets with comma separation: `+cursor,windsurf -vs-code-fork`.
- **Scoping attributes with target delimiters:**
    - Add `+<target>` to scope an attribute to a target (e.g., `title+cursor="Cursor Rules"`).
    - Precedence: explicit target > target group > default.
- **Modifiers with `?` delimiters:**
    - Some attributes (like `title`) support modifiers for heading levels (e.g., `title?h2="Rules"`).
- **Precedence and Overrides:**
    - Target-specific attributes override group or default values.
    - When multiple attributes apply, the most specific wins.
    - For multiple target specifications, left-to-right precedence applies.
- **Custom Attributes:**
    - Any custom attribute is allowed and will be passed through to the rendered XML, but is not interpreted by Mixdown (e.g., `my-attribute=my-value`).

**Examples:**

```markdown
{{# instructions !xml title="Core Rules" title+cursor="Cursor Rules" }}
```

```markdown
{{# rules export="cli" -cursor }}
```

#### Shortcuts for Filtering Targets

You can use shorthand notation using delimiters for filtering sections by target or group:

- `+<target>` — Only include for specified target (e.g., `+cursor`, `+ide`)
- `-<target>` — Exclude for specified target (e.g., `-cli`, `-roo-code`)
- `+*` — Include for all targets
- `-*` — Exclude for all targets

**Precedence Rules:**

- When a target exists in multiple groups with conflicting filters, explicit target specifications take precedence over group specifications.
- For conflicting patterns (e.g., `+cursor -cursor`), Mixdown will provide a warning or error in strict mode.
- The character set for target IDs is limited to lowercase letters, numbers, and hyphens (`a-z0-9-`).

**Examples:**

```markdown
{{# instructions +ide }}
Visible only in IDE targets.
{{/instructions }}

{{# instructions -cli }}
Hidden from CLI targets.
{{/instructions}}

{{# instructions -* +cursor }}
Only visible in Cursor, hidden from all other targets.
{{/instructions}}
```

#### Title and Heading Attribute Options
<!-- TODO: Double check this section -->
The `title` attribute controls the heading that appears at the start of a section's content. As noted in the [Terminology Notes](#terminology-notes), "name" is the section's identifier (implied by the section tag name), while "title" refers to the actual rendered heading level. The `title` attribute is highly flexible and supports several modifiers and overrides:

- **Basic Use:**
    - `title="My Section Heading"` injects a heading at the top of the section.
    - Alternatively, use the section-title shorthand: `{{# "My Section Heading" }}`

    ```markdown
    {{# instructions title="Rules" !xml }}
    Section content.
    {{/instructions}}
  
    Renders as:
  
    # Rules
    Section content.
    ```

- **Heading Level Modifiers:**
    - Use `title?h[1-6]` to force a specific heading level (e.g., `title?h2="Rules"` → `## Rules`).
    - Use `title?h:inc` to increment the current heading level (e.g., if parent is `##`, this becomes `###`).
    - Use `title?h:dec` to decrement the current heading level (e.g., if parent is `###`, this becomes `##`).
    - Example:

    ```markdown
    {{# section title?h3="Subsection" !xml }}
    Content.
    {{/section}}

    Renders as:

    ### Subsection
    Content.
    ```

- **Replace First Heading:**
    - Use `title?replace="New Heading"` to replace the first heading found in the section content with the value of `title`.
        - Note: This is useful primarily when embedding content with an existing heading.
    - If no value is provided (`title?replace`), the section title is used as the heading.
    - Example:

    ```markdown
    {{# rules title?replace="Core Rules" !xml }}
    ## Old Heading
    Content.
    {{/rules}}

    Renders as:

    # Core Rules
    Content.
    ```

- **Target/Group-Specific Overrides:**
    - Use `title+<target>` to override the heading for a specific target or group.
    - Example:

    ```markdown
    {{# instructions title="General Rules" title+cursor="Cursor Rules" !xml }}
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

- **Setting Just the Heading without Attributes:**
    - To quickly set up just a heading without other attributes:

    ```markdown
    {{# "Core Rules" }}
    Content goes here...
    {{/ "Core Rules"}}
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
<!-- TODO: Address exporting -->
#### Target Group Usage

- Use group names in attribute scopes (e.g., `title+ide="Heading for IDEs"`).
- Use in filter/export attributes (e.g., `export="cli"`).
- Use shortcuts in sections to filter by target group (e.g., `{{# instructions +ide }}`).

### Front-Matter

```yaml
---
# /prompts/instructions/my-rule.md
name: my-rule
version: 1.0.0
labels: ["core", "security"]
# Target filter examples using standard keys:
targets:
  include: ["cursor", "cli"]
  exclude: ["windsurf"]
---
```

Provider plugins declare allowed and required front-matter keys within their manifests using the `types.<artifact>.allowedkeys` and `types.<artifact>.required-keys` arrays respectively. Missing `required-keys` will raise build errors, ensuring necessary metadata is present for each artifact type. In some cases, such as `globs`, the target may require a key to be present, but a value is not required.

#### Target-Specific Front Matter

Front-matter supports several approaches for target scoping and configuration:

1. **Standard Target Filter Keys**:

   ```yaml
   targets:
     include: ["cursor", "cli"]  # Include only these targets/groups
     exclude: ["windsurf"]        # Exclude these targets/groups
   ```

   - Note: The `+/-` delimiters used in section attributes do NOT apply in front-matter
   - Full target names or group names must be used instead

2. **Target-Specific Override Blocks**:

   ```yaml
   ---
   description: General description  # Default for all targets
   cursor:                           # Override block for Cursor target
     description: Cursor-specific description
   roo-code:                       # Quotes needed for kebab-case
     file: "roo-code-instructions"
   ide:                           # Target group override
     icon: "🖥️"
   ---
   ```

3. **Combining Both Approaches**:
<!-- TODO: Double check on quotes around targets, and use of `name` as frontmatter key -->
   ```yaml
   ---
   name: coding-standards
   targets:
     include: ["ide", "claude-code"]
   cursor:
     file: "cursor-coding-standards"
   ---
   ```

**Precedence Rules**:

- Target-specific keys override global values
- If multiple target overrides could apply (e.g., a target is in multiple groups), explicit target overrides take precedence over group overrides
- For conflicting include/exclude targets, explicit exclusions take precedence

### Placeholder Instructions

When writing prompts or instructions, it has become common practice to use placeholders as self-contained prompts to direct an AI to fill in. Placeholders typically take the form of bracketed or braced text, e.g. `[task description]` or `{short task summary}`. Mixdown supports this out of the box, and can work with either `[placeholder]` or `{placeholder}` syntax. These are distinguished from other Mixdown syntax by simply using single bracket or bracing characters.

- ✅ Do this:
    - `[placeholder text]`
    - `{placeholder text}`
- ❌ Don't do this:
    - `[[placeholder text]]`
    - `{{placeholder text}}`
    - `<placeholder text>`

> [!IMPORTANT]
> Remember, placeholder values should be simply considered instructions for the AI, and the output may not always be exactly what you expect.

#### Placeholder Formatting

Since placeholders are basically just prompts, you can experiment with different things to try to coax out a specific output. Some ideas:

- Markdown-formatting (these are generally pretty reliable):
    - Bold: `**[placeholder text]**`
    - Italics: `*[placeholder text]*`
    - etc.
- Pipe-delimited formatting:
    - `[placeholder text|uppercase]`: "Instruction: placeholder text should be formatted in uppercase"

### Insertions

| Type | Syntax | Notes |
|------|--------|-------|
| **Alias** | `{{ $name }}` | Alias lookup chain: current file's front-matter → `prompts/data/alias.yaml`. |
| **File Data** | `{{ $.[filename].key }}` | Injects YAML data from `prompts/data/[filename].yaml`. |
| **Front-matter** | `{{ $.file.key }}` | Access current file's front-matter. |

**Built-in System Insertions**:

- `{{ $target }}` → current target ID
- `{{ $target.name }}` → display name from the provider manifest

**Insertion Types:**

- **Alias:** `{{ $name }}` — Looks up alias in current file's frontmatter or `prompts/data/alias.yaml`.
- **Data:** `{{ $.user.name }}` — Injects YAML data from `prompts/data/user.yaml`.
    - Other data files are also supported
    - Defaults include `user.yaml`, `project.yaml`, and `org.yaml`
    - You can also add your own data files to the `prompts/data` directory and reference them by their filename (excluding .yaml)
- **Current File's Data:** `{{ $.file.key }}` or `{{ $.frontmatter.key }}` — Access current file's front-matter.
- **Escaping:** Prefix with `\` to render as-is (e.g., `\{{ $alias }}`).

**Caching and Performance:**

- YAML file reads and JSON-pointer lookups are memoized and cached by file path + pointer for optimal performance.
- Complex data structure lookups maintain good performance even with deeply nested data.

**Undefined References:**

- By default, undefined references emit a warning and render as `{{⚠ unresolved:path }}` in the output.
- In strict mode (`--strict` flag), undefined references cause the build to fail.

**Debugging:**

- Use the `--debug` flag with the CLI to trace insertion resolution:

  ```bash
  mixdown build --debug
  ```

- Debug output includes JSON lines showing pointer paths and resolved values:

  ```json
  {"type":"insertion", "pointer":"$.user.name", "resolved":"Alice"}
  ```

**Examples:**

```markdown
- Name: {{ $user.name }}
- Email: {{ $.user.email }}
- Please fill out: [ your escalation steps ]
```

### Links

| Type | Syntax | Notes |
|------|--------|-------|
| **Internal Link** | `[Alias](file.md#section)` | Standard Markdown links to other mix files. |
| **Absolute Link** | `[Alias](//src/file.ts)` | Links to project files with `//` prefix. |
| **Link Attributes** | `{{ /my-rule.md alias="Rules" key="value" }}` | Link with additional attributes. |

**Link Examples:**

```markdown
- Link to internal section: [Core Rules](my-rule.md#core-rules)
- Link to project file: [Source File](//src/main.ts)
- Link with attributes: {{ /my-rule.md alias="Core Rules" }}
```

### Embeds
<!-- TODO: Add in section embedding -->
Embeds allow you to include reusable content, mixes, or templates inline.

```markdown
<!-- Embed /prompts/partials/legal.md and suppress its heading -->
{{> legal !heading }}

<!-- Self-closing embed syntax -->
{{> legal !heading /}}

<!-- Embed as a section with attributes -->
{{#> legal title="Legal Section" }}

<!-- Self-closing section embed syntax -->
{{#> legal title="Legal Section" /}}

<!-- Embed /prompts/mixes/common-rules.md and include only section-1 and exclude section-2 -->
{{> mix:common-rules sections="section-1,!section-2" }}

<!-- Embed a specific section from the current mix -->
{{> #section-name }}

<!-- Embed a template -->
{{> template:my-template }}
```

#### Embed Attributes

| Attribute | Purpose |
|-----------|---------|
| `as="alternate-name"` | Rename embed on render; allows for flexibility in XML tag naming. |
| `!heading` | Suppress top heading of source. |
| `!embeds` | Strip nested embeds inside source. |
| `sections="section-1,!section-2"` | Filter specific sections. |

#### Self-Closing Embed Tags

Self-closing embed tags provide a more concise syntax when the embed doesn't have child content:

```markdown
{{> partial attribute="value" /}}
```

Key points about self-closing embed tags:

- They work exactly like regular embed tags but use the trailing slash `/`
- All attributes must appear before the closing slash
- They have complete attribute handling parity with paired tags
- They can be used with all embed types: partials, mixes, sections, and templates
- Multi-line self-closing embeds are supported for readability

#### Embed Advanced Usage

- Embeds can be nested, filtered, and aliased.
- You can include only certain sections, suppress headings, or target specific tools.
- To embed as a section with attributes, use the `#>` prefix.
- Examples:

```markdown
<!-- Simple partial embed -->
{{> legal !heading }}

<!-- Embed as a section with attributes -->
{{#> legal 
  as="Legal Terms"
  !embeds
  sections="summary,steps"
}}

<!-- Embed a specific section from a mix -->
{{> mix:incident-protocol#summary }}
```

### Whitespace Handling

Mixdown has specific rules for whitespace to ensure consistent parsing and output:

- **Tag Component Spacing**:
    - A single space is required after the opening `{{#` or `{{>` in tag declarations
    - Example: ✅ `{{# section }}` (correct), ❌ `{{#section}}` (incorrect)
- **Using Titles for Sections without `title="value"`**:
    - If you want, you can write just the desired title heading name in quotes: `{{# "Section Name" }}`
    - This is a helpful shortcut, and is functionally equivalent to `{{# section-name title="Section Title" }}`
- **Attribute Spacing**:
    - Attributes must be separated by spaces or newlines
    - No spaces are allowed around the `=` sign in attribute declarations
    - Example: `title="value"` (correct), `title = "value"` (incorrect)
- **Whitespace-Sensitive Areas**:
    - Inside attribute values: `title="My Title"` preserves spaces exactly as written
    - Between tag components: `{{# section }}` requires the space after `#`
    - Indentation within section content: preserved exactly as written
- **Whitespace Preservation**:
    - Mixdown preserves all whitespace in section content
    - Leading and trailing whitespace in tag declarations is ignored
    - Multiline tag formatting is allowed and preserved for readability

**Linting and Validation**:

- The `mixdown lint` command can detect and warn about problematic whitespace cases
- The `--fix` flag can automatically correct common whitespace issues: `mixdown lint --fix`

## Code Examples (Practical Snippets)

### Auto-Closing vs. Explicit Nesting

For simplicity, Mixdown auto-closes sections when they're proceeded by another section. This means you can write:

```markdown
{{# example }}
This is an examples section.
{{# example }}
This is an example *inside* the examples section.
{{# example }}
Another example inside the examples section.
```

And see the following rendered (auto-closed):

```markdown
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

However, if you want to explicitly nest sections, you should do so with explicit closures:

```markdown
{{# examples }}
Intro to examples.
  {{# example }}First nested example.{{/example}}
  {{# example }}Second nested example.{{/example}}
{{/examples}}
```

Which would be rendered as:

```markdown
<examples>
Intro to examples.

  <example>First nested example.</example>
  <example>Second nested example.</example>
</examples>
```

### Target-Filter Shortcuts

```markdown
{{# instructions +ide }}
Visible only in IDE targets like Cursor or Windsurf.
{{/instructions}}

{{# instructions -ide }}
Hidden from IDEs; visible everywhere else.
{{/instructions}}

{{# instructions +cli }}
Visible only in CLI targets (Aider, Claude Code).
{{/instructions}}

{{# instructions +cursor -* }}
Only visible in Cursor, excluded from all other targets.
{{/instructions}}
```

### Rich Section Attributes

```markdown
{{# rules
  title="Core Coding Rules"
  export="+cursor"
  include-attributes="title"
}}
All commits *must* follow Conventional Commits.
{{/rules}}
```

- **Cursor** sees `core-rules.mdc` as a separate file.
- **Roo Code** inlines the content with a `## Core Coding Rules` heading.

### Insertion Types in Action

```markdown
### User Info
- Name: {{ $user.name }}
- Email: {{ $.user.email }}
- Current Git Branch: {{ $git-branch }}
- Reference: [Core Rules](rules.md#core-rules)
- Absolute Path: [Source File](//src/main.ts)
- Please fill out: [ your escalation steps ]
```

Aliases resolve from `alias.yaml`, data is pulled from `prompts/data/user.yaml`, and standard Markdown links are used for references. The bracketed instruction remains for the LLM to complete.

### Embed with Section Filtering

```markdown
{{> mix:incident-protocol
  as="protocol"
  !heading
  sections="summary,steps"
}}
```

This embeds the *summary* and *steps* sections from `incident-protocol.md`, suppresses its heading, and aliases the section name to `protocol` in the caller mix.

Alternatively, as a section with attributes:

```markdown
{{#> mix:incident-protocol
  as="Emergency Protocol"
  !heading
  sections="summary,steps"
}}
```

## Directory Structure (Monorepo)

```text
mixdown/
├── prompts/
│   ├── artifacts/
│   │   ├── builds/{id}/    # build-specific outputs
│   │   └── latest/         # symlink to latest build
│   ├── instructions/       # Mix files (*.md)
│   ├── partials/           # reusable content & data
│   └── templates/          # document templates
├── .mixdown/               # compiler config, cache, reports
├── packages/               # pnpm workspaces
│   ├── core/               # core compiler
│   ├── cli/                # Ink-based CLI
│   ├── api/                # Express/MCP API
│   ├── plugin-cursor/      # Cursor target provider plugin
│   ├── plugin-claude-code/ # Claude Code target provider plugin
│   └── plugin-[target]/    # Other target provider plugins
└── docs/                   # deep dives & spec
```

### Documentation

```text
mixdown/
├── advanced-usage.md                     # advanced usage
├── cli.md                                # CLI reference
├── config.md                             # Mixdown configuration
├── glossary.md                           # Mixdown glossary of terms
├── partials.md                           # partials reference
├── mixes.md                              # mixes reference
├── embeds.md                              # embeds reference
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
│       ├── partials-spec.md              # partials specification
│       ├── linting-spec.md               # linting rules specification
│       ├── mix-spec.md                   # mix specification
│       ├── mixdown-syntax.md             # syntax reference
│       ├── embed-spec.md                 # embed specification
│       ├── insertions-spec.md            # insertions specification
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

1. **Core Compiler** – Parses, resolves placeholders & embeds, produces AST.
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

| Attribute            | Type    | Default    | Section | Embed | Front-matter | Description |
|----------------------|---------|------------|---------|-------|--------------|-------------|
| `name`               | string  | none       | ✅      | ✅    | ✅           | Name or identifier (front-matter: mix identifier, required) |
| `title`              | string  | none       | ✅      | ❌    | ❌           | Title for the section which renders as a Markdown heading |
| `description`        | string  | none       | ✅      | ❌    | ✅           | Short description of content |
| `filter`             | list    | none       | ✅      | ❌    | ❌           | Include/exclude targets |
| `export`             | list    | none       | ✅      | ❌    | ❌           | Export as separate artifact |
| `format`             | enum    | none       | ✅      | ❌    | ❌           | Force specific content format |
| `include-attributes` | list    | none       | ✅      | ❌    | ❌           | Whitelist attributes in rendered XML |
| `as`                 | string  | none       | ❌      | ✅    | ❌           | Rename embed on render; allows for flexibility in XML tag naming |
| `sections`           | list    | none       | ❌      | ✅    | ❌           | Filter specific sections |
| `version`            | string  | none       | ❌      | ❌    | ✅           | Mix version (required) |
| `labels`             | array   | `[]`       | ❌      | ❌    | ✅           | Categorization tags |
| `targets`            | array   | `[]`       | ❌      | ❌    | ✅           | Filter applicable targets |
| **Flags**            |         |            |         |       |              | **Boolean attributes (default true unless otherwise noted):** |
| `!xml`               | flag    | true       | ✅      | ❌    | ❌           | Skip XML wrapping |
| `remove-first-heading`| flag   | true       | ✅      | ❌    | ❌           | Strip first intra-section heading |
| `!heading`           | flag    | true       | ❌      | ✅    | ❌           | Suppress top heading of source |
| `!embeds`            | flag    | true       | ❌      | ✅    | ❌           | Strip nested embeds in source |

**Notes:**

- All attributes with string values can be scoped with target/group suffixes (e.g., `heading+cursor="Cursor-specific heading"`)
- Flag attributes default to `true` when specified without a value
- Target-specific front-matter keys override global values (e.g., `cursor: { description: "..." }`)

*© 2025 Mixdown contributors – MIT License.*
