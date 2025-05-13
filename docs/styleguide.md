# Mixdown Language Styleguide

This document provides terminology guidance for consistent language in Mixdown documentation, code, and community communication.

## Key Terminology

| Term | Definition | Usage Examples |
|------|------------|----------------|
| **Mix** | Source instruction files, written in Mixdown Syntax | "Write your code standards in a mix file." |
| **Record** | Target-specific output files generated from mixes | "Compile your mixes into records for each tool." |
| **Target** | A supported tool (e.g., Cursor, Claude Code) | "Each target has specific formatting requirements." |
| **Tag** | Syntax element using `{{...}}` notation | "Use tags to direct the compiler." |
| **Section** | Delimited blocks marked with `{{tag}}...{{/tag}}` | "Define a section for agent instructions." |
| **Remix** | A reference to another mix file or section | "Remix common guidelines into multiple files." |
| **Insertion** | Dynamic values replaced at build time | "Use insertions to include variable data." |
| **Stem** | Modular content component stored in `/_stems` | "Mix in commonly used content as stems." |

## Linguistic Conventions

### General Principles
- Prefer clear, specific terminology over vague descriptions
- Be consistent with capitalization and hyphenation
- Use declarative present tense when describing functionality

### Specific Terminology Patterns

#### Compilation Process
- ✅ "Compile mixes into records"
- ✅ "Generate tool-specific outputs"
- ✅ "Transform mix into target-specific records"
- ❌ "Render artifacts" (outdated)

#### Record Generation
- ✅ "Output" (as a noun for the compilation result)
- ✅ "Records are written to their respective locations"
- ✅ "The mix file is transformed into records"
- ❌ "The rendered artifact" (outdated)

#### Content Display
- ✅ "Formatted as" (when describing how content appears)
- ✅ "Displayed as" (for visual presentation)
- ✅ "Converted to" (for transformation descriptions) 
- ❌ "Rendered as" (avoid when possible)

#### XML Generation
- ✅ "Converted to XML tags"
- ✅ "Transformed into XML structure"
- ✅ "Outputs XML notation"
- ❌ "Renders as XML" (outdated)

## File and Directory Naming

| Entity Type | Naming Convention | Example |
|-------------|-------------------|---------|
| Mix files | `kebab-case.md` | `coding-standards.md` |
| Directory | `kebab-case` | `_samples` |
| Config files | `kebab-case.config.json` | `mixdown.config.json` |
| Section names | `kebab-case` | `{{user-instructions}}` |
| XML output tags | `snake_case` | `<user_instructions>` |

## Musical Theme Alignment

Mixdown uses audio production terminology to reinforce its brand identity:

| Term | Audio Meaning | Mixdown Meaning |
|------|--------------|-----------------|
| **Mix** | Source audio tracks | Source instruction file |
| **Mixdown** | Process of combining audio | Process of compiling instructions |
| **Record** | Final audio product | Final compiled output |
| **Track** | Individual audio component | Individual section in a mix |
| **Stem** | Isolated, reusable track | Modular, reusable content component |

## Markdown Formatting

- Use ATX-style headers (`#` syntax) 
- Triple backticks for code blocks with language identifiers
- Use bullet lists for collections of related items
- Use numbered lists for sequential steps
- Prefer tables for structured data comparison

## Version References

When referring to versions:
- Full version format: "Mixdown v0.1.0"
- Major version format: "Mixdown v0"
- Release candidate format: "Mixdown v0.1.0-rc1"

## Best Practices

- Be consistent with terminology across all documentation
- Align new terminology with the music production theme
- When new terms are introduced, add them to this styleguide
- Prefer clarity over cleverness in technical documentation
- Use examples liberally to illustrate abstract concepts

---

*This styleguide is a living document and will evolve with Mixdown's development.*