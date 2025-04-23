# Simplifying Mixdown Syntax

*A concise, lint‑friendly overhaul of the Mixdown file format designed to lower the barrier to entry while preserving power‑user flexibility.*

## Table of Contents

- [Table of Contents](#tableofcontents)
- [Why This Change?](#whythischange)
- [Design Goals](#designgoals)
- [At‑a‑Glance Changes](#ataglancechanges)
- [Syntax Reference](#syntaxreference)
    - [Section Delimiters](#sectiondelimiters)
        - [Multi‑line Tags](#multilinetags)
    - [Section Attributes](#sectionattributes)
    - [Front‑matter](#frontmatter)
        - [Provider‑Driven Requirements](#providerdriven-requirements)
    - [Placeholders](#placeholders)
    - [Embeds](#embeds)
- [Heading Levels](#headinglevels)
- [Target Groups](#targetgroups)
- [Advanced Usage](#advancedusage)
- [Ambiguities \& Open Questions](#ambiguitiesopenquestions)
- [TODO List](#todolist)

## Why This Change?

The original Mixdown syntax combined custom XML, bespoke placeholder sigils, and front‑matter alternatives. While functional, the surface area was daunting for newcomers and caused markdown‑lint violations. This proposal makes every Mixdown file **100 % CommonMark‑compliant**, meaning it renders cleanly in GitHub, VS Code, or Obsidian, and is easier to lint, write, and parse.

## Design Goals

| Goal | Description |
|------|-------------|
| **Simplicity** | Reduce the number of bespoke tokens to the minimum needed. |
| **Lintability** | All files must pass standard markdown‑lint without configuration hacks. |
| **Previewability** | Files should render legibly anywhere markdown is rendered. |
| **Extensibility** | Power users can still declare advanced behaviors (export, filtering, etc.) via attributes rather than additional syntax. |

## At‑a‑Glance Changes

| Old Concept | New Concept | Rationale |
|-------------|------------|-----------|
| `<section>` XML tags | `{{section}}` braces | Removes mixed‑language markup & keeps markdown valid. |
| `<meta>` block | Standard `---` YAML front‑matter | Aligns with ecosystem norms (Jekyll, MDX, etc.). |
| `$[link:example]`, `$[alias:name]`, `$[profile:user]` | Unified **placeholders** using braces with a leading sigil or keyword (`{>example}`, `{@name}`, `{=user.name}`) | Single mental model for dynamic substitution. |
| `$[include]` / `mix` / `template` | **Embeds** written as sections with a `$` sigil (`{{$my‑include}}`) | Keeps include semantics but re‑uses the section delimiter. |
| `tool=` attribute | `target=` attribute | Clarifies that the string refers to a build **target**, not an LLM *tool*. |

## Syntax Reference

### Section Delimiters

```md
{{name key="value" flag attr@scope="v"}}
Section contents …
{{/name}}
```

- **Open** `{{name …}}`
- **Close** `{{/name}}` (optional if another section starts)
- **Self‑close** `{{name … /}}`

> **Why braces?** They are always valid markdown and do not require escaping in most editors.

#### Multi‑line Tags

```md
{{instructions
  title="Rules"
  description="Section description."
}}
```

Line breaks plus 4‑space indents are allowed after the section name for readability.

### Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `id` | string | Unique reference for links (`{>file#id}`). |
| `title` | string \| `title?h2="…"` | Heading to inject above the section. Supports heading modifiers. |
| `description` | string | Short blurb, optionally kept via `include-attributes`. |
| `filter` | list | Build‑time include/exclude logic (`filter="target=ide,!windsurf"`). |
| `export` | list | Export section to separate artifact for listed targets. |
| `format` | enum | Force render as `code`, a specific `language`, `blockquote`, or `normal`. |
| `no-xml` | flag | Skip XML wrapping during build. Optional target list: `no-xml="ide"`. |
| `include-attributes` | list | Whitelist attributes preserved in rendered XML. |
| `remove-first-heading` | flag | Strips first intra‑section heading. |
| *Custom* | any | Passed through untouched. |

> Target‑specific overrides: append `@target` or `@group` (e.g., `title@cursor="Cursor Rules"`). Override precedence: *explicit target* → *target group* → *default*.

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

### Placeholders

| Type | Syntax | Old Syntax | Replaced By |
|------|--------|-----------|-------------|
| **Static (AI note)** | `[ fill this in ]` | *unchanged* | – |
| **Alias** | `{@name}` | `$[alias:name]` | Alias lookup chain (front‑matter → project → global). |
| **Data** | `{=user.name}` | `$[profile:user.name]` | YAML data injection. |
| **Internal Link** | `{>file#section\|Alias}` | `$[link:file]` | Smart relinking & target‑aware exports. |

*Placeholders in code blocks are still processed unless back‑slash escaped (`\{@alias}`).*

### Embeds

Embed another mix / include / template inline using the `$` sigil:

```md
{{$include:my‑include}}
{{$mix:common‑rules no-title}}
```

All section attributes are legal plus:

| Attribute | Purpose |
|-----------|---------|
| `as` | Rename embed on render. |
| `no-title` | Suppress embedded document heading. |
| `no-embeds` | Strip nested embeds inside source. |
| `include-frontmatter` | Bring over source front‑matter. |
| `alias-from="source|current"` | Choose which aliases to resolve. |
| `sections="sec1,!sec2"` | Filter specific sections. |

## Heading Levels

Heading generation is configurable globally (`.mixdown/config.yaml`) and per‑file via `heading_level` in front‑matter.

```yaml
mixdown:
  headings:
    default: 2      # <h2> by default
    reserve_h1: true
    strict: true
    range: {min: 2, max: 6}
```

Modifiers on `title` (`?h2`, `?h+`, `?h-`) offer per‑section overrides.

## Target Groups

Built‑in groups streamline attribute filters:

| Group | Members* | Description |
|-------|----------|-------------|
| `ide` | cursor, windsurf, zed | Graphical editors. |
| `vs-code-fork` | cursor, windsurf | VS Code forks. |
| `vs-code-extension` | roo-code, cline | Plugin‑style IDEs. |
| `cli` | aider, claude-code | Terminal tools. |
| `desktop` | cursor, vs‑code | Native apps. |
| `all` | *(wildcard)* | Every registered target. |

*Additional groups may be supplied by provider manifests or overridden in `.mixdown/config.yaml`.*

Example usage:

```md
{{rules export="cli" xml@ide}}
```

## Advanced Usage

- **Placeholder Resolution in Code Blocks** — Mixdown replaces dynamic placeholders even inside fenced blocks; prefix with `\` to keep them literal.
- **Conditional Content (Future)** — `%if target in cli %` style conditionals are planned but not finalized.

## Ambiguities & Open Questions

1. **Heading Algorithm** — Define the *current heading level* when a file starts with `{{section}}`. Should H1 be implicit? How do we clamp `h-1` at `<h6>`?
2. **Group‑Override Merge Semantics** — Does `include/exclude` replace provider `groups[]` or mutate it? The table above assumes *replace*.
3. **Provider Manifest Schema** — Need a full JSON schema with optional keys (`description`, `versionCompat`, etc.).
4. **Case Sensitivity** — Should target IDs, group names, and section names be forced to `lower-kebab`? Decide whether the linter auto‑converts or errors.
5. **Heading Strictness Precedence** — If project config says `strict: true` but a mix sets `strict: false`, which wins? Current assumption: front‑matter overrides project defaults.

## TODO List

- [ ] Add mini‑BNF / regex for section openers, attribute tokens, and placeholders.
- [ ] Provide linter examples for tricky precedence (`xml@cursor` vs. `no-xml`).
- [ ] Expand **Section Attributes** table with default values and target‑specific examples.
- [ ] Author comprehensive provider manifest example.
- [ ] Finalize merge semantics & heading algorithm.
