# 💽 Mixdown – Comprehensive Project Overview

> *One prompt. Every tool. Zero drift.*

## 1. Purpose & Vision

### 1.1 Elevator Pitch

Mixdown is a **CommonMark-compliant prompt compiler** that lets you author a single *mix* file in plain Markdown and compile it into tool-specific instruction artifacts (Cursor `.mdc`, Claude Code `CLAUDE.md`, Roo Code `.md`, and more). Think of it as **Terraform for AI prompts**—declare once, target many, keep every teammate (human *and* bot) on the same authoritative rules.

### 1.2 Problem Statement

- Instruction formats are **fragmented** across IDEs and agentic tools, leading to duplication and drift.
- Manual copy-paste workflows break **source-of-truth** guarantees and slow experimentation with new tools.
- Lack of a **machine-readable prompt spec** hinders automation, testing, and versioning.

### 1.3 Solution Overview

Mixdown introduces a single source-of-truth **mix** file written (just a `.md` file) in pure Markdown plus YAML front-matter. The Mixdown compiler:

1. Parses the mix into an AST (sections, placeholders, mixins).
2. Delegates rendering to *plugin providers*—one per target tool.
3. Writes per-tool **artifacts** to predictable locations under `prompts/artifacts/builds/`.
4. Optionally exposes a **CLI** and **HTTP/MCP API** so CI pipelines or agents can fetch fresh rules on demand.

Result: *author once, distribute everywhere, zero drift.*

## 2. Core Concepts

| Term | Definition |
|------|------------|
| **Mix** | Source Markdown file that is compiled into artifacts. |
| **Artifact** | Tool-specific output file (e.g., `.cursor/rules/foo.mdc`). |
| **Section** | Delimited block `{{section}}…{{/section}}` with optional attributes. |
| **Mixin** | Re-usable include (`{{$my-include}}`) that can embed another mix/segment/template. |
| **Placeholder** | Dynamic token replaced at build time (`{@alias}`, `{=data.key}`, `[ fill this in ]`). |
| **Target** | A supported tool (Cursor, Roo Code, etc.) identified by an ID. |
| **Target Group** | Named set of targets (`@ide`, `@cli`) for attribute filtering. |

## 3. Key Features

- **100 % CommonMark** – Renders cleanly in GitHub & VS Code; passes markdown-lint.
- **Plugin Architecture** – Add new targets via `MixdownPluginProvider` without touching core.
- **Granular Sections** – Export, filter, or re-title sections per target.
- **Powerful Placeholders** – Aliases, YAML data injections, runtime values (`{@git_branch}`) with sandboxed resolvers.
- **CLI & API** – `mixdown build`, `mixdown validate`, and `POST /compile` endpoint return ZIP artifacts, unzipped into `artifacts/builds/`.
- **Snapshot Testing** – Contract tests ensure mix edits don't silently change generated artifacts.

## 4. Supported Targets (MVP)

| 🚦 | ID | Tool | Type | Status |
|----|----|------|------|--------|
| ✅ | `cursor` | Cursor | IDE | Stable |
| 🟡 | `claude-code` | Claude Code | CLI | Beta |
| 🟡 | `roo-code` | Roo Code | VS Code Ext | Beta |
| 🔵 | `aider` | Aider | CLI | Planned |
| 🔵 | `openai-codex` | OpenAI Codex | CLI | Planned |
| 🔵 | `windsurf` | Windsurf | IDE | Planned |

*Want a new target? Implement `toolProvider` and publish `@mixdown/plugin-<your-tool>`. See `docs/provider-development.md`.*

## 5. Getting Started

### 5.1 Installation

```bash
npm install -g mixdown        # global CLI
# or project-local
npm install --save-dev mixdown
```

### 5.2 Quick Start

```bash
mixdown init          # scaffolds prompts/ & .mixdown/
cd prompts/instructions
echo "---\nname: hello\n---\n{{system}}Hi!{{/system}}" > hello.mixd
cd ../..

mixdown build         # writes artifacts under prompts/artifacts/
```

The latest build is always symlinked at `prompts/artifacts/latest/`.

## 6. Syntax Cheatsheet

| Token / Feature | Example | Notes |
|-----------------|---------|-------|
| **Section** | `{{instructions title="Rules" export="cli"}}…{{/instructions}}` | Attributes control heading & export. |
| **Front-matter** | `---\nname: foo\n---` | YAML at file top. |
| **Mixin Include** | `{{$legal no-title}}` | Embed another mix/include. |
| **Internal Link** | `{>rules\|Read more}` | Auto-resolves per target path. |
| **Alias Placeholder** | `{@project}` | Resolved via alias chain. |
| **Data Placeholder** | `{=user.email}` | Injects YAML data. |
| **Static Fill-In** | `[ fill this in ]` | Marker for LLM to complete. |

Full spec lives in `docs/spec.md`.

## 7. Full Syntax Reference (Specification)

### 7.1 Design Goals

| Goal | Description |
|------|-------------|
| **Simplicity** | Reduce bespoke tokens to the minimum necessary. |
| **Lintability** | Files must pass standard markdown-lint without hacks. |
| **Previewability** | Render legibly in GitHub, VS Code, Obsidian, etc. |
| **Extensibility** | Advanced behaviors declared via attributes instead of new syntax. |

### 7.2 Section Delimiters

```md
{{instructions title="Rules" export="cli"}}
Please follow these coding standards…
{{/instructions}}
```

- **Section Tags Syntax**:
    - **Open** `{{name …}}`  
    - **Close** `{{/name}}` (optional if another section starts)  
    - **Self-close** `{{name … /}}` (Attributes must precede the `/`)
- **Section Tag Naming**:
    - `snake_case` is recommended for section names.
    - `kebab-case` and `spaced out` are also supported but will be normalized to `snake_case` in rendered output.

**Multi-line Tags** are allowed for readability, and the parser preserves this formatting:

```md
{{instructions
  title="Rules"
  description="Section description."
}}
```

### 7.3 Section Attributes

| Attribute | Type | Purpose |
|-----------|------|---------|
| `id` | string | Unique reference for `{>file#id}` links. |
| `title` | string / `title?h2="…"` | Inject a heading above the section. |
| `description` | string | Short blurb retained in rendered XML (if allowed). |
| `filter` | list | Include/exclude targets (`filter="target=ide,!windsurf"`). |
| `export` | list | Export section as its own artifact for listed targets. |
| `format` | enum | Force `code`, `language`, `blockquote`, etc. |
| `no-xml` | flag | Skip XML wrapping. Optional target list: `no-xml="ide"`. |
| `include-attributes` | list | Whitelist attributes preserved in rendered XML. |
| `remove-first-heading` | flag | Strip first intra-section heading. |
| *Custom* | any | Passed through untouched. |

> **Target-specific overrides**: append `@target` / `@group` (e.g. `title@cursor="Cursor Rules"`). Precedence: explicit target → target group → default.

### 7.4 Front-Matter

```yaml
---
name: my-rule
version: 1.0.0
labels: ["core", "security"]
# Target filter examples:
# targets: ["cursor", "!windsurf", "@cli"]
---
```

Provider plugins declare allowed and required front-matter keys within their manifests using the `types.<artifact>.allowed_keys` and `types.<artifact>.required_keys` arrays respectively (see example in Section 7.9). Missing `required_keys` will raise build errors, ensuring necessary metadata is present for each artifact type. In some cases, such as `globs`, the target may require a key to be present, but a value is not required.

*Target-specific overrides*:

```yaml
---
description: General description
cursor:
  description: Cursor-specific description
---
```

### 7.5 Placeholders

| Type | Syntax | Notes |
|------|--------|-------|
| **Static (AI note)** | `[ fill this in ]` | Human or AI-fillable placeholder |
| **Alias** | `{@name}` | Alias lookup chain: front-matter → project → global. |
| **Data** | `{=user.name}` | Injects YAML data from `prompts/data/user.yaml`. |
| **Internal Link** | `{>file#section\|Alias}` | Path auto-resolved per target. |

**Built-in Alias Placeholders**:

- `{@target}` → current target ID  
- `{@target.name}` → display name from the provider manifest

### 7.6 Mixins

```md
{{$include:legal no-title}}
{{$mix:common-rules sections="sec1,!sec2"}}
```

Additional attributes:

| Attribute | Purpose |
|-----------|---------|
| `as="alternate-name"` | Rename mixin on render; helps disambiguate duplicate mixins when the same mixin is included multiple times in a document. |
| `no-title` | Suppress top heading of source. |
| `no-mixins` | Strip nested mixins inside source. |
| `include-frontmatter` | Bring source front-matter into caller. |
| `alias-from="source"` | Choose alias resolution scope (`source` or `current`). |
| `sections="sec1,!sec2"` | Filter specific sections (`sec1,!sec2`). |

## 8. Code Examples (Practical Snippets)

The following examples are lifted from historical design notes and cover everyday authoring scenarios. Build these mixes with `mixdown build` to see artifact differences across targets.

### 8.1 Auto-Closing vs. Explicit Nesting

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

### 8.2 Target-Filter Shortcuts

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

### 8.3 Rich Section Attributes

```md
{{rules
  id="core-rules"
  title="Core Coding Rules"
  export="cursor"
  include-attributes="title"
}}
All commits *must* follow Conventional Commits.
{{/rules}}
```

• **Cursor** sees `core-rules.mdc` as a separate file.  
• **Roo Code** inlines the content with a `## Core Coding Rules` heading.

### 8.4 Placeholder Types in Action

```md
### On-Call Engineer
- Name: {@user.on_call}
- Email: {=user.email}
- Current Git Branch: {@git_branch}
- Please fill out: [ your escalation steps ]
```

Aliases resolve in the documented order (mix ‑> project ‑> global), data is pulled from `prompts/data/user.yaml`, and the bracketed instruction remains for the LLM.

### 8.5 Mixin Include with Section Filtering

```md
{{$mix:incident-protocol
  as="protocol"
  no-title
  sections="summary,steps"
}}
```

This embeds the *summary* and *steps* sections from `incident-protocol.mixd`, suppresses its heading, and aliases the section name to `protocol` in the caller mix.

### 8.6 Front-Matter Migration Cheat-Sheet

Old XML flavour ➜ new YAML flavour:
```xml
<mixdown version="0.1.0">
<meta>
name: legacy-rule
</meta>
<mix>…</mix>
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

## 9. Directory Structure (Monorepo)

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

## 10. System Architecture

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

### 9.1 Component Highlights

1. **Core Compiler** – Parses, resolves placeholders & mixins, produces AST.
2. **Plugin Providers** – Map AST → tool-specific markdown; declare directories & extensions.
3. **CLI** – Ink UI with non-interactive flag support (`--json`).
4. **API Server** – Express + OpenAPI validator; returns ZIP artifacts, MCP-compliant.
5. **Artifact Writer** – Persists outputs, creates `latest` symlink, embeds checksum headers.

## 11. Security, Testing & Performance

| Area | Approach |
|------|----------|
| **Security** | XML parser sandbox (`ignoreEntities: true`), path sanitization, placeholder shell-outs whitelisted. |
| **Testing** | Jest ≥ 80 % coverage; snapshot tests for plugin renders; Supertest E2E for API. |
| **Performance** | Stream parser; <250 ms compile for 500-line mix on M-series CPU. |

## 12. Roadmap (High Level)

| Phase | Deliverables |
|-------|--------------|
| **MVP** | Core compiler, Cursor & Claude providers, `init`/`build`/`validate` CLI, `/compile` API. |
| 0.2 | Roo Code & Windsurf providers, provider SDK docs. |
| 0.3 | Prompt test harness, security hardening, >90 % coverage. |
| 0.4 | Mix registry (`mixdown add @acme/rails-rules`), web playground. |

Track detailed tasks in `.agent/tasks.md` and project plan docs.

## 13. Contributing & Community

1. **Fork → `pnpm i` → `pnpm dev`**.
2. Follow conventional commits; run `pnpm changeset add` for version bumps.
3. Add unit & contract tests for new features.
4. Submit PR—CI must pass snapshot tests.

See [`docs/contributing.md`](docs/contributing.md) for full guidelines.

## 14. References

- `docs/spec.md` – Full syntax specification.
- `docs/provider-development.md` – Build a new plugin provider.
- `simplifying-mixdown-syntax.md` – Design rationale & deep-dive.
- `README.md` – Project README (public landing).

## 15. Appendix

### 15.1 Comprehensive Attribute Reference Table

The following table provides a complete list of all supported attributes in Mixdown, their types, default values, and scope support:

| Attribute | Type | Default | Section | Mixin | Front-matter | Description |
|-----------|------|---------|---------|-------|--------------|-------------|
| `id` | string | none | ✅ | ❌ | ❌ | Unique reference for sections |
| `title` | string | none | ✅ | ❌ | ❌ | Inject heading above section |
| `description` | string | none | ✅ | ❌ | ✅ | Short description of content |
| `filter` | list | none | ✅ | ❌ | ❌ | Include/exclude targets |
| `export` | list | none | ✅ | ❌ | ❌ | Export as separate artifact |
| `format` | enum | none | ✅ | ❌ | ❌ | Force specific content format |
| `no-xml` | flag | true | ✅ | ❌ | ❌ | Skip XML wrapping |
| `include-attributes` | list | none | ✅ | ❌ | ❌ | Whitelist attributes in rendered XML |
| `remove-first-heading` | flag | true | ✅ | ❌ | ❌ | Strip first intra-section heading |
| `as` | string | none | ❌ | ✅ | ❌ | Rename mixin on render to disambiguate duplicate mixins in the same document. |
| `no-title` | flag | true | ❌ | ✅ | ❌ | Suppress top heading of source |
| `no-mixins` | flag | true | ❌ | ✅ | ❌ | Strip nested mixins in source |
| `include-frontmatter` | flag | false | ❌ | ✅ | ❌ | Bring source front-matter into caller |
| `alias-from` | enum | "current" | ❌ | ✅ | ❌ | Alias resolution scope |
| `sections` | list | none | ❌ | ✅ | ❌ | Filter specific sections |
| `name` | string | none | ❌ | ❌ | ✅ | Mix identifier (required) |
| `version` | string | none | ❌ | ❌ | ✅ | Mix version (required) |
| `labels` | array | `[]` | ❌ | ❌ | ✅ | Categorization tags |
| `targets` | array | `[]` | ❌ | ❌ | ✅ | Filter applicable targets |
| `heading_level` | object | config | ❌ | ❌ | ✅ | Override heading settings |

**Notes:**
- All attributes with string values can be scoped with target/group suffixes (e.g., `title@cursor="Cursor-specific title"`)
- Flag attributes default to `true` when specified without a value
- Target-specific front-matter keys override global values (e.g., `cursor: { description: "..." }`)

### 15.2 Legacy Format Migration

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
<mix>…</mix>
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