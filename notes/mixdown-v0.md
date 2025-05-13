# Mixdown v0

## Overview

I want to take what I've put together for Mixdown so far, and break it down into a more iterative process. We'll start from the bare bones, and add features in small, focused steps.

### Goals

- Create a minimal syntax for authoring Mixdown files
- Implement a basic compiler that builds Mixdown files into their target formats
- Handle rules files for Cursor, Windsurf, Roo Code, Claude Code, and OpenAI Codex

### Non-goals

- Enable all features of the final Mixdown syntax
- Handle modes (Roo Code), slash commands (Claude Code), and other advanced features

## Design Goals

- Simplicity
- Extensibility
- Previewability
    - Render mix files legibly in GitHub, VS Code, Obsidian, etc.
- Lintability
    - Files should pass standard markdown-lint without hacks

## Permanent Changes

Below is a list of changes that will override previous behavior detailed in the [Overview](overview.md):

- Directory Structure
    - ✴️ **Consolidating:** `prompts/` into `.mixdown/`
        - Retaining `instructions/` and `artifacts/` subdirectories
    - ✴️ **Replacing:** `mixdown.yaml` with `mixdown.config.json`
        - A more standard config file name, and moving to JSON since it's less prone to parsing issues.
    - ✅ **Adding:** `instructions/path/to/instructions.md`
        - Including subdirectories within `instructions/` will render artifacts within the corresponding subdirectory, based on the project root `./`.
            - Example: `instructions/app/instructions.md` would render for Cursor as `./app/.cursor/rules/instructions.md`
        - Users can also use parens `instructions/(path)/` to organize instructions within Mixdown, while keeping the rendered artifacts in their default destination path.
        - Entire paths and their contents can be ignored for rendering by prefixing them with `_` e.g. `instructions/_drafts/`
    - ✴️ **Moving:** `prompts/partials` into `instructions/_partials`
- Sections
    - ✴️ **Replacing:** `{{# section-name key="value" }}` with `{{section-name key="value"}}`
        - This is more concise and simpler. It's also more of a direct 1:1 translation of the XML tags.
            - e.g. `<section_name>` to `{{section-name}}`
    - ✅ **Adding:** `[+]target?key="value"?additional-key="additional-value"`
        - ✴️ **Replaces:** `key+target="value"`
        - This feels better from an organizational standpoint because you're attaching the attribute override to the target, not the original key.
        - It's also able to be used even when targets are comma-separated, unlike the previous syntax.
        - Can be used in conjunction with `+target` when including/excluding sections.
    - ✅ **Adding:** `^target`
        - This is a way to export a section to a target.
        - It's treated similarly to `[+|-]target` when including/excluding sections.
        - Default behavior then is to exclude the section for the target, and render a new artifact for it instead.
        - Can be combined with `?key="value"` to provide attributes to the exported artifact
            - Key/value pairs included in this way will be rendered within the exported artifact's frontmatter.
        - **Important:** Exporting a section to a target that uses frontmatter keys like `description` or `globs` for key behavior will require inclusion of those attributes within the section definition.
            - Failure to do so will result in the frontmatter values being left blank in the exported artifact, which may not be the desired outcome.
            - Should supply warnings when this is the case. Using strict-mode should mean this throws an error.
        - ✴️ **Replacing:** `export="target"`
    - ✅ **Adding:** `\key="value"`
        - This is a way to include attributes within the rendered XML tag.
        - ✴️ **Replaces:** `include-attributes="[attributes]"`
    - ✅ **Adding:** `allow-bare-xml-tags`
        - This is a boolean flag defaulting to `true` to allow the use of bare XML tags in Mixdown files.
        - It removes the warnings about invalid XML tags when using them without wrapping them in a code block within Mixdown files.
    - ✅ **Adding:** `globs` and `alwaysApply` as allowed section attributes
        - This is a Cursor and Roo-code convention for Rules files.
        - Allowing these as attributes on sections will allow for them to be used as exports to targets that support them.
    - ✅ **Adding:** `no-tags` (boolean, true by default)
        - This boolean flag will render the section contents without any XML tags wrapping it.
    - ❌ **Removing:** `format`
        - Not needed
    - ❌ **Removing** All heading behavior including:
        - `title?h[*]` heading behavior.
            - We really don't need to render headings at all, when XML tags are employed.
            - This decision could eventually be revisited if there is a compelling use case.
        - `{{# "My Title" }}`
            - Just too much complexity to justify. Keep it simple with just `{{# my_title }}`
        - `title?replace`
            - Don't need it
        - `!heading`
            - Don't need it
- Insertions
    - ❌ **Removing:** Explicit data insertions (`{{ $.user.name }}`, etc.) and `data/` directory
        - Honestly just probably overkill for now.
    - ✴️ **Replacing:** `prompts/data/alias.yaml` with `alias` key in `mixdown.config.json`
        - The alias data file might return at some point, but this is good for now.
    - ✴️ **Defining:** `{{ $alias }}` or `{{$alias}}` are both valid
    - ✅ **Adding:** `{{ $.key[.key*] }}` to insert the value of any key in the current file's frontmatter
        - ✴️ **Replacing:** `{{ $.frontmatter.key }}` for simplicity
        - The `$.` prefix is doing the work here, to make it easy and not take up any additional namespace or characters.
- Links
    - ✅ **Adding:** `{{link ["My Link Title"] my-rule[**/*.md[#section-name]]}}` as the link syntax
        - ✴️ **Replacing:** `{{ /my-rule.md alias="My Link Title" }}`
        - Inspired by the Handlebars link syntax
        - Note: `[My Link Title](my-rule.md)` is still valid, and will continue to work.
    - ✅ **Adding:** `{{link ["My Link Title"] /path/to/file.md }}` as the syntax for linking to project files, starting from the project root.
        - ✴️ **Replacing:** `[My Project File](//src/file.ts)`
            - The double slash is just confusing, and would have produced invalid links anyways.
- Embeds
    - ✅ **Adding:** `{{> mix-name }}`
        - This takes the place of partials, and keeps the syntax simpler for embedding mixes.
        - ✴️ **Replacing:** `{{> partial }}` with `{{> _partial }}`
            - While partials are stored in `instructions/_partials`, the path is not needed in the embed syntax.
            - Partials do not need to include the `_` prefix in their filename, they just need to be within the `/_partials` directory.
            - If desired, `{{> _partials/my-partial }}` would also work
            - If a partial `instructions/_partials/my-partial.md` and `instructions/_my-partial.md` both happen to exist, the `_partials/` version will always take precedence. A warning will be issued if both exist.
        - ✴️ **Replacing:** `{{#> mix:my-rule }}` with `{{> my-rule }}`
- Other
    - ✅ **Adding:** Triple-brace `{{{...}}}` to skip Markdown processing and render them as raw.
        - This is useful for writing documentation or rules that need to show Mixdown syntax literally, or for cases where you want to ensure the section is output exactly as authored.
        - Wrapping a section in triple curly braces, like `{{{section-name ...}}} ... {{{/section-name}}}`, will render the entire section as raw output, preserving all Mixdown syntax and content exactly as written, without any transformation or stripping of code block markers.
        - The same can be used for embeds e.g. `{{{> my-embed}}}`
        - You can also combine this with `no-tags` to render the section contents without any XML tags wrapping it e.g. `{{{section-name no-tags}}}`

## v0 Syntax

### Sections

#### Sections Syntax

Proper Mixdown section format:

```markdown
{{section-name key="value"}}

{{/section-name}}
```

In the build process, the above will be rendered as:

```xml
<section_name key="value">

</section_name>
```

**Note:**

- Any Mixdown attributes included will not be rendered in the final XML output by default.
    - To explicitly include an attribute, you can use the format `\key="value"`
        - Note: This not specifically escaping anything, it's just the adopted format for including the attribute from within the XML tag.
- Custom key/value pairs as attributes will be included as-is.
- `kebab-case` is used for section names as `snake_case` may cause unintended rendering issues, displaying the text in between as italicized text.

---

Using XML tags for section names, with code block wrapper:

````markdown
```xml key="value"
<section_name>

</section_name>
```
````

The above format is still valid Markdown. We're using the post-xml language tag in the code block opening to take the place of standard Mixdown attribute syntax. The benefit of wrapping in the code block is twofold:

1. It allows us to use XML tags for section names, which are not valid Markdown.
2. It allows us to use Mixdown attributes in the code block, which are not valid Markdown.

Note:

- Attribute inclusion can still be done using the `\key="value"` format.
- Code block attributes are not required. They only exist to provide a place to put Mixdown attributes if desired.
- Some Markdown previewers may render certain attributes differently, such as `title`, so tread carefully.
- Additional code blocks to nest sections is not supported, so some Mixdown features won't work.

---

When `allow-bare-xml-tags` is set to `true` in frontmatter or config, you can use bare XML tags for section names. The artifacts will be rendered verbatim.

**Important:**

- Bare XML tags are not valid Markdown, so they may not render in standard Markdown previewers.
- Some Markdown previewers may render certain attributes differently, such as `title`, so tread carefully.

````markdown
<section_name>

</section_name>
````

#### Sections Attributes

- `title="My Title"`
    - `title="$target.name Instructions"` would render as "Cursor Instructions" for artifacts when target is `cursor`
- `description="My Description"`
- `[+|-]target`
    - `+cursor -windsurf`: Include section for Cursor, exclude for Windsurf
- `+target?key="value"` e.g. `+cursor?title="My Title for Cursor"`
    - Note: `-target` does not allow a `?` modifier

#### Self-closing Section Tags

These will not be supported in v0.

#### Multi-line Section Tags

This is preserved, with the exception of the `#` prefix.

```markdown
{{instructions
  title="My Rules"
  description="These are the rules for the instructions section."
  include-attributes="title,description"
}}

### Embeds

Trying to simplify the embed syntax to just `{{> embed-name }}`. Examples:

```markdown
<!-- Embed /instructions/conventions.md, with the optional .md extension -->
{{> conventions[.md] }}

<!-- Embed a specific section from within the conventions file -->
{{> conventions#section-name }}

<!-- Embed a section from within the existing file -->
{{> #section-name }}

<!-- Embed a mix with specific sections included and excluded -->
{{> my-rules sections="section-name,!section-name-to-exclude" }}
```

Embed tags will close automatically on render, so you don't need to include a closing tag.

#### Embed Attributes

- All the same attributes of sections are supported
- Sections being embedded can be re-named using the syntax `{{> old-name name="new-name" }}`
    - By default the name of a section is the value within the `{{ ... }}` double-braces, so re-using `name` for this purpose is essentially just telling Mixdown to re-write the name of the section on render.

### Placeholder Instructions

Keeping this as-is for now e.g. `[ fill this in ]` as a placeholder for the LLM to fill in. This is preserved intact from the Mixdown file to the final artifact.

### Links

Links are preserved as-is from the [overview](overview.md).

## v0.x Features (Next Steps)

- Self-closing section tags
- Target groups
    - Custom target groups
- Mode support
- Slash command support
- Strict mode
- Template support
    - These will likely be partials, with some special frontmatter to be handled properly.