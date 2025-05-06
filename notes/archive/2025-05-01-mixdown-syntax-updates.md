# 2025-05-01: Mixdown Syntax Updates

## XML tags

- For easier onboarding to Mixdown, XML tags could be supported out of the box.
- There could also be a CLI flag for preprocessing XML files into Mixdown.
- Documentation should note that using XML tags in Mixdown files mean they're not CommonMark compliant, and probably wouldn't be rendered correctly in most Markdown editors.

## Language

- `includes` -> `partials`
- `mixin` -> embed

## Global changes

- Prefixing any `{{ <content> }}` with `\` will render the braces and braced text as-is
    - This might be useful if you want to explicitly define Mixdown-formatted content
- Removing `alias-from` as an attribute

## Considerations

- We'll probably need to include some things in the global config, as well as front-matter configuration (and probably as a CLI flag)
    - `[!]render-tags` would be a boolean to toggle rendering of XML tags based on sections

## Sections

**Current syntax:**

```markdown
{{instructions heading="Rules" export="cli"}}
Please follow these coding standards...
{{/instructions}}
```

**Updated syntax:**

```markdown
{{# instructions name="Rules & Instructions" export="cli" }}
Please follow these coding standards...
{{/instructions}}
```

The string that immediately follows the `#` sigil and space would be the name of the section.

**Reasoning:**

- Adding the `#` prefix to the section tag makes it easier to identify Mixdown sections.
- `#` also happens to be the "header" syntax in Markdown, both for headings and links to sections.
- The `{{# section }}` format takes inspiration from the `{{#helper}}` tags that are used in Handlebars.

### Section Naming (new)

- In lieu of requiring writing something like `{{# instructions name="Core Instructions"}}`, you can just write `{{# "Core Instructions" }}`.
    - This does double-duty as including the section heading in the rendered artifact, without requiring any additional syntax.

### Section Attributes

- Inclusion/exclusion notation: `[+|-][*|target]`
    - Notes:
        - `[+|-]` -> include/exclude
        - `*` -> include/exclude for all targets
        - `target` -> target name
        - target values can be a comma-separated list of target names e.g. `+cursor,windsurf`
    - Filter targets: `[+|-][*|target]`
        - `filter="target=ide, !windsurf"` -> `+ide -windsurf`
        - `+target` -> include for the target only
        - `-target` -> exclude for the target only
        - `+cursor -*` -> include for cursor, exclude for all other targets
    - Target-specific overrides:
        - `key@<target>` -> `key[+|-][*|target]`
        - `key+target` -> include key/value for target
        - `key-target` -> exclude key/value for target
        - `key+*` -> include key/value for all targets
        - `key-*` -> exclude key/value for all targets
        - `key-* key+target` -> exclude all targets except the specified target
    - Filter/override ordering:
        - Target-specific overrides take precedence over target groups
            - e.g. `+ide -cursor` -> include for ide, exclude for cursor
        - When multiple target groups are specified, the precedence is left-to-right
        - e.g. `+ide -vs-code-fork` -> include for ides, exclude for vs-code-forks
- Headings
    - `no-heading` -> `!heading` (to suppress the top heading of the embedded content)
    - `{{# section-name heading !wrap }}` -> Includes the `section-name` as a heading 
    - `heading?h2="Rules"` -> `name heading?h2="Rules"` (to set the heading level of the embedded content)
        - `heading?h[+|-]` -> `name heading:[increment|decrement]` (to increment or decrement the heading level of the embedded content)
        - `heading?replace="Rules"` -> `name heading:replace="Rules"` (to replace the heading of the embedded content with the value of `heading`)

## Embeds (fka Mixins)

**Current syntax:**

```markdown
{{$include:my-include}}
{{$mix:my-mix}}
```

**Updated syntax:**

- `{{> my-partial }}`: Embed a partial (previously known as `includes`)
    - Partial files are located in `prompts/partials`
    - While partials can have frontmatter, it's not required.
- Embeds can be set up as a section by prefixing the `>` with `#` e.g. `{{#> my-partial }}`.
    - Adding `#` also allows for section attributes to be set for the embed.
- `{{> #section-name }}`: Embed a section already defined in the current mix.
    - We're using `#` with no preceding space to indicate that this is a section reference.
- `{{> mix:my-mix }}`: Embed a mix.
    - `{{> mix:my-mix#my-section }}`: Embed a specific section from a mix.
- `{{> template:my-template }}`: Embed a template from `prompts/templates`

**Other changes:**

- `no-heading` -> `!heading` (to suppress the top heading of the embedded content)
- `no-mixins` -> `!embeds` (strip nested embeds from the embedded content)
- `as="alternate-name"` -> `name="alternate-name"` (Rename the embedded section name on render)
- Removing these attributes:
    - `include-frontmatter`

**Reasoning:**

- Mixins create distinct sections in the output
- The `>` sigil is used in Handlebars to embed a partial.

## Insertions (fka Dynamic Placeholders)

**Current syntax:**

- `{=my-data}`: Insert data

**Updated syntax:**

- We'll use `{{ $.file.key }}` to insert values corresponding to the referenced key.
- Data from the current file's front-matter is available as `{{ $.file.key }}`.
- Another approach would be to use `{{ $.frontmatter.key }}` instead of `{{ $.file.key }}`
    - This would allow for embedded mixes to use the embedding mix's front-matter data instead of the original mix's.
    - This means that when working within a mix, `.frontmatter` is the same as `.file`
- Default data files (`[user|project|org].yaml`) are located in `prompts/data`
- Custom YAML data files located in `prompts/data` can be referenced by file name e.g. `{{ $.filename.key }}`.

### Alias Insertions

**Current syntax:**

- `{@my-alias}`: Insert an alias

**Updated:**

- No longer treating `alias` as a specific placeholder type.
- Instead, we'll use `{{ $my-alias }}` which will pull from the `prompts/data/alias.yaml` file.
    - Note that with aliases, the `.` prefix is not required, but `{{ $.alias.key }}` is also supported.

## Internal Links

**Current syntax:**

```markdown
{>my-rule|My Rule}
```

**Updated syntax:**

```markdown
[My Rule](my-rule.md)
```

Internal links to rules should use standard Markdown links. Relative paths within the `/prompts` directory are supported, and will render to the appropriate path.

Links to other files within the project are also supported but should be written as absolute paths. They should start with `//` to indicate the root of the project. They will be rendered as links relative to the artifact's location in the project.

```markdown
[My Rule](//src/example.test.ts)
```

To use attributes in links, they have a slightly different format using a `/` prefix for relative paths, or `//` for absolute paths:

```markdown
{{ /my-rule.md alias="My Rule" key="value" }}
{{ //src/example.test.ts alias="Example Test" key="value" }}
```
