# Mixdown MVP Task Plan

## Context

- **Goal**: Deliver a Minimum Viable Product of Mixdown that can compile a single `.mxml` mix into tool‑specific instruction files, starting with Cursor (`.mdc`) and Claude Code (`CLAUDE.md`), via both CLI and HTTP API.
- **Definition of Done**: Users can scaffold a project with `mixdown init`, author a mix, run `mixdown build` to generate rules, and CI can call `/compile` to retrieve a ZIP artifact. ≥80% unit-test coverage on core, contract tests for plugins, and clear documentation.
- **Project doc**: [project-mvp.md](../projects/project-mvp.md)
- **Supporting docs**: None

## Task Plan

### In Progress

- [ ] Add task plan to `./.agent/tasks.md` under appropriate section

### Next Tasks

- [ ] Core Repo & Tooling
  - [ ] Initialize repo with `pnpm init` and workspaces
  - [ ] Configure TypeScript base config
  - [ ] Add ESLint & Prettier configs
- [ ] Core Compiler Implementation
  - [ ] XML + YAML parser to AST
  - [ ] Placeholder resolver
  - [ ] Writer with run ID & symlink setup
- [ ] Plugin Development
  - [ ] Cursor plugin render function
  - [ ] Claude plugin render function
- [ ] CLI Commands
  - [ ] Implement `mixdown init` (scaffold dirs & sample mix)
  - [ ] Implement `mixdown build` (compile mixes → output)
  - [ ] Implement `mixdown validate` (schema lint only)
- [ ] API Endpoint
  - [ ] Express server `/compile` endpoint returning a ZIP artifact
- [ ] Testing & CI Setup
  - [ ] Unit tests for core compiler (≥80% coverage)
  - [ ] Contract tests: snapshot plugin outputs
  - [ ] E2E test: Supertest `/compile` ZIP contents
- [ ] Documentation
  - [ ] Update README.md
  - [ ] Update CLI docs (`docs/cli.md`)
  - [ ] Update API Swagger

### Completed Tasks

...

### Cleanup?

- [ ] Docs written
- [ ] Tests written
- [ ] Tests passed
- [ ] Changes checked in to `release/v0.1.0-mvp`

## Follow-up Notes

### Decisions Made

...

### Findings

...

### Proposed Next Steps

... 