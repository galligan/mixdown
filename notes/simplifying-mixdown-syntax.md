# Simplifying Mixdown Syntax

*A concise, lint‑friendly overhaul of the Mixdown file format designed to lower the barrier to entry while preserving power‑user flexibility.*

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Why This Change?](#why-this-change)
- [Design Goals](#design-goals)
- [At‑a‑Glance Changes](#ataglance-changes)
- [Syntax Reference](#syntax-reference)
    - [Section Delimiters](#section-delimiters)
        - [Multi‑line Tags](#multiline-tags)
    - [Section Attributes](#section-attributes)
    - [Front‑matter](#frontmatter)
        - [Provider‑Driven Requirements](#providerdriven-requirements)
        - [Target-specific Frontmatter](#target-specific-frontmatter)
    - [Placeholders](#placeholders)
        - [Built‑in Alias Placeholders](#builtin-alias-placeholders)
        - [Data Placeholders](#data-placeholders)
    - [Mixins](#mixins)
- [Heading Levels](#heading-levels)
    - [Attribute Modifiers](#attribute-modifiers)
- [Target Groups](#target-groups)
    - [Provider-defined Groups](#provider-defined-groups)
    - [Project-level Group Overrides](#project-level-group-overrides)
- [Advanced Usage](#advanced-usage)
    - [Attribute Parsing](#attribute-parsing)
- [Ambiguities \& Open Questions](#ambiguities--open-questions)
- [Future Plans](#future-plans)
    - [Plugin Target Versioning](#plugin-target-versioning)
- [TODO List](#todo-list)

## Why This Change?

The original Mixdown syntax combined custom XML, bespoke placeholder sigils, and front‑matter alternatives. While functional, the surface area was daunting for newcomers and caused markdown‑lint violations. This proposal makes every Mixdown file **100% CommonMark‑compliant**, meaning it renders cleanly in GitHub, VS Code, or Obsidian, and is easier to lint, write, and parse.

## Design Goals

| Goal | Description |
|------|-------------|
| **Simplicity** | Reduce the number of bespoke tokens to the minimum needed. |
| **Lintability** | All files must pass standard markdown‑lint without configuration hacks. |
| **Previewability** | Files should render legibly anywhere markdown is rendered. |
| **Extensibility** | Power users can still declare advanced behaviors (export, filtering, etc.) via attributes rather than additional syntax. |

## At‑a‑Glance Changes

| Old Concept | New Concept | Rationale |
|-------------|------------|-----------|
| `<section>` XML tags | `{{section}}` braces | Removes mixed‑language markup & keeps markdown valid. |
| `<meta>` block | Standard `---` YAML front‑matter | Aligns with ecosystem norms (Jekyll, MDX, etc.). |
| `$[link:example]`, `$[alias:name]`, `$[profile:user]` | Unified **placeholders** using braces with a leading sigil or keyword (`{>example}`, `{@name}`, `{=user.name}`) | Single mental model for dynamic substitution. |
| `$[include]` / `mix` / `template` | **Mixins** written as sections with a `$` sigil (`{{$my‑include}}`) | Keeps include semantics but re‑uses the section delimiter. |
| `tool=` attribute | `target=` attribute | Clarifies that the string refers to a build **target**, not an LLM *tool*. |

## Syntax Reference

### Section Delimiters

```md
{{name key="value" flag attr@scope="v"}}
Section contents …
{{/name}}
```

- **Open** `{{name …}}`
- **Close** `{{/name}}` (optional if another section starts)
- **Self‑close** `{{name … /}}`

> **Why braces?** They are always valid markdown and do not require escaping in most editors.

#### Multi‑line Tags

```md
{{instructions
  title="Rules"
  description="Section description."
}}
```

Line breaks plus 4‑space indents are allowed after the section name for readability.

### Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `id` | string | Unique reference for links (`{>file#id}`). |
| `title` | string \| `title?h2="…"` | Heading to inject above the section. Supports heading modifiers. |
| `description` | string | Short blurb, optionally kept via `include-attributes`. |
| `filter` | list | Build‑time include/exclude logic (`filter="target=ide,!windsurf"`). |
| `export` | list | Export section to separate artifact for listed targets. |
| `format` | enum | Force render as `code`, a specific `language`, `blockquote`, or `normal`. |
| `no-xml` | flag | Skip XML wrapping during build. Optional target list: `no-xml="ide"`. |
| `include-attributes` | list | Whitelist attributes preserved in rendered XML. |
| `remove-first-heading` | flag | Strips first intra‑section heading. |
| *Custom* | any | Passed through untouched. |

> Target‑specific overrides: append `@target` or `@group` (e.g., `title@cursor="Cursor Rules"`). Override precedence: *explicit target* → *target group* → *default*.

### Front‑matter

Every Mixdown file begins with YAML front‑matter:

```yaml
---
mixdown:
  version: 0.1.0
name: my-rule
description: "Rule description."
targets: ["cursor", "roo-code", "!windsurf"] # List items as strings should be wrapped in quotes
labels: ["core", "security"]
# ...other keys allowed
---
```

*Keys outside the spec are ignored in build artifacts but retained for human context.*

#### Provider‑Driven Requirements

Target providers can declare `required_keys` / `allowed_keys` per artifact type. Missing required keys raise build errors.

#### Target-specific Frontmatter

You can override frontmatter values for specific targets:

```yaml
---
description: "General description for all targets"
cursor:
  description: "Cursor-specific description"
---
```

When the mix is rendered for Cursor, it will use the Cursor-specific description instead of the general one.

### Placeholders

| Type | Syntax | Old Syntax | Replaced By |
|------|--------|-----------|-------------|
| **Static (AI note)** | `[ fill this in ]` | *unchanged* | – |
| **Alias** | `{@name}` | `$[alias:name]` | Alias lookup chain (front‑matter → project → global). |
| **Data** | `{=user.name}` | `$[profile:user.name]` | YAML data injection. |
| **Internal Link** | `{>file#section\|Alias}` | `$[link:file]` | Smart relinking & target‑aware exports. |

*Placeholders in code blocks are still processed unless back‑slash escaped (`\{@alias}`).*

#### Built‑in Alias Placeholders

- **`{@target}`**: The current target ID (e.g., `cursor`, `roo-code`)
    - When used with a target group, expands to all member targets
- **`{@target.name}`**: The display name of the current target (e.g., `Cursor`, `Roo Code`)

**Alias Resolution Order:**

1. Mix's frontmatter under the `aliases` key
2. Project private aliases (`prompts/data/.aliases.private.yaml`)
3. Project public aliases (`prompts/data/aliases.yaml`)
4. Global aliases (`.config/mixdown/aliases.yaml`)

#### Data Placeholders

Data placeholders (`{=key.path}`) inject values from YAML files:

- Files are loaded from `prompts/data/{filename}.yaml`
- The placeholder path maps to the YAML path: `{=user.name}` → `prompts/data/user.yaml` with key `name`
- Deeply nested properties use dot notation: `{=project.team.lead.email}`

### Mixins

Mixins are a mechanism to embed another mix / include / template inline using the `$` sigil:

```md
{{$include:my‑include}}
{{$mix:common‑rules no-title}}
```

All section attributes are legal plus:

| Attribute | Purpose |
|-----------|---------|
| `as` | Rename mixin on render. |
| `no-title` | Suppress a mixin's document heading. |
| `no-mixins` | Strip nested mixins inside source. |
| `include-frontmatter` | Bring over source front‑matter. |
| `alias-from="source\|current"` | Choose which aliases to resolve. |
| `sections="sec1,!sec2"` | Filter specific sections. |

## Heading Levels

Heading generation is configurable globally (`.mixdown/config.yaml`) and per‑file via `heading_level` in front‑matter.

```yaml
mixdown:
  headings:
    default: 2      # <h2> by default
    reserve_h1: true
    strict: true
    case: "title"   # "title" | "sentence" | "lower" | "upper"
    break_after: true
    range: {min: 2, max: 6}
```

Per‑file front‑matter can override global settings:

```yaml
---
heading_level:
  reserve_h1: false
  strict: false
  range:
    min: 1
    max: 6
---
```

### Attribute Modifiers

Title attributes support these modifiers:

- **Heading level** modifiers adjust rendering depth:
    - `title?h2="Rules"` → `## Rules` (explicit level)
    - `title?h+="Rules"` → Increment current level (h2→h3)
    - `title?h-="Rules"` → Decrement current level (h2→h1)
- **Replacement** modifiers affect section content:
    - `title?replace="New Title"` → Replace first heading in section
    - `title?replace` → Replace first heading with section's name

## Target Groups

Built‑in groups streamline attribute filters:

| Group | Members* | Description |
|-------|----------|-------------|
| `ide` | cursor, windsurf, zed | Graphical editors. |
| `vs-code-fork` | cursor, windsurf | VS Code forks. |
| `vs-code-extension` | roo-code, cline | Plugin‑style IDEs. |
| `cli` | aider, claude-code | Terminal tools. |
| `desktop` | cursor, vs‑code | Native apps. |
| `all` | *(wildcard)* | Every registered target. |

*Additional groups may be supplied by provider manifests or overridden in `.mixdown/config.yaml`.*

Example usage:

```md
{{rules export="cli" xml@ide}}
```

### Provider-defined Groups

Plugins define their own groups in manifest files:

```json
// @mixdown/target-cursor/mixdown-provider.json
{
  "id": "cursor",
  "name": "Cursor",
  "groups": ["ide", "vscode", "agent", "desktop"],
  "types": {
    "rule": {
      "dir": ".cursor/rules",
      "ext": ".mdc",
      "allowed_keys": ["description", "globs", "alwaysApply"],
      "required_keys": ["description", "globs", "alwaysApply"]
    }
  }
}
```

### Project-level Group Overrides

Target groups can be customized in your project's `.mixdown/config.yaml` file:

```yaml
target-groups:
  # Define a new target group
  core:
    include: ["cursor", "roo-code"]
    description: "Core editor targets"
  
  # Override an existing target group
  ide:
    include: ["zed", "cursor"]  # Replace original members with these
    exclude: ["windsurf"]       # Additionally exclude these targets
    description: "Preferred IDE targets"
  
  # Extend an existing group
  cli:
    append: ["new-terminal-tool"]  # Add to existing members
    description: "Command-line interface tools"
```

**Group Override Semantics:**

1. When using `include`, you're fully replacing the original group members
2. The `exclude` property removes targets from the result (applied after `include`)
3. Use `append` to add to existing members without replacing them
4. Groups defined at the project level take precedence over provider-defined groups
5. Group names are automatically kebab-cased for consistency

Group expansion happens during build time in this order:

1. Load provider-defined groups
2. Apply project overrides (replace/extend)
3. Resolve nested group references
4. Apply build-time exclusions

## Advanced Usage

- **Placeholder Resolution in Code Blocks** — Mixdown replaces dynamic placeholders even inside fenced blocks; prefix with `\` to keep them literal.
- **Conditional Content (Future)** — `%if target in cli %` style conditionals are planned but not finalized.
- **Target-specific Attributes** — Use `@target` suffix for target-specific values like `title@cursor="Cursor Rules"`.
- **Section Nesting** — For proper nesting and complex hierarchies, use explicit closing tags.
- **Filter Shortcuts** — Use double-@ symbols for simpler target filtering:

  ```md
  {{instructions @@ide}}
  <!-- Only renders for IDE targets -->
  
  {{instructions !@windsurf}}
  <!-- Renders for all targets except Windsurf -->
  ```

### Attribute Parsing

- **Flags** (boolean attributes):
    - Format: `attribute-name` without `=`
    - Examples: `no-xml`, `export`
    - Default value: `true`

- **Scoped attributes**:
    - Format: `attribute@target="value"`
    - Target-specific configuration
    - Valid only with value assignment
    - Precedence: `@target` > `@target-group` > no scope

- **Key-value pairs**:
    - Format: `key="value"` or `key=value` (quotes required for values with spaces)
    - Some attributes support modifiers: `title?h2="My Title"`

Examples:

```text
no-xml                      # No XML tags in the artifact
no-xml="ide"                # No XML tags for IDE targets
title="Rules"               # Heading for all targets
title@cli="CLI Rules"       # Override for CLI targets
```

## Ambiguities & Open Questions

1. **Heading Algorithm** — Define the *current heading level* when a file starts with `{{section}}`. Should H1 be implicit? How do we clamp `h-1` at `<h6>`?
2. **Group‑Override Merge Semantics** — Does `include/exclude` replace provider `groups[]` or mutate it? The table above assumes *replace*.
3. **Provider Manifest Schema** — Need a full JSON schema with optional keys (`description`, `versionCompat`, etc.).
4. **Case Sensitivity** — Should target IDs, group names, and section names be forced to `lower-kebab`? Decide whether the linter auto‑converts or errors.
5. **Heading Strictness Precedence** — If project config says `strict: true` but a mix sets `strict: false`, which wins? Current assumption: front‑matter overrides project defaults.

## Future Plans

### Plugin Target Versioning

A challenge in plugin ecosystems is handling version compatibility across multiple targets. Future versions of Mixdown will introduce a standardized approach to version management:

```json
{
  "id": "cursor",
  "name": "Cursor",
  "version": "1.0.0",
  "versionCompat": {
    "mixdown": "^2.0.0",
    "targets": {
      "roo-code": ">=0.8.0 <2.0.0",
      "windsurf": "^1.0.0"
    }
  }
}
```

**Key Benefits:**

1. **Version Awareness:** Plugins can declare which versions of Mixdown and other plugins they're compatible with
2. **Conflict Detection:** Build-time warnings when incompatible plugin combinations are used
3. **Feature Negotiation:** Auto-selection of compatible feature sets when version mismatches occur
4. **Graceful Degradation:** Mixdown can handle version differences by:
   - Warning about potential issues during build
   - Disabling specific incompatible features
   - Offering options for version-specific alternatives
   - Providing clear error messages when versions are incompatible

**Implementation Plan:**

1. Initially, introduce simple version declaration in provider manifests
2. Add build-time compatibility checking
3. Later expand to feature-level compatibility negotiation

This approach will provide stability as the Mixdown ecosystem grows, preventing breaking changes when plugins update at different rates.

## TODO List

- [x] Finalize this document (details available in [older version](simplifying-mixdown-syntax.backup.md))
    - [x] Clarify attribute parsing rules — differentiate **flags** vs. `key="value"` pairs, quoting requirements, and `@scope` precedence (`@target` > `@group` > default).
    - [x] Document simple filter shortcuts using `@@target` and `!@target` aliases for include/exclude cases.
    - [x] Add explanation of built‑in **alias placeholders** (`{@target}`, `{@target.name}`) and alias resolution order (front‑matter → project → global).
    - [x] Detail **data placeholders** (`{=file.key}`) including YAML file lookup semantics (`prompts/data/{file}.yaml`).
    - [x] Expand **Heading Level** config options to cover `case`, `break_after`, and demonstrate front‑matter overrides.
    - [x] Describe `title?replace` and other attribute modifiers (`?h2`, `?h+`, `?h-`).
    - [x] Document project‑level overrides for `target-groups` in `.mixdown/config.yaml` (include/exclude semantics, replacement vs. merge, example YAML).
    - [x] Outline *Future* section on plugin‑declared target version compatibility and how Mixdown should handle differing target versions across plugins.
- [ ] Add mini‑BNF / regex for section openers, attribute tokens, and placeholders.
- [ ] Provide linter examples for tricky precedence (`xml@cursor` vs. `no-xml`).
- [ ] Expand **Section Attributes** table with default values and target‑specific examples.
- [ ] Author comprehensive provider manifest example.
- [ ] Finalize merge semantics & heading algorithm.
