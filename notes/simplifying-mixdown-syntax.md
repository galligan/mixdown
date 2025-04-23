# Goal: Simplifying Mixdown Syntax

## TODOS

## Consider

- [ ] Adding a way to filter for modes on sections

## Ambiguities to Resolve

- [ ] **Heading algorithm**
    - Need to clarify: When a file starts with `<!-- #section -->` what is the *"current heading level"*?
    - Specify whether H1 or inherited from Y‑offset
    - Clarify clamping for `h-1` at H6
    - Determine whether `h` is allowed on self‑closing sections
- [ ] **Group‑override merge semantics**
    - Clarify: In YAML overrides, do `include/exclude` apply after provider's `groups[]` expansion or replace the entire set?
    - Current documentation implies "replace" but example shows add/remove
- [ ] **Provider manifest schema**
    - Provide complete example with optional keys (`description`, `versionCompat`, etc.)
    - Help community authors avoid guesswork
- [ ] **Case‑sensitivity**
    - Specify whether target IDs, group names, and section names are always lower‑kebab
    - If so, note that linter should down‑case or error
- [ ] **Front‑matter required keys**
    - Document where provider-required keys are stored
    - Suggest location like `provider.types.rule.required_keys`
- [ ] **Heading‑level config precedence**
    - Clarify: If project config says `strict: true` but front‑matter sets `strict: false`, which wins?
    - (Usually front‑matter overrides project defaults)

### Quick wins before you cut docs

1. **Add a mini‑BNF or regex** for:  
   - section opener token  
   - attribute token (`key[@scope][=val]`)  
   - placeholder token (`{sigil …}`).

2. **Write two linter examples** covering the trickiest precedence:  
   - `xml@cursor no-xml`  
   - `export="cli" skip@cli`.

3. **Update the “state‑allowed attributes” list** or drop the bullet.

4. **Clarify merge order** (provider groups ➜ project overrides ➜ mix attributes).

Locking down these edge‑cases will make the upcoming implementation and
documentation update friction‑free.  The core design looks solid—tight,
CommonMark‑friendly, and much easier for new users to absorb.  🚀

---

## Problem

- The current syntax for Mixdown has too many moving parts.
    - `<xml>` tags
    - `<meta>` tags that take the place of frontmatter
    - `[placeholder]` tags
    - `<segment>` tags
    - `$[include]` syntax
    - `$[link]` syntax (also profiles, data)
- This complexity may be overwhelming for new users with too much cognitive overload to easily understand and write in Mixdown.

## Goals

- Simplify the syntax to make it easier to understand and write in Mixdown.
- Make it possible for the Mixdown syntax to pass a markdown lint without any errors or warnings.
- See that a Mixdown file could be previewed in GitHub or a markdown viewer without any issues.

## Proposed Solution

## New inclusions to documentation

- Values for attributes can be written without quotes (`key=value`), but if the value includes spaces, the values must be wrapped in quotes (`key="value1,value2"`).

### `tool` → `target`

The term `tool` is used frequently in the context of LLMs, but in Mixdown we've used it to mean the tool that the mix is being rendered for. This is a bit confusing, and we can simplify things by using the term `target` instead.

Targets are introduced through plugins as "target providers."

### Swap out `<section>` xml tags in favor of braced `{{section}}` tags

Using xml, sections looked like this:

```xml
<instructions>
  ...
</instructions>
```

But without code blocks wrapping the sections, this wouldn't pass a markdown lint without errors, and it might be displayed incorrectly in a markdown viewer.

By switching to double braces, we keep the file **100% CommonMark-compliant**, so it previews correctly everywhere (GitHub, VS Code, Obsidian) and passes markdown-lint. Using `{{section}}` denotes the beginning of a section, the same as XML. Anything that follows would be considered a part of that section, until the next `{{section}}` is encountered, or an `/` character is used as a prefix to close the section e.g. `{{/instructions}}`.

Self-closing sections use a trailing space and slash e.g. `{{instructions /}}` (same as XML). When a section is self-closing, all attributes must be included before the trailing slash e.g. `{{instructions title="Rules" /}}`.

Section names are derived from the string that immediately follows the opening braces `{{`, before any attributes (`key="value"`), closing braces `}}` or self-close `/}}`. You're free to use any alphanumeric or number characters, separating words with a space, `-` or `_` character. By default, these sections will be rendered in artifacts as `<section_name>...</section_name>` tags with spaces and dashes replaced with underscores, but this can be configured globally, by project, or in the mix's frontmatter.

Example:

```md
{{instructions}}
This is within the instructions section.

{{example}}
This is within the example section. Since the instructions section was not closed, the new `example` section beginning implicitly closes the previous section.
{{/example}}

{{self_closing_example /}}
This is not in any section because the previous example section was closed.
```

Which would render as:

```md
<instructions>
This is within the instructions section.
</instructions>

<example>
This is within the example section. Since the instructions section was not closed, the new `example` section beginning implicitly closes the previous section.
</example>

<self_closing_example />
This is not in any section because the previous example section was closed.
```

We can continue with the use of attributes within the section:

```md
{{instructions title="Rules"}}
This is within the instructions section.
{{/instructions}}
```

Which would render as:

```md
# Rules

This is within the instructions section.
```

By adding the `title` attribute, Mixdown will include a heading at the top of the section in the rendered artifact, which will be rendered at the correct heading level based on the surrounding content e.g. `# Instructions`. By default, the title will reflect the section's name, but it can be overridden by adding a `title="New Title"` attribute.

#### Multi-line section tags

When writing sections, you can break the opening tag onto multiple lines for readability.

```md
{{instructions
  title="Rules"
  description="These are the rules for the instructions section."
}}

Will render as:

<instructions>

But you can keep some attributes around in the XML tags by using `include-attributes`:

{{instructions
  include-attributes="title,description"
  title="Rules"
  description="These are the rules for the instructions section."
}}

Rendered as:

<instructions
  title="Rules"
  description="These are the rules for the instructions section.">
```

By default, if attributes were to be preserved in the artifact's XML tags with `include-attributes`, the multi-line formatting will be preserved for any attributes specified.

#### How section open/close works when rendered as XML tags

Automatically closing a section that has an opening but no corresponding closing tag, but rendering to include a closing XML tag, is a design choice that Mixdown makes, for simplicity.

However, if your goal is to nest sections, it's important to include closing tags, so that the inner sections are rendered correctly. For example:

```md
{{example}}
This is supposed to be an examples section.
{{example}}
This is supposed to be an example within the examples section.
{{example}}
Another example within the examples section.
```

Becomes:

```md
<example>
This is supposed to be an examples section.
</example>

<example>
This is supposed to be an example within the examples section.
</example>

<example>
Another example within the examples section.
</example>
```

This is why including closing tags is important:

```md
{{examples}}
This is supposed to be an examples section.
{{example}}
This is supposed to be an example within the examples section.
{{example}}
Another example within the examples section.
{{/examples}}

<!-- or -->

{{examples}}

This is supposed to be an examples section.
{{example}}This is supposed to be an example within the examples section.{{/example}}
{{example}}Another example within the examples section.{{/example}}

{{/examples}}
```

Gets rendered as:

```md
<examples>
This is supposed to be an examples section.

<example>
This is supposed to be an example within the examples section.
</example>

<example>
Another example within the examples section.
</example>
</examples>
```

#### Section attributes

Section attributes can be included within the section comment to control the rendering of the section.

- `name` (implied): Derived from the section's name.
- `id="section-id"` (optional): A unique identifier for the section. This can be used as a reference for includes, links, and more e.g. `{$my-mix#section-id}`.
    - IDs can contain upper or lowercase letters, numbers, and either a `-` or `_` character.
    - Using an `id` may come in handy if you want to make use of it elsewhere, and there are multiple sections with the same `name`.
    - If an `id` is not specified, the `name` will be used as the `id`.
- `title="title"` (optional): The title of the section, which will be added as a heading at the top of the section in the rendered artifact.
    - `title[?h[1-6,+,-]]`: Adding a `?h...` modifier allows for control over how the title would be rendered as a heading.
        - `title?h2="Rules"` → `## Rules`
        - `title?h+="Rules"` → `# Rules` (Using `?h+` will automatically increment the heading level e.g. if the current heading level is `h2`, the heading will be `h3`)
        - `title?h-="Rules"` → `### Rules` (Using `?h-` will automatically decrement the heading level e.g. if the current heading level is `h2`, the heading will be `h1`)
    - `title?replace="title"`: A boolean flag to replace the containing section's first heading with the title.
    - `title?replace` without a value will replace the first heading with the section's name as a heading. This is so that you don't have to specify the title if you don't need to.
- `description="description"` (optional): A description of the section, which by default will not be included in the rendered artifact's section tags.
    - You can use `include-attributes="description"` to include the description in the rendered XML tags.
- `filter="[filter-type="filter-value"]"` (optional): A comma-separated list of specific targets or target groups to include or exclude the section when rendering the mix
    - `filter="[target="ide,!windsurf"]"` → Include the section in artifacts built for members of the `ide` target group, excluding Windsurf
    - `filter="[target="cursor"]"` → Include the section in artifact built for Cursor-only
- `export="target1,!target2"` (optional): A comma-separated list of specific targets or target groups to export the section for.
    - Example: `export="cursor"` → Keep the section intact in the rendered artifacts, but exclude it for Cursor, and instead export it as a new file for Cursor.
- `format="[code|language|blockquote|normal]"` (optional): `format` declares if the section should be rendered as a code block, blockquote, or normal (default).
    - `code` or `language`: The section contents should be rendered as a code block
        - If using `code`, Mixdown will attempt to detect the language based on the section's contents.
        - Specifying with the `language` value will force the section to be rendered as a code block with the specified language.
        - If the section already contains a code block exclusively, the rendered code block's language will inherit that of the existing code block. Note: This will not render double code blocks.
    - `blockquote`: The section contents should be rendered as a blockquote.
    - `normal` (default): The section contents should be rendered as-written.
- `no-xml[="target1,target2"]`: A boolean flag to prevent the section from being wrapped in xml tags, with the option to specify which targets should not see the section rendered with xml tags.
- `include-attributes="title,filter"`: A comma-separated list of attributes to include in the rendered XML tags.
- `remove-first-heading`: A boolean flag to remove the first heading contained within the section.

**Custom attributes**:

Outside of the listed attributes, you can add any custom attributes to sections that you wish. They will be included by default in the rendered XML tags, but will not be used by Mixdown for any other purpose.

**Shortcuts for filtering targets**:

In addition to the powerful `filter` attribute, you can simply use the `@@target` alias (note the double `@`) to include or exclude (`!@target`) (note the `!@`) section-artifact rendering for specific targets or target groups. Example:

```md
{{instructions @@ide}}
This section will render for members of the `ide` target group only.
{{instructions !@ide}}
This section will render all targets except members of the `ide` target group.
{{instructions @@cli}}
This section will render for members of the `cli` target group only.
```

**Including attributes in rendered xml tags**:

By default, the attributes will not be included in the rendered XML tags. If you want to include them, you can add the `include-attributes` attribute to the section e.g. `{{instructions include-attributes}}`.

Target-specific attribute values can be specified by adding a `@` symbol following the attribute name, followed by the target name e.g. `title@cursor="Cursor Rules"`. If you want to specify multiple target-specific attribute values, you can either include the attribute-target pairs individually, or by separating targets with commas e.g. `title@cursor,roo-code="Agent Rules"`.

Example:

```md
<!-- #instructions title="Rules" title@cursor="Cursor Rules" -->
```

#### Rendering sections as XML Tags in artifacts

By default, Mixdown sections written as comments will render as corresponding xml tags in place of the comments. This can be prevented by adding the `no-xml` attribute to the section e.g. `<!-- #instructions no-xml -->`.

Example:

```md
{instructions remove-first-heading}
## Instructions
This is within the instructions section.
{/instructions}

{rules title="Rules"}
This is within the rules section.
{/rules}

{self_closing_instructions /}
```

```md
<instructions>
  This is within the instructions section.
</instructions>

## Rules
This is within the rules section.

<self_closing_instructions />
```

#### Additional notes on use of double braces vs. xml tags

- Mixing xml tags with markdown comes with some caveats:
    - As included in a markdown file, including xml tags outside of code blocks would not be considered valid markdown, and would result in a linting error.
    - When writing to a .xml file, any included Markdown will not be considered by language servers, and will not be highlighted correctly.
- Braces, on the other hand, are always valid markdown, and are always highlighted correctly by language servers (that is to say, not highlighted at all, but still valid).
    - In the future, we could consider creating a custom language server that highlights Mixdown sections so that they're more readable in a Mixdown file.
- By using double braces, and standard markdown, Mixdown files can be broadly supported in most places, and will be more readable in more tools.
    - They can also be uploaded to some tools that otherwise wouldn't support .xml or other filetypes for uploads.

### Remove the `<meta>` section, and use a standard `---` frontmatter block

The `<meta>` section was always intended to be frontmatter, so let's just lean into that. We can also include the `<mixdown>` section in the frontmatter block, so it's easier to see at a glance what version of Mixdown is being used.

Previously:

```xml
<mixdown version="0.1.0">
<meta>
name: my-rule
</meta>

<mix>

</mix>
</mixdown>
```

Now:

```md
---
mixdown:
  version: 0.1.0
name: my-rule
---
```

#### Frontmatter keys

Unless otherwise specified, all keys in the frontmatter block are considered optional. However, target providers can declare required keys, which will be enforced by Mixdown. If it's not specified below, the existing frontmatter keys in the documentation will still be used.

- `mixdown`: The version of Mixdown that was used to create the mix.
    - `version`: The version of Mixdown that was used to create the mix.
- `name`: The name of the mix. If not specified, Mixdown will derive it from the filename.
    - Names are formatted as `kebab-case` or `snake_case`, meaning all lowercase with hyphens or underscores to separate words. They may only include alphanumeric characters, numbers, and hyphens or underscores.
- `filename`: The filename of the mix. By default, the filename will be derived from the `name` key, but this can be overridden by specifying the `filename` key, and can include additional characters such as `.`, `()`, but disallows `/` or `\` characters.
- `description`: A description of the mix.
- `created`: The date the mix was created (YYYY-MM-DD[T]HH:mm:ss in UTC).
- `modified`: The date the mix was last modified (YYYY-MM-DD[T]HH:mm:ss in UTC).
    - This value is automatically updated by Mixdown when a build is run, based on the date and time of the last change to the mix.
- `targets`: A list of targets that the mix is intended for. A `!` can be used to exclude targets from the list.
    - Example: `targets: [cursor, roo-code, !windsurf]`
- `labels`: A list of labels to apply to the mix (can be used for filtering, file-naming, etc.).
- `type=[rule,command,mode,template]`: The type of artifact the mix is intended to be written as.
- `globs`: A list of globs to include in the mix.
- `alwaysApply`: Whether the target should always apply the artifact (rule).
- `aliases`: A list of aliases to apply to the mix.

Target providers can define `required_keys` and `allowed_keys` for each type of artifact. When a mix's frontmatter contains keys that are not allowed for the target's type, Mixdown will not include the key/value pair in the artifact. When a mix's frontmatter contains keys that are required for the target's type, Mixdown will throw an error if a key or value is missing.

You are free to add any key/value pairs to the frontmatter block, but they will not be included in the final artifacts.

#### Frontmatter example

```yaml
---
mixdown:
  version: 0.1.0
name: my-rule
description: A description of the mix.
targets: [cursor, roo-code]
aliases:
  important: "This is an important rule"
---
```

#### Target-specific frontmatter values

A mix's frontmatter can be adjusted for specific targets by including a key with the target name, with key/value pairs nested within.

Example:

```yaml
---
description: "This is a description of the mix"
# Rest of frontmatter
cursor:
  description: "This is a description of the mix just for Cursor"
```

### Simplifying syntax for placeholders, includes, links, data, and profiles

We'll simplify the language by referring to them all as "placeholders" and will further denote them as static (`[ brackets ]`) or dynamic (`{braces}` with a prefix word or sigil). So they're all placeholder types.

#### Placeholder Types

- `[ static_placeholder ]`: Static Placeholders use brackets and are instructions for the AI to fill in the placeholder with the requested content.
    - Important: They are **not** replaced by Mixdown, and will be rendered as-is in the final artifact.
- `{[function:]dynamic_placeholder}`: Dynamic Placeholders use braces and are replaced by Mixdown with the requested content.
    - Mixdown uses a prefix word or sigil to denote the type of placeholder, and the placeholder's name:

For braced placeholders, we use a prefix word or sigil to denote the type of placeholder which determines how Mixdown will replace the placeholder with the requested content:

- `{@my-alias}` or `{alias:my-alias}` → Alias placeholder
- `{=user.name}` or `{data:user.name}` → Data placeholder
- `{>my-rule}` or `{link:my-rule}` → Internal link placeholder

Here are a list of Mixdown placeholders and how they work:

#### Static Placeholder: AI Instructions

- **Format**: `[ placeholder ]` (no change)
- **Styling**:
    - Spacing between brackets: `[ placeholder ]` or `[placeholder]`
        - We prefer to add spaces between the brackets and the placeholder text, but it's not required.
            - This is purely a stylistic choice, and helps to further distinguish instruction placeholders from others.
    - Word separation: There are a variety of ways to separate words, which some AI models may interpret differently. It's worth experimenting with different approaches to see which one works for you.
        - `[ separating with spaces ]`
        - `[ separating-with-dashes ]`
        - `[ separating_with_underscores ]`
    - Attributes: `[ placeholder attribute="value" ]`
        - You can include some key/value attributes e.g. `[ current time format="HH:mm" ]` which should help the AI understand the context of the placeholder better. Also worth experimenting with this one.

#### Dynamic Placeholder: Alias

- **Format**: `{@my-alias}`
    - **Previous syntax**: `$[alias:my-alias]`
- **Built-in aliases**: `{@built-in-alias}` or `@built-in-alias` when including in attributes
    - `{@target}`: The target the mix is rendered for e.g. `cursor, roo-code, windsurf` (When the target is a group, the aliases are rendered as their member targets individually)
    - `{@target.name}`: The name of the target the mix is rendered for e.g. `Cursor, Roo Code, Windsurf`
- **Behavior**:
    - The alias is replaced by Mixdown, which will look for the corresponding alias value in a specific order of precedence:
        - The mix's frontmatter under the `aliases` key
        - The private project aliases in `prompts/data/.aliases.private.yaml`
        - The project aliases in `prompts/data/aliases.yaml`
        - The global aliases in `.config/mixdown/aliases.yaml`
- **Important**: Aliases can not be used to define section names.

#### Dynamic Placeholder: Data

- These use serialized data from `.yaml` files in the `prompts/data` directory. The first part of the path in the placeholder is the filename without the `.yaml` extension e.g. `{=user.name}` refers to `prompts/data/user.yaml`
- `$[profile:user.name]` → `{=user.name}`

#### Dynamic Placeholder: Internal link

- **Format**: `{>...}`
    - **Previous syntax**: `$[link:my-rule]`
- **Options**:
    - Section link: You can include a specific section from within the source file by adding a `#` character after the link e.g. `{>my-rule#my-section}`
    - Alias: You can add an alias with a `|` pipe after the link e.g. `{>my-rule|My Rule}`
- **Behavior**:
    - Links point to mixes (or sections within mixes) within the Mixdown directory e.g. `{>my-rule}` → `/prompts/instructions/my-rule.md`
    - If a link points to a section that is [exported for a target](#section-attributes), the link will be rendered to point to the section's export artifact for the target.

Here's how section links work, when they're being exported for a specific target:

```md
<!-- my-rule.md -->
# My Rule

<!-- #core-rules export="cursor" -->
This is a section.
<!-- core-rules# -->
```

Above you see `my-rule.md` with a section called `core-rules` which is to be exported to another file for Cursor. Let's write a link to it:

```md
<!-- agent-instructions.md -->
# Agent Instructions

- See the rules here: {>my-rule#core-rules}
```

This would be rendered for Cursor differently than it would be rendered for other targets.

```md
<!-- .cursor/rules/agent-instructions.md -->
# Agent Instructions

- See the rules here: [Core Rules](mdc:core-rules.mdc)

<!-- .roo/rules/agent-instructions.md -->
# Agent Instructions

- See the rules here: [Core Rules](agent-instructions.md#core-rules)
```

Notice that the link being rendered for Cursor points to `mdc:core-rules.mdc`, where Roo Code points to `agent-instructions.md#core-rules`? That's because the `core-rules` section was exported specifically for Cursor, which moved it out of the `my-rule.mdc` file and into `-core-rules.mdc` specifically for Cursor. For Roo Code, the section appears as-is within the `agent-instructions.md` file.

### Embedding content within a mix

Previously the `$[include[:mix|template]]` syntax was used to embed an include, mix, or template file inline into a mix. However, this could have created some issues, especially if the include was not on a new line.

Instead, we'll use sections, and add the `$` sigil after the opening braces to denote an "embed."

- `{{$my-include}}` → Embed an include as a section
    - Note: Since the purpose of an include is to be embedded, they don't require a `prefix:` key.
- `{{$mix:my-mix}}` → Embed an existing mix as a new section
- `{{$template:my-template}}` → Embed a template as a new section

#### Using attributes with embeds

All section attributes are supported with embeds. Some of them, like `format="[code|language|blockquote|normal]"` might be particularly useful here.

Embed-specific attributes are:

- `as="alternate-name"`: This allows you to give the embed an alternate name from the source file when rendered in the mix.
- `no-title`: A boolean flag to exclude the title of the included file from being rendered in the mix, regardless of whether the source has a defined title.
- `no-embeds`: A boolean flag to exclude embeds within the source file from being rendered in the mix.
- `include-frontmatter`: A boolean flag to include the frontmatter of the included file in the imported content. By default, the frontmatter is not included.
- `alias-from="source|current"`: This instructs Mixdown which frontmatter-based aliases to use when rendering the embed.
    - `source`: Use the aliases from the source file being embedded.
    - `current`: Use the aliases from the current file that's receiving the embed.
- `sections="section1,!section2"`: A comma-separated list of sections contained in the source file to include or exclude from the embed. By default all sections are included.

## Advanced Uses

- Mixdown will attempt to replace all dynamic placeholders, including those in code blocks.
    - If you want Mixdown to render dynamic placeholders as-is, you can prefix them with a single backslash `\` e.g. `\{$my-insert}`.

## Clarifications

### Attribute-parsing

- Flags are introduced for attributes, in both sections and placeholders.
    - Attributes that are used without an `=` sign are flags e.g. `no-xml`
    - Flags are always boolean, defaulting to `true`.
    - Available flags:
        - `no-xml`: Don't render the section as XML tags in the artifact
        - `export`: Export the section for the given target
- Scopes are introduced for attributes, denoted with the `@` symbol e.g. `title@cursor="Cursor Title"`
    - Scopes are used to specify which targets or target groups should be used for the attribute.
    - They should only be used for attributes that contain a `="value"`.
        - ✅ Valid: `export="cursor"`
        - ❌ Invalid: `export@cursor`
    - Scope precedence:
        - When a target-specific attribute is used, it will override the default attribute value, regardless of the order of the attributes for the section.
        - When a target, target groups, etc. are specified together for the same attribute, they will take the following order of precedence:
            - `key@target="value"` (specifically named target e.g. `key@cursor="value"`) > `key@target-group="value"` (e.g. `key@ide="value"`) > `key="value"` (e.g. `key="value"`)
- Key-value pairs for attributes use the `=` sign and should be followed by a quoted string if the value includes spaces e.g. `title="My Title"`
    - Some attributes, such as `title` support modifiers with the `?` symbol e.g. `title?h2="My Title"`


Examples:

```txt
no-xml                      # No XML tags included in the artifact
no-xml="ide"                # No XML tags on IDE targets
title="Rules"               # Heading in all targets
title@cli="CLI Rules"       # Override just for CLI targets
```

## New Concepts

### Heading Levels

Heading levels are a way to control the heading level of a section. The default behavior for heading use can be configured in the `.mixdown/config.yaml` file.

```yaml
mixdown:
  headings:
    default: 2 # default heading level `h2` as a number
    reserve_h1: true # whether to reserve `h1` for the title of the mix
    strict: true # whether to enforce the heading level hierarchy
    case: "title" # "title" | "sentence" | "lower" | "upper"
    break_after: true # whether to break after headings
    range:
      min: 2 # minimum heading level
      max: 6 # maximum heading level
```

These values can be overridden in the frontmatter of a mix.

```yaml
---
# frontmatter
heading_level:
  reserve_h1: false
  strict: false
  range:
    min: 1
    max: 6
# rest of frontmatter
---
```

### Target Groups

Target groups are a way to associate multiple targets with a single identifier. This can be handy to use in place of referencing each target individually in attributes, conditionals, and more.

#### Default Target Groups

The following target groups are available by default:

| Group               | Members (example)     | Note |
|---------------------|-----------------------|------|
| `ide`               | cursor, windsurf, zed | Graphical editors / IDEs |
| `vs-code-fork`      | cursor, windsurf      | Sub‑set of IDE tools that are forks of VS Code |
| `vs-code-extension` | roo-code, cline       | VS Code extensions |
| `cli`               | aider, claude-code    | Terminal‑centric tools |
| `desktop`           | cursor, vs‑code       | Native desktop apps |
| `mobile`            | *none by default*     | Populated when mobile targets ship |
| `cloud`             | *none by default*     | For future SaaS builders |
| `all`               | *wildcard* (`*`)      | Every registered target; no need to declare |

#### Target Groups from Mixdown Providers

Mixdown plugins declare their own groups, so new targets join the correct bucket automatically:

Example:

```json
// node‑module: @mixdown/target-cursor/mixdown-provider.json
{
  "id": "cursor",
  "name": "Cursor",
  "groups": ["ide", "vscode", "agent", "desktop"],
  "types": {
    "rule": {
      "dir": ".cursor/rules",
      "ext": ".mdc",
      "allowed_keys": ["description", "globs", "alwaysApply"],
      "required_keys": ["description", "globs", "alwaysApply"]
    },
  }
}
```

#### Target Groups in `.mixdown/config.yaml`

Project‐level overrides in `.mixdown/config.yaml` **replace** provider defaults (they don’t merge). Target group names are expanded before being used for builds.

In the event that a target provider introduces a new named target group, subsequent plugins introducing targets with the same name will see the group's members together.

```yaml
# ---------- Target Groups (and overrides) ----------------------------
target-groups:
  # Adding a new target group
  core:
    include: [cursor, roo-code]

  # Replacing default target group members
  ide:
    include: [zed]
    exclude: [windsurf]
```

#### Impact on mix files

```md
<!-- #rules export="cli" xml@ide -->
<!-- #docs skip="desktop" -->
<!-- %if tool in vs-code % -->
```

## Future

- Plugins should be able to include versions of their own targets in the manifest .json files, so that Mixdown behavior can be consistent across versions.