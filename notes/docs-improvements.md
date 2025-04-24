# 📐 Mixdown Overview – Formatting Improvement Suggestions

> These recommendations focus on **clarity, explicitness for AI agents, and future‑proof maintainability**. Treat them as an incremental punch‑list rather than a full rewrite.

## Table of Contents

- [Todos](#todos)
- [Guiding Principles](#guiding-principles)
- [Structural Tweaks](#structural-tweaks)
- [Formatting Conventions to Adopt](#formatting-conventions-to-adopt)
- [Making Implicit Rules Explicit](#making-implicit-rules-explicit-for-ai-build-agents)
- [Section-by-Section Notes](#section-by-section-notes)
- [Automation Hooks](#automation-hooks-next-steps-for-ai-agents)
- [Open Questions](#open-questions)
- [References & Resources](#references-resources)

## Todos

1. **Add Table of Contents**
   - [x] Insert Table of Contents after H1
   - [x] Configure markdown‑lint rule to validate TOC presence
2. **Refactor Purpose & Vision**
   - [ ] Merge Elevator Pitch into single paragraph
   - [ ] Replace 1.1‑style headings with concise bullet list
3. **Convert Core Concepts to Definition List**
   - [ ] Replace table with `Term : Definition` format
   - [ ] Add note about VS Code preview limitations for definition lists
4. **Split Key Features Section**
   - [ ] Separate into *Authoring* vs *Compiler* sub‑lists
5. **Relocate Syntax Cheatsheet** ⚡ FAST TRACK
   - [ ] Create `docs/quick‑reference.md`
   - [ ] Link from overview
6. **Modularize Full Syntax Reference**
   - [ ] Break into dedicated spec files under `docs/spec/`
   - [ ] Introduce index page
7. **Annotate Directory Structure** ⚡ FAST TRACK
   - [ ] Add comments indicating ignored/generated directories
   - [ ] Add `.gitattributes` snippet for generated content
8. **Update Roadmap with Dates**
   - [ ] Determine target quarters/semesters
   - [ ] Use consistent version numbering (v0.1, v0.2, etc.)
   - [ ] Insert into roadmap table
9. **Automate Appendix Attribute Table**
   - [ ] Write script to generate from schema
   - [ ] Replace manual table with generated include
   - [ ] Add table caption for accessibility
10. **Implement Automation Hooks** ⚡ FAST TRACK
    - [ ] Add `.markdownlint.yaml` with appropriate configuration
    - [ ] Configure Husky for pre-commit validation in package.json
    - [ ] Build docs builder pipeline
11. **Create SECURITY.md** ⚡ FAST TRACK
    - [ ] Document sandbox limits and placeholder whitelist
    - [ ] Add two-way linking with overview security section
    - [ ] Reference in overview

## Change Implemenation Plan

### Todo #2: Refactor Purpose & Vision

*Reference: [Section 1. Purpose & Vision](#1-purpose--vision) in overview.md*

#### Current State

The Purpose & Vision section currently uses a 1.1, 1.2, 1.3 numbering system with three separate H3 headings for Elevator Pitch, Problem Statement, and Solution Overview.

#### Implementation Details

1. Convert the three H3 sections into a single H2 section with bullet points:

```markdown
## Purpose & Vision

**Mixdown is a CommonMark-compliant prompt compiler that lets you author a single *mix* file in plain Markdown and compile it into tool-specific instruction artifacts. Think of it as Terraform for AI prompts—declare once, target many, keep every teammate (human and bot) on the same authoritative rules.**

### Why It Matters
- Instruction formats are **fragmented** across IDEs and agentic tools, leading to duplication and drift.
- Manual copy-paste workflows break **source-of-truth** guarantees and slow experimentation with new tools.
- Lack of a **machine-readable prompt spec** hinders automation, testing, and versioning.

### What You Get
- A single source-of-truth **mix** file written in pure Markdown plus YAML front-matter
- A compiler that parses your mix into an AST (sections, placeholders, mixins)
- Rendering to target tools via plugin providers
- Tool-specific **artifacts** written to predictable locations
- Optional **CLI** and **HTTP/MCP API** for integration
```

#### Definition of Done

- The original three H3 sections (1.1, 1.2, 1.3) are removed
- A single bolded paragraph combines the Elevator Pitch content
- Two bullet lists ("Why It Matters" and "What You Get") replace the Problem Statement and Solution Overview
- All key points from the original sections are preserved

### Todo #3: Convert Core Concepts to Definition List

*Reference: [Section 2. Core Concepts](#2-core-concepts) in overview.md*

#### Current State

Core concepts are currently presented in a table format with Term and Definition columns.

#### Implementation Details

1. Replace the table with a definition list using the following format:

```markdown
## Core Concepts

**Mix**
: Source Markdown file that is compiled into artifacts.

**Artifact**
: Tool-specific output file (e.g., `.cursor/rules/foo.mdc`).

**Section**
: Delimited block `{{section}}…{{/section}}` with optional attributes.

**Mixin**
: Re-usable include (`{{$my-include}}`) that can embed another mix/segment/template.

**Placeholder**
: Dynamic token replaced at build time (`{@alias}`, `{=data.key}`, `[ fill this in ]`).

**Target**
: A supported tool (Cursor, Roo Code, etc.) identified by an ID.

**Target Group**
: Named set of targets (`@ide`, `@cli`) for attribute filtering.
```

2. Add links to relevant specification sections for each term:

```markdown
**Mix** [↗](#7-full-syntax-reference-specification)
: Source Markdown file that is compiled into artifacts.
```

3. Add a note about VS Code preview limitations:

```markdown
> **Note for VS Code users:** Definition lists may not render correctly in VS Code's built-in Markdown preview. This is expected behavior and will display correctly on GitHub and other CommonMark-compliant renderers.
```

#### Definition of Done

- Table format is replaced with a definition list (Term : Definition)
- Each term is bolded and linked to its relevant section in the specification
- All original terms and definitions are preserved
- Format follows CommonMark-compliant definition list syntax
- Note added about VS Code preview limitations

### Todo #4: Split Key Features Section

*Reference: [Section 3. Key Features](#3-key-features) in overview.md*

#### Current State

Key features are presented as a single bullet list without categorization.

#### Implementation Details

1. Split the current bullet list into two categorized sub-lists:

```markdown
## Key Features

### Authoring Features
- **100% CommonMark** – Renders cleanly in GitHub & VS Code; passes markdown-lint.
- **Granular Sections** – Export, filter, or re-title sections per target.
- **Powerful Placeholders** – Aliases, YAML data injections, runtime values (`{@git_branch}`) with sandboxed resolvers.

### Compiler & Integration
- **Plugin Architecture** – Add new targets via `MixdownPluginProvider` without touching core.
- **CLI & API** – `mixdown build`, `mixdown validate`, and `POST /compile` endpoint return ZIP artifacts, unzipped into `artifacts/builds/`.
- **Snapshot Testing** – Contract tests ensure mix edits don't silently change generated artifacts.
```

2. Re-frame key features as user stories:

```markdown
### Authoring Features
- As a **content author**, I can write in standard Markdown that renders cleanly in GitHub & VS Code and passes linting.
- As a **documentation maintainer**, I can export, filter, or re-title sections per target for granular control.
- As a **template creator**, I can use powerful placeholders with aliases, YAML data injections, and runtime values.
```

#### Definition of Done

- Features are categorized into "Authoring Features" and "Compiler & Integration" sections
- Features are optionally rephrased as user stories ("As a [role], I can...")
- The "Snapshot Testing" bullet is moved under the "Compiler & Integration" section
- All original features are preserved with their descriptions

### Todo #5: Relocate Syntax Cheatsheet

*Reference: [Section 6. Syntax Cheatsheet](#6-syntax-cheatsheet) in overview.md*

#### Implementation Details

1. Create a new file at `docs/quick-reference.md` with the following content:

```markdown
# Mixdown Quick Reference

> This is a condensed reference of Mixdown syntax. For complete details, see the [full specification](spec/mixdown-syntax.md).

## Syntax Elements

| Token / Feature | Example | Notes |
|-----------------|---------|-------|
| **Section** | `{{instructions title="Rules" export="cli"}}…{{/instructions}}` | Attributes control heading & export. |
| **Front-matter** | `---\nname: foo\n---` | YAML at file top. |
| **Mixin Include** | `{{$legal no-title}}` | Embed another mix/include. |
| **Internal Link** | `{>rules\|Read more}` | Auto-resolves per target path. |
| **Alias Placeholder** | `{@project}` | Resolved via alias chain. |
| **Data Placeholder** | `{=user.email}` | Injects YAML data. |
| **Static Fill-In** | `[ fill this in ]` | Marker for LLM to complete. |

## Common Patterns

### Section with Attributes
~~~md
{{instructions
  title="Rules"
  export="cursor"
  filter="target=ide,!windsurf"
}}
Content here...
{{/instructions}}
~~~

### Target-Specific Overrides

~~~md
{{section
  title="General Title"
  title@cursor="Cursor-Specific Title"
}}
~~~

### Working with Mixins

~~~md
{{$mix:common-rules
  sections="sec1,!sec2"
  no-title
}}
~~~
```

2. Replace the current cheatsheet section in overview.md with a link:
```markdown
## Syntax Cheatsheet

For a quick reference of Mixdown syntax elements and patterns, see the [Quick Reference Guide](docs/quick-reference.md).
```

#### Definition of Done

- A new file `docs/quick-reference.md` is created with complete cheatsheet content
- The cheatsheet section in overview.md is replaced with a brief description and link
- The quick reference includes all original syntax elements plus additional examples
- The quick reference is structured with clear headings and sections
- Nested code blocks use different fence symbols (`~~~`) to avoid conflicts

### Todo #6: Modularize Full Syntax Reference

*Reference: [Section 7. Full Syntax Reference](#7-full-syntax-reference-specification) in overview.md*

#### Implementation Details

1. Create the following files in the `docs/spec/` directory:

```
docs/spec/
├── mixdown-syntax.md          # Main syntax index
├── sections-spec.md           # Section delimiters and attributes
├── front-matter-spec.md       # Front-matter specification
├── placeholders-spec.md       # Placeholder syntax and resolution
├── mixins-spec.md             # Mixin includes and attributes
└── attributes-spec.md         # Complete attribute reference
```

2. Create an index page at `docs/spec/mixdown-syntax.md`:

```markdown
# Mixdown Syntax Specification

This document serves as an index to the complete Mixdown syntax specification.

## Design Goals

| Goal | Description |
|------|-------------|
| **Simplicity** | Reduce bespoke tokens to the minimum necessary. |
| **Lintability** | Files must pass standard markdown-lint without hacks. |
| **Previewability** | Render legibly in GitHub, VS Code, Obsidian, etc. |
| **Extensibility** | Advanced behaviors declared via attributes instead of new syntax. |

## Specification Documents

- [**Sections**](sections-spec.md) - Section delimiters and attributes
- [**Front-Matter**](front-matter-spec.md) - YAML metadata and configuration
- [**Placeholders**](placeholders-spec.md) - Dynamic tokens and resolution
- [**Mixins**](mixins-spec.md) - Re-usable includes and templates
- [**Attributes**](attributes-spec.md) - Complete attribute reference

## Quick Start

See the [Quick Reference Guide](../quick-reference.md) for common syntax patterns.
```

3. Move content from each subsection (7.2-7.6) into the corresponding spec files

4. Update the Full Syntax Reference section in overview.md:

```markdown
## Full Syntax Reference

For complete syntax details, see the [Mixdown Syntax Specification](docs/spec/mixdown-syntax.md), which covers:

- [Section Delimiters](docs/spec/sections-spec.md)
- [Front-Matter](docs/spec/front-matter-spec.md)
- [Placeholders](docs/spec/placeholders-spec.md)
- [Mixins](docs/spec/mixins-spec.md)
- [Attributes](docs/spec/attributes-spec.md)

The specification documents provide normative definitions, examples, and edge cases.
```

#### Definition of Done

- Create directory structure with individual spec files
- Each spec file contains corresponding content from the overview
- Index page links to all individual spec documents
- Overview.md section is updated to link to spec documents
- All original content is preserved across the new structure

### Todo #7: Annotate Directory Structure

*Reference: [Section 9. Directory Structure](#9-directory-structure-monorepo) in overview.md*

#### Implementation Details

1. Annotate the directory structure with comments:

```markdown
## Directory Structure

```text
mixdown/
├── prompts/
│   ├── artifacts/           # Generated content - not committed
│   │   ├── builds/{id}/     # Build-specific outputs
│   │   └── latest/          # Symlink to latest build
│   ├── instructions/        # Mix files (*.md) - source of truth
│   ├── includes/            # Reusable content & data
│   └── templates/           # Document templates
├── .mixdown/                # Compiler config, cache, reports
├── packages/                # pnpm workspaces
│   ├── core/                # Core compiler
│   ├── cli/                 # Ink-based CLI
│   ├── api/                 # Express/MCP API
│   ├── plugin-cursor/       # First-party provider
│   └── plugin-claude-code/  # First-party provider
└── docs/                    # Deep dives & spec
```

2. Add a note explaining directory annotations:

```markdown
**Directory Annotations:**
- **Generated content** is marked and should be in `.gitignore`
- **Required directories** must exist for the compiler to function
- **Optional directories** can be created as needed
```

3. Add a note about the `latest` symlink:

```markdown
> **Note on `latest` symlink:** The compiler automatically creates a symlink from `prompts/artifacts/latest` to the most recent build directory after each successful build.
```

4. Add a `.gitattributes` snippet:

```markdown
**Add to `.gitattributes` for better GitHub experience:**
```
/prompts/artifacts/* linguist-generated=true
```
This makes GitHub diff and PR files view hide generated content, reducing noise.
```

#### Definition of Done

- Directory structure is annotated with comments indicating:
  - Generated/ignored directories
  - Required vs. optional directories
- A note is added explaining directory annotations
- A note about the `latest` symlink creation is included
- A `.gitattributes` snippet is included for handling generated files
- Original directory structure format is maintained

### Todo #8: Update Roadmap with Dates

*Reference: [Section 12. Roadmap](#12-roadmap-high-level) in overview.md*

#### Implementation Details

1. Update the roadmap table with target dates and consistent versioning:

```markdown
## Roadmap

| Phase | Target | Deliverables |
|-------|--------|--------------|
| **v0.1** | Q3 2024 | Core compiler, Cursor & Claude providers, `init`/`build`/`validate` CLI, `/compile` API. |
| **v0.2** | Q4 2024 | Roo Code & Windsurf providers, provider SDK docs. |
| **v0.3** | Q1 2025 | Prompt test harness, security hardening, >90% coverage. |
| **v0.4** | Q2 2025 | Mix registry (`mixdown add @acme/rails-rules`), web playground. |
```

2. Add a note about date flexibility:

```markdown
> **Note:** Target dates are approximate and subject to change based on community feedback and priorities.
```

#### Definition of Done

- Roadmap table includes a new "Target" column with quarters/semesters
- Version numbering is consistent (v0.1, v0.2, etc.) rather than mixing MVP/0.2/etc.
- A note about date flexibility is included
- All original deliverables information is preserved

### Todo #9: Automate Appendix Attribute Table

*Reference: [Section 15.1 Comprehensive Attribute Reference](#151-comprehensive-attribute-reference-table) in overview.md*

#### Implementation Details

1. Create a script to generate the attributes table from schema:

```javascript
// scripts/generate-attributes-table.js
const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');

// Load attribute schema
const schemaPath = path.join(__dirname, '../packages/core/src/schema/attributes.yaml');
const schema = yaml.load(fs.readFileSync(schemaPath, 'utf8'));

// Generate markdown table
let markdown = '<sub>Table 1: Complete Mixdown attribute reference with type, default values, and scope support</sub>\n\n';
markdown += '| Attribute | Type | Default | Section | Mixin | Front-matter | Description |\n';
markdown += '|-----------|------|---------|---------|-------|--------------|-------------|\n';

Object.entries(schema.attributes).forEach(([name, attr]) => {
  const row = [
    `\`${name}\``,
    attr.type || 'string',
    attr.default || 'none',
    attr.scopes?.includes('section') ? '✅' : '❌',
    attr.scopes?.includes('mixin') ? '✅' : '❌',
    attr.scopes?.includes('frontmatter') ? '✅' : '❌',
    attr.description || ''
  ];
  markdown += `| ${row.join(' | ')} |\n`;
});

// Write to file
const outputPath = path.join(__dirname, '../docs/generated/attributes-table.md');
fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, markdown);

// Also export as CSV
const csvPath = path.join(__dirname, '../docs/generated/attributes-table.csv');
const csvHeader = 'Attribute,Type,Default,Section,Mixin,Front-matter,Description\n';
let csvContent = csvHeader;

Object.entries(schema.attributes).forEach(([name, attr]) => {
  const row = [
    name,
    attr.type || 'string',
    attr.default || 'none',
    attr.scopes?.includes('section') ? 'Yes' : 'No',
    attr.scopes?.includes('mixin') ? 'Yes' : 'No',
    attr.scopes?.includes('frontmatter') ? 'Yes' : 'No',
    attr.description ? `"${attr.description.replace(/"/g, '""')}"` : ''
  ];
  csvContent += `${row.join(',')}\n`;
});

fs.writeFileSync(csvPath, csvContent);

console.log('Attribute tables generated:');
console.log(`- Markdown: ${outputPath}`);
console.log(`- CSV: ${csvPath}`);
```

2. Add an npm script to package.json:

```json
{
  "scripts": {
    "generate:docs": "node scripts/generate-attributes-table.js"
  }
}
```

3. Update the Comprehensive Attribute Reference section in overview.md:

```markdown
### Comprehensive Attribute Reference

The following table provides a complete list of all supported attributes in Mixdown, their types, default values, and scope support:

<!-- GENERATED_ATTRIBUTES_TABLE -->
<!-- Do not edit this section directly. Run `npm run generate:docs` to update. -->
<!-- Include from docs/generated/attributes-table.md -->

For a machine-readable version of this data, see [attributes-table.csv](docs/generated/attributes-table.csv).

**Notes:**
- All attributes with string values can be scoped with target/group suffixes (e.g., `title@cursor="Cursor-specific title"`)
- Flag attributes default to `true` when specified without a value
- Target-specific front-matter keys override global values (e.g., `cursor: { description: "..." }`)
```

#### Definition of Done

- A script is created to generate the attributes table from schema
- The script outputs both markdown and CSV formats
- An npm script is added to run the generator
- The overview.md section is updated with a placeholder for the generated content
- A note is added about the machine-readable CSV version
- A table caption is included for accessibility

### Todo #10: Implement Automation Hooks

*Reference: [Section 5. Automation Hooks](#5-automation-hooks-next-steps-for-ai-agents) in docs-improvements.md*

#### Implementation Details

1. Create a `.markdownlint.yaml` file in the project root:

```yaml
# .markdownlint.yaml
default: true
MD013:
  line_length: 100
  code_blocks: false
  tables: false
MD033: false  # Inline HTML (allow for details/summary)
MD041: false  # First line should be a heading (allow front-matter)

# Enforce TOC presence
MD043:
  required_headings:
    - "^# .*"
    - "^## Table of Contents$"

# Custom rules
extends: 
  - "./.mixdown/markdown-lint-rules.js"
```

2. Create a `.mixdown/markdown-lint-rules.js` file:

```javascript
// .mixdown/markdown-lint-rules.js
module.exports = {
  "mixdown-toc-required": {
    names: ["mixdown-toc-required"],
    description: "Table of Contents must be present after H1",
    tags: ["mixdown"],
    function: (params, onError) => {
      const { tokens } = params;
      const h1Index = tokens.findIndex(t => t.type === 'heading_open' && t.tag === 'h1');
      
      if (h1Index !== -1) {
        const tocFound = tokens.some((t, i) => 
          i > h1Index && 
          t.type === 'heading_open' && 
          t.tag === 'h2' && 
          t.line && 
          t.line.includes('Table of Contents')
        );
        
        if (!tocFound) {
          onError({
            lineNumber: tokens[h1Index].lineNumber + 1,
            detail: "A '## Table of Contents' heading must follow the H1 title",
            context: tokens[h1Index].line
          });
        }
      }
    }
  }
};
```

3. Configure Husky in package.json:

```json
{
  "scripts": {
    "lint:md": "markdownlint \"**/*.md\"",
    "validate": "mixdown validate",
    "prebuild": "npm run lint:md && npm run validate",
    "build:docs": "node scripts/build-docs.js",
    "prepare": "husky install"
  },
  "devDependencies": {
    "markdownlint-cli": "^0.33.0",
    "husky": "^8.0.0"
  },
  "husky": {
    "hooks": {
      "pre-commit": "npm run prebuild"
    }
  }
}
```

4. Add a docs builder pipeline script:

```javascript
// scripts/build-docs.js
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Generate attribute tables
console.log('Generating attribute tables...');
execSync('npm run generate:docs');

// Generate quick reference
console.log('Generating quick reference...');
// Extract cheatsheet from overview.md and write to quick-reference.md
const overviewPath = path.join(__dirname, '../notes/overview.md');
const quickRefPath = path.join(__dirname, '../docs/quick-reference.md');
const overview = fs.readFileSync(overviewPath, 'utf8');

const cheatsheetMatch = overview.match(/## Syntax Cheatsheet\n\n([\s\S]*?)(?=\n## )/);
if (cheatsheetMatch) {
  const content = `# Mixdown Quick Reference\n\n> This is a condensed reference of Mixdown syntax. For complete details, see the [full specification](spec/mixdown-syntax.md).\n\n## Syntax Elements\n\n${cheatsheetMatch[1]}`;
  fs.writeFileSync(quickRefPath, content);
  console.log(`Quick reference written to ${quickRefPath}`);
}

console.log('Documentation build complete!');
```

#### Definition of Done

- A `.markdownlint.yaml` file is created with appropriate rules
  - Line length is set to 100 chars but disabled for code blocks and tables
  - Supports using `<!-- markdownlint-disable-next-line MD013 -->` for exceptions
- Custom markdown-lint rules are defined in `.mixdown/markdown-lint-rules.js` 
- Husky is configured in package.json for pre-commit validation
- A docs builder script is created to generate documentation artifacts
- npm scripts are added for linting, validation, and doc building
- Dependencies for markdown-lint and husky are added

### Todo #11: Create SECURITY.md

*Reference: [Section 11. Security, Testing & Performance](#11-security-testing--performance) in overview.md*

#### Implementation Details

1. Create a `SECURITY.md` file in the project root:

```markdown
# Mixdown Security

This document outlines the security considerations and constraints in Mixdown.

> See also the [Security, Testing & Performance](overview.md#security-testing--performance) section in the overview for a high-level summary.

## Security Model

Mixdown operates with a minimal-access security model:

1. **Sandboxed Execution** - All dynamic operations are performed in controlled environments
2. **Allowlist Approach** - Only explicitly permitted operations are allowed
3. **Input Validation** - All inputs are validated against schemas before processing

## Placeholder Execution Security

Placeholders that execute code (e.g., `{@git_branch}`, `{@shell:command}`) operate under the following constraints:

### Allowed Operations

The following placeholder operations are permitted:

| Placeholder | Purpose | Security Constraints |
|-------------|---------|---------------------|
| `{@git_branch}` | Get current Git branch | Read-only, no arguments |
| `{@git_version}` | Get Git version | Read-only, no arguments |
| `{@date:format}` | Get formatted date | Specified date formats only |
| `{@env:VAR}` | Access environment variable | Allowlisted variables only |

### Sandbox Constraints

1. **No Network Access** - Dynamic placeholders cannot access the network
2. **No File System Writes** - Operations are read-only
3. **Resource Limits** - Execution time and memory are capped
4. **Isolation** - Each operation runs in isolation from others

## XML Parser Security

The XML parser used for processing sections employs the following security measures:

1. **Entity Expansion Disabled** - `ignoreEntities: true` prevents XXE attacks
2. **DTD Processing Disabled** - Prevents DTD-based vulnerabilities
3. **External Loading Disabled** - No external entities can be loaded

## Path Security

All file paths are sanitized to prevent directory traversal:

1. **Path Normalization** - Removes `../` and other potential traversal sequences
2. **Base Directory Enforcement** - Operations cannot access files outside defined roots
3. **Symlink Resolution** - Symlinks are resolved and validated against allowed paths

## Recommendations for Users

1. **Review Custom Placeholders** - Carefully review any custom placeholders before use
2. **Use Version Pinning** - Pin to specific Mixdown versions in your project
3. **Keep Updated** - Follow security advisories and update promptly
4. **Limit Privileges** - Run Mixdown with minimal system privileges

## Reporting Security Issues

Please report security vulnerabilities via [private issue reporting](https://github.com/mixdown/mixdown/security/advisories/new) rather than public issues.
```

2. Add a reference to SECURITY.md in the Security section of overview.md:

```markdown
## Security, Testing & Performance

| Area | Approach |
|------|----------|
| **Security** | XML parser sandbox (`ignoreEntities: true`), path sanitization, placeholder shell-outs whitelisted. See [SECURITY.md](SECURITY.md) for details. |
| **Testing** | Jest ≥ 80% coverage; snapshot tests for plugin renders; Supertest E2E for API. |
| **Performance** | Stream parser; <250 ms compile for 500-line mix on M-series CPU. |
```

#### Definition of Done

- A `SECURITY.md` file is created with comprehensive security information
- The file documents sandbox limits and placeholder whitelist
- Two-way linking is added between SECURITY.md and the overview.md security section
- The security document follows best practices for security documentation

### Todo #12: Quick Wins & Final Fixes

1. Create `.prettierrc.json`:

```json
{
  "singleQuote": true,
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "printWidth": 100,
  "proseWrap": "always",
  "overrides": [
    {
      "files": "*.md",
      "options": {
        "proseWrap": "preserve"
      }
    }
  ]
}
```

2. Fix minor typos and formatting issues:
   - Fix "Implementation" typo in heading
   - Use consistent heading levels
   - Use proper backticks nesting in code blocks
   - Add a table caption to the attribute table

#### Definition of Done

- All quick wins items are implemented
- Typos and formatting issues are fixed
- Proper heading levels are used throughout
- Code blocks properly handle nested backticks
</details>

## Guiding Principles

1. **Single‑responsibility docs** – keep the overview lightweight; deep dives live under `docs/`.
2. **Consistent heading depth** – every top‑level H2 is a chapter; H3/H4 for sub‑topics.
3. **CommonMark‑strict** – pass markdown‑lint; avoid HTML blocks where possible.
4. **Machine‑friendly first** – mark all dynamic regions and decisions explicitly so coding agents don't guess.
5. **Progressive disclosure** – surface key info early, link out for detail.

## Structural Tweaks

| Area | Current State | Suggested Change | Rationale |
|------|---------------|------------------|-----------|
| **Table of Contents** | Absent | Auto‑generate with `[TOC]` or plugin | Quick scan & link anchors |
| **Purpose & Vision** | 1.1/1.2/1.3 numbering as H3 | Use bullets inside a single H2; slim to 3–4 sentences | Less visual noise, faster comprehension |
| **Core Concepts** | Wide table | Switch to definition list (`Term : Definition`) | Easier diffing, copy‑pastable |
| **Key Features** | Bullet list | Split into two sub‑lists: *Authoring* vs *Compiler* | Improves mental model |
| **Syntax Cheatsheet** | Inline in overview | Move to `docs/quick‑reference.md`; link | Keep overview shorter |
| **Full Syntax Ref** | Huge block | Break into >5 sub‑files under `docs/spec/` (sections, mixins, placeholders, front‑matter, DSL) | Navigable & maintainable |
| **Directory Structure** | Code‑fence tree | Add comments `# ignored by Git`, `# generated` | Clarifies VCS boundaries |
| **Roadmap table** | No dates | Add tentative quarter/half‑year targets | Gives stakeholders time horizon |
| **Appendix attr table** | Massive | Auto‑generate from source YAML with script; include CSV export | Prevent drift, aid agents |

## Formatting Conventions to Adopt

### Headings & IDs

- Use `[gh-slug]` IDs: `## Core Concepts {#core-concepts}` so agents can create stable links.
- Reserve H1 for doc title only.

### Lists

- Four‑space indents for nested lists to match Markdown spec.
- Prefer `-` bullets over `*` for consistency.

### Tables

- Left‑align all columns; wrap long cell text at 80 chars.
- Include a caption: `<sub>Table X: …</sub>` for accessibility.

### Code Fences

- Always set language tag (` ```bash`, ` ```mermaid` ).
- If output shown, use `output` tag (` ```output`).

### Admonitions / Call‑outs

- Adopt `>` blockquotes with emoji prefixes for tips/warnings (render nicely in GitHub):
  > ⚠️ **Security Note:** Placeholder shell‑outs are whitelisted.

## Making Implicit Rules Explicit (for AI build agents)

| Concern | Current Implicit Detail | Needed Explicit Marker |
|---------|------------------------|------------------------|
| **Build‑artifact path** | Mentioned inline in prose | Declare once in front‑matter: `artifacts_dir: prompts/artifacts` |
| **Placeholder scope order** | Explained narratively | Provide numbered list *and* example matrix table |
| **Target group membership** | Not centrally defined | Add `groups.yaml` listing each tool→groups mapping |
| **Reserved section names** | Scattered examples | Enumerate canonical list in spec with must/should language |
| **Security constraints** | Inline bullets | Separate `SECURITY.md` referencing sandbox limits |

## Section‑by‑Section Notes

### Purpose & Vision

- Merge Elevator Pitch into a bolded paragraph.
- Follow with two bullet lists: **Why It Matters** / **What You Get**.

### Core Concepts

- Convert to definition list for better diffs.
- Link each term to its dedicated spec subsection.

### Key Features

- Re‑frame as user stories (`As a **tool maintainer** I can…`).
- Move Snapshot Testing bullet under **Quality** sub‑heading.

### Supported Targets

- Add *Min Mixdown Core Version* column so agents can warn on incompat‑ability.
- Provide emoji legend in footnote.

### Getting Started

- Collapsible details block (`<details>` tag) for *install variations* to declutter.

### Syntax Cheatsheet & Reference

- Separate *Cheatsheet* (quick patterns) from *Reference* (normative, exhaustive).
- Add inter‑doc x‑refs so AI agents can follow anchors without scraping.

### Directory Structure

- Annotate which dirs are **required**, **optional**, **generated**.
- Call out `latest` symlink creation rules in a code comment.

### System Architecture

- Provide alt‑text and ASCII fallback for Mermaid.
- Link each component label to code package path.

### Roadmap

- Number phases `v0.1`, `v0.2` instead of *MVP, 0.2* for semver clarity.

## Automation Hooks (Next Steps for AI Agents)

1. **markdown‑lint config** – commit a `.markdownlint.yaml` encoding new style rules.
2. **Pre‑commit hook** – auto‑run `mixdown validate` and `npm run lint:md`.
3. **Docs builder** – generate Quick Reference & Attribute CSV from schema so specs never drift.

## Open Questions

- Should *Plugin Provider* dev guide live in the monorepo or separate site?
- Will the compiler enforce heading‑levels or only lint? Decide to avoid silent failures.
- Any need for versioned docs (e.g., `/v0.3/`)?

## References & Resources

- **CommonMark Spec** – <https://spec.commonmark.org/>
- **Markdown‑lint** – <https://github.com/markdownlint/markdownlint>
- **Keep a Changelog** – <https://keepachangelog.com/>
</code_block_to_apply_changes_from>

## Guiding Principles

1. **Single‑responsibility docs** – keep the overview lightweight; deep dives live under `docs/`.
2. **Consistent heading depth** – every top‑level H2 is a chapter; H3/H4 for sub‑topics.
3. **CommonMark‑strict** – pass markdown‑lint; avoid HTML blocks where possible.
4. **Machine‑friendly first** – mark all dynamic regions and decisions explicitly so coding agents don't guess.
5. **Progressive disclosure** – surface key info early, link out for detail.

## Structural Tweaks

| Area | Current State | Suggested Change | Rationale |
|------|---------------|------------------|-----------|
| **Table of Contents** | Absent | Auto‑generate with `[TOC]` or plugin | Quick scan & link anchors |
| **Purpose & Vision** | 1.1/1.2/1.3 numbering as H3 | Use bullets inside a single H2; slim to 3–4 sentences | Less visual noise, faster comprehension |
| **Core Concepts** | Wide table | Switch to definition list (`Term : Definition`) | Easier diffing, copy‑pastable |
| **Key Features** | Bullet list | Split into two sub‑lists: *Authoring* vs *Compiler* | Improves mental model |
| **Syntax Cheatsheet** | Inline in overview | Move to `docs/quick‑reference.md`; link | Keep overview shorter |
| **Full Syntax Ref** | Huge block | Break into >5 sub‑files under `docs/spec/` (sections, mixins, placeholders, front‑matter, DSL) | Navigable & maintainable |
| **Directory Structure** | Code‑fence tree | Add comments `# ignored by Git`, `# generated` | Clarifies VCS boundaries |
| **Roadmap table** | No dates | Add tentative quarter/half‑year targets | Gives stakeholders time horizon |
| **Appendix attr table** | Massive | Auto‑generate from source YAML with script; include CSV export | Prevent drift, aid agents |

## Formatting Conventions to Adopt

### Headings & IDs

- Use `[gh-slug]` IDs: `## Core Concepts {#core-concepts}` so agents can create stable links.
- Reserve H1 for doc title only.

### Lists

- Four‑space indents for nested lists to match Markdown spec.
- Prefer `-` bullets over `*` for consistency.

### Tables

- Left‑align all columns; wrap long cell text at 80 chars.
- Include a caption: `<sub>Table X: …</sub>` for accessibility.

### Code Fences

- Always set language tag (` ```bash`, ` ```mermaid` ).
- If output shown, use `output` tag (` ```output`).

### Admonitions / Call‑outs

- Adopt `>` blockquotes with emoji prefixes for tips/warnings (render nicely in GitHub):
  > ⚠️ **Security Note:** Placeholder shell‑outs are whitelisted.

## Making Implicit Rules Explicit (for AI build agents)

| Concern | Current Implicit Detail | Needed Explicit Marker |
|---------|------------------------|------------------------|
| **Build‑artifact path** | Mentioned inline in prose | Declare once in front‑matter: `artifacts_dir: prompts/artifacts` |
| **Placeholder scope order** | Explained narratively | Provide numbered list *and* example matrix table |
| **Target group membership** | Not centrally defined | Add `groups.yaml` listing each tool→groups mapping |
| **Reserved section names** | Scattered examples | Enumerate canonical list in spec with must/should language |
| **Security constraints** | Inline bullets | Separate `SECURITY.md` referencing sandbox limits |

## Section‑by‑Section Notes

### Purpose & Vision

- Merge Elevator Pitch into a bolded paragraph.
- Follow with two bullet lists: **Why It Matters** / **What You Get**.

### Core Concepts

- Convert to definition list for better diffs.
- Link each term to its dedicated spec subsection.

### Key Features

- Re‑frame as user stories (`As a **tool maintainer** I can…`).
- Move Snapshot Testing bullet under **Quality** sub‑heading.

### Supported Targets

- Add *Min Mixdown Core Version* column so agents can warn on incompat‑ability.
- Provide emoji legend in footnote.

### Getting Started

- Collapsible details block (`<details>` tag) for *install variations* to declutter.

### Syntax Cheatsheet & Reference

- Separate *Cheatsheet* (quick patterns) from *Reference* (normative, exhaustive).
- Add inter‑doc x‑refs so AI agents can follow anchors without scraping.

### Directory Structure

- Annotate which dirs are **required**, **optional**, **generated**.
- Call out `latest` symlink creation rules in a code comment.

### System Architecture

- Provide alt‑text and ASCII fallback for Mermaid.
- Link each component label to code package path.

### Roadmap

- Number phases `v0.1`, `v0.2` instead of *MVP, 0.2* for semver clarity.

## Automation Hooks (Next Steps for AI Agents)

1. **markdown‑lint config** – commit a `.markdownlint.yaml` encoding new style rules.
2. **Pre‑commit hook** – auto‑run `mixdown validate` and `npm run lint:md`.
3. **Docs builder** – generate Quick Reference & Attribute CSV from schema so specs never drift.

## Open Questions

- Should *Plugin Provider* dev guide live in the monorepo or separate site?
- Will the compiler enforce heading‑levels or only lint? Decide to avoid silent failures.
- Any need for versioned docs (e.g., `/v0.3/`)?

## References & Resources

- **CommonMark Spec** – <https://spec.commonmark.org/>
- **Markdown‑lint** – <https://github.com/markdownlint/markdownlint>
- **Keep a Changelog** – <https://keepachangelog.com/>
</rewritten_file>
