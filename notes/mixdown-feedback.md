# Mixdown Feedback Ledger

## 1. Outstanding Items

### 1.1 Syntax & Core Compiler

- [x] **Malformed‐Tag Handling** – add explicit logging + `E1001` diagnostic for missing space after `#` (ref: `mixdown-syntax-updates-execution-notes.md`).
    - **Decision**: 👉🏻 Yes, this should happen.
- [x] **Strict Nesting / Auto-Close Policy** – decide default vs `--strict` mode; update parser accordingly (ref: Gemini + o3 evaluations).
    - **Decision**: 👉🏻 Under [decisions](#3-decisions-needed-open-questions)
- [x] **Pragma Directives** – per-file front-matter flags (`strict`, `version`, etc.) need design (ref: [execution notes §11](mixdown-syntax-updates-execution-notes.md#11-16-future-roadmap-items)).
    - **Decision**: 👉🏻 Under [decisions](#3-decisions-needed-open-questions)
- [x] **Conditional Logic Blocks** – evaluate `{% if target %}` / `{{% if ... %}}` syntax ([execution notes §12](mixdown-syntax-updates-execution-notes.md#11-16-future-roadmap-items), Claude feedback [§4.2](2025-04-15-agent-rules-research.md#clause-feedback-42)).
    - **Decision**: 👉🏻 We should add this detail into the overview doc. Keep it simple for now to relate to just targets.
- [x] **Variable Filters / Pipe Syntax** – design and implement `| uppercase`, `| default` etc. ([execution notes §13](mixdown-syntax-updates-execution-notes.md#11-16-future-roadmap-items), Gemini critique #5).
    - **Decision**: 👉🏻 Transformations will be nice to have with a simplified syntax. Roadmap item. Out of scope for now.
- [x] **Template Inheritance Model** – high-level design doc required ([execution notes §14](mixdown-syntax-updates-execution-notes.md#11-16-future-roadmap-items)).
    - **Decision**: 👉🏻 Under [decisions](#3-decisions-needed-open-questions). Out of scope for now. But keep in roadmap.
- [x] **Built-in Placeholder Helpers** – design default helpers like `[git_branch]`, `[random_uuid]`, `[package_version]` to auto-populate common values (ref: [2025-04-16 o3 review §3](2025-04-16-o3-review.md#3-placeholder-helpers)).
    - **Decision**: 👉🏻 This was deprecated. Must be removed from overview and any plan for now.

### 1.2 Tooling & Ecosystem

- [x] **VS Code / LSP Extension** – syntax highlighting, IntelliSense, linting (all evaluations – high priority).
    - **Decision**: 👉🏻 Yes this should exist. Need to build out a plan for it and include in short-term roadmap after initial tooling (linter comes first though).
- [x] **CLI Debug Mode** – `mixdown build --debug` spec & UX ([execution notes §15](mixdown-syntax-updates-execution-notes.md#11-16-future-roadmap-items), critiques #3).
    - **Decision**: 👉🏻 Must be spec'ed out. Debug mode can come later. Add to short-term roadmap.
- [x] **Error-Message Reference Docs** – catalogue common errors & remedies ([execution notes §9](mixdown-syntax-updates-execution-notes.md#9-error-message-reference)).
    - **Decision**: 👉🏻 Yes, we must get an error message reference doc. Should be in the execution plan (tasks.md)
- [x] **Interactive Playground** – requirements + tech spike ([execution notes §16](mixdown-syntax-updates-execution-notes.md#11-16-future-roadmap-items)).
    - **Decision**: 👉🏻 Yep. Should be in the future roadmap.
- [x] **Starter Kit & Templates** – `mixdown init --template basic` (evaluations – high impact).
    - **Decision**: 👉🏻 Yeah, let's add this to round out the execution plan. Could be in a nice to have for v1.
- [x] **Dry-Run / Preview Command** – add `mixdown preview --tool <id>` to render artifact to stdout without writing files (ref: o3 review §1).
    - **Decision**: 👉🏻 Yep let's be sure to add this. Should be in the execution plan (tasks.md)
- [x] **Embedded Changelog Header** – auto-insert comment block (mix name, version, commit SHA) at top of emitted artifacts (o3 review §5).
    - **Decision**: 👉🏻 Great idea. Should be in the near-term execution plan    
- [x] **MCP Fetch Endpoint** – expose `GET /mixes/:tool` for agents to pull latest artifacts (o3 review §6).
    - **Decision**: 👉🏻 MCP is going to be a must-have, but not for this particular use-case. MCP on the roadmap.

### 1.3 Documentation Gaps

- [x] **Comprehensive Syntax Guide** – single authoritative doc (Claude [§3.1](archive/syntax-updates-claude.md#31-syntax-guide)).
    - **Decision**: 👉🏻 100% yes. Goes into execution plan.
- [x] **Whitespace Rules & Linter** – finalise spec and auto-fixer ([execution notes §7](mixdown-syntax-updates-execution-notes.md#7-whitespace-handling)).
    - **Decision**: 👉🏻 Decision below in [decisions](#3-decisions-needed-open-questions)
- [x] **Target-Specific Front-Matter Examples** – include/exclude keys vs `+/-` syntax (Claude 1.4).
    - **Decision**: 👉🏻 Decision below in [decisions](#3-decisions-needed-open-questions)

### 1.4 Performance & Infrastructure

- [x] **Caching Layer for Data Insertions** – memoise YAML/JSON pointer lookups (Claude 1.3; Gemini critique #3).
    - **Decision**: 👉🏻 Agreed.
- [x] **Two-Phase Parser & AST Cache** – benchmark large mixes (>5k lines) (o3 critique #5).
    - **Decision**: 👉🏻 This size of mix would be silly, but yeah I guess this is fine. Roadmap item.

### 1.5 Project Management

- [x] **Task Matrix Ownership** – assign owners & GitHub issues for rows 1-16 (execution notes table).
    - **Decision**: 👉🏻 Not worried right now. These items will live in the roadmap for now.
- [x] **Acceptance Criteria** – CI snapshot tests, demo compile with `--debug` (execution notes footer).
    - **Decision**: 👉🏻 Tests are a must.

---

## 2. Recommendations

1. **Prioritise Tooling** – begin with LSP extension + syntax grammar to shorten learning curve.
2. **Ship Strict Mode Early** – implement explicit-closing enforcement behind flag; gather feedback.
3. **Publish Starter Kit** – `mixdown init` template + example repo to showcase new syntax.
4. **Add Debug Telemetry** – structured JSON logs for insertions/link resolution to aid adopters.
5. **Design Pragma/Directive Schema** – unblock conditional & filter roadmap items.

---

## 3. Decisions Needed (Open Questions)

- [x] 1. **Strict nesting default:**
    - Should auto-close remain default or switch to strict explicit closing? (Gemini & [o3 critique #2](2025-05-01-evaluation-o3.md#critique-2-auto-closing-sections-can-hide-errors))
    - **Decision**: 👉🏻 Auto-close should remain default. `auto-close-sections` can be set to false (to require explicit closing) via CLI flag, `config.yaml`, or frontmatter under the `mixdown` key.
- [x] 2. **Filter expression language:**
    - Lightweight boolean expressions vs provider hooks? ([o3 critique #4](2025-05-01-evaluation-o3.md#critique-4-limited-conditional-logic-for-power-users))
    - **Decision**: 👉🏻 No filter expression language yet. Add to roadmap as a "being considered" item.
- [x] 3. **Delimiter configurability:**
    - Support configurable delimiters project-wide? ([o3 critique #3](2025-05-01-evaluation-o3.md#critique-3-delimiter-collision--markdown-toolchain-friction))
    - **Decision**: 👉🏻 No longer relevant. I know it could conflict with other tools, but the conflict seems unlikely, since they're entirely different contexts.
- [x] 4. **Placeholder pipe syntax:**
    - Adopt Liquid-style `|` filters or explicit attributes? ([o3 critique #4](2025-05-01-evaluation-o3.md#critique-4-limited-conditional-logic-for-power-users))
    - **Decision**: 👉🏻 Not worried about this right now.
- [x] 5. **Debug output format:**
    - JSON lines vs human-readable tables? ([o3 critique #5](2025-05-01-evaluation-o3.md#critique-5-debug-output-format))
    - **Decision**: 👉🏻 JSON lines with an additional human-readable table option.
- [x] 6. **Playground scope:**
    - In-repo Storybook-style vs standalone web service? ([o3 critique #6](2025-05-01-evaluation-o3.md#critique-6-in-repo-playground))
    - **Decision**: 👉🏻 Roadmap item. Should be standalone.

Please review & convert unchecked boxes into GitHub issues / tasks.