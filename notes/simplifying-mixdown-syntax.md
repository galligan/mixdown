# Goal: Simplifying Mixdown Syntax

## TODOS

## Ambiguities to Resolve

- [ ] **`xml` vs `no‑xml` flags**
  - Default is "XML on"
  - Need to decide: What happens if a user writes both `xml@ide` and `no‑xml` on the same opener?
  - Pick one rule: "last token wins" or "emit lint error"
- [ ] **Flag negation** (`no‑xml`, `skip`, `export`)
  - Need to decide: Do we permit `!` shorthand (`!xml`) or is the negative form always `no‑key`?
  - Document under *Attribute‑parsing → Flags*
- [ ] **Heading algorithm**
  - Need to clarify: When a file starts with `<!-- #section -->` what is the *"current heading level"*?
  - Specify whether H1 or inherited from Y‑offset
  - Clarify clamping for `h-1` at H6
  - Determine whether `h` is allowed on self‑closing sections
- [ ] **Attribute precedence**
  - Need to document precedence for flags (not just key/value overrides)
  - Example: `no-xml@cli xml` – which wins?
- [ ] **Self‑closing sections + export/skip**
  - For tags like `<!-- #log# export="cli" -->`, should Mixdown:
    1. Create a separate file for each CLI target and keep nothing inline, or
    2. Ignore `export` because it's self‑closing?
- [ ] **Switch vs future `%if`**
  - The `% switch %` block currently has no inline attribute syntax
  - Decide if `<!-- % switch target="cursor" % -->` will be allowed
  - If not, document "attributes not allowed on switch comments" for linters
- [ ] **Placeholder grammar escape**
  - Document how to write a literal `{!example}` in prose
  - Options: `\{!example\}` or wrap in back‑ticks
  - Add to *Attributes in placeholders* section
- [ ] **Group‑override merge semantics**
  - Clarify: In YAML overrides, do `include/exclude` apply after provider's `groups[]` expansion or replace the entire set?
  - Current documentation implies "replace" but example shows add/remove
- [ ] **Provider manifest schema**
  - Provide complete example with optional keys (`description`, `versionCompat`, etc.)
  - Help community authors avoid guesswork
- [ ] **Allowed attribute list**
  - Complete the "state‑allowed attributes are:" section
  - Either enumerate all attributes or link to a comprehensive table
- [ ] **Import syntax**
  - Clarify that in block‑quote imports:
    - First line declares **kind + attrs** (`[!mix]`)
    - Second line is the **source placeholder** (`{!my-mix}`)
    - Document that `mixdown fmt` will enforce this structure
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
   * section opener token  
   * attribute token (`key[@scope][=val]`)  
   * placeholder token (`{sigil …}`).

2. **Write two linter examples** covering the trickiest precedence:  
   * `xml@cursor no-xml`  
   * `export="cli" skip@cli`.

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

### `tool` → `target`

The term `tool` is used frequently in the context of LLMs, but in Mixdown we've used it to mean the tool that the mix is being rendered for. This is a bit confusing, and we can simplify things by using the term `target` instead.

Targets are introduced through plugins as "target providers."

### Swap out `<section>` xml tags in favor of `<!-- section -->` comments

Using xml, sections looked like this:

```xml
<instructions>
  ...
</instructions>
```

But without code blocks wrapping the sections, this wouldn't pass a markdown lint without errors, and it might be displayed incorrectly in a markdown viewer.

By switching to HTML comments, we keep the file **100% CommonMark-compliant**, so it previews correctly everywhere (GitHub, VS Code, Obsidian) and passes markdown-lint. To distinguish between run-of-the-mill comments and Mixdown sections, we can use the `#` character to denote a Mixdown section. Using `#` as a prefix indicates the start of a section. Anything that follows would be considered a part of that section, until the next `<!-- #section -->` comment is encountered, or an `#` character is used as a suffix to close the section e.g. `<!-- instructions# -->`.

Self-closing sections are supported by including the `#` character as both a prefix and suffix e.g. `<!-- #instructions# -->`. Note that when a section is self-closing, all attributes must be included within the section comment e.g. `<!-- #instructions title="Rules" -->`.

Section names are derived from the string that immediately follows the `#` symbol, before the first whitespace character or closing `#` symbol. For this reason, they must only include alphanumeric characters, numbers, and either a `-` or `_` character, but no other characters.

Example:

```md
<!-- #instructions -->
This is within the instructions section.

<!-- #example -->
This is within the example section. Since the instructions section was not closed, the new `#example` section beginning implicitly closes the previous section.
<!-- example# -->

<!-- #self_closing_example# -->
This is not in any section because the previous example section was closed with `example#`.
```

We can continue with the use of attributes within the comments:

```md
<!-- #instructions title="Rules" -->
This is within the instructions section.
```

Which would render as:

```md
# Rules

This is within the instructions section.
```

By adding the `title` attribute, Mixdown will include a heading at the top of the section, which will be rendered at the correct heading level based on the surrounding content e.g. `# Instructions`. By default, the title will reflect the section's name, but it can be overridden by adding a `title="New Title"` attribute.

If greater control over the heading level is desired, it can also be specified:

- `title="Rules" h2` → `## Rules`
- `title="Rules" h+1` → `# Rules` (Using `h+1` will automatically increase the heading level by one from the current heading level e.g. if the current heading level is `h2`, the heading will be `h1`)
- `title="Rules" h-1` → `### Rules` (Using `h-1` will automatically decrease the heading level by one from the current heading level e.g. if the current heading level is `h2`, the heading will be `h3`)

Final notes:

The `#` symbol was used to define sections separately from comments, to make sure that Mixdown can properly parse them. Further, the closing `section#` syntax was used to not introduce any extra characters into the section names, keeping the start/end consistent.

#### Including attributes in sections

Attributes can be included within the section comment to control the rendering of the section.

- `name` (implied): The name of the section, which will be derived from the section's `#name` comment.
  - The string that immediately follows the `#` symbol, before the first whitespace character or closing `#` symbol.
- `id` (optional): A unique identifier for the section. This can be used as a reference for includes, links, and more e.g. `{!my-mix#section-id}`.
  - IDs can contain upper or lowercase letters, numbers, and either a `-` or `_` character.
  - Using an `id` may come in handy if you want to make use of it elsewhere, and there are multiple sections with the same `name`.
  - If an `id` is not specified, the `name` will be used as the `id`.
- `title`: The title of the section.
- `export`: A comma-separated list of target names to export the section for.
  - Note: When included in a self-closing section tag, export will not be applied.
- `skip`: A comma-separated list of target names to skip the section for.
- `only`: A comma-separated list of target names to only render the section for.
- `ignore-first-header`: A boolean flag to prevent the first heading within the section from being rendered.
  - This option is provided so that the `<mixdown-name>.md` file can still have a heading when rendered in a markdown viewer.
- `no-xml`: A boolean flag to prevent the section from being rendered as XML tags in the artifact.
- `xml-attr`: A list of attributes to include within the xml tags e.g. `xml-attr="title,description"` which would render as `<instructions title="Rules" description="Rules for Cursor">`.

Target-specific attribute values can be specified by adding a `@` symbol following the attribute name, followed by the target name e.g. `title@cursor="Cursor Rules"`. If you want to specify multiple target-specific attribute values, you can either include the attribute-target pairs individually, or by separating targets with commas e.g. `title@cursor,roo-code="Agent Rules"`.

Example:

```md
<!-- #instructions title="Rules" title@cursor="Cursor Rules" -->
```

#### Rendering sections as XML Tags in artifacts

By default, Mixdown sections written as comments will render as corresponding xml tags in place of the comments. This can be prevented by adding the `no-xml` attribute to the section e.g. `<!-- #instructions no-xml -->`.

Example:

```md
<!-- #instructions ignore-first-header -->
## Instructions
This is within the instructions section.
<!-- instructions# -->

<!-- #rules no-xml title -->
This is within the rules section.
<!-- rules# -->

<!-- #self_closing_instructions# -->
```

```md
<instructions>
  This is within the instructions section.
</instructions>

# Rules
This is within the rules section.

<self_closing_instructions />
```

We can also specify which targets should not see the xml tags by adding the targets as the value to the `no-xml` attribute e.g. `no-xml="cursor,roo-code"`.

### Replace `<segment>` tags by adding `export` attribute and folding into `<!-- #section -->` comments

#### Exporting a section

The `<segment>` tag was used to add target-specific instructions to a mix, which would be written to the declared target's instruction file. Instead, we'll use `<!-- #section export="cursor,roo-code" -->` to conditionally include content based on the target.

Example:

```md
<!-- #instructions export="cursor,roo-code" -->
This is within the instructions section.
<!-- instructions# -->
```

#### Changes from `<segment>` tag

- `<segment>` no longer exists, replaced by improvements to sections.
- The `name` attribute no longer applies, and is inherited by the section's name.

#### Additional notes on use of comments vs. xml tags

- Mixing xml tags with markdown comes with some caveats:
  - As included in a markdown file, including xml tags outside of code blocks would not be considered valid markdown, and would result in a linting error.
  - When writing to a .xml file, any included Markdown will not be considered by language servers, and will not be highlighted correctly.
- Comments, on the other hand, are always valid markdown, and are always highlighted correctly by language servers (that is to say, not highlighted at all, but still valid).
  - In the future, we could consider creating a custom language server that highlights Mixdown section comments so that they're more readable in a Mixdown file.
- By using comments, and standard markdown, Mixdown files can be broadly supported in most places, and will be more readable in more tools.
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

Target providers can define `required_keys` and `allowed_keys` for each type of artifact. When a mix's frontmatter contains keys that are not allowed for the target's type, Mixdown will not include the key/value pair in the artifact. When a mix's frontmatter contains keys that are required for the target's type, Mixdown will throw an error if a key or value is missing.

#### Frontmatter example

```yaml
---
mixdown:
  version: 0.1.0
name: my-rule
description: A description of the mix.
targets: [cursor, roo-code]
---
```

### Swapping out `<override>` tags for special `<!-- % switch % -->` conditional comments

The `<override>` tag was used to add target-specific instructions to a mix, which would be written to the declared target's instruction file. Instead, we'll use `<!-- % switch % -->` to conditionally include content based on the target specified. The `% switch %` tag in this case acts like an if-switch statement, and requires that cases are specified within the tag, closing with `% endswitch %`.

Note: While switches use the same comment-based syntax as sections, they are not themselves sections. If you want to define a section with a switch, you'll want to wrap the switch in a section comment e.g.:

```md
<!-- #section -->
<!-- % switch % -->
...
<!-- % endswitch % -->
<!-- section# -->
```

Currently, the only cases supported are:

- `target` (can be used for both specific targets and target groups)
- `type` (can be used to switch content based on the artifact type)

Target Example:

```md
<!-- % switch % -->
This is the default content.
<!-- % target ide % -->
This is only rendered for targets in the `ide` target group.
<!-- % target cursor % -->
This is only rendered for Cursor.
<!-- % target roo-code % -->
This is only rendered for Roo Code.
<!-- % endswitch % -->
```

Type Example:

```md
<!-- % switch % -->
This is the default content.
<!-- % type rule % -->
This is only rendered for rules.
<!-- % type command % -->
This is only rendered for commands.
<!-- % endswitch % -->
```

In the above examples, the order of rendering is based on the order of the targets specified in the `% switch %` tag, from first to last.

#### Future: `<!-- %if -->` for more complex conditionals

- `<!-- % if [condition] % -->`
  - `<!-- % elif [condition] % -->`
  - `<!-- % else % -->`
  - `<!-- % endif % -->`

### Simplifying syntax for placeholders, includes, links, data, and profiles

We'll simplify the language by referring to them all as "placeholders" and will further denote them with braces, brackets, and sigil use. So they're all placeholder types, and `includes` are a specific type of placeholder now.

#### Placeholder types

- Instruction placeholders:
  - `[placeholder]`: "instruction placeholder" which is the current syntax, and will continue to use the `[ ]` brackets
  - These can contain key/value attributes e.g. `[current time format="HH:mm"]` which would serve as instructions for the AI to fill in the placeholder with the current time in the format `HH:mm`. Results are not guaranteed to be in the requested format, but with nicely formatted attributes in placeholders, it should have enough context to try.
- Include placeholders (`{!...}`):
  - `$[include:my-include]` → `{!my-include}`
  - We can also include a `#` character to include a specific section from an include file e.g. `{!my-include#my-section}`
- Internal link placeholders (`{>...}`):
  - `{>my-rule}` → `$[link:my-rule]`
  - You can alias the link text by adding a `|` pipe and the alias text e.g. `{>my-rule|My Rule}`
- Data placeholders (`{=...}`):
  - These use serialized data from `.yaml` files in the `prompts/data` directory. The first part of the path in the placeholder is the filename without the `.yaml` extension e.g. `{=user.name}` refers to `prompts/data/user.yaml`
  - `$[profile:user.name]` → `{=user.name}`
- Aliases previously denoted as `$[alias:]` now uses the `@` sigil e.g. `{@my-alias}`. They are defined in a special `aliases.yaml` file in `prompts/data` by default.
  - Private aliases can also be defined by maintaining a `prompts/data/.aliases.private.yaml` file in the root of the project (note the leading `.` dot in the filename). They can be used by using a dot after the `@` sigil e.g. `{@.my-private-alias}`

#### Sigil usage in placeholders

- `[...]` → Instruction placeholder
- `{!...}` → Include placeholder
- `{>...}` → Internal link placeholder
- `{=...}` → Data placeholder
- `{@...}` → Alias placeholder

#### Attributes in placeholders

- `recursive`: A boolean flag to include includes from the sources of the including mix e.g. `{!my-include#my-rule recursive}`
  - Optionally, a numeric value can be added to limit the depth of recursion e.g. `{!my-include#my-rule recursive=2}`
  - Any includes that might result in a loop will be skipped, and a warning will be logged.
- `as-code-block="language"`: A boolean flag to render the included content as a code block e.g. `{!my-include as-code-block="yaml"}`

### Imports: Separating `mix` and `template` as options from inline include placeholders

Previously the `$[include[:mix|template]]` syntax was used to include a mix or template file. However, this could have created some issues, especially if the include was not on a new line. Despite using the `> ` blockquote syntax, these will not be rendered as a blockquote unless the attribute `as-blockquote` is used.

Instead, we'll use an admonition/callout-like syntax using a blockquote to include a mix, template, or include file. These are called "imports" in Mixdown. Note that includes are available for inline inclusion, but mixes and templates are not. Since it can be guaranteed that 

```md
<!-- Import a mix -->
> [!mix]
> {!my-mix}

<!-- Import a mix with a specific section -->
> [!mix]
> {!my-mix#my-section}

<!-- Import a template -->
> [!template]
> {!my-template}

<!-- Import an include -->
> [!include]
> {!my-include}
```

#### Attributes in inline includes

- `recursive`: The same as the `recursive` attribute in include placeholders.
- `as="[code|language|blockquote]"`: Renders the included content as a code block, blockquote, or language-specific code block.
  - `as="blockquote"` can be used to render the included content as a blockquote.
  - `as="code"` can be used to render the included content as a code block, with language detection attempted, falling back to `text` if none is detected.
- `include-frontmatter`: A boolean flag to include the frontmatter of the included file in the imported content. Only renders if `as="[code|language]"` is also used.
- `include-title`: A boolean flag to include the title of the included file in the imported content as a heading.
- `section[="attributes"]`: A boolean flag to include the import as a new section, with the given attributes.

## Clarifications

### Attribute-parsing

- Flags are introduced for attributes, in both sections and placeholders.
  - Attributes that are used without an `=` sign are flags e.g. `xml`
  - Flags are always boolean, defaulting to `true`.
  - Flags can be used in place of a key-value pair for attributes e.g. `xml` is equivalent to `xml="true"`
  - Available flags:
    - `no-xml`: Don't render the section as XML tags in the artifact
    - `export`: Export the section for the given target
    - `skip`: Skip the section for the given target
    - `only`: Only render the section for the given target
- Scopes are introduced for attributes, denoted with the `@` symbol e.g. `title@cursor="Cursor Title"`
  - Scopes are used to specify which targets or target groups should be used for the attribute.
  - They should only be used for attributes that contain a `="value"`.
    - ✅ Valid: `export="cursor"`
    - ❌ Invalid: `export@cursor`
- Key-value pairs for attributes use the `=` sign and should be followed by a quoted string if the value includes spaces e.g. `title="My Title"`
  - Except for the `h` attribute, which indicates the heading level and supports `+` and `-` modifiers e.g. `h+1` or simply `h2`
- State-allowed attributes are:
- Attribute precedence:
  - When a target-specific  is used, it will override the default attribute value, regardless of the order of the attributes in the comment.
  - When a target, target groups, etc. are specified together for the same attribute, they will take the following order of precedence:
    - `key@target="value"` (specifically named target e.g. `key@cursor="value"`) > `key@target-group="value"` (e.g. `key@ide="value"`) > `key="value"` (e.g. `key="value"`)

Examples:

```txt
xml                         # XML everywhere
xml@ide                     # XML only on IDE targets
title="Rules"               # Heading in all targets
title@cli="CLI Rules"       # Override just for CLI targets
skip@cursor                 # Hide section from Cursor
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
| `vs-code`           | cursor, windsurf      | Sub‑set of IDE tools that inherit VS Code engine |
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