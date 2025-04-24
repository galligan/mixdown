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

<sub>Table 1: Core syntax elements in Mixdown</sub>

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

## Tips for AI Agents

- Use section attributes to control visibility and presentation per target
- Placeholders are resolved in this order: aliases → data → environment → runtime
- Internal links automatically adjust paths based on the target's artifact structure
- Mix files should pass standard markdown-lint without exceptions
