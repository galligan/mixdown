# Mixdown Syntax Evolution

This document details the evolution of Mixdown's syntax, explaining why certain design decisions were made and how the syntax has been refined over time.

## Introduction

Mixdown was created to solve the problem of maintaining consistent agent instructions across different AI coding tools. As the number of AI-powered coding assistants expanded (Cursor, Claude Code, Roo Code, etc.), maintaining separate instruction sets became increasingly difficult. Mixdown emerged as a **markdown-based templating language** that allows authors to create a single source of truth for instructions that can be compiled into multiple target-specific formats.

The syntax of Mixdown has undergone thoughtful evolution to prioritize:

1. **Readability**: How easy it is for humans to understand the syntax
2. **Lintability**: Whether files can pass standard markdown linters
3. **Previewability**: How well files render in standard markdown previewers
4. **Familiarity**: Leveraging similar concepts from established templating systems
5. **Extensibility**: Supporting new features without breaking existing syntax

## From XML to Braces: The Core Evolution

### The Original XML-Based Format

Mixdown initially used an XML-based syntax for sections and metadata. This approach was inspired by structured document formats but had significant drawbacks:

```xml
<mixdown version="0.1.0">
<meta>
name: my-rule
</meta>
<mix>
<instructions>
Please follow these coding standards...
</instructions>
</mix>
</mixdown>
```

**Challenges with XML Approach:**

- XML tags in markdown files violated markdown-lint rules
- Rendered poorly in markdown previewers like GitHub, VS Code, and Obsidian
- Created a steep learning curve for new users
- Required complex parsing logic to handle mixed XML/markdown content
- Caused issues with syntax highlighting in editors

### The Move to Braced Syntax

The major breakthrough was moving from XML tags to double-braced delimiters:

```markdown
---
mixdown:
  version: 0.1.0
name: my-rule
---

{{# instructions name="Rules & Instructions" export="cli" }}
Please follow these coding standards...
{{/instructions}}
```

**Advantages of Braced Syntax:**

- **100% CommonMark compliant** - renders properly in any markdown previewer
- **Lintable** - passes standard markdown linters without configuration
- **Familiar** - similar to templating systems like Handlebars and Mustache
- **Distinguishable** - clear visual separation from regular markdown content
- **Extensible** - attributes, modifiers, and parameters can be added without breaking syntax

The `{{...}}` delimiters were specifically chosen because they don't require escaping in markdown and have precedent in popular templating systems.

## Section Syntax Evolution

### Section Prefix

A key addition was the `#` prefix for sections:

```markdown
{{# section}}...{{/section}}
```

This change was implemented to:

1. Clearly distinguish sections from other braced constructs
2. Align with Markdown's existing use of `#` for headings
3. Echo similar patterns in templating systems like Handlebars
4. Provide a visual cue for the structural hierarchy of the document
5. Create clean separation in parsing logic

The space after the `#` is required to ensure consistent parsing, with robust error handling for malformed tags.

### Section Attributes

Section attributes evolved from simple key-value pairs to a rich set of modifiers and filters:

```markdown
{{# instructions 
  name="Rules & Instructions"
  export="+cursor -windsurf"
  !xml
}}
```

**Attribute Evolution:**

- Boolean flags now use `!` prefix (e.g., `!xml` instead of `no-xml`)
- Target-specific attributes use `@` notation (e.g., `name@cursor="Cursor Rules"`)
- Attribute modifiers use `:` notation (e.g., `name:h2="Rules"`)
- Filtering uses `+/-` prefix for include/exclude logic

The key design principle was to keep the attribute syntax consistent while enabling rich functionality without introducing new syntax elements.

### Self-Closing Tags

Self-closing tags were added to handle cases where sections have attributes but no content:

```markdown
{{# note id="important" name="Note" /}}
```

This syntax mimics HTML/XML self-closing tags but within the brace delimiter system.

## Embeds (fka Mixins)

The concept of "mixins" was renamed to "embeds" to better reflect their purpose and avoid confusion with CSS mixins. The syntax evolved significantly:

**Original approach:**

```markdown
$[include:my-include]
$[mix:common-rules]
```

**New syntax:**

```markdown
{{> my-partial}}
{{> mix:common-rules}}
```

**Design rationale:**

1. The `>` sigil indicates "include" (inspired by Handlebars partials)
2. Using the same brace delimiters maintains visual consistency
3. The prefix differentiates embeds from sections (`#` vs `>`)
4. Parameters follow the same attribute syntax as sections

Self-closing syntax was also added for embeds:

```markdown
{{> legal !heading /}}
```

Section embeds (embedding as a section with attributes) use a combined prefix:

```markdown
{{#> legal name="Legal Section"}}
```

## Insertions System

The insertion system underwent significant revision to unify different placeholder types under a consistent syntax:

**Original approach:**

```markdown
{@my-alias}
{=user.name}
{>my-rule|My Rule}
```

**New syntax:**

```markdown
{{ $alias }}
{{ $.data.key }}
[Link text](file.md#section)
```

### Alias Insertions

Alias insertion syntax was updated to use a `$` prefix:

```markdown
{{ $alias }}
```

This change:

1. Differentiates aliases from other insertions
2. Makes the purpose clearer ($ is commonly associated with variables)
3. Improves parsing reliability

### Data Insertions

Data insertions now use a `$.` prefix pattern:

```markdown
{{ $.user.name }}
```

The system includes:

- Caching strategy for complex data lookups
- Clear behavior for undefined references (warnings in normal mode, errors in strict mode)
- Debugging workflow via `--debug` flag showing resolution paths

### Internal Links

Perhaps the most significant change was replacing custom link syntax with standard Markdown links:

**Original:**

```markdown
{>my-rule|My Rule}
```

**New:**

```markdown
[My Rule](my-rule.md)
```

This change embraces Markdown's native features rather than creating custom syntax, improving compatibility and readability. The compiler handles link validation, cross-mix resolution, and export-aware transformations.

## Front-Matter

The transition from XML-based metadata to YAML front-matter was a significant improvement:

**Original:**

```xml
<mixdown version="0.1.0">
<meta>
name: legacy-rule
</meta>
...
</mixdown>
```

**New:**

```yaml
---
mixdown:
  version: 0.1.0
name: legacy-rule
---
```

This change aligns with ecosystem norms (Jekyll, MDX, etc.) and leverages standard YAML parsing. The front-matter also gained target-specific configuration capabilities:

```yaml
---
description: "General description"
cursor:
  description: "Cursor-specific description"
---
```

Important design decisions:

- The `+/-` shorthand syntax for filtering is NOT available in front-matter
- Target-specific keys override global values
- Explicit target specification takes precedence over target groups
- Custom keys are allowed but ignored during builds

## Target Groups

Target groups were introduced to simplify filtering for common tool categories:

```markdown
{{# instructions +@ide}}
Only visible in IDE targets.
{{/instructions}}
```

This approach allows for:

- Provider-defined groups in plugin manifests
- Project-level overrides in `.mixdown/config.yaml`
- Consistent expansion during build time

## Whitespace Handling

Explicit rules for whitespace were documented to ensure consistent parsing and output:

- A single space is required after opening tokens (`{{# ` and `{{> `)
- Attributes must be separated by spaces or newlines
- No spaces are allowed around the `=` sign in attribute declarations
- Whitespace in attribute values is preserved exactly as written
- Indentation within section content is preserved exactly as written

## Future-Focused Design

The syntax evolution also incorporated forward-looking features:

1. **Pragma directives** at file level to control parser behavior
2. **Conditional logic** for enhanced flexibility
3. **Variable filters** for simple transformations (`{{ $var | uppercase }}`)
4. **Template inheritance** for complex document composition
5. **Debug mode** with resolution tracing
6. **Plugin Target Versioning** for compatibility management

## Terminology Consistency

Careful attention was paid to terminology consistency:

- "Embed" (noun) vs. "embed" (verb) were clearly differentiated
- "name" (section identifier) vs. "heading" (rendered heading level) distinction was clarified
- "Target" replaced "tool" to avoid confusion with LLM tool concepts

## The Design Process

Throughout the evolution, the design process involved:

1. **Problem identification**: Recognizing pain points in the existing syntax
2. **Goal setting**: Establishing clear design objectives (lintability, previewability, etc.)
3. **Alternative exploration**: Considering multiple syntax approaches  
4. **Implementation testing**: Validating parser feasibility
5. **Feedback incorporation**: Refining based on user experience
6. **Documentation**: Thoroughly explaining the reasoning and usage

## Conclusion

Mixdown's syntax evolution represents a careful balance between power and simplicity. By moving from XML to braces, standardizing on familiar patterns, and embracing markdown's native features, Mixdown achieved its goal of creating a templating language that is both powerful for advanced users and approachable for newcomers.

The CommonMark-compliant approach ensures files render properly in any markdown environment while providing the rich features needed for sophisticated multi-target instruction management. This evolution positions Mixdown as a sustainable, future-proof solution for managing AI agent instructions across an expanding ecosystem of tools.

---

## Appendix: Syntax Comparison Table

| Feature | Original Syntax | Current Syntax | Rationale |
|---------|----------------|----------------|-----------|
| **Section** | `<instructions>...</instructions>` | `{{# instructions}}...{{/instructions}}` | CommonMark compliance, better rendering |
| **Metadata** | `<meta>name: value</meta>` | `---\nname: value\n---` | Standard YAML front-matter approach |
| **Include** | `$[include:my-include]` | `{{> my-partial}}` | Visual consistency, improved readability |
| **Alias** | `{@my-alias}` | `{{ $alias }}` | Unified placeholder system |
| **Data** | `{=user.name}` | `{{ $.user.name }}` | Clear data referencing pattern |
| **Link** | `{>my-rule|My Rule}` | `[My Rule](my-rule.md)` | Standard Markdown pattern |
| **Filter** | `filter="target=ide,!windsurf"` | `+@ide -windsurf` | More concise, easier to read |
| **Flags** | `no-xml` | `!xml` | Consistent with standard flag notation |

## Appendix: Key Design Decisions

1. **Braces over XML**: Makes files 100% CommonMark-compliant
2. **Section `#` prefix**: Clear identifier for structural elements
3. **Embed `>` prefix**: Distinct from sections but consistent visual language  
4. **YAML front-matter**: Standard approach across markdown ecosystem
5. **Native markdown links**: Leverage built-in markdown features
6. **Consistent attribute syntax**: Same patterns for all constructs
7. **Explicit whitespace rules**: Ensures reliable parsing
8. **Target group syntax**: Simplifies filtering for common tool categories
