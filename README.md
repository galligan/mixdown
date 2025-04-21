# 💽 Mixdown: A toolbox for AI/Agentic Prompting

Mixdown is a project that consists of two parts:

1. A Node.js app with an API, CLI, and Model Context Protocol implementation for creating and managing prompts/instructions for AI chatbots, agents, and agentic development tools.
2. A Markdown-based markup specification for creating effective and reusable prompts with reliable results.

## What is Mixdown?

Well, if you're reading this, you're probably already familiar with at least one of the AI coding tools that Mixdown is [designed to work with](#mixdown-supported-tools). Each tool has its own unique way of being provided context, guidance, and operational instructions for your projects e.g. Cursor's rules (`.cursor/rules`), OpenAI Codex instructions (`codex.md`), Claude Code's instructions (`CLAUDE.md`), etc.

The problem is, they all have different formats, behavior, and capabilities, which can become a huge pain to manage. This can be frustrating, and might even lead you to just sticking to one tool. But that's no fun, and you'll be missing out on all the awesome capabilities and differences each tool has to offer! That's where Mixdown comes in…

With Mixdown, you can apply the "Don't Repeat Yourself" principle to your agentic code tools' rules files, instructions, etc. Instead of writing slightly different versions of the same instructions for each tool, you create a single "mix" file. A mix is the "gold master" for your instructions, from which individual tool-specific files are created in their respective format, to the appropriate places, etc.

<!-- TODO: Maybe consider this as an alternative -->

Mixdown is "Terraform for AI prompts": declare your ideal prompt rules once, target dozens of coding agents, and guarantee every teammate (human or bot) runs with the same authoritative instructions—no copy‑paste, no drift, just high‑quality, version‑controlled context.

## What's with the name?

We borrowed "Mixdown" from the music product world because it nails the vibe so well. Think of a mixdown as the moment a song stops being a pile of takes and starts being the version everyone hears. That's what this toolbox does for prompt engineering: it fuses disparate rules into one golden master, then automatically generates the perfect format for Cursor, Windsurf, Claude Code, and beyond.

### Mixdown Supported Tools

| 🚦 | Tool ID | Tool Name | Type | Status |
|---------|---------|------|------|--------|
| ✅ | `cursor` | [Cursor](https://www.cursor.com/) | IDE | Supported |
| 🟡 | `claude-code` | [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) | Terminal-based tool | In Progress |
| 🟡 | `cline` | [Cline](https://cline.dev/) | VS Code Extension | In Progress |
| 🟡 | `roo-code` | [Roo Code](https://roocode.dev/) | VS Code Extension | In Progress |
| 🔵 | `aider` | [Aider](https://aider.chat/) | Terminal-based tool | Planned |
| 🔵 | `openai-codex` | [OpenAI Codex](https://github.com/openai/codex) | Terminal-based tool | Planned |
| 🔵 | `windsurf` | [Windsurf](https://windsurf.dev/) | IDE | Planned |

## Installation

### Install Mixdown globally

```bash
npm install -g mixdown
```

### Install Mixdown within a project

```bash
npm install mixdown
```

## Versioning and Changelog

This project uses [Changesets](https://github.com/changesets/changesets) for versioning and changelog management.

### Adding a Changeset

When making changes that should be reflected in the version number and changelog, create a changeset:

```bash
pnpm changeset add
```

Follow the prompts to:

1. Select the appropriate version bump (patch, minor, major)
2. Write a description of the change for the changelog

### For Contributors

For more detailed information on using Changesets in this project, see [docs/CHANGESETS.md](/docs/CHANGESETS.md).

## Quick Start

### Set up Mixdown within a project

```bash
mixdown init
```

This command will create a`.mixdown` directory within your project with the following structure:

```txt
./prompts/
├── output/                                 # Generated output files
│   ├── runs/                               # Run-specific output files
│   └── latest/                             # Symlink to the latest output version
├── scripts/                                # Custom scripts for runtime includes
├── instructions/                           # Your mix files
│   └── [mix-name].mixd
├── includes/                               # Reusable content as includes
│   ├── [include-name].include.mixd         # 
│   ├── [profile-name].profile.yaml
│   └── *.[md,txt,json,ts]                  # Other text-based files you want to include in your project e.g. .md, .txt, .json, .ts, etc.
└── templates/                              # Template files
    └── [template-name].template.mixd
├── mixdown.config.yaml                     # Mixdown project configuration
└── README.md                               # Mixdown Documentation
```

## Creating Mixes

### Templating with "Mixes"

Templates in Mixdown are called "Mixes". Think of a mix as the "gold master" of a rule/instruction/prompt. Mixes use a specific syntax to define how the instructions should be written out to the directories of the tools you're using, in the format they're expecting. We use the `.mixd` extension to denote a Mixdown file.

The default setup for a Mix (`prompts/instructions/[mix-name].mixd`) is:

```xml
<mixdown version="0.1.0">
<meta>
name: rule-name
description: This is a rule description
</meta>

<mix>

[instructions]

</mix>
</mixdown>
```

### Using Frontmatter in a Mix

We use [YAML frontmatter](https://jekyllrb.com/docs/front-matter/) to define the mix's metadata, contained within a `<meta>` tag and omitting the typical `---` delimiters. This is useful for providing information, as well as provide for file and tool-specific context. Note: Mixdown does not use the `---` delimiters in the syntax, but uses the `<meta>` tags to denote the frontmatter section.

Supported keys are:

#### Standard Keys

- `name`: The name of the mix.
  - Names are formatted as `kebab-case`, meaning all lowercase with hyphens to separate words.
- `description`: A description of the mix.

#### Meta Keys

- `created`: The date the mix was created.
- `modified`: The date the mix was last modified.

#### Optional Keys

Optional keys aren't required for Mixdown to work, but will be included in any tool's instructions files that support them. They can be overridden by tool-specific keys, which are defined below.

- `include` (optional): A list of tools that Mixdown should output files for.
- `exclude` (optional): A list of tools that Mixdown should not output to.
- `type=[rule,command,mode,template]` (optional): The format of output you'd like the mix to be written as.
  - `type="rule"` (default): The mix will be written as a rule (e.g. for Cursor Rules).
  - `type="command"`: The mix will be written as a command (e.g. for Claude Code).
  - `type="mode"`: Modes are supported by some tools, which allow for agents to have entirely different sets of instructions e.g. "Architect," "Writer," "Coder," etc.
  - `type="template"`: Templates define a specific format for an LLM to use to generate content. They are typically paired with rules or instructions to contextualize the desired output for the LLM.
- `globs`: A list of globs to include in the mix. e.g. `globs: **/*.md`
  - Mixdown's globs implementation supports more complex patterns than what individual tools may support e.g. `**/*.{md,mdc,txt}`.
    - In these cases, Mixdown will parse the globs, and apply the appropriate tool-specific globs format when writing the files.
- `alwaysApply`: Whether the mix should always be applied.

#### Tool Overrides

Tool overrides define specific settings for the tool in question. With these, you can provide tool-specific overrides to the mix's default settings.

- `cursor`: Cursor-specific keys, which will be included in Cursor Rules `.mdc` files Mixdown writes.
  - `description`: Cursor-specific description
  - `globs`: Cursor-specific globs
  - `alwaysApply`: Whether the mix should always be applied.

Example:

```yaml
---
# Rest of the mix's frontmatter
cursor:
  description: Cursor-specific description
  globs: **/*.md
  alwaysApply: false
claude-code:
  type: command # overrides the mix's default type of "rule"
---
```

### Bracketed Placeholders

**Placeholders** are denoted by square brackets e.g. `[name]`. They are used as instructions for the AI to fill in the value. The square brackets were selected as they are already a common convention in AI prompting, and are visually distinct from the rest of the text.

Attributes can also be added to the placeholder to direct the formatting of the value. For example, `[name format="uppercase"]` will instruct the AI to format the name in uppercase. You can also try other types of formatting options such as `[date format="YYYY-MM-DD"]` or `[time format="HH:mm"]`

Example:

```md
# [title format="uppercase"]

**Date:** [date format="YYYY-MM-DD"]
**Time:** [time format="HH:mm"]

## Introduction

[introduction]

## Context

[context]

```

### Section Tags

**Section Tags** are xml-like tags used within mixes, instructions, and templates to delineate different aspects of a prompt, content, or document. The can help LLMs separate aspects of a prompt and avoid conflating unrelated context, leading to more accurate and reliable results. XML has been proven to be a reliable way to structure prompts and see more consistent results (see the [GPT-4.1 Prompting Guide](https://cookbook.openai.com/examples/gpt4-1_prompting_guide) for example).

There are some common XML tags that we use in Mixdown:

- `<system>`: A system prompt
- `<instructions>`: A set of instructions for the AI to follow
- `<example>`: An example response to guide the AI's output
  - `<good_example>` and `<bad_example>` can be used to illustrate examples of good (correct) and bad (incorrect) responses, respectively.
- `<formatting>`: Formatting instructions
- Chain of thought prompting can be done by using `<thinking>` and `<answer>` tags.

If you'll be explicitly referring to the content of one of the tags, you should use the `<tag_name />` to refer to it elsewhere in the mix. We recommend using a self-closing tag to avoid confusing the LLM.

One great thing about using XML is that it's very easy to extend. You can define your own tags to group and separate different aspects of a prompt, content, or document. By using an opening and corresponding closing tag, you're telling the LLM that the content between the tags is a separate and distinct thing.

Example:

```xml
<system>
You are a helpful assistant that can answer questions and help with tasks. The user will provide you with information they would like to include in a document. Use the document template to structure the document.
</system>

<document_template>
# [title format="uppercase"]

**Date:** [date format="YYYY-MM-DD"]
**Time:** [time format="HH:mm"]

## Introduction

[introduction]

...

</document_template>
```

The example above could be a complete AI prompt. In it we're using both section tags and placeholders. The placeholders are used to tell the LLM which values to use in the document, and the section tags are there to distinguish different aspects or instructions for the LLM.

### Splitting Mixes with Segments

One special feature of Mixdown is the ability to have a single mix file that can be split and written into multiple rules/instructions, with options for when to do the splitting. These are called segments. You can think of these as mixes themselves, but embedded a "parent" mix. This is useful for when you're setting up instructions for different coding agents, where one may prefer to have a single instruction, while another may prefer to have them broken down into multiple sections.

To add a split to a mix, you can use the `<segment>` tag. Attributes are included within the tag to specify conditions for creating new files, whether or not to include them in certain rules files for specific tools, and more.

When including a segment in a mix, you'll need to give it a name, and use one or more of the following attributes for it to work: `export`, `skip`, `only`, or `type`.

#### Segment Attributes

- `name` (required): The name of the segment. This will be used to name the file that is created when the mix is split. The files will be written to their respective tool's directory with its preferred file extension.
  - Example: `<segment name="code-quality">` would create `.cursor/rules/code-quality.mdc` for Cursor, and `.roo/rules/code-quality.md` for Roo Code.
  - `name[:tool-name]`: You can use a `:` as a namespace to specify tool-specific alternative names for written files. You can specify one or more tools by using a colon, followed by the tool's name e.g. `name:cursor="code-quality-rules" name:claude-code="code-quality"`.
- `title[:tool-name]`: The title of the segment. This will be used as a title at the top of the output files, likely as a `# H1 Heading`. By default the title will output with the first letter of the title capitalized. Otherwise, formatting will be preserved.
- `skip="[tool-name-1,tool-name-2]"`: This attribute indicates that a segment should not get written to a tool's instructions. It's populated with a comma-separated list of tool names.
  - Example: `skip="cursor"` would mean that when writing the mix to Cursor Rules, this particular segment would not be included.
- `export="[tool-name-1,tool-name-2]"`: Exporting a segment means that the segment will be skipped in the mix's final output, and will be written as a separate file. This is handy when you want to write instructions in a comprehensive way, but ultimately want to have separate files for each tool to work with.
  - You can also include specific tools to export the segment for: `<segment name="my-rule" export="cursor,roo">`. This will create a file called `my-rule.[md,mdc]` in the each tool's respective directories, but only for Cursor and Roo Code.
- `only`: Only is a shortcut for `export` that will create a separate segment file called `my-rule.[md,mdc]` in all target directories, and skip the segment's content from being included in the main mix output files.
- `type[:tool-name]`: This attributes allows you to specify the "type" of output you'd like the segment to be written as (e.g. `rule`, `command`, `mode`, `template`). You can specify one or more tools by using a colon, followed by the tool's name e.g. `type:cursor="rule" type:claude-code="command"`.

**Attribute Namespaces:**

The `name`, `title`, and `type` attributes allow for the use of a `:` as a namespace to specify tool-specific values. This allows you to customize the output for specific tools in a really granular way.

#### Formatting Exported Segments

When exporting a segment, Mixdown will re-write the headings within the content of the segment to ensure the resulting output file is formatted with correct heading levels. Note: this will not apply to content that's in code blocks or within `<template>` tags.

#### Segment Example

Here's how a segment might look within a mix:

```xml
<!-- Rest of the mix above -->
<segment name="code-quality" type:cursor="rule" type:claude-code="command" title="Code Quality Guidelines" title:claude-code="Code Quality Command">
...
</segment>
<!-- Rest of the mix below -->
```

### Using Overrides for tool-specific instructions

The `<override>` tag is used to add tool-specific instructions to a mix, which would be written to the declared tool's instruction file.

Example:

```xml
<!-- Nesting override tags with named tools -->
<override>
<cursor>
---
description: 
globs: 
alwaysApply:
---
</cursor>
<windsurf>
...
</windsurf>
</override>

<!-- overriding with tools as an attribute -->
<override for="cursor,windsurf">foo</override>
<override for="roo,cline">bar</override>
```

### Adding content to a Mix with Includes

An "include" is used to inject content into a mix, from either the `./prompts/includes` directory, an existing mix file, or from a segment contained within the same mix. This adds a significant amount of flexibility to your mixes, allowing for more dynamic and reusable prompts. Here's how they're formatted:

- `$[include:name]`: Injects the content of the include file named `name.mixd` from the `./prompts/includes` directory or from an include contained within the same mix. This can be handy to re-use content from elsewhere in the same mix, such as important instructions that may be useful in the top or bottom of a mix.
  - Note: If an include's name within a mix is the same as one in the `prompts/includes` directory, the include within the mix will take precedence.
- `$[include:mix:name]`: Injects the content of the mix file named `name.mixd` from the `./prompts/instructions` directory. When you do this, the mix content is included inline without consideration of the mix's `<meta>` section, `<override>` tags, or any other mix-specific content.
- `$[include:template:name]`: Injects the content of a template named `name` from the `./prompts/templates` directory.
- `$[include:path="path/to/file.md"]`: Injects the content of the file at `path/to/file.md` inline into the mix. We use the full `include` keyword ensure Mixdown handles it correctly. 🚧 Any included content will be sanitized to avoid potential security concerns.

Includes also support re-writing the top-most heading from the source content, or removing it entirely. This is useful to avoid confusion when the source content has a heading that doesn't quite fit with the rest of the mix. Here's how it works:

- `$[include:name title="[## ]New Title"]`: This will rewrite the top-most heading of the source content with "new title". You don't need to include a `#` heading symbol in the title, but it's recommended to avoid confusion.
- `$[include:name title-none]`: This will remove the top-most heading from the source content.

#### Example Includes

```md
<!-- Rest of the mix above -->
$[include:legal]
```

This will inject the content of `./prompts/includes/legal.mixd` into the mix. If no such file exists, Mixdown will warn and skip the include. It can also be configured to fail the build if an include is missing or by using the `--strict` flag.

#### Data/Profile Includes

Data/profile includes are a way to inject content from a YAML-formatted serialized data file such as a "profile" (personal, project, or org/company) into a mix.

- `data` and `profile` are interchangeable, but both are supported to help organize your includes.
  - When using `$[data:foo]`, Mixdown will look for `.prompts/includes/foo.data.yaml`
  - When using `$[profile:bar]`, Mixdown will look for `.prompts/includes/bar.profile.yaml`

Examples:

- `$[profile:user.name]`: Injects the content of the `name` key in the `./prompts/includes/user.profile.yaml` file.
- `$[profile:project.legal]`: Injects the content of the `legal` key in the `./prompts/includes/project.profile.yaml` file.

### Mixdown Aliases

Aliases can be created in `./prompts/mixdown.config.yaml` to expand the value when an include is used e.g. `[alias:my-alias]` would expand to the value of the `alias.my-alias` key in `./prompts/mixdown.config.yaml`. Example:

```yaml
# ./prompts/mixdown.config.yaml

aliases:
  my-alias: "Mixdown is awesome!"
```

Will go like this:

```md
<!-- Rest of the mix above -->
$[alias:my-alias]

<!-- Which will be written into the output files as: -->
Mixdown is awesome!
```

You can also make use of a profile configuration in `./prompts/includes/[profile-name].profile.yaml`. For example:

```yaml
# ./prompts/mixdown.config.yaml

aliases:
  legal: "[include:project.privacy]"

# ./prompts/includes/project.profile.yaml

project:
  legal:
    path: "./prompts/includes/privacy.mixd"
    title: "Lumon Privacy Policy"
```

Will go like this:

```md
<!-- Rest of the mix above -->
$[alias:legal]

<!-- Is interpreted as: -->
$[include path="./prompts/includes/privacy.mixd" title="Company Privacy Policy"]

<!-- Which will be written into the output files as: -->
## Lumon Privacy Policy

Our privacy policy is available at [https://lumon.com/privacy](https://lumon.com/privacy).
```

Note in the above example that the YAML key `legal` has `path` and `title` keys. Any keys that correspond to an include attribute will see their values used as the attribute's value.

## TODOS (build, and documentation)

<!-- TODO: Add a section here explaining how Mixdown works. Going to stub it out for now -->

1. SHA-256 of rendered files
2. Compiler / validation layer
   - Schema linting: Mixdown will lint `.mixd` files to ensure they're valid. Surfacing errors and warnings to the user (unknown tags, bad placeholders, unknown attributes, etc.)
   - Dry-run preview: `mixdown preview --tool cursor` will output a preview of the would-be Cursor .mdc rules files, so the user can review it before it's written.
   - Round-trip tests: snapshot generated files and fail CI if output drift occurs without a corresponding change to the mix.
   - Build: final mix output is performed with `mixdown build`. This will write the final mix outputs to their respective destinations. A build report is saved as a JSON file in the `./mixdown/output/latest` directory (a symlink to the latest version). It includes the following information:
     - The mix's name, version, and hash ID of the mix's content
     - The date and time the mix was published
     - A list of tools the mix was written to
     - A list of files that were written, and their hash ID
     - A list of files that were skipped
     - A list of files that had errors
3. Plug-in architecture
   - Expose a `toolProvider` interface (`resolvePath(), renderTemplate(), etc.) so the community can PR support for as-yet-unsupported tools.
   - Keep core small; ship extra providers as optional npm packages e.g. `@mixdown/tool-cursor`, `@mixdown/tool-godmode`, etc.
4. Content-aware helpers
   - Runtime inserts as includes: You can use built-in functions like `$[include:@git_branch]`, `$[include:@project-name]`, `$[include:@user-name]`, `$[include:@random-uuid]`, etc. We'll use one sigil `$` to denote an include and distinguish them from placeholders.
     - The `@` is used to denote a runtime include, and is used to distinguish them from static includes. They will be resolved at runtime, and will include the current state of the project.
     - You can use the values from the `<meta>` section of a mix to populate an include.
     - Runtime includes can also be configured in `./mixdown/mixdown.config.yaml` to set project-default values, or trigger scripts to run contained in `./mixdown/scripts`.
   - LLM test harness: run each generated prompt against a chosen model with canned inputs; flag large response deltas to highlight prompt regressions.
5. Security & sandbox
   - XML + string interpolation invites XSS attacks; sanitize all content before writing to disk
   - Use `fast-xml-parser` to parse XML content with `ignoreEntities: true`
   - For placeholders that shell out to a command e.g. `
6. UI / DX
   - Define CLI
   - Define MCP server
   - Web playground: paste a mix, select target tools, see render files side-by-side for learning/sharing
7. Versioning & distribution
   - Mix registry: a GitHub‑backed index of public mixes with semantic versioning so teams can mixdown install `@acme/rails-rules@^2.0.0`
   - Embedded changelogs: auto‑insert a generated comment block at top of emitted files linking back to mix + commit SHA that produced it.
8. Interop with MCP
   - Since we already lean on MCP, expose a GET /mixes/:tool route so any agent in the Mixdown ecosystem can fetch fresh rules before spawning
   - Optionally embed a checksum header so agents can skip download if nothing changed.

### Backlog

- "Takes": version/tag of a mix, which could allow for A/B testing of mixes

