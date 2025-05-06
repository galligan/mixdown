# 📄 Mixdown Product Requirements & Technical Specification (v0.1)

## 1.0 Purpose & Vision

### 1.1 Problem

- **Instruction‑format fragmentation** across Cursor, Windsurf, Claude Code, etc.—leads to duplication and drift
- Rising number of IDE/agent tools makes maintaining prompt rules exponentially harder for teams
- Lack of a common, machine‑readable spec hinders automation, versioning, and testing

### 1.2 Solution (Mixdown)

- **Single "mix" source‑of‑truth files** (`.md`) → compiles into per‑target artifacts
- **Plugin architecture** so new target providers (Cursor, Claude Code, etc.) can be added without touching core
- **Robust API & CLI tools**
- **MCP Server for writing Mixdown files, and performing Mixdown operations**
- **Mixdown markup** (CommonMark-compliant Markdown with brace-based sections, YAML frontmatter) with placeholders/section tags → reliable prompt structure

### 1.3 Goals (MVP)

1. Compile a `.md` file into Cursor `.mdc` & Claude Code `CLAUDE.md` artifacts
2. Provide an Ink‑based CLI (`mixdown build`, `mixdown init`, `mixdown validate`, `mixdown preview`)
3. Expose `/compile` API endpoint that returns a ZIP of generated artifacts
4. Deliver syntax validation & helpful error messages with detailed diagnostics
5. Ship as pnpm workspace with plugin packages and optional caching for performance

### 1.4 Non‑Goals

- Web UI editor (out of scope for v0.1)
- Cloud sync / account management (not ever needed)

## 2.0 Stakeholders & Users

- **Prompt Engineers / Dev‑Rel**: maintain canonical rules, distribute to teams
- **Backend Devs**: call Mixdown API to fetch fresh rules before spawning agents
- **Individual Developers**: run CLI locally for their IDEs
- **Plugin Authors**: extend ecosystem with third‑party tool support

## 3.0 Personas & User Stories

| Persona | Story | Acceptance Criteria |
|---------|-------|---------------------|
| *Prompt Engineer Jane* | "As a PE, I want to update a single mix file and regenerate all IDE rules ¬so there is no drift." | • `mixdown build` rewrites `prompts/artifacts/builds/{id}/` • Exit code 0 if successful • Latest build symlinked at `prompts/artifacts/latest/` |
| *DevOps Amir* | "As DevOps, I want an API endpoint to fetch compiled artifacts in CI." | • `POST /compile` returns ZIP • Response contains checksum • Changelog header in artifacts |
| *Plugin Author Lee* | "As a plugin author, I want to publish `@mixdown/plugin‑zed`." | • Implements typed interface • Registrable via manifest • Supports target groups |

## 4.0 Functional Requirements

### FR‑1 Mix Parsing & Validation

- MUST parse `.md` files (CommonMark with brace sections and YAML front‑matter) into AST
- MUST detect malformed tags, unknown attributes, and produce helpful error codes (e.g., E1001)
- MUST validate section nesting and handle auto-closing behavior with configurable strictness
- MUST validate internal links and section references across mixes
- MUST support whitespace validation according to specification

### FR‑2 Plugin Execution

- Core MUST load plugins dynamically via name or JS object
- MUST support target groups for filtering and addressing multiple targets at once
- MUST support emitting multiple artifact files per mix (via sections using `export` attribute)
- MUST support target-specific overrides for section attributes and front-matter

### FR‑3 CLI

- Commands: `init`, `build`, `validate`, `preview`, `lint`
- Interactive (Ink) & non‑interactive (`--json` output) modes
- Debug mode with structured JSON logs for insertions and link resolution
- Support for strict mode to enforce explicit section closing and other best practices

### FR‑4 HTTP API

- RESTful Express server
- Routes: `POST /compile`, `GET /healthz`, `GET /plugins`, `GET /mixes/:target`
- Swagger/OpenAPI spec auto‑validated via `express‑openapi‑validator`
- MCP-compliant endpoints for agent integration

### FR‑5 Configuration

- Global config file at `~/.config/mixdown/config.yaml` (or OS equivalent)
- Project configuration in `.mixdown/config.yaml`
- Support for target groups configuration in project config
- Support for configurable auto-close behavior via CLI flags, config, or front-matter
- Front-matter support for target-specific settings via include/exclude lists

### FR‑6 Starter Templates & Mixes

- Provide starter **mixes** (e.g., `sample-core-coding-guidelines.md`)
- Provide starter **templates** (e.g., `code-review.template.mixd`, `plan.template.mixd`)
- Provide error message reference documentation
- Deliver whitespace validation and auto-fixing capability

## 5.0 Non‑Functional Requirements

- **Performance**: compile < 250 ms for a 500‑line mix on M1 CPU
- **Caching**: memoize YAML/JSON pointer lookups and file reads for optimal performance
- **Extensibility**: adding plugin requires no core package change
- **DX**: clear CLI errors with error codes; TypeScript typings for public API
- **Security**: sanitized content parsing, CORS restricted
- **CommonMark Compliance**: all files render cleanly in GitHub & VS Code; pass markdown-lint
- **Testing**: ≥ 90 % line coverage in core compiler; contract tests for each plugin

## 6.0 System Architecture

```mermaid
flowchart LR
    A[User / CI] -->|CLI: mixdown build| B(Core Compiler)
    C(API Server) -->|POST /compile| B
    B -->|uses| D[Plugin Provider Registry]
    D --> P1[@mixdown/plugin‑cursor]
    D --> P2[@mixdown/plugin‑claude‑code]
    B --> E[AST & Caching Layer]
    B --> F[Artifact Writer]
    F --> O[prompts/artifacts/builds/{id}]
    F --> L[prompts/artifacts/latest]
```

### 6.1 Component Breakdown

1. **Core Compiler (`@mixdown/core`)**
   - Markdown+YAML → AST (custom parser)
   - Section handler, insertion resolver, embed resolver, link validator
   - Caching layer for data lookups and file reads
   - Whitespace validation and diagnostics
   - Emits `RenderedArtifact[]`
2. **Plugin Provider Registry**
   - Registers `MixdownPluginProvider` objects
   - Loads packages specified in `.mixdown/config.yaml` or discovered
   - Supports target groups for addressing multiple providers at once
3. **Plugin Providers** (`@mixdown/plugin-*`)
   - Map AST → target‑specific artifact content (e.g., Markdown)
   - Define target directory, file extensions, naming conventions
   - Transform links based on export mapping and target-specific formats
4. **CLI (`@mixdown/cli`)**
   - Ink UI + commander fallback
   - Shared yargs‑style parser for flags
   - Debug mode with structured JSON logs
   - Lint command with auto-fix capability
5. **API (`@mixdown/api`)**
   - Express + OpenAPI validator
   - Multer for file uploads (future)
   - Endpoints for artifact access by target
6. **MCP Adapter**
   - Conforms responses to Model Context Protocol v1
   - Exposes agent-accessible fetch endpoints for artifacts

### 6.2 Data Flow (CLI)

```sequence
User->>CLI: mixdown build
CLI->>Core: compileMix( mixPath, opts )
Core->>Core: parseMix(mixPath)
Core->>Core: validateLinks()
Core->>Registry: get("cursor")
Registry->>Plugin: render(ast)
Plugin->>Core: RenderedFile[]
Core->>Writer: write(files)
Writer->>FS: mkdir/.writeFile/symlink
CLI-->>User: Success + summary table
```

### 6.3 Directory Structure (Monorepo)

```text
mixdown-monorepo/
├── README.md
│
├── .mixdown/                  # mixdown configuration
│   ├── cache/                 # cache directory 
│   ├── reports/               # build reports
│   ├── scripts/               # scripts directory
│   └── config.yaml            # project configuration
│
├── prompts/                   # source directory for mixes
│   ├── artifacts/             # generated artifacts
│   │   ├── builds/            # build-specific artifacts
│   │   └── latest/            # symlink to latest artifact set
│   ├── instructions/          # mix files (.md)
│   ├── data/                  # YAML data files for insertions
│   ├── partials/              # reusable content blocks
│   └── templates/             # template files
│
├── packages/                  # pnpm workspaces
│   ├── core/                  # core compiler & plugin API
│   │   ├── src/
│   │   └── tests/
│   ├── cli/                   # Ink‑based command‑line app
│   │   ├── src/
│   │   └── tests/
│   ├── api/                   # Express / MCP service
│   │   ├── src/
│   │   └── tests/
│   ├── plugin-cursor/         # first‑party plugin: Cursor IDE
│   │   ├── src/
│   │   └── tests/
│   └── plugin-claude-code/    # first‑party plugin: Claude Code
│       ├── src/
│       └── tests/
│
├── docs/                      # documentation root
│   ├── archive/               # deprecated/legacy docs
│   ├── architecture/          # architecture diagrams, ADRs, OpenAPI html
│   ├── changelog/             # project changelogs
│   ├── developer/             # plugin development guides
│   ├── project/               # PRD, roadmap, planning docs
│   └── spec/                  # syntax and feature specifications
│
├── .agent/                    # agentic development files
├── .changeset/                # Changesets version files
├── .cursor/                   # Cursor-specific files
├── .github/                   # GitHub-specific files
├── .roo/                      # Roo-code files
├── scripts/                   # release, lint‑staged, misc automation
├── .eslintrc.cjs
├── .gitignore
├── .prettierrc
├── jest.config.ts
├── package.json               # root meta (workspaces, scripts, engines…)
├── pnpm-workspace.yaml        # lists all workspaces
└── tsconfig.base.json         # root TS compiler options
```

## 7.0 Detailed Technical Specification

### 7.1 Key TypeScript Interfaces

```ts
// packages/core/src/plugin.ts
export interface MixAST {
  meta: Meta;
  sections: Section[];
  links: Link[];
  embeds: Embed[];
  insertions: Insertion[];
}

export interface Section {
  id: string;
  name?: string;
  attributes: Record<string, any>;
  content: string;
  children?: Section[];
}

export interface MixdownPlugin {
  name: string;
  defaultExt: string;
  targetGroups: string[];
  render(ast: MixAST, opts?: PluginOpts): Promise<RenderedFile[]>;
  validate?(ast: MixAST): ValidationError[];
  transformLink?(href: string, context: LinkContext): string;
}
```

### 7.2 Insertion System

- Supports multiple insertion types:
    - Aliases: `{{ $name }}` - looks up in alias chain
    - Data: `{{ $.user.name }}` - injects YAML data
    - File Data: `{{ $.file.key }}` - access current file's front-matter
    - Static Placeholders: `[ fill this in ]` - not replaced by Mixdown, for human/AI fill-in
- Uses memoization and caching for optimal performance
- Provides debug tracing of resolution path with `--debug` flag
- Undefined references emit warnings and render as `{{⚠ unresolved:path}}` (or fail in strict mode)

### 7.3 Error Handling

| Code | Condition | Example Message |
|------|-----------|-----------------|
| `E1001` | Malformed tag | "Malformed section tag: missing space after `#` (line 12)" |
| `E1002` | Invalid attribute | "Invalid attribute syntax: space around = sign (line 15)" |
| `E1010` | Missing required attribute | "Section requires 'name' attribute (line 20)" |
| `E1020` | Unresolved reference | "Unresolved data reference: $.unknown.key (line 30)" |
| `E1030` | Link validation | "Cannot resolve internal link: my-file.md#unknown-section (line 42)" |
| `E1040` | Plugin render fail | "cursor: Cannot write file; path undefined" |
| `E1050` | Conflicting filters | "Conflicting target filters: +cursor -cursor (line 55)" |

### 7.4 Config Resolution

1. CLI flags
2. Project `.mixdown/config.yaml`
3. User `~/.mixdown/config.yaml`
4. Hard‑coded defaults

### 7.5 Testing Strategy

- **Unit**: core compiler functions (parsing, resolving insertions/embeds, section handling, whitespace validation).
- **Contract**: each plugin provider loaded with sample mixes → snapshot generated artifacts.
- **E2E**: Supertest hits API `/compile`, verifies ZIP artifact contents.
- **Linting**: Auto-verification of whitespace rules and CommonMark compliance across all mix files.

### 7.6 CI/CD

- GitHub Actions matrix: Node 18 | 20; macOS + ubuntu
- `pnpm -r test && pnpm -r build`
- Changesets for independent package version bumps

## 8.0 Milestones & Timeline

| Phase | Deliverables |
|-------|--------------|
| *MVP* | Core compiler, Cursor & Claude plugin providers, build/validate CLI |
| *0.2* | Windsurf, Roo Code, Cline providers; provider author guide |
| *0.3* | Express API, Dockerfile, OpenAPI docs |
| *0.4* | Perf hardening, security audit, >90 % coverage, website docs |

## 9.0 Open Questions / Risks

- How to version mix files when plugins introduce breaking syntax changes?
- Large mix files (5k+ lines) performance considerations—may need AST caching
- Target-specific section and attribute overrides configuration can become complex
- Introduction of conditional logic could add complexity to the parser
- Balancing auto-closing sections with explicit nesting requirements

## 10.0 Appendix

- **Glossary**:
    - **Mix**: The template used to generate artifact files, with `.md` extension
    - **Section**: A braced block of content `{{# section}}...{{/section}}` that can be exported or filtered
    - **Artifact**: The file(s) created from a mix for a specific target (e.g., Cursor .mdc files)
    - **Embed**: Content injected into a mix from external files or sections using `{{> partial}}`
    - **Insertion**: Dynamic value replaced at build time (e.g., `{{ $alias }}`, `{{ $.data.key }}`)
    - **Target**: A supported tool (Cursor, Claude Code, etc.) identified by a kebab-case ID
    - **Target Group**: Named set of targets (`@ide`, `@cli`) for attribute filtering
    - **Plugin**: Extension that supports specific targets with rendering logic
    - **MCP**: Model Context Protocol standard for AI tooling
- **References**: GPT‑4.1 prompting guide, Cursor Rules docs, Claude Code docs, CommonMark spec
