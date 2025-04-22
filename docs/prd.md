# 📄 Mixdown Product Requirements & Technical Specification (v0.1)

## 1.0 Purpose & Vision

### 1.1 Problem

- **Instruction‑format fragmentation** across Cursor, Windsurf, Claude Code, etc.—leads to duplication and drift
- Rising number of IDE/agent tools makes maintaining prompt rules exponentially harder for teams
- Lack of a common, machine‑readable spec hinders automation, versioning, and testing

### 1.2 Solution (Mixdown)

- **Single "mix" source‑of‑truth** (`.mixd` file) → compiles into per‑tool artifacts
- **Plugin architecture** so new tool providers can be added without touching core
- **CLI + HTTP (MCP‑compliant) API** for both local and remote consumption
- **Mixdown markup** (XML structure with Markdown content, YAML frontmatter) with placeholders/section tags → reliable prompt structure

### 1.3 Goals (MVP)

1. Compile a `.mixd` file into Cursor `.mdc` & Claude `CLAUDE.md` artifacts
2. Provide an Ink‑based CLI (`mixdown build`, `mixdown init`, `mixdown validate`)
3. Expose `/compile` HTTP endpoint that returns a ZIP of generated artifacts
4. Deliver schema validation & helpful error messages
5. Ship as pnpm workspace with plugin packages

### 1.4 Non‑Goals

- Web UI editor (out of scope for v0.1)
- Cloud sync / account management

## 2.0 Stakeholders & Users

- **Prompt Engineers / Dev‑Rel**: maintain canonical rules, distribute to teams
- **Backend Devs**: call Mixdown API to fetch fresh rules before spawning agents
- **Individual Developers**: run CLI locally for their IDEs
- **Plugin Authors**: extend ecosystem with third‑party tool support

## 3.0 Personas & User Stories

| Persona | Story | Acceptance Criteria |
|---------|-------|---------------------|
| *Prompt Engineer Jane* | “As a PE, I want to update a single mix file and regenerate all IDE rules ¬so there is no drift.” | • `mixdown build` rewrites `.cursor/rules/*.mdc` & `CLAUDE.md` • Exit code 0 if successful |
| *DevOps Amir* | “As DevOps, I want an API endpoint to fetch compiled artifacts in CI.” | • `POST /compile` returns ZIP • Response contains checksum |
| *Plugin Author Lee* | “As a plugin author, I want to publish `@mixdown/plugin‑zed`.” | • Implements typed interface • Registrable via manifest |

## 4.0 Functional Requirements

### FR‑1 Mix Parsing & Validation

- MUST parse `.mixd` (XML structure with YAML front‑matter in `<meta>`) into AST
- MUST detect unknown tags/attributes and produce helpful diagnostics

### FR‑2 Plugin Execution

- Core MUST load plugins dynamically via name or JS object
- MUST support emitting multiple artifact files per mix (via segments using `export` or `only`)

### FR‑3 CLI

- Commands: `init`, `build`, `validate`, `preview`
- Interactive (Ink) & non‑interactive (`--json` output) modes

### FR‑4 HTTP API

- RESTful Express server
- Routes: `POST /compile`, `GET /healthz`, `GET /plugins`
- Swagger/OpenAPI spec auto‑validated via `express‑openapi‑validator`

### FR‑5 Configuration

- Global config file at `~/.config/mixdown/config.yaml` (or OS equivalent)
- Project configuration in `.mixdown/config.yaml`

### FR‑6 Starter Templates & Mixes

- Provide starter **mixes** (e.g., `sample-core-coding-guidelines.mixd`)
- Provide starter **templates** (e.g., `code-review.template.mixd`, `plan.template.mixd`)

## 5.0 Non‑Functional Requirements

- **Performance**: compile < 250 ms for a 500‑line mix on M1 CPU
- **Extensibility**: adding plugin requires no core package change
- **DX**: clear CLI errors; TypeScript typings for public API
- **Security**: sandbox XML parser (no entity expansion), CORS restricted
- **Testing**: ≥ 90 % line coverage in core compiler; contract tests for each plugin

## 6.0 System Architecture

```mermaid
flowchart LR
    A[User / CI] -->|CLI: mixdown build| B(Core Compiler)
    C(API Server) -->|POST /compile| B
    B -->|uses| D[Plugin Provider Registry]
    D --> P1[@mixdown/plugin‑cursor]
    D --> P2[@mixdown/plugin‑claude‑code]
    B --> F[Artifact Writer]
    F --> O[prompts/artifacts/builds/{id}]
```

### 6.1 Component Breakdown

1. **Core Compiler (`@mixdown/core`)**
   - XML+YAML → AST (`fast‑xml‑parser`)
   - Segment handler, placeholder resolver, include resolver
   - Emits `RenderedArtifact[]`
2. **Plugin Provider Registry**
   - Registers `MixdownPluginProvider` objects
   - Loads packages specified in `.mixdown/config.yaml` or discovered
3. **Plugin Providers** (`@mixdown/plugin-*`)
   - Map AST → tool‑specific artifact content (e.g., Markdown)
   - Define target directory, file extensions, naming conventions
4. **CLI (`@mixdown/cli`)**
   - Ink UI + commander fallback
   - Shared yargs‐style parser for flags
5. **API (`@mixdown/api`)**
   - Express + OpenAPI validator
   - Multer for file uploads (future)
6. **MCP Adapter**
   - Conforms responses to Model Context Protocol v1

### 6.2 Data Flow (CLI)

```sequence
User->>CLI: mixdown build
CLI->>Core: compileMix( mixPath, opts )
Core->>Registry: get("cursor")
Registry->>Plugin: render(ast)
Plugin->>Core: RenderedFile[]
Core->>Writer: write(files)
Writer->>FS: mkdir/.writeFile
CLI-->>User: Success + summary table
```

### 6.3 Directory Structure (Monorepo)

```text
mixdown-monorepo/
├── .agent/                    # agentic development files
├── .changeset/                # Changesets version files
├── .cursor/                   # Cursor-specific files
├── .github/                   # GitHub-specific files
├── .roo/                      # Roo-code files
├── .eslintrc.cjs
├── .gitignore
├── .prettierrc
├── jest.config.ts
├── package.json               # root meta (workspaces, scripts, engines…)
├── pnpm-workspace.yaml        # lists all workspaces
├── README.md
├── scripts/                   # release, lint‑staged, misc automation
├── tsconfig.base.json         # root TS compiler options
│
├── .mixdown/
│   ├── scripts/               # 🛠️ Mixdown scripts
│   ├── studio/                # 💾 author‑edited material
│   │   ├── mixes/
│   │   ├── profiles/
│   │   ├── stems/
│   │   ├── splices/
│   │   ├── templates/
│   │   └── config.yaml
│   └── output/                # ⚙️ generated artifacts (git‑ignored)
│       ├── runs/
│       └── latest -> runs/<id>   # symlink
│
├── docs/                      # architecture diagrams, ADRs, OpenAPI html
│
└── packages/                  # pnpm workspaces
    ├── core/                  # core compiler & plugin API
    │   ├── src/
    │   └── tests/
    ├── cli/                   # Ink‑based command‑line app
    │   ├── src/
    │   └── tests/
    ├── api/                   # Express / MCP service
    │   ├── src/
    │   └── tests/
    ├── plugin-cursor/         # first‑party plugin: Cursor IDE
    │   ├── src/
    │   └── tests/
    └── plugin-claude-code/    # first‑party plugin: Claude Code
        ├── src/
        └── tests/
```

## 7.0 Detailed Technical Specification

### 7.1 Key TypeScript Interfaces

```ts
// packages/core/src/plugin.ts
export interface MixAST {
  meta: Meta;
  tracks: Track[];
  nodes: Node[]; // raw xml nodes
}

export interface MixdownPlugin {
  name: string;
  defaultExt: string;
  render(ast: MixAST, opts?: PluginOpts): Promise<RenderedFile[]>;
  validate?(ast: MixAST): ValidationError[];
}
```

### 7.2 Placeholder Engine

- Uses regex `/\[(?<key>[\w-]+)(?:\s+format="(?<fmt>[^"]+)")?\]/g`
- Built‑in handlers: `date`, `time`, `title`, `git_branch`, `package_version`
- Plugins may register custom placeholder resolvers

### 7.3 Error Handling

| Code | Condition | Example Message |
|------|-----------|-----------------|
| `MX001` | Unknown tag | "Tag `<foo>` is not supported (line 12)" |
| `MX010` | Plugin render fail | "cursor: Cannot write file; path undefined" |

### 7.4 Config Resolution

1. CLI flags
2. Project `.mixdown/config.yaml`
3. User `~/.config/mixdown.yaml`
4. Hard‑coded defaults

### 7.5 Testing Strategy

- **Unit**: core compiler functions (parsing, resolving includes/placeholders, segment handling).
- **Contract**: each plugin provider loaded with sample mixes → snapshot generated artifacts.
- **E2E**: Supertest hits API `/compile`, verifies ZIP artifact contents.

### 7.6 CI/CD

- GitHub Actions matrix: Node 18 | 20; macOS + ubuntu
- `pnpm -r test && pnpm -r build`
- Changesets for independent package version bumps

## 8.0 Milestones & Timeline

| Phase | Dates | Deliverables |
|-------|-------|--------------|
| *MVP α* | Apr 28 – May 15 | Core compiler, Cursor & Claude plugin providers, build/validate CLI |
| *API β* | May 16 – May 31 | Express API, Dockerfile, OpenAPI docs |
| *Plugin Ecosystem* | June | Windsurf, Roo, Cline providers; provider author guide |
| *v1 GA* | July | Perf hardening, security audit, >90 % coverage, website docs |

## 9.0 Open Questions / Risks

- How to version mix files when plugins introduce breaking template syntax?
- Need sandbox for resolving placeholders that execute shell commands (security)
- Large mix files (10 k+ lines) performance—may need streaming compiler

## 10.0 Appendix

- **Glossary**: mix, track, bounce, patch, plugin, MCP
- **References**: GPT‑4.1 prompting guide, Cursor Rules docs, Claude Code docs
