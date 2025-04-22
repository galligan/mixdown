# 2024-06-17 Project: Mixdown MVP

## Context

- **Project doc:** [project-mvp.md](../../projects/project-mvp.md)
- **Task plan:** [mixdown-mvp-tasks.md](../../.agent/plans/mixdown-mvp-tasks.md)

## Overview

- **Objective:** Deliver a Minimum Viable Product of Mixdown that can compile a single `.mixd` mix into tool‑specific artifacts, starting with Cursor (`.mdc`) and Claude Code (`CLAUDE.md`), via both CLI and HTTP API.
- **Scope:** Core compiler (`@mixdown/core`), two first‑party plugins (`@mixdown/plugin‑cursor`, `@mixdown/plugin‑claude-code`), CLI commands (`init`, `build`, `validate`), Express API endpoint (`POST /compile`), basic schema validation, and output writer to `.mixdown/output`.
- **Expected Outcome:** Users can scaffold a project with `mixdown init`, author a mix, run `mixdown build` to generate artifacts, and CI can call `/compile` to retrieve a ZIP artifact. ≥80 % unit‑test coverage on core, contract tests for plugins, and clear documentation.

## Status

- **Current Status:** Backlog
- **Last Updated:** 2024-06-17
- **Task Plan:** [.agent/tasks/mvp-tasks.md](../../.agent/tasks.md)

## Prerequisites

- Node.js ≥ 18 and pnpm installed locally
- Git repository initialized with conventional commits tooling
- Development dependencies: `fast-xml-parser`, `commander`, `ink`, `express`, `jest`, `ts-jest`, `typescript`
- ESLint & Prettier configuration shared across workspaces
- Access to GPT‑4 or equivalent model for prompt testing (optional but recommended)
- Team agreement on coding standards and branch strategy

## Background Research

Mixdown aims to solve instruction‑format fragmentation across multiple AI/agent tools by introducing a single source‑of‑truth "mix" file that can be compiled into per‑tool artifacts. The README and PRD outline a plugin architecture, CLI commands, and an HTTP API compliant with the Model Context Protocol (MCP).

### Key Findings

- **Single Source‑of‑Truth:** Teams struggle with duplicated prompt rules; Mixdown's mix file addresses this.
- **Plugin Architecture:** Extensibility is critical; first‑party plugins will set the pattern for community contributions.
- **Speed & DX:** MVP must compile a 500‑line mix in <250 ms to feel instant for users.

### Alternatives Considered

| Option | Pros | Cons | Decision |
|--------|------|------|----------|
| Monolithic binary (no providers) | Simpler build, fewer moving parts | Harder to extend, larger binary | Rejected |
| Core + Plugin Provider system (chosen) | Extensible, encourages ecosystem | Slightly higher complexity | Selected |
| Pure YAML syntax instead of XML | Familiar to some devs | Loses section‑tag clarity, harder for placeholders | Rejected |

## Implementation Plan

### Dependencies and Sequence

A simplified sequence diagram:

1. Core compiler parses mix and delegates rendering to plugins.
2. Writer persists rendered files to output directory.
3. CLI & API both call compiler.

### Phase 1: Repository & Tooling

1. Scaffold pnpm workspace with `core`, `cli`, `plugin-cursor`, `plugin-claude-code`, `api` packages.
   - **Complexity:** Medium
   - **Dependencies:** None
2. Configure TypeScript, ESLint, Prettier across repo.
   - **Complexity:** Low

### Phase 2: Core Compiler MVP

1. Implement XML parser (handling YAML front‑matter within `<meta>`) → AST.
   - **Complexity:** High
   - **Dependencies:** Phase 1 tooling
   - Potential challenges: XML entity security, placeholder/include regex edge cases
2. Implement segment handler, placeholder resolver, include resolver.
   - **Complexity:** Medium
3. Implement Writer that creates artifact files in `prompts/artifacts/builds/<id>` and `prompts/artifacts/latest` symlink.
   - **Complexity:** Medium

### Phase 3: Plugin Development

1. Cursor plugin renders AST to `.mdc` markdown.
   - **Complexity:** Medium
   - Potential challenges: heading level adjustments, metadata mapping
2. Claude Code plugin renders AST to `CLAUDE.md`.
   - **Complexity:** Medium

### Phase 4: CLI Interface

1. Implement `mixdown init` (scaffold dirs & sample mix).
   - **Complexity:** Low
2. Implement `mixdown build` (compile mixes → output).
   - **Complexity:** Medium
3. Implement `mixdown validate` (schema lint only).
   - **Complexity:** Low

### Phase 5: HTTP API (MCP compliant)

1. Express server with `/compile` that accepts mix content or path.
   - **Complexity:** Medium
2. Return ZIP of generated files, include checksum.
   - **Complexity:** Medium

### Phase 6: Verification and Testing

1. Unit tests for core compiler (≥80 % coverage).
   - **Success criteria:** Jest coverage report passes threshold.
2. Contract tests: sample mix compiled through each plugin matches snapshot.
   - **Success criteria:** `jest -u` snapshots clean.
3. E2E test: Supertest hits `/compile` and verifies ZIP contents.
   - **Success criteria:** Test passes.

## Technical Considerations

### Security Considerations

- Disable XML entity expansion (`ignoreEntities: true`).
- Sanitize any file writes to prevent path traversal.
- Validate user‑supplied mix size & reject >10 k lines to avoid DoS.

### Testing Considerations

- Snapshot plugin outputs to detect regressions.
- Use mock filesystem for writer tests to avoid disk I/O.

### Performance Considerations

- Stream parser where possible.
- Cache plugin resolution to avoid dynamic `import()` overhead.

### Deployment Considerations

- Publish packages to npm under `@mixdown/*` scope.
- Provide Docker image for API server.

## Verification Process

1. Run `pnpm -r test` – all tests must pass.
2. Compile sample mix; artifacts must match committed snapshots.
3. `mixdown build` on example repo completes in <250 ms (measured via CI).

## Proposed Tasks

1. Core Repo & Tooling
   - **Description:** Scaffold pnpm workspace, shared TS config, linting.
   - **Complexity:** Medium
   - **Dependencies:** None
   - **Potential challenges:** Setting up Jest across workspaces
   - **Subtasks:**
     - [ ] Initialize repo with `pnpm init` and workspaces
     - [ ] Configure TypeScript base config
     - [ ] Add ESLint & Prettier configs
2. Core Compiler Implementation
   - **Description:** Implement `.mixd` parser (handling `<meta>` YAML), AST, include/placeholder resolution, artifact writer.
   - **Complexity:** High
   - **Dependencies:** Task 1
   - **Potential challenges:** XML parsing security, placeholder/include engine edge cases, segment handling logic.
   - **Subtasks:**
     - [ ] XML parser (handling `<meta>` tag YAML) to AST
     - [ ] Placeholder & Include resolver (`[...]`, `$[include:...]`)
     - [ ] Segment handler (`<segment>`)
     - [ ] Writer to `prompts/artifacts/builds/<id>` with `latest` symlink setup
3. Plugin Provider Development
   - **Description:** Build `@mixdown/plugin-cursor` & `@mixdown/plugin-claude-code` providers.
   - **Complexity:** Medium
   - **Dependencies:** Task 2
   - **Potential challenges:** Heading level adjustments for exported segments, metadata mapping.
   - **Subtasks:**
     - [ ] Cursor provider render function
     - [ ] Claude provider render function
4. CLI Commands
   - **Description:** Implement `init`, `build`, `validate` using Ink + commander fallback.
   - **Complexity:** Medium
   - **Dependencies:** Task 2
   - **Potential challenges:** Interactive vs non‑interactive output
5. API Endpoint
   - **Description:** Express server with `/compile` returning ZIP archive of artifacts.
   - **Complexity:** Medium
   - **Dependencies:** Task 2
6. Testing & CI Setup
   - **Description:** Unit, contract (provider snapshot), E2E tests; GitHub Actions matrix.
   - **Complexity:** Medium
   - **Dependencies:** Tasks 2‑5
7. Documentation
   - **Description:** Update README, CLI docs, API Swagger, Glossary, PRD.
   - **Complexity:** Low
   - **Dependencies:** Feature completion

## References

- README.md (project overview)
- docs/cli.md (CLI command spec)
- docs/prd.md (product requirements draft)

## Appendix

- Initial architecture diagram located in `docs/prd.md#6 System Architecture`
