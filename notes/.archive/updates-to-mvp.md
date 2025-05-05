# Proposed Updates to Mixdown MVP Documentation

This document outlines recommended updates to the `.agent/projects/project-mvp.md` file based on changes observed since Git commit `dd7bb450918711c0a36a81e95c9955ecc55ed4fb`.

## Background

The recent commit (`dd7bb45`) made several documentation updates across the project repository. Additionally, significant documentation work has been done on the following files:

- `README.md`: Comprehensive overview of Mixdown with detailed explanations of concepts
- `.mixdown/config.yaml`: Project configuration settings
- `docs/config.md`: Detailed configuration documentation

These changes reflect substantial progress on both implementation and documentation aspects of the project.

## Identified Issues

1. **Task Plan Reference Inconsistency**
   - In the Status section, the task plan links to `[.agent/tasks/mvp-tasks.md](../../.agent/tasks.md)`
   - In the Context section, it links to `[mixdown-mvp-tasks.md](../../.agent/plans/mixdown-mvp-tasks.md)`
   - These inconsistent references point to different files

2. **Project Status Information**
   - The "Current Status" is listed as "Backlog" but the commit shows that the task plan is marked as completed in tasks.md
   - The "Last Updated" date (2024-06-17) hasn't been refreshed to reflect recent changes

3. **Cleanup Task Information**
   - The project document doesn't specify the target branch for deployment (`release/v0.1.0-mvp`), which was added in the task plan

4. **Missing Documentation Structure Updates**
   - The project documentation doesn't reflect the established file structure and organization
   - The comprehensive terminology defined in README.md isn't reflected in the MVP documentation

5. **Incomplete Reflection of Configuration System**
   - The detailed configuration system described in `.mixdown/config.yaml` and `docs/config.md` isn't represented in the MVP documentation

## Recommended Updates

### 1. Standardize Task Plan References

```markdown
- **Task Plan:** [mixdown-mvp-tasks.md](../../.agent/plans/mixdown-mvp-tasks.md)
```

### 2. Update Project Status

```markdown
- **Current Status:** In Progress
- **Last Updated:** 2025-04-21
```

### 3. Add Deployment Branch Information

- Add a note in the Deployment Considerations section:
```markdown
- Target branch for MVP release: `release/v0.1.0-mvp`
- Publish packages to npm under `@mixdown/*` scope
- Provide Docker image for API server
```

### 4. Update File Structure Information

Add a new section or update the existing implementation plan to include the established project structure:

```markdown
### Project Structure

The Mixdown MVP follows this file organization:
```

```txt
project-root/
├── prompts/
│   ├── artifacts/                              # Generated artifacts
│   │   ├── builds/                             # Build-specific artifacts
│   │   └── latest/                             # Symlink to the latest artifact set
│   ├── instructions/                           # Mix files
│   │   ├── [mix-name].mixd                     # Mix file
│   │   └── [directory-name]/                   # Optional nested instruction directories
│   ├── includes/                               # Reusable content as includes
│   │   ├── [include-name].include.mixd         # Reusable content for mixes
│   │   ├── [profile-name].profile.yaml         # Serialized profile data
│   │   └── *.[md,txt,json,ts]                  # Other includable text files
│   └── templates/                              # Template files
│       └── [template-name].template.mixd
├── .mixdown/                                   # Mixdown directory
│   ├── cache/                                  # Mixdown cache directory
│   ├── reports/                                # Mixdown reports directory
│   ├── scripts/                                # Mixdown scripts directory
│   ├── config.yaml                             # Mixdown project configuration
│   └── README.md                               # Mixdown Documentation
```

### 5. Add Terminology Section

Add a new section to clarify important Mixdown terminology:

```markdown
### Glossary of Mixdown Terms

- **Mix**: The template source file that generates tool-specific artifacts. Uses the `.mixd` extension.
- **Artifact**: The output file created from a mix in a specific tool's format. (previously "output" or other terms)
- **Segment**: A mix embedded within another mix, which can be split into separate artifacts (previously "stem").
- **Include**: Content injected into a mix from external files using `$[include:name]` syntax (previously "splice").
- **Override**: Tool-specific instructions added to a mix using the `<override>` tag (previously "punch").
- **Placeholder**: Value tokens that provide LLM instructions to fill in values, using `[name]` syntax.
- **Alias**: Key-value pairs that expand to their value when used with the `$[alias:name]` syntax.
- **Profile/Data**: YAML-formatted serialized data that can be injected into mixes.
```

- **Note**: This reflects terminology updates like `stem` changing to `segment` (see commit `docs: update to more generic terminology`).

### 6. Update "Core Compiler MVP" Details

Expand the "Core Compiler MVP" section to include more details about the parsing and rendering:

```markdown
1. Implement XML + YAML front‑matter parser → AST.
   - **Complexity:** High
   - **Dependencies:** Phase 1 tooling
   - **Implementation details:**
     - Parse XML content with security settings (`ignoreEntities: true`)
     - Support for section tags and placeholders 
     - Handle both single-file and multi-file output structures
2. Implement track splitter & placeholder resolver.
   - **Complexity:** Medium
   - **Features:** 
     - Support runtime placeholder resolution
     - Handle segment splitting based on tool overrides
3. Implement Writer that creates files in `.mixdown/output/builds/<id>` and `latest` symlink.
   - **Complexity:** Medium
   - **Features:**
     - Artifact checksums for caching/verification
     - Proper directory structure following config settings
```

### 7. Update Plugin Development Section

Enhance the "Plugin Development" section to clarify the plugin architecture:

```markdown
1. Cursor plugin renders AST to `.mdc` markdown.
   - **Complexity:** Medium
   - **Features:**
     - Frontmatter support (description, globs, alwaysApply)
     - Write files to `.cursor/rules/` directory
     - Proper heading level adjustments
2. Claude Code plugin renders AST to `CLAUDE.md`.
   - **Complexity:** Medium
   - **Features:**
     - Single-file mode support (CLAUDE.md)
     - Command mode for multi-file output
```

### 8. Add Configuration System Section

Add details about the configuration system:

```markdown
### Configuration System

The MVP will implement a comprehensive configuration system through `.mixdown/config.yaml`:

1. **Directory structure configuration**
   - Source directory paths
   - Artifact/output locations
   - Build storage settings
   
2. **Build lifecycle management**
   - Build pattern formatting
   - Symlink options
   - Build rotation/cleanup

3. **Naming conventions**
   - Label-based filename formatting
   - Directory path affixing options
   
4. **Tool provider configuration**
   - Plugin discovery paths
   - Tool-specific output settings
   - Type mapping (rule, command, template, etc.)
```

### 9. Update "Proposed Tasks" Section

Update to reflect both documentation and implementation progress:

```markdown
1. Core Repo & Tooling
   - **Description:** Scaffold pnpm workspace, shared TS config, linting.
   - **Status:** Complete
   - **Subtasks:**
     - [x] Initialize repo with `pnpm init` and workspaces
     - [x] Configure TypeScript base config
     - [x] Add ESLint & Prettier configs
     
2. Core Compiler Implementation
   - **Description:** Implement mix parser, AST, writer.
   - **Status:** In Progress
   - **Subtasks:**
     - [ ] XML + YAML parser to AST
     - [ ] Placeholder resolver
     - [ ] Writer with run ID & symlink setup
     
3. Documentation Structure
   - **Description:** Create comprehensive documentation framework.
   - **Status:** Substantial Progress
   - **Subtasks:**
     - [x] Establish main README with core concepts
     - [x] Define configuration documentation
     - [ ] Complete API documentation
     - [ ] Create end-user guides
```

## Implementation Notes

These changes will align the MVP documentation with the actual state of development, reflecting both the code structure and the conceptual framework that has been established in the README and configuration documentation.

The primary goals are to:

1. Ensure consistency across all project documentation
2. Reflect the current implementation state accurately
3. Incorporate the terminology and concepts that have been defined
4. Update the project structure to match the established patterns
5. Provide clear guidance on the configuration system and plugin architecture

By implementing these updates, the MVP documentation will provide a more accurate and comprehensive guide for team members working on the Mixdown project.