# 💽 Mixdown: A CommonMark-Compliant Prompt Compiler

Mixdown is a **CommonMark-compliant prompt compiler** that lets you author a single *mix* file in plain Markdown and compile it into tool-specific instruction artifacts (Cursor `.mdc`, Claude Code `CLAUDE.md`, Roo Code `.md`, and more). Think of it as **Terraform for AI prompts**—declare once, target many, keep every teammate (human *and* bot) on the same authoritative rules.

## What is Mixdown?

If you're reading this, you're probably already familiar with at least one of the AI coding tools that Mixdown is [designed to work with](#supported-target-tools). Each tool has its own unique way of being provided context, guidance, and operational instructions for your projects e.g. Cursor's rules (`.cursor/rules`), OpenAI Codex instructions (`codex.md`), Claude Code's instructions (`CLAUDE.md`), etc.

The problem is, they all have different formats, behavior, and capabilities, which can become a huge pain to manage. This can be frustrating, and might even lead you to just sticking to one tool. But that's no fun, and you'll be missing out on all the awesome capabilities and differences each tool has to offer! That's where Mixdown comes in…

**Terminology note**: Mixdown uses the term **artifact** to mean the concrete file(s) it emits for each target tool (Cursor rules, Claude commands, etc.). You'll find them in `prompts/artifacts/builds/` with the latest always symlinked at `prompts/artifacts/latest/`.

## What Mixdown Does

Mixdown is "Terraform for AI prompts": declare your ideal prompt rules once, target dozens of coding agents, and guarantee every teammate (human or bot) runs with the same authoritative instructions—no copy‑paste, no drift, just high‑quality, version‑controlled context.

With Mixdown, you can apply the "Don't Repeat Yourself" principle to your agentic coding tools. Instead of writing slightly different versions of the same instructions for each tool, you create a single "mix" file (`.md`). This mix is the "gold master" for your instructions, from which individual target-specific files are created in their respective format and sent to the right places.

The app consists of:

1. A Node.js app with an API, CLI, and Model Context Protocol implementation for managing prompts and instructions
2. A CommonMark-compliant markup specification for creating effective and reusable prompts

Result: *author once, distribute everywhere, zero drift.*

## What's with the name?

We borrowed "Mixdown" from the music product world because it nails the vibe so well. Think of a mixdown as the moment a song stops being a pile of takes and starts being the version everyone hears. That's what this toolbox does for prompt engineering: it fuses disparate rules into one golden master, then automatically generates the perfect format for Cursor, Windsurf, Claude Code, and beyond.

## Core Concepts

**Mix**
: Source Markdown file that is compiled into artifacts.

**Artifact**
: Target-specific output file (e.g., `.cursor/rules/foo.mdc`).

**Section**
: Delimited block `{{# section}}...{{/section}}` with optional attributes.

**Embed**
: Re-usable include mechanism (`{{> my-partial}}`) that can incorporate content from another mix/section/template.

**Insertion**
: Dynamic value replaced at build time (`{{ $alias }}`, `{{ $.data.key }}`, `[ fill this in ]`).

**Target**
: A supported tool (Cursor, Roo Code, etc.) identified by a `kebab-case` ID, e.g. `cursor`, `roo-code`.

**Target Group**
: Named set of targets (`@cursor`, `@ide`, `@cli`) for attribute filtering.

## Supported Target Tools

| ID | Tool | Type | Status |
|----|------|------|--------|
| `cursor` | [Cursor](https://www.cursor.com/) | IDE | ✅ Supported |
| `claude-code` | [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) | CLI | 🟡 In Progress |
| `roo-code` | [Roo Code](https://roocode.dev/) | VS Code Ext | 🟡 In Progress |
| `cline` | [Cline](https://cline.dev/) | VS Code Ext | 🟡 In Progress |
| `aider` | [Aider](https://aider.chat/) | CLI | 🔵 Planned |
| `openai-codex` | [OpenAI Codex](https://github.com/openai/codex) | CLI | 🔵 Planned |
| `windsurf` | [Windsurf](https://windsurf.dev/) | IDE | 🔵 Planned |

*Want a new target? Implement `toolProvider` and publish `@mixdown/plugin-<your-tool>`. See `docs/developer/plugin-development.md`.*

## Key Features

### Authoring Features

- **100% CommonMark** – Renders cleanly in GitHub & VS Code; passes markdown-lint.
- **Granular Sections** – Export, filter, or replace section headings per-target.
- **Powerful Insertions** – Aliases, YAML data injections, runtime values with sandboxed resolvers.

### Compiler & Integration

- **Plugin Architecture** – Add new targets via `MixdownPluginProvider` without touching core.
- **CLI & API** – `mixdown build`, `mixdown validate`, and `POST /compile` endpoint return ZIP artifacts.
- **Snapshot Testing** – Contract tests ensure mix edits don't silently change generated artifacts.

## Installation

```bash
npm install -g mixdown        # global CLI
# or project-local
npm install --save-dev mixdown
```

## Quick Start

```bash
mixdown init          # scaffolds prompts/ & .mixdown/
cd prompts/instructions
echo "---\nname: hello\n---\n{{# system}}Hi!{{/system}}" > hello.md
cd ../..

mixdown build         # writes artifacts under prompts/artifacts/
```

The latest build is always symlinked at `prompts/artifacts/latest/`.

## Syntax Cheatsheet

| Token / Feature | Example | Notes |
|-----------------|---------|-------|
| **Section** | `{{# instructions name="Rules" export="+cli"}}...{{/instructions}}` | Attributes control name & export. |
| **Front-matter** | `---\nname: foo\n---` | YAML at file top. |
| **Embed** | `{{> legal !heading}}` | Embed another partial. |
| **Section Embed** | `{{#> legal}}` | Embed as a section. |
| **Internal Link** | `[Read more](rules.md)` | Standard Markdown links. |
| **Absolute Link** | `[Example](//src/example.ts)` | Links to project files. |
| **Alias Insertion** | `{{ $project }}` | Resolved via alias chain. |
| **Data Insertion** | `{{ $.user.email }}` | Injects YAML data. |
| **Static Fill-In** | `[ fill this in ]` | Marker for LLM to complete. |

Full spec lives in `docs/spec/mixdown-syntax.md`.

## Versioning and Changelog

This project uses [Changesets](https://github.com/changesets/changesets) for versioning and changelog management.

### Adding a Changeset

When making changes that should be reflected in the version number and changelog, create a changeset:

```bash
pnpm changeset add
```

Follow the prompts to:

1. Select the appropriate version bump (patch, minor, major)
2. Write a description of the change for the changelog

### For Contributors

For more detailed information on using Changesets in this project, see [docs/contributing/CHANGESETS.md](/docs/contributing/CHANGESETS.md).

## Contributing & Community

1. **Fork → `pnpm i` → `pnpm dev`**.
2. Follow conventional commits; run `pnpm changeset add` for version bumps.
3. Add unit & contract tests for new features.
4. Submit PR—CI must pass snapshot tests.

See [`docs/contributing/DEVELOPMENT.md`](docs/contributing/DEVELOPMENT.md) for full guidelines.

## References

- `docs/spec/mixdown-syntax.md` – Full syntax specification.
- `docs/developer/plugin-development.md` – Build a new plugin provider.
- `docs/architecture/design-decisions.md` – Design rationale & deep-dive.