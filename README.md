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

### Mixdown Supported Tools

- IDEs
  - [Cursor](https://www.cursor.com/)
  - [Windsurf](https://windsurf.dev/)
- VS Code Extensions
  - [Roo Code](https://roocode.dev/)
  - [Cline](https://cline.dev/)
- Terminal-based tools
  - [Aider](https://aider.chat/)
  - [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
  - [OpenAI Codex](https://github.com/openai/codex)

## Installation

### Install Mixdown globally

```bash
npm install -g mixdown
```

### Install Mixdown within a project

```bash
npm install mixdown
```

## Quick Start

### Set up Mixdown within a project

```bash
mixdown init
```

This command will create a`.mixdown` directory within your project with the following structure:

```
.mixdown/
├── mixes/
    ├── [mix-name].mix.xml
├── output/
├── templates/
├── config.yaml
└── README.md
```

## Creating Mixes

### Templating with "Mixes"

Templates in Mixdown are called "Mixes". This is to avoid confusion with other terms like "prompts", "instructions", or "templates." Think of a mix as the "gold master" of a rule/instruction/prompt. Mixes use a specific syntax to define how the instructions should be written out to the directories of the tools you're using, in the format they're expecting. We use the `.mix.xml` extension to denote a Mixdown file.

The default setup for a Mix (`./mixdown/mixes/[mix-name].mix.xml`) is:

```xml
<mixdown version="1.0.0">
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

We use [YAML frontmatter](https://jekyllrb.com/docs/front-matter/) to define the mix's metadata, contained within a `<meta>` tag and omitting the typical `---` delimiters. This is useful for providing information, as well as provide for file and tool-specific context. Supported keys are:

#### Standard Keys

- `name`: The name of the mix.
- `description`: A description of the mix.

#### Meta Keys

- `created`: The date the mix was created.
- `modified`: The date the mix was last modified.

#### Optional Keys

Optional keys aren't required for Mixdown to work, but will be included in any tool's instructions files that support them. They can be overridden by tool-specific keys, which are defined below.

- `include` (optional): A list of tools that Mixdown should output files for.
- `exclude` (optional): A list of tools that Mixdown should not output to.
- `type=[rule,command]` (optional): The format of output you'd like the mix to be written as.
  - `type="rule"` (default): The mix will be written as a rule (e.g. for Cursor Rules).
  - `type="command"`: The mix will be written as a command (e.g. for Claude Code).
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

Attributes can also be added to the placeholder to direct the formatting of the value. For example, `[name format="uppercase"]` will instruct the AI to format the name in uppercase. You can also try other types of formatting options such as `[date format="YYYY-MM-DD"]` or `[time format="HH:mm"]`.

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

**Section Tags** are xml-like tags used within mixes, instructions, and templates to delineate different aspects of a prompt, content, or document. The can help LLMs separate aspects of a prompt and avoid conflating unrelated context, leading to more accurate and reliable results. XML has been proven to be a reliable way to structure prompts, and is a de facto standard for this purpose (see the [GPT-4.1 Prompting Guide](https://cookbook.openai.com/examples/gpt4-1_prompting_guide) for example).

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

### Splitting Mixes with "Tracks"

One special feature of Mixdown is the ability to have a single mix file that can be split and written into multiple rules/instructions, with options for when to do the splitting. These are called "tracks." You can think of these as mixes themselves, but embedded a "parent" mix. This is useful for when you're setting up instructions for different coding agents, where one may prefer to have a single instruction, while another may prefer to have them broken down into multiple sections.

To add a split to a mix, you can use the `<track>` tag (also usable as `<t>`). Attributes are included within the tag to specify conditions for creating new files, whether or not to include them in certain rules files for specific tools, and more.

When including a track in a mix, you'll need to give it a name, and use one or more of the following attributes for it to work: `bounce`, `skip`, or `type`.

#### Track Attributes

- `name` (required): The name of the track. This will be used to name the file that is created when the mix is split. The files will be written to their respective tool's directory with its preferred file extension.
  - Example: `<track name="code-quality">` would create `.cursor/rules/code-quality.mdc` for Cursor, and `.roo/rules/code-quality.md` for Roo Code.
  - `name[:tool]`: You can use a `:` as a namespace to specify tool-specific alternative names for written files. You can specify one or more tools by using a colon, followed by the tool's name e.g. `name:cursor="code-quality-rules" name:claude-code="code-quality"`.
- `title[:tool]`: The title of the track. This will be used as a title at the top of the output files, likely as a `# H1 Heading`. By default the title will output with the first letter of the title capitalized. Otherwise, formatting will be preserved.
- `skip="[tools]"`: This attribute indicates that a track should not get written to a tool's instructions. It's populated with a comma-separated list of tool names.
  - Example: `skip="cursor"` would mean that when writing the mix to Cursor Rules, this particular track would not be included.
- `bounce="[tools]"`: Bouncing a track means that the track will be skipped in the mix's final output, and will be written as a separate file. This is handy when you want to write instructions in a comprehensive way, but ultimately want to have separate files for each tool to work with.
  - It can be used on its own, without including specific tools: `<track name="my-rule" bounce>`. This will create a file called `my-rule.md` in all target directories, and skip the track's content in the main mix output files.
  - You can also include specific tools to bounce the track for: `<track name="my-rule" bounce="cursor,roo">`. This will create a file called `my-rule.md` in the each tool's respective directories, but only for Cursor and Roo Code.
- `type[:tool]`: This attributes allows you to specify the "type" of output you'd like the track to be written as. You can specify one or more tools by using a colon, followed by the tool's name e.g. `type:cursor="rule" type:claude-code="command"`.

#### Attribute Namespaces

The `name`, `title`, and `type` attributes allow for the use of a `:` as a namespace to specify tool-specific values. This allows you to customize the output for specific tools in a really granular way.

#### Track Example

Here's how a track might look within a mix:

```xml
<!-- Rest of the mix above -->
<track name="code-quality" type:cursor="rule" type:claude-code="command" title="Code Quality Guidelines" title:claude-code="Code Quality Command">
...
</track>
<!-- Rest of the mix below -->
```

### Using "Patch" for tool-specific instructions

The `<patch>` tag (also usable as `<p>`) is used to add tool-specific instructions to a mix, which would be written to the declared tool's instruction file.

Example:

```xml
<!-- Nesting patch tags with named tools -->
<patch>
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
</patch>

<!-- Patching with tools as an attribute -->
<patch for="cursor,windsurf">foo</patch>
<patch for="roo,cline">bar</patch>
```

## TODOS (build, and documentation)

<!-- TODO: Add a section here explaining how Mixdown works. Going to stub it out for now -->

1. Compiler / validation layer
   - Schema linting: Mixdown will lint `.mix.xml` files to ensure they're valid. Surfacing errors and warnings to the user (unknown tags, bad placeholders, unknown attributes, etc.)
   - Dry-run "rough mix": `mixdown rough --tool cursor` will output the rough mix for would-be Cursor .mdc rules files, so the user can review it before it's written.
   - Round-trip tests: snapshot generated files and fail CI if output drift occurs without a corresponding change to the mix.
2. Plug-in architecture
   - Expose a `toolProvider` interface (`resolvePath(), renderTemplate(), etc.) so the community can PR support for as-yet-unsupported tools.
   - Keep core small; ship extra providers as optional npm packages e.g. `@mixdown/tool-cursor`, `@mixdown/tool-godmode`, etc.
3. Content-aware helpers
   - Placeholder helpers: built-in fucntions like `[git_branch]`, `[project_name]`, `[user_name]`, `[random_uuid]`, etc.
   - LLM test harness: run each generated prompt against a chosen model with canned inputs; flag large response deltas to highlight prompt regressions.
4. UI / DX
   - Define CLI
   - Define MCP server
   - Web playground: paste a mix, select target tools, see render files side-by-side for learning/sharing
5. Versioning & distribution
   - Mix registry: a GitHub‑backed index of public mixes with semantic versioning so teams can mixdown install `@acme/rails-rules@^2.0.0`
   - Embedded changelogs: auto‑insert a generated comment block at top of emitted files linking back to mix + commit SHA that produced it.
6. Interop with MCP
   - Since we already lean on MCP, expose a GET /mixes/:tool route so any agent in the Mixdown ecosystem can fetch fresh rules before spawning
   - Optionally embed a checksum header so agents can skip download if nothing changed.
7. Backlog
   - Optional `.mixdown.yaml` companion: for folks allergic to XML, we could offer a pure YAML alternative that compiles to the same AST.