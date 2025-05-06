# Mixdown Syntax Updates – Execution Notes

## Overview

- **Document purpose**: Provide implementation guidance for an AI agent (or engineering team) to execute the syntax-update follow-ups. Every task below includes: rationale, success criteria, suggested owner, and dependency notes.
- **Primary references**:
    - `notes/2025-05-01-mixdown-syntax-updates.md` – original spec updates
    - `notes/overview.md` – canonical overview now using new syntax
    - `notes/syntax-updates-claude.md` – post-implementation review & comments

---

## Abbreviations

- **CC** = Core Compiler (packages/core)
- **CLI** = Command-line interface (`packages/cli`)
- **LSP** = Language-server / editor tooling (future)

---

## Task Checklist (Detailed)

### Update Section Tag Syntax with `#` Prefix

- [x] Design and document comprehensive guidelines for the new section syntax.
- [ ] Update IDE plugins & syntax highlighting schemas to recognize `{{# section}}` prefix.
- [ ] Implement logging and error handling for malformed section tags (e.g., missing space after `#`).

### Update Inclusion/Exclusion Notation (`+target -target`)

- [x] Implement validation for conflicting patterns (e.g., `+cursor -cursor` → warning / strict-mode error).
- [x] Document precedence rules when a target exists in multiple groups with conflicting filters.
- [x] Confirm no escaping rules are required; clarify allowed character set for target IDs.

### Update Insertions System (`{{ $alias }}` / `{{ $.data.key }}`)

- [x] Evaluate and, if beneficial, design caching strategy for complex data lookups.
- [x] Define behavior for undefined references (warn vs error, strict mode behavior) and document.
- [x] Specify debugging workflow for tracing data reference resolution (e.g., CLI `--debug` flag).

### Update Internal Links

- [x] Implement compiler link validation; emit warnings or strict errors for unresolved links.
- [x] Ensure cross-mix link resolution logic is defined and documented.
- [x] Describe transformation rules for links targeting exported sections per target provider.

### Update Terminology Consistency

- [x] Audit docs for consistent use of "embed" (verb) vs "Embed" (noun) and fix discrepancies.
- [x] Clarify and document distinction between "name" (identifier) vs "heading" (rendered heading level).

### Update Self-Closing Tags

- [x] Explicitly document self-closing embed syntax (`{{> partial /}}`), include examples.
- [x] Confirm attribute handling parity between self-closing and paired tags; update spec.

### Update Whitespace Handling

- [x] Specify whitespace requirements between tag components and around attribute values.
- [x] Add linter rules or parser warnings for problematic whitespace cases.

### Update Target-Specific Front Matter

- [x] Define front-matter keys (`include`, `exclude`) for target scoping; add examples.
- [x] Clarify that `+/-` shorthand does not apply in front-matter; update docs accordingly.

### Update Additional Documentation

- [ ] Draft error-message reference section with common syntax issues and fixes.
- [ ] Outline tooling support plan (VS Code extension, linter rules, CLI validation).

### Update Roadmap / Feature Ideas

- [ ] Pragma directives: design and document per-file compiler options (`strict`, `version`).
- [ ] Conditional logic syntax (`{{% if target %}}`); evaluate feasibility and spec out.
- [ ] Variable filters (`| uppercase`, `| default`); design pipeline mechanism.
- [ ] Template inheritance model; add to long-term roadmap with high-level design notes.
- [ ] Debug mode (`mixdown build --debug`); specify output expectations.
- [ ] Interactive playground concept; capture requirements and success criteria.

## Task Matrix (Implementation Planning)

| # | Theme | Task (✅ = exit criteria) | Owner | Depends on |
|---|-------|---------------------------|--------|-------------|
| 1 | Section Tag `#` | 1.1 Documentation & guidelines<br>1.2 Editor syntax packages<br>1.3 Malformed-tag diagnostics | Core / Tooling | – |
| 2 | `+/-` Filters | 2.1 Conflict detection<br>2.2 Precedence docs | Core Compiler | – |
| 3 | Insertions | 3.1 Caching layer PoC<br>3.2 Undefined-ref policy<br>3.3 `--debug` trace output | Core | 2.1 (strict flag) |
| 4 | Links | 4.1 Link validator<br>4.2 Cross-mix resolver<br>4.3 Export-aware rewrites | Core | 1,2 |
| 5 | Terminology | 5.1 `embed` audit | Docs | – |
| 6 | Self-closing tags | 6.1 Embed `/` grammar & docs | Core + Docs | 1 |
| 7 | Whitespace | 7.1 Whitespace spec<br>7.2 Lint rules | Core + Lint | 1 |
| 8 | Target front-matter | 8.1 `include`/`exclude` keys<br>8.2 Docs update | Core + Docs | 2 |
| 9 | Error docs | 9.1 Error catalogue page | Docs | parallel |
| 10 | Tooling plan | 10.1 VS Code ext roadmap | Tooling | parallel |
| 11 | Pragmas | 11.1 Front-matter `mixdown` block handling | Core | 1 |
| 12 | Conditional | 12.1 AST changes<br>12.2 Renderer support | Core | 11 |
| 13 | Filters | 13.1 Pipeline design | Core | 3,12 |
| 14 | Templates | 14.1 Inheritance design doc | Core | – |
| 15 | Debug mode | 15.1 CLI `--debug` impl | CLI | 3 |
| 16 | Playground | 16.1 Requirements & tech-spike | Web Team | 3,12,13 |

---

## Detailed Execution Guidance

### 1. Section `#` Tag Tasks

#### 1.1 Documentation & Guidelines

- **Rationale**: Clear documentation and guidelines are needed for consistent use of the new section syntax.
- **Approach**:
  1. Create comprehensive documentation in `docs/spec/section-spec.md`.
  2. Include examples of common patterns and edge cases.
  3. Create quick reference guides with examples of all section options.
- **Exit criteria**: Documentation covers all syntax variations with clear examples.

#### 1.2 Editor Syntax Packages

- **Scope**: VS Code TextMate grammar & any LSP.
- **Checklist**:
    - Update grammar to match `\{\{[#>]?` tokens.
    - Add snippets for `{{# section}}…`.

#### 1.3 Malformed-Tag Diagnostics

- **Implementation**: Extend parser with token-lookahead verifying space after `#`; raise `E1001` error code (warning unless `--strict`).

### 2. Inclusion / Exclusion Notation

- **Conflict Detection**: In AST post-processing, collect filter flags, build set intersection; if both include & exclude for same target ⇒ `W2100` / `E2100` (strict).
- **Precedence Docs**: Add subsection to `docs/spec/attributes-spec.md` w/ examples.

### 3. Insertions System

- **Caching Layer**: Memoise YAML file reads & JSON-pointer lookups keyed by file path + pointer.
- **Undefined Refs Policy**: Default = warning + `{{⚠ unresolved:path}}` sentinel in output; strict = build fail.
- **Debug Trace**: When `--debug`, emit JSON lines `{type:"insertion", pointer:"$.user.name", resolved:"Alice"}`.

### 4. Internal Links

- **Validator**: During compilation, for each Markdown link `[...] (target)`, resolve to file/section; on miss record `W3100`.
- **Cross-mix**: Build index of all mix front-matter `name`/`id` at start; resolve accordingly.
- **Export-Aware**: Provider plugin hook `transformLink(href, context)` rewrites based on `export` mapping.

### 5. Terminology Consistency

- **Audit Script**: Grep docs for `\b[Ee]mbed[s]?\b`; flag capitalisation; manual pass.

### 6. Self-Closing Tags

- **Grammar Update**: Allow `{{> partial /}}` → AST node `embed.selfClosing=true`.
- **Docs**: Add to `sections-spec.md` & `includes-spec.md`.

### 7. Whitespace Handling

- **Spec**: Require single space after `#` or `>`; attributes separated by spaces/newlines; attribute `=` no surrounding spaces.
- **Lint Rule**: `mixdown lint --fix` auto-trims inconsistent whitespace.

### 8. Target-Specific Front-Matter

- **Schema**: Under root, add keys:

  ```yaml
  targets:
    include: [cursor]
    exclude: [windsurf]
  ```

- **Compiler**: Merge front-matter filters into section filters.

### 9. Error-Message Reference

- **Location**: `docs/spec/linting-spec.md#errors`.
- **Template**: Code, message, remedy, strict-mode level.

### 10. Tooling Support Plan

- Consolidate tasks 1.2, 9, 15; produce roadmap doc `docs/roadmap/tooling.md`.

### 11-16. Future Roadmap Items

Brief bullets here (see matrix) – each will have its own design doc when prioritised.

---

## Recommended Execution Order

1. Core grammar & compiler enhancements (tasks 1,2,6,7,8,4).
2. CLI / Lint surface (tasks 3,15).
3. Documentation pass (tasks 5,9).
4. Tooling ecosystem (tasks 10,11).
5. Advanced features (12 → 16) once base is stable.

---

## Acceptance Checklist for Entire Epic

- [ ] All tasks in Task Matrix have assignees and GitHub issues.
- [ ] CI passes snapshot & new unit tests.
- [x] Spec docs updated and redeployed.
- [ ] Demo compile run with `--debug` showcases new features.

---

## Change-Log Stub (keep updated)

```markdown
### Added
- Section tag migration CLI
- Filter validation & warnings
- Undefined-insertion diagnostics
- Self-closing embed support

### Fixed
- Whitespace inconsistencies in tag parsing

### Docs
- Attribute precedence clarification
- Error catalogue page
```
