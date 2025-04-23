---
name: mixdown
version: 0.1.0
Description: "CommonMark‑compliant prompt compiler and CLI."
labels: ["ai", "ai-agents", "prompt‑engineering", "compiler"]
---

# 💽 Mixdown – A Toolbox for AI/Agentic Prompting

> **TL;DR** Write your prompts once in lint‑clean Markdown, target every AI coding tool you use, and keep your whole team (human _and_ bot) on the same authoritative rules—no copy‑paste, no drift.

Mixdown ships **two things**:

1. **A CLI + API** that compiles your Markdown‑based *mix* files into tool‑specific artifacts (Cursor `.mdc`, Roo Code `.md`, Claude Code commands, etc.).
2. **A lightweight markup spec** for writing those mix files—100 % CommonMark, zero custom XML, fully lintable, renders perfectly in GitHub/VS Code/Obsidian.

## 1. What Exactly Is a Mix?

A **mix** is the _gold master_ of a rule, command, or template. Think of it like the final song bounce in audio production: once you’ve mixed down, every headphone and speaker hears the same version.

A minimal mix:

```md
---
name: hello‑world
version: 1.0.0
labels: ["example"]
---

{{system}}
You are a friendly assistant.
{{/system}}

{{instructions title="User Greeting"}}
Please greet the user by name.
{{/instructions}}
```

Running `mixdown build` renders artifacts such as:

- `.cursor/rules/hello‑world.mdc`
- `.roo/rules/hello‑world.md`
- `.claude/commands/hello‑world.md`

…each with the heading levels, front‑matter keys, and extensions that tool expects.

## 2. Why Mixdown?

| Pain | Mixdown Fix |
|------|-------------|
| **Multiple Specs** – Every tool wants a different rules file. | Author once → compile to many. |
| **Markdown lint errors** – Hybrid XML/Markdown breaks renders & linters. | Pure CommonMark braces: `{{section}}` |
| **Doc Drift** – Teammates copy files and forget to update. | Single source of truth, build‑time diffs, CI snapshot tests. |

## 3. Supported Targets

| 🚦 | ID | Tool | Type | Status |
|----|----|------|------|--------|
| ✅ | `cursor` | Cursor | IDE | Stable |
| 🟡 | `claude-code` | Claude Code | CLI | Beta |
| 🟡 | `roo-code` | Roo Code | VS Code Ext | Beta |
| 🔵 | `openai-codex` | OpenAI Codex | CLI | Planned |
| 🔵 | `windsurf` | Windsurf | IDE | Planned |

Want another target? Implement [`toolProvider`](docs/tool‑provider.md) and ship it as `@mixdown/target‑<your‑tool>`.

## 4. Install

```bash
npm i -g mixdown        # global CLI
# or
npm i --save-dev mixdown # project‑local
```

### Quick Start

```bash
mixdown init            # scaffolds prompts/ & .mixdown/
cd prompts/instructions
code hello-world.md     # write your first mix (see sample above)
cd ../..

mixdown build           # writes tool artifacts under prompts/artifacts/
```

The latest build is always symlinked at `prompts/artifacts/latest/`.

## 5. Syntax Overview

| Token / Feature | Example | Description |
|-----------------|---------|-------------|
| **Section**     | `{{instructions}}…{{/instructions}}` | Block of content, supports attributes. |
| **Front‑matter**| `---\nname: foo\n---` | Standard YAML metadata at top of file. |
| **Internal Link** | `{>rules|Read more}` | Smart link to another mix or section. |
| **Alias Placeholder** | `{@project}` | Injects value from aliases chain. |
| **Data Placeholder** | `{=user.name}` | Injects YAML data. |
| **Mixin Include** | `{{$legal no-title}}` | Inline include of another mix, include, or template. |

Full syntax details live in [`docs/spec.md`](docs/spec.md).

## 6. Key Concepts Glossary

| Term | Meaning |
|------|---------|
| **Mix** | Source Markdown compiled to artifacts. |
| **Artifact** | Tool‑specific output (file path + format). |
| **Section** | Delimited block; can be filtered, exported, or given attributes. |
| **Mixin** | Re‑usable include (`{{$foo}}`). |
| **Placeholder** | Runtime value injection (`{@alias}` / `{=data.key}`). |
| **Target Group** | Named list of targets (e.g., `@ide`). |

## 7. Authoring Cheatsheet

```md
---
name: code‑quality
labels: ["lint", "rules"]
targets: ["@ide", "!windsurf"]   # build for all IDEs except Windsurf
---

{{rules title@cursor="Cursor Rules"}}
Follow these coding conventions …
{{/rules}}

{{example export="cli"}}
# good_example
print("hello")
{{/example}}
```

- **Attribute scopes** `@cursor` → specific target, `@ide` → group.
- **Export** writes the section as its own artifact for listed targets.
- Prefix `!` to exclude targets: `filter="!@cli"`.

## 8. Versioning & CI

We use **Changesets**. Run `pnpm changeset add`, fill the prompt, merge to `main`, and CI will version & publish.

Add **artifact snapshot tests**:

```bash
mixdown test
```

CI fails if a mix edit changes generated files without an accompanying Changeset.

## 9. Roadmap (High Level)

- 🔌 **Plugin SDK** – 3rd‑party targets via `toolProvider` interface.
- 🧪 **Prompt Lint/Test Harness** – Diff model outputs across builds.
- 🛡️ **Sandbox & Security** – XSS‑safe XML, stricter placeholder shell‑outs.
- 🌐 **Mix Registry** – `mixdown add @acme/rails‑rules@^3`.

Track progress in [`docs/ROADMAP.md`](docs/ROADMAP.md).

## 10. Contributing

1. Fork → `npm i` → `pnpm dev`.
2. Add unit tests & fixture mixes.
3. Submit a PR with a Changeset.

See [`CONTRIBUTING.md`](docs/CONTRIBUTING.md).

## 11. License

MIT © Matt Galligan & contributors

## 12. TODOS

### 12.1 README Scope Checklist

**Keep in README:**

- Elevator‑pitch & why it matters
- Quick install / quick start
- Supported targets table
- Glossary of key concepts (concise)
- One or two minimal code examples

**Remove / move elsewhere:**

- Deep syntax reference (move to `docs/spec.md`)
- Full TODO / roadmap details (`docs/ROADMAP.md`)
- Security sandbox internals (`docs/security.md`)
- Provider manifest JSON schema (`docs/tool‑provider.md`)
- CI snapshot test docs (`docs/testing.md`)

### 12.2 Additional Documentation Needed

| Doc | Purpose |
|-----|---------|
| `docs/spec.md` | Exhaustive syntax reference with attribute tables & BNF. |
| `docs/provider-development.md` | How to build a new target plugin (interface, examples). |
| `docs/roadmap.md` | Living roadmap & prioritization, moved from README. |
| `docs/architecture/testing.md` | Snapshot tests, `mixdown test`, CI setup guide. |
| `docs/architecture/security.md` | XML sanitization, placeholder sandbox, threat model. |
| `docs/contributing/CHANGESETS.md` | Contributor guide to Changesets workflow. |
| `examples/` | Real‑world mixes with rendered artifacts side‑by‑side. |
