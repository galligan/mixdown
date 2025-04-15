# AI Coding Tools: Instruction Files and Configuration

AI-assisted coding tools have introduced **instruction files** and configuration mechanisms that let developers customize an AI’s behavior on a project. These files contain persistent rules, style guides, and context that the AI will automatically consider in its responses. Below we detail how several modern tools implement these instruction/config files, how they’re structured, and how users can work with them.

## Common Patterns in Instruction File Systems

While each tool uses its own naming and format, there are common patterns:

- **Location & Naming:** Instruction files are usually stored at the project root, often as hidden dotfiles or in a special folder. Examples include `.cursorrules` or `.cursor/rules/` for Cursor, `.windsurfrules` for Windsurf, `.clinerules` for Cline, `.roomodes`/`.roorules` for Roo Code, and `.github/copilot-instructions.md` for GitHub Copilot ([Unleashing AI Power with Rules Files: Utilize 100% of Cursor and Windsurf | by M.F.M Fazrin | Medium](https://mfmfazrin.medium.com/unleashing-ai-power-with-rules-files-utilize-100-of-cursor-and-windsurf-6f27b40eccff#:~:text=These%20files%20might%20be%20stored,context%20for%20your%20AI%20assistant)) ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=Please%20create%20a%20memory%20for,this)). These naming conventions clearly tie the file to the tool.

- **Scope:** Most tools support project-specific rules (living in the repo and version-controlled) to tailor the AI to that codebase ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Project%20rules)). Some also allow global or user-level instructions – for example, VS Code Copilot instructions can be set at user level via settings, and Aider loads config from the home directory if present ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=Most%20of%20aider%E2%80%99s%20options%20can,this%20file%20in%20these%20locations)). In many cases, multiple sources merge (user + project) with project instructions taking precedence ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=You%20can%20also%20store%20custom,automatically%20pick%20up%20this%20file)).

- **Format & Syntax:** The files often use a simple Markdown or YAML-based format for readability. For instance, Copilot and Windsurf use plain Markdown instructions ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=Rules%20are%20more%20permanent%20and,it%20helps%20with%20your%20code)) ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=1.%20Create%20a%20%60.github%2Fcopilot,custom%20instructions%20to%20the%20file)), Cursor uses “MDC” files (Markdown with front-matter) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Rule%20structure)), and Aider uses YAML for its config file ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=Most%20of%20aider%E2%80%99s%20options%20can,this%20file%20in%20these%20locations)). These formats allow section headings, bullet lists of rules, or key–value metadata. Some tools (Cursor, Roo) support a **front-matter section** at the top for metadata like descriptions or file globs to scope the rule ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Example%20MDC%20rule)).

- **Activation & Usage:** All these files serve as **persistent context** automatically prepended to the AI’s prompt or system message. For example, once added, Copilot’s repository instructions are “automatically applied” in Copilot Chat for that repo ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=%F0%9F%9A%80%20Getting%20Started)). Cursor’s rules are injected “at the start of the model context” whenever relevant ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Large%20language%20models%20do%20not,context%20at%20the%20prompt%20level)). Many tools allow multiple rules and the AI/agent will include the ones relevant to the query or files being worked on ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Essentially%2C%20you%20create%20individual%20,attaching%20to%20the%20AI%20panel)) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=,ruleName)).

- **Custom Commands & Modes:** Several tools let users define custom *modes* or command behaviors via these files. Roo Code’s `.roomodes` JSON allows defining new AI “personas” with specific abilities and instructions (e.g. a testing mode, a translation mode) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=URL%3A%20https%3A%2F%2Fgithub.com%2FRooVetGit%2FRoo,Test%20utilities%20and)) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=strategies,slug)). Cursor’s rules can be made available for manual invocation or automatically triggered by file patterns (more on this below) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Rule%20Type%20Description%20,ruleName)). This enables specialized workflows (like a “Test Guru” mode that only writes tests).

- **Updating & Ergonomics:** Editing these files is part of the development workflow. Many tools allow creation/editing from the UI: Cursor has a “New Cursor Rule” command that opens a template in the `.cursor/rules` directory ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=You%20can%20use%20,rule%20quickly%20from%20inside%20Cursor)); VS Code automatically picks up changes to `.github/copilot-instructions.md` on save ([Adding repository custom instructions for GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot#:~:text=github%2Fcopilot,instructions%20will%20be%20automatically)). Typically, changes apply immediately to new AI requests. Because they live in your editor/repo, normal editing and version control practices apply – you might commit your rules file or share it.

- **Sharing & Community:** Users often share their rule files or maintain templates for common frameworks. For instance, there are curated repositories of **Cursor rules** (e.g. an “awesome .cursorrules” list) and even scripts to convert older Cursor rules to the new format ([A curated list of awesome .cursorrules files - GitHub](https://github.com/PatrickJS/awesome-cursorrules#:~:text=,might%20want%20to%20use%20it)). Windsurf’s community has adapted many Cursor rules for Windsurf (e.g. the `kinopeee/windsurfrules` repo on GitHub) ([kinopeee/windsurfrules - GitHub](https://github.com/kinopeee/windsurfrules#:~:text=kinopeee%2Fwindsurfrules%20,of%20cursorrules%20for%20Windsurf%20Cascade)). Aider’s docs link to a community **“conventions” repository** with contributed style guideline files that others can reuse ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=Community%20contributed%20conventions)). This sharing helps bootstrap project-specific rules by leveraging community knowledge.

- **Tooling:** Some projects provide tools to manage these config files. Aider supports multiple config sources (CLI flags, YAML file, environment, `.env` file) to make configuration flexible ([Configuration | aider](https://aider.chat/docs/config.html#:~:text=Aider%20has%20many%20options%20which,file)) ([Configuration | aider](https://aider.chat/docs/config.html#:~:text=Using%20a%20)). VS Code’s Copilot integration provides GUI toggles to enable the use of instruction files ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=1,use%20the%20custom%20instructions%20file)). In many cases, the AI itself can help maintain the rules – e.g. with Claude Code and Cursor, you can ask the AI to append a new guideline to the rules file when you encounter a recurring issue ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=I%20did%20consider%20just%20including,use%20any%20kind%20of%20rule)) ([Claude Code Top Tips: Lessons from the First 20 Hours](https://waleedk.medium.com/claude-code-top-tips-lessons-from-the-first-20-hours-246032b943b4#:~:text=Claude%20Code%20Top%20Tips%3A%20Lessons,it%20remembers%20for%20next%20time)).

Now, we’ll examine each tool in detail, highlighting their unique approach and features.

## Cursor

**Cursor** is an AI-integrated code editor that pioneered project-specific instruction files. Cursor originally used a single Markdown file, `.cursorrules`, in the repo root to provide the AI with project guidelines. In recent updates, this has evolved into a more powerful system under a **`.cursor/rules/`** directory.

### Project Rules and `.cursor/rules` System

Cursor’s **Project Rules** live in the `.cursor/rules` folder, with each rule in its own `.mdc` file ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Project%20rules)). An MDC file (short for *Multi-Document Context*) is essentially Markdown with a YAML-like header for metadata ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Rule%20structure)). This structure allows multiple focused rule files instead of one large monolith. Cursor is moving away from the single `.cursorrules` file in favor of these individual rule files ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=When%20I%20say%20rules%20for,than%20one%20giant%20rule%20file)). Each rule file can specify when it should apply:

- **Metadata:** At the top of an `.mdc` rule, a fenced YAML block (`---`) defines attributes like a **description**, file path patterns (**globs**), and whether it should **alwaysApply** ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Example%20MDC%20rule)). For example, a rule might specify `globs: "*.py"` to only auto-apply for Python files, or set `alwaysApply: true` to include it for every AI request.

- **Rule Types:** Depending on metadata, a rule can be:
  - **Always** included (if alwaysApply is true) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Rule%20Type%20Description%20,ruleName)).
  - **Auto-Attached** based on file context (if `globs` match files involved in the query) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Rule%20Type%20Description%20,ruleName)).
  - **Agent-Requested**, meaning the AI can choose to use it when relevant. In this case a `description` is required so the AI knows what the rule is about ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=,ruleName)).
  - **Manual**, only included if the user explicitly calls it out (e.g. by name in a prompt). Manual rules typically have neither alwaysApply nor globs set.

When a rule triggers, Cursor inserts its content at the start of the LLM’s context (as system instructions) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Large%20language%20models%20do%20not,context%20at%20the%20prompt%20level)). This persistent guidance then influences all code completions, chat answers, and code transformations.

### Content and Example

Inside the rule file (after the `---` metadata), you write the actual instructions in Markdown. This can include prose guidelines or lists of rules, and even references to other files using an `@filename` syntax (Cursor will insert the content of referenced files into the context when that rule applies) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=%40service)). For example, a rule file might look like:

```md
---
description: RPC Service boilerplate
globs: "services/**/*.ts"
alwaysApply: false
---

- Use our internal RPC pattern when defining services.
- Always use snake_case for service names.

@service-template.ts
``` 

In this example, whenever the AI is working on files under `services/` with extension `.ts`, it will include the listed guidelines and also pull in the contents of `service-template.ts` as additional context ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=%40service)). This showcases how rules can combine written instructions with templated boilerplate.

Cursor encourages keeping each rule **focused and actionable** – e.g., separate rules for “API endpoint validation standards” vs “Frontend component styling conventions” ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Examples)) ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=,Follow%20our%20component%20naming%20conventions)). They recommend keeping rules under ~500 lines and splitting large concepts into composable files ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Good%20rules%20are%20focused%2C%20actionable%2C,and%20scoped)). This modular approach not only organizes knowledge better but also lets the AI selectively load only the relevant rules for a given query (saving token space).

### Creation and Management

You can create new rules directly in Cursor. Using the command palette or settings (`Cursor Settings > Rules`), you can invoke **“New Cursor Rule”** to generate a blank rule file in `.cursor/rules` ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=You%20can%20use%20,rule%20quickly%20from%20inside%20Cursor)). The Cursor UI also lists all rules in the project and shows their status (which are currently applied, etc.). Since rule files are plain text, they can be edited like any other file and checked into version control.

Cursor’s agent automatically decides which project rules to apply based on context, but the user can also manually invoke a rule by name if needed (for example, typing the rule’s filename with an `@` in chat).

### Evolution from `.cursorrules`

Older versions of Cursor used a single **`.cursorrules`** file. This file was essentially a Markdown document whose entire content would be injected as context (global to the project). The new multi-file system is more powerful: it allows scoping and the agent can reason about which subset of rules are needed ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=experience%20using%20X%2C%20Y%20and,attaching%20to%20the%20AI%20panel)) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=I%20did%20consider%20just%20including,use%20any%20kind%20of%20rule)). The Cursor team has announced deprecation of the monolithic `.cursorrules` in favor of `.cursor/rules/*` files ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=When%20I%20say%20rules%20for,than%20one%20giant%20rule%20file)). (During the transition, Cursor can still read a `.cursorrules` if present, but users are encouraged to migrate to individual rules.)

One practical consequence of the new system is the AI might explicitly reference which rule it’s following when giving an answer, making its chain of thought more transparent. Users have noted the Cursor agent will sometimes say *“Applying rule: X…”* in its reasoning, especially if a rule instructs it to do so for transparency ([Unleashing AI Power with Rules Files: Utilize 100% of Cursor and Windsurf | by M.F.M Fazrin | Medium](https://mfmfazrin.medium.com/unleashing-ai-power-with-rules-files-utilize-100-of-cursor-and-windsurf-6f27b40eccff#:~:text=The%20key%20to%20the%20effectiveness,%E2%80%9D)) ([Unleashing AI Power with Rules Files: Utilize 100% of Cursor and Windsurf | by M.F.M Fazrin | Medium](https://mfmfazrin.medium.com/unleashing-ai-power-with-rules-files-utilize-100-of-cursor-and-windsurf-6f27b40eccff#:~:text=1,codebase%2C%20especially%20beneficial%20for%20teams)).

### Community and Updates

Cursor’s user community has embraced rule files. Developers share their `.cursorrules` or `.mdc` rule sets for various frameworks. For instance, there are curated lists of awesome Cursor rules on GitHub, highlighting how to enforce popular style guides or project structures ([A curated list of awesome .cursorrules files - GitHub](https://github.com/PatrickJS/awesome-cursorrules#:~:text=,might%20want%20to%20use%20it)). A forum post even shared a script that converted **879 Cursor rule files** from old `.cursorrules` format into the new `.mdc` format for everyone’s benefit ([Created a collection of 879 .mdc Cursor Rules files for you all](https://forum.cursor.com/t/created-a-collection-of-879-mdc-cursor-rules-files-for-you-all/51634#:~:text=Created%20a%20collection%20of%20879,Here%27s%20the%20link)) – a testament to how many have been created and shared.

**Latest changes:** As of late 2024, Cursor officially supports the `.cursor/rules/` directory structure and the older single file approach is being phased out ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=When%20I%20say%20rules%20for,than%20one%20giant%20rule%20file)). This aligns Cursor with a more “agentic” approach: the AI agent can treat each rule as a piece of knowledge to retrieve as needed, rather than blindly loading one massive prompt. The Cursor team continues to refine how the agent selects rules automatically to ensure relevant context without busting token limits.

## Windsurf

**Windsurf** (formerly part of Codeium) is another AI-assisted IDE that uses the concept of persistent rules. Windsurf introduced the **`.windsurfrules`** file to serve a similar purpose as Cursor’s rules, providing project-specific context to its AI agent (called “Cascade”).

### Workspace Rules and `.windsurfrules`

In Windsurf, you create a plain text file named **.windsurfrules** in your project root ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=Please%20create%20a%20memory%20for,this)). This file contains instructions or preferences that Windsurf’s AI will always take into account for that project. As one user explains, “Just create a `.windsurfrules` file in your project’s root with specific instructions (similar to how `.cursorrules` works)” ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=Please%20create%20a%20memory%20for,this)). Every time the AI (Cascade) generates code or responds, it will include this file’s content at the beginning of its prompt.

The `.windsurfrules` file is typically written in Markdown style or simple text. There is no special front-matter or structured syntax required – Windsurf parses the whole file as guidance for the AI. A common pattern is to start by telling the AI about the stack or role it should assume, then enumerate specific guidelines. For example:

```md
You are an expert in Elixir, Phoenix, PostgreSQL, JavaScript, TypeScript, React, Inertia, and Tailwind CSS.

# Elixir and Phoenix Usage
- In controllers, use `assign_prop/3` (not `assign/3`) to pass data to React via Inertia, then use `render_inertia/2`.
- In controller tests, use `inertia_component/1` to assert the component.

# React & Inertia
- Always initialize Inertia pages with proper prop types...
```

This sample (adapted from a Windsurf user’s actual `.windsurfrules` for an Elixir + Phoenix project) demonstrates a mix of high-level role (“expert in X, Y, Z”) and concrete rules for how to implement things ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=You%20are%20an%20expert%20in,React%2C%20Inertia%2C%20and%20Tailwind%20CSS)). The headings and bullet points provide structure but ultimately it’s all context text for the model.

Windsurf’s AI, called **Cascade**, utilizes these rules as part of what Codeium calls “Workspace Rules”. The official Windsurf documentation notes that rules help Cascade better understand the user and codebase, resulting in higher-quality responses ([Windsurf Rules Directory | Windsurf (formerly Codeium)](https://codeium.com/windsurf/directory#:~:text=otherwise%20not%20know%20about%20the,user%20and%20the%20codebase)). Essentially, the `.windsurfrules` content is prepended to every prompt to the model, giving it knowledge of code style, project conventions, and any do’s or don’ts the user has specified.

### Memories vs Rules

Windsurf distinguishes between **“Memories”** and **“Rules”** ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=I%20mainly%20use%20two%20features,in%20Windsurf%3A%20memories%20and%20rules)). Rules (the `.windsurfrules` file) are permanent and apply every time. “Memories” are more ephemeral, created during a coding session to remind the AI of something it just learned. For example, if the AI makes a mistake or you correct it, you can save a “memory” so it won’t forget that correction for the rest of the session ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=I%20mainly%20use%20two%20features,in%20Windsurf%3A%20memories%20and%20rules)). Memories might not persist once you close the project (they are like session notes), whereas `.windsurfrules` is persistent across sessions (since it’s a file in the repo).

A workflow might be: if you notice the AI repeatedly doing X incorrectly, you first correct it and use a memory to fix it for now; later you might promote that to a permanent rule by adding it to `.windsurfrules` for future sessions ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=Memories%20are%20like%20Windsurf%27s%20personalized,and%20avoid%20repeating%20the%20error)).

### Usage and Scope

The `.windsurfrules` file affects both Windsurf’s chat-based assistance and its automated “Cascade” flows. Codeium’s Windsurf has a feature called *Cascade Flows* (autonomous multi-step AI tasks). In Cascade’s Wave 1 release, they emphasized that the user can specify rules as the primary way to influence the AI’s autonomous flow ([Windsurf Wave 1 - Codeium](https://codeium.com/blog/windsurf-wave-1#:~:text=Windsurf%20Wave%201%20,are%20the%20first%20interface)). This means whether you are just asking for a single suggestion or letting the agent run through a sequence of actions, it will abide by the project rules.

Unlike Cursor’s multi-file approach, Windsurf currently uses a single file for all rules in a project. There isn’t an official notion of multiple rule files or types (auto vs manual) in Windsurf yet – it’s either in `.windsurfrules` or it’s not considered. However, users can of course include multiple sections in that one file for organization (as shown above).

### Examples and Community Rules

The Codeium team has provided an online **Windsurf Rules Directory** showcasing curated examples ([Windsurf Rules Directory | Windsurf (formerly Codeium)](https://codeium.com/windsurf/directory#:~:text=Explore%20a%20curated%20collection%20of,rules)). These are templates for common setups – e.g. a Next.js project rule set, a React Native + TypeScript rule set, etc. The examples are written as fenced code blocks of Markdown rules covering code style, project structure, naming conventions, preferred libraries, etc. For instance, a Next.js rule snippet from the directory includes guidelines on following the Next.js App Router patterns, using Tailwind for styling, React Query for data fetching, etc., all listed under Markdown headers like “# General Code Style & Formatting” ([Windsurf Rules Directory | Windsurf (formerly Codeium)](https://codeium.com/windsurf/directory#:~:text=%60,Use%20Prisma%20for%20database%20access)). Users can copy-paste these into their own `.windsurfrules` and tweak as needed.

The community has also mirrored Cursor’s rule-sharing: there was an “awesome-windsurfrules” repository with community-contributed rule files. (It has since been deprecated in favor of official resources, but it shows how early adopters ported Cursor rules over to Windsurf format) ([kinopeee/windsurfrules - GitHub](https://github.com/kinopeee/windsurfrules#:~:text=kinopeee%2Fwindsurfrules%20,of%20cursorrules%20for%20Windsurf%20Cascade)). Many rules are indeed **adapted from Cursor** since both tools use Claude under the hood in many cases ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=This%20year%20I%20tried%20using,they%27re%20both%20solid%20options)), meaning a style guide that helped Cursor’s Claude 3.5 will similarly help Windsurf’s Claude model.

### Editing and Ergonomics

To use `.windsurfrules`, you manually create the file in your project. Currently, Windsurf doesn’t have a special UI for creating or toggling rules (unlike Cursor). You simply edit the file in your editor. The changes take effect immediately for any new AI query. If the AI is already mid-session, it might need a nudge (e.g. reloading the AI assistant) to pick up changes, but generally saving the file is enough.

Because `.windsurfrules` is just a text file, it’s easy to version control and share. Teams can commit this file to their repo, so all members’ editors apply the same AI guidelines. This is helpful in an enterprise setting: the team’s preferred coding style can be enforced not just by linters after the fact, but by the AI during code generation.

**Latest updates:** As of early 2025, Windsurf’s core method remains the single `.windsurfrules` file. There’s mention of “Project Mode Support” and custom mode introduction in recent patch notes (the term *RooMode* in a Reddit patch note refers to Roo Code, not Windsurf). Windsurf’s unique feature is the “Cascade memories” which complement the static rules file. The Codeium/Windsurf team is likely to continue adding features akin to Cursor’s (since the two products leapfrog each other) ([My AI-Powered Workflow for Writing Elixir and Phoenix with Windsurf - DEV Community](https://dev.to/danielbergholz/my-ai-powered-workflow-for-writing-elixir-and-phoenix-with-windsurf-4k8m#:~:text=since%20they%20both%20use%20Claude,they%27re%20both%20solid%20options)), so it wouldn’t be surprising to see multi-file rules or GUI rule managers in the future.

## Zed

**Zed** is a modern code editor with AI assistance, notable for its focus on *in-editor transparency*. Zed doesn’t currently have a dedicated persistent rules file feature like Cursor or Windsurf, but it offers other ways to include context and is considering similar capabilities.

### Context Inclusion via Commands

Zed’s philosophy is to give the developer full control over the AI’s context. In Zed’s AI Assistant panel (a chat-like interface in the editor), there is no hidden system prompt – the entire prompt, including any system instructions, is visible and editable by the user ([Introducing Zed AI — Zed's Blog](https://zed.dev/blog/zed-ai#:~:text=The%20assistant%20panel%20is%20where,and%20control%20over%20every%20interaction)) ([Introducing Zed AI — Zed's Blog](https://zed.dev/blog/zed-ai#:~:text=a%20fluid%2C%20interactive%20coding%20experience,in%20control%20throughout%20the%20process)). This means if you want to give the AI a set of rules or additional context, **you have to insert it into the prompt manually** (or via a command). Zed provides **slash commands** to easily pull in content:

- `/file <path>` will insert the contents of a file or even a whole folder tree into the prompt (folded, so it can be expanded or collapsed) ([Introducing Zed AI — Zed's Blog](https://zed.dev/blog/zed-ai#:~:text=To%20populate%20this%20text,a%20system%20of%20slash%20commands)) ([Introducing Zed AI — Zed's Blog](https://zed.dev/blog/zed-ai#:~:text=The%20,to%20assist%20in%20development%20tasks)).
- `/tab` inserts the content of an open tab.
- Other commands like `/fetch` can pull in a URL’s content, etc.

Using these, a Zed user can simulate a rules file. For example, one could maintain a `rules.md` in the project with desired instructions, and whenever starting an AI conversation in Zed, run `/file rules.md` to include it. In fact, Zed’s assistant allows including entire directories: a user discovered that running `/file .cursor/rules/` will insert all files in that directory (for those who perhaps already had Cursor rules written) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Quick%20update%20after%20another%20test%3A,it%20as%20I%20wrote%20previously)). Once the content is inserted (even in folded form), the model will consider it. 

It’s worth noting that initially one user found that simply referencing a file with `/file` might not always apply to inline completions until expanded, but later tests showed that including it is enough for the AI to pick it up ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Quick%20update%20after%20another%20test%3A,it%20as%20I%20wrote%20previously)). This implies Zed’s inline suggestions do use the assistant panel’s context (folded or not) as long as it’s attached.

### Lack of Persistent Rules Feature (Yet)

As of March 2025, Zed does **not have an automatic rules loading** feature. There is an open discussion where users requested “rules for AI” similar to Cursor’s implementation ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Hello%2C)) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Essentially%2C%20you%20create%20individual%20,attaching%20to%20the%20AI%20panel)). The Zed team has acknowledged related ideas, but the functionality isn’t in the product yet. In that discussion, a user outlines how great Cursor’s multi-file `.mdc` rules system is and suggests Zed implement something similar ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=I%20would%20like%20to%20request,AI%20behaves%20and%20generates%20code)) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=2,descriptive%20of%20the%20rule%27s%20purpose)). A Zed contributor responded by pointing out that since Zed lets you include any text in the prompt, one could manually include Cursor’s rules (by using the `/file` command as described) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Bear%20in%20mind%2C%20,that%20it%20edits%20your%20files)) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=,that%20it%20edits%20your%20files)). However, this is a manual step, not automatic.

So currently, if you want persistent AI instructions in Zed, you must re-insert them each time you start a new AI session. Some users may script this or have a habit of always doing `/file my-rules.md` at the beginning of a conversation. This is obviously less convenient than Cursor/Windsurf where the tool does it for you on every invocation.

### Transparent AI Prompt

The benefit of Zed’s approach is **transparency**. Zed users see *exactly* what is sent to the AI. There’s no behind-the-scenes injection of instructions without your knowledge ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Most%20naive%20approach%20is%20to,call%20performed%20behind%20the%20scenes)). Some users appreciate this, as it “hides nothing from the end-user” and avoids any confusion about why the AI responded a certain way ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=Most%20naive%20approach%20is%20to,call%20performed%20behind%20the%20scenes)). The drawback is the onus is on the user to provide context each time (or trust the AI with zero additional context beyond the open file code).

Zed’s inline AI features (like inline code completion or transformation on a selection) also draw from the assistant panel’s content. An experiment by a user showed that if they put a quirky system message (“you are a 15th century pirate...”) into the chat panel, both the inline completions and inline edits started adopting that style (speaking like a pirate in code comments, for instance) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=I%20was%20curious%20how%20Zed,inline%20assist)) ([Rules for AI · zed-industries zed · Discussion #26550 · GitHub](https://github.com/zed-industries/zed/discussions/26550#:~:text=For%20example%2C%20I%20added%20the,def%20hello_world_ye_lubbers)). This confirms that Zed’s one source of truth for the model is that assistant panel text. Remove or change the instructions, and the behavior changes accordingly.

### Potential Future

Given user interest, it’s likely Zed might add a feature to automatically load a file (or folder) from the workspace as default context for the AI – essentially a “persistent project instructions” setting. There is precedent: Zed’s configuration system already creates a `.zed/` directory for project-specific settings (for things like editor config) ([Configuring Zed](https://zed.dev/docs/configuring-zed#:~:text=Configuring%20Zed%20You%20can%20open,zed%2Fsettings)). Conceivably, a future version could support something like `.zed/ai-rules.md` or even reuse Cursor’s `.cursor/rules` if present, to auto-load those. In the meantime, power users work around it by manual inclusion or even by writing Zed extensions (Zed allows custom slash commands via extensions ([Introducing Zed AI — Zed's Blog](https://zed.dev/blog/zed-ai#:~:text=Slash%20commands%20are%20extensible%20via,specific%20ways))).

In summary, **Zed currently lacks a first-class instructions file**, but it gives users the tools to include any context manually. The focus is on a WYSIWYG prompt where you control what the AI sees, at the cost of convenience. This approach appeals to those who want maximal control and minimal magic. As AI-assisted coding matures, Zed may find a middle ground by offering optional automatic context for those who want it, while preserving the transparency of showing those instructions in the UI.

## Visual Studio Code (Copilot Chat and Agent Mode)

Visual Studio Code has integrated GitHub Copilot’s AI features deeply, including a **Copilot Chat** view and the new **Copilot “Agent” mode**. Instructions and configuration for Copilot in VS Code can be provided via both settings and files. Let’s break down the mechanisms:

### Repo-Specific Instructions (`copilot-instructions.md`)

GitHub Copilot (especially Copilot Chat) supports repository-specific instructions through a special Markdown file. By creating **`.github/copilot-instructions.md`** at the root of your repository, you can supply custom instructions that Copilot will always follow for that repo ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=%F0%9F%9A%80%20Getting%20Started)). This file can contain any natural language guidance about the project: coding style, architectural preferences, what technologies to use or avoid, etc.

Once the file is present (and the feature enabled in settings), Copilot Chat reads it and “automatically apply these instructions whenever you’re chatting about that repository” ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=1.%20Create%20a%20%60.github%2Fcopilot,custom%20instructions%20to%20the%20file)). This works not only in VS Code, but also in Copilot Chat on GitHub.com and Visual Studio 2022 as of early 2025 ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=Copilot%20chat%20on%20GitHub,%F0%9F%8E%89)). Essentially, it’s a cross-environment way to tie instructions to the codebase.

**Enabling**: In VS Code, you need to turn on the setting `"github.copilot.chat.codeGeneration.useInstructionFiles": true` (it’s experimental/new) to have the editor pick up the file ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=1,use%20the%20custom%20instructions%20file)). In newer versions this may be on by default. Copilot will combine any instructions from the file with those you set in settings (described next) – it tries to merge them smartly ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=You%20can%20also%20store%20custom,automatically%20pick%20up%20this%20file)).

**Content**: The file is Markdown, but Copilot doesn’t display it verbatim in chat; it’s injected into the system prompt. You can write it as bullet points or paragraphs. For example, GitHub’s announcement gave samples like instructing JavaScript style (“Omit semicolons in code examples.”) or project tooling (“We use Poetry for dependencies, not pip.”) ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=%F0%9F%92%A1%20Looking%20for%20ideas%3F%20Here,examples%20to%20kick%20things%20off)). These are straightforward statements. Whitespace and formatting are mostly for human readability – Copilot will ignore blank lines and just treat the text as one combined set of instructions ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=3,can%20use%20the%20Markdown%20format)).

### Custom Instructions via Settings

VS Code’s Copilot extension also allows defining instructions in JSON settings, which can be scoped by *type of task*:

- **Code generation instructions** – general guidance when asking Copilot to generate or refactor code ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=%2A%20Code,Markdown%20file%20in%20your%20workspace)).
- **Test generation instructions** – for when using Copilot to create tests ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=%2A%20Test,Markdown%20file%20in%20your%20workspace)).
- **Code review instructions** – when asking Copilot to review selected code ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=%2A%20Code%20review%20instructions%20,Markdown%20file%20in%20your%20workspace)).
- **Commit message instructions** – for commit message suggestions ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=instructions%20in%20settings%2C%20or%20in,Markdown%20file%20in%20your%20workspace)).
- **PR description instructions**, etc.

These can be set either as a user setting (affect all projects) or workspace setting (affect only that project). For instance, one can put in their `settings.json`:
```json
"github.copilot.chat.codeGeneration.instructions": [
    { "text": "Private class members should have a '_' prefix." },
    { "text": "Use dependency injection where possible." }
]
```
Each entry in the list is an instruction string. There’s also an option to reference a file:
```json
"github.copilot.chat.testGeneration.instructions": [
    { "file": "tests/style-guide.md" }
]
``` 
This would load instructions from a file relative to the workspace ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=,style.md)). So you could maintain a Markdown file with all your test writing conventions and just reference it in settings (similar to Aider’s approach of referencing a conventions file).

If both the `.github/copilot-instructions.md` and settings are used for a category, Copilot will combine them ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=You%20can%20also%20store%20custom,automatically%20pick%20up%20this%20file)). Generally, this system is quite flexible – it covers the various contexts in which you might want different instructions (writing code vs writing tests vs reviewing code might each require different persona or focus).

One important note: *Copilot’s inline autocomplete suggestions (the classic “ghost text” completions) do not currently use these instructions* ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=Note)). The custom instructions apply to Copilot Chat and any “on-demand” generation (like the `/test` command to generate tests, etc.), but the real-time autocompletion largely remains based only on immediate code context and Copilot’s training. So, these instruction mechanisms are mostly relevant to the conversational or task-based Copilot usage.

### Copilot Agent Mode

Recently, VS Code introduced **Agent Mode** as part of Copilot, which essentially turns Copilot into an “AI agent” that can perform multi-step tasks and use tools. This was initially in Insiders (preview) and as of VS Code 1.99 (March 2025) became available in Stable ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=)) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=match%20at%20L121%20We%27re%20happy,by%20default%20to%20all%20users)). Copilot Agent Mode is an evolution beyond just providing text suggestions – it can read files, modify multiple files, run commands (like tests or git), and iterate until a goal is met ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20%20is,soon%20in%20VS%20Code%20Stable)) ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20operates%20in,iterates%20multiple%20times%20as%20needed)).

**How it works:** When you switch Copilot Chat into “Agent” mode, you essentially ask it to *execute a task*. For example, “Add a login form to the app” or “Upgrade this project to React 18”. The agent will then autonomously: 
- Determine which files are relevant and open/read them.
- Propose code changes (and apply them with user approval).
- Run terminal commands like building or testing the project to validate changes.
- Observe outputs (compiler errors, test failures) and make further changes.
- Repeat this loop until the task is completed or it gets stuck ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20operates%20in,iterates%20multiple%20times%20as%20needed)) ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20uses%20a,tools%20to%20accomplish%20these%20tasks)).

It uses an arsenal of **tools** to do this. Some built-in tools include:
- `read_file` (to get file contents), 
- `write_file` (to apply changes),
- `run_tests` or general shell commands,
- `#fetch` (to fetch web content, e.g., documentation) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=servers%20in%20agent%20mode,file%20operations%2C%20accessing%20databases%2C%20or)) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=Use%20the%20%60,what%20that%20might%20look%20like)),
- a “thinking” tool that allows the AI to insert scratchpad reasoning steps without acting (inspired by chain-of-thought research) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=match%20at%20L180%20a%20thinking,bench%20eval)) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=)).

Each tool has an internal description/instructions telling the model when and how to use it ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Each%20tool%20has%20detailed%20instructions,tool%20description%20as%20an%20example)) – these are essentially system-level guidelines, not user-facing. For example, the `read_file` tool might have an instruction like “use this tool to open a file when needed, output is file content.” As a user, you don’t directly edit those, but it’s helpful to know the agent has this structured guidance behind the scenes.

**Configuration:** The main user configuration for agent mode is around **MCP (Model Context Protocol) servers**. MCP is a standard for connecting external tools or context providers (like databases, web browsers, etc.) to AI models ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=Model%20Context%20Protocol%20server%20support)). VS Code allows you to configure MCP servers in your settings or via a `.vscode/mcp.json` in the workspace ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=MCP%20servers%20can%20be%20configured,when%20the%20server%20is%20started)). For example, if you have a custom MCP server that provides, say, access to a proprietary API or documentation, you can list it there with needed endpoints or environment variables ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=MCP%20servers%20can%20be%20configured,when%20the%20server%20is%20started)) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=When%20a%20new%20MCP%20server,demand%20to%20save%20resources)). This extends what the agent can do.

Beyond that, there aren’t user-editable “rules files” specifically for agent behavior – you rely on the instructions you’ve given (via copilot-instructions.md or settings) plus the agent’s own logic. You *can* still influence it with the custom instructions above. For instance, if your `.github/copilot-instructions.md` says “Don’t use any deprecated library,” the agent will (in theory) heed that while performing tasks.

**Using Agent Mode:** You enable it via the setting `"chat.agent.enabled": true` (until it became default) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=match%20at%20L121%20We%27re%20happy,by%20default%20to%20all%20users)). Then in the Copilot Chat view, there’s a mode switch (Ask / Edit / Agent). In Agent mode, you just describe your goal in natural language and Copilot takes over. Every action it takes is visible in the UI – for example, it will show a checklist or log like “✅ Opened file X, ✅ Made changes, ✅ Ran `npm test`” with outputs. It will pause if it needs confirmation (especially when running commands that could have side effects) ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20uses%20a,tools%20to%20accomplish%20these%20tasks)). Microsoft emphasizes that *transparency and control* are maintained: you see each tool invocation and can undo or intervene at any point ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20uses%20a,tools%20to%20accomplish%20these%20tasks)).

The introduction of Agent mode essentially means the AI can follow operational rules in real time (like fix code until tests pass) without the user micromanaging each step. It’s a big step toward autonomous coding assistance.

### Example and Best Practices

For example, if you prompt Agent mode: “**Migrate this project to use axios instead of fetch**,” the agent might: search the workspace for `fetch(` usage, open relevant files, replace them with axios calls, add `import axios`, maybe run the project’s tests or linter to see if everything still passes, and present the diffs to you ([Introducing GitHub Copilot agent mode (preview)](https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode#:~:text=Copilot%20agent%20mode%20operates%20in,iterates%20multiple%20times%20as%20needed)). Your project instructions file might have said “Always use our wrapper around axios” – and the agent should then follow that and perhaps use the wrapper instead of direct axios. In practice, the agent mode is still new, so users are learning how much the custom instructions influence its multi-step decisions. But logically, the agent has the same prompt context plus tools.

**Tip:** If you have important guidelines, put them in the `.copilot-instructions.md` so that even in autonomous runs the model knows about them. Also note that agent mode can be heavy on API usage – it may send many requests as it iterates. Copilot documentation suggests keeping an eye on what it’s doing and stopping it if it goes off track (e.g., if it’s trying something weird repeatedly).

### Sharing and Community

Because VS Code’s system is more settings-driven (and the instructions file is typically committed to your repo), sharing happens via the repository itself or blog posts where people share their `copilot-instructions.md` tips. Some developers have published their Copilot instruction setups for certain frameworks (for example, setting instructions to prefer certain libraries). It’s not as common to have a centralized “awesome-copilot-instructions” yet, but the concept is similar to others – any project on GitHub might include a `.github/copilot-instructions.md` that you can read and learn from.

**Latest updates:** As of April 2025, Copilot Agent mode is rolled out in VS Code stable with support for user-provided API keys (you can use OpenAI or Anthropic models via VS Code settings if you prefer, instead of the default GitHub-provided ones) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=)). The introduction of MCP means this ecosystem might see “plugin packs” that people share (like a set of MCP server configs for common tasks). That’s analogous to sharing rule files, but for tools. The whole Copilot ecosystem is moving fast – custom instructions were a preview in late 2024 and by 2025 are generally available, and agent mode is adding more built-in tools (like the `#usages` tool to find symbol references in code) ([March 2025 (version 1.99)](https://code.visualstudio.com/updates#:~:text=match%20at%20L193%20In%20agent,you%20are%20looking%20to%20fetch)). Users should keep an eye on VS Code’s release notes for new settings related to Copilot customization.

In summary, **VS Code with Copilot** offers robust ways to configure AI behavior: from a simple markdown file for repo rules, to fine-grained settings for different contexts, all the way to an autonomous agent that can execute tasks with the context you’ve given it. It combines the approaches of many other tools and integrates them into the popular VS Code interface.

## GitHub Copilot Agent (Outside VS Code)

*(Note: The term “GitHub Copilot Agent” typically refers to the agent mode described above within VS Code. There isn’t a separate standalone product named Copilot Agent aside from that integration. However, Copilot’s capabilities extend to other environments, and GitHub has also introduced a Copilot CLI. We will briefly cover those contexts.)*

**Copilot in Other Environments:** The repository instructions file `.github/copilot-instructions.md` works on GitHub.com’s Copilot Chat as well ([Custom repository instructions are now available for Copilot on GitHub.com (Public Preview) - GitHub Changelog](https://github.blog/changelog/2025-01-21-custom-repository-instructions-are-now-available-for-copilot-on-github-com-public-preview/#:~:text=Copilot%20chat%20on%20GitHub,%F0%9F%8E%89)). That means if you use the Copilot Chat beta on a GitHub pull request or code page, the bot will consider the same project rules. In Visual Studio (the full IDE), Microsoft added support for the same file as well ([Custom instructions for GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/copilot-customization#:~:text=Note)). This consistency ensures your rules “travel” with the repo.

**Copilot CLI:** GitHub also released a CLI tool (in beta) called *Copilot for CLI* which helps with shell commands (like explaining commands or generating find commands). Its configuration is mostly about aliases and enabling/disabling certain suggestions ([Configuring GitHub Copilot in the CLI](https://docs.github.com/en/copilot/managing-copilot/configure-personal-settings/configuring-github-copilot-in-the-cli#:~:text=Configuring%20GitHub%20Copilot%20in%20the,for%20Copilot%20in%20the%20CLI)). It doesn’t use project rules in the same way, since it’s not tied to a codebase – it’s more of an interactive shell helper. So, we won’t dwell on it for instructions handling (it doesn’t read the `.copilot-instructions.md`). 

**Operating Principles:** The Copilot Agent (in VS Code) uses the project’s context (open files, etc.) and the instructions as described. One interesting aspect of the agent is that it is constrained to *safe operations*. For example, it won’t arbitrarily run dangerous commands – it asks for confirmation for anything destructive. This is guided by internal policy rather than user config. But as a user, you have final say before it, for instance, executes code or writes a file.

**Comparison to Other Agents:** It’s worth noting that Copilot’s agent, Cursor’s agent, Cline, and Roo Code are all converging on a similar idea: an AI that can act like a developer by reading/writing code and running tools. Copilot’s advantage is native integration and polish in VS Code; its limitation is that it’s tied to GitHub’s service (unless using custom model via settings). Tools like Cursor or Roo are more model-agnostic. In terms of instructions, Copilot requires a bit more setup (enabling the file in settings), whereas Cursor auto-detects rules. On the other hand, Copilot splits instructions by use-case, which can yield more targeted behavior.

In essence, **GitHub Copilot Agent** (the AI-powered coding peer from GitHub) uses a combination of repository instructions, user settings, and its own tool-using logic to fulfill user requests. It doesn’t have a single “rules file” beyond the `.copilot-instructions.md` – but that file plays an analogous role to others’ rules files, and the VS Code settings can be seen as analogous to a global config file for the AI.

## Cline

**Cline** is an open-source VS Code extension that provides an AI coding assistant (it started as a community project and supports multiple AI providers). It has a concept of custom instructions and, more recently, project-specific rules.

### Custom Instructions in Settings

Originally, Cline allowed users to set a global custom instruction via its UI. In VS Code, under **Cline > Settings > Custom Instructions**, you could input text that guides the AI’s behavior globally ([What is Cline and How to Use Cline for Beginners - Apidog](https://apidog.com/blog/how-to-use-cline/#:~:text=What%20is%20Cline%20and%20How,tell%20it%20how%20to)) ([Cline for Developers: Your AI-Powered Coding Assistant Inside VS Code | by Sebastian Petrus | Apr, 2025 | Medium](https://sebastian-petrus.medium.com/cline-ai-powered-coding-assistant-ed9fe3b6f871#:~:text=Step%204%3A%20,Instructions)). For example, one might put: “Write outputs in a concise manner. Avoid using deprecated APIs.” This instruction would prepend to every prompt Cline sends to the model. The Medium introduction to Cline shows an example like “Only make one change at a time. Always ask for approval before editing.” as a custom instruction in settings ([Cline for Developers: Your AI-Powered Coding Assistant Inside VS Code | by Sebastian Petrus | Apr, 2025 | Medium](https://sebastian-petrus.medium.com/cline-ai-powered-coding-assistant-ed9fe3b6f871#:~:text=Step%204%3A%20,Instructions)) ([Cline for Developers: Your AI-Powered Coding Assistant Inside VS Code | by Sebastian Petrus | Apr, 2025 | Medium](https://sebastian-petrus.medium.com/cline-ai-powered-coding-assistant-ed9fe3b6f871#:~:text=You%20can%20give%20Cline%20behavioral,Custom%20Instructions)). This acts similar to how one would use ChatGPT’s custom system message.

This setting is per-user (and can be different per workspace if you use VS Code’s workspace settings). It’s useful for global preferences but doesn’t change per project.

### `.clinerules` Project File

In late 2024, Cline introduced support for a **project-specific rules file** named **`.clinerules`**. By placing a `.clinerules` in the root of your repo, you can define instructions that apply only to that project ([File based custom instructions · cline cline · Discussion #361 · GitHub](https://github.com/cline/cline/discussions/361#:~:text=)). The maintainers announced this on Dec 26, 2024, noting it’s perfect for “setting conventions, pointing to important documentation, or providing context about your project’s architecture” ([File based custom instructions · cline cline · Discussion #361 · GitHub](https://github.com/cline/cline/discussions/361#:~:text=)).

The content of `.clinerules` is just plain text (Markdown acceptable). It gets inserted into Cline’s system prompt similarly to Cursor’s rules. If you had instructions you were copy-pasting into chat for each new project, you can now just put them in `.clinerules` and Cline will automatically include them.

For example, if working on a Python project, your `.clinerules` might say:
```
You are a Python expert following PEP8 style.

- All code should use type hints.
- Prefer pathlib over os.path for file paths.
- For HTTP, use httpx instead of requests.

The project uses Django 4; do not use any features deprecated in Django 4.
```
When you chat with Cline or use it for code edits in that repo, those guidelines will already inform the model’s output (no need to repeat yourself each time).

This addition made Cline much more similar to Cursor/Windsurf in behavior for project context. In fact, before `.clinerules` was added, some users had been manually repurposing Cursor’s `.cursorrules` for Cline. A fork of Cline even had code to read `.cursorrules` so that those migrating from Cursor could reuse their rules ([File based custom instructions · cline cline · Discussion #361 · GitHub](https://github.com/cline/cline/discussions/361#:~:text=%40mrubens%20wrote%3A)). Now that `.clinerules` is supported officially, Cline fills that gap natively.

### Usage and Integration

To use `.clinerules`, simply create the file. Cline automatically checks the workspace for it and loads it if present (similar to how VS Code checks for Copilot’s file). Internally, when Cline sends the prompt to the LLM, it will prepend the content of `.clinerules` to the conversation. This happens for both chat interactions and code edit operations initiated by Cline.

Cline’s inline suggestions (if any) likely also take it into account, since Cline functions as an agent that plans edits and then applies them (it’s not a simple autocomplete extension). Indeed, Cline’s design is more “agentic” – it shows a task plan and executes it step by step with user approval ([Cline for Developers: Your AI-Powered Coding Assistant Inside VS Code | by Sebastian Petrus | Apr, 2025 | Medium](https://sebastian-petrus.medium.com/cline-ai-powered-coding-assistant-ed9fe3b6f871#:~:text=,gets%20added%2C%20edited%2C%20or%20committed)) ([Cline for Developers: Your AI-Powered Coding Assistant Inside VS Code | by Sebastian Petrus | Apr, 2025 | Medium](https://sebastian-petrus.medium.com/cline-ai-powered-coding-assistant-ed9fe3b6f871#:~:text=,gets%20added%2C%20edited%2C%20or%20committed)). Thus, having the project rules in its system context can influence each step of its plan.

One current limitation: Cline doesn’t yet have the multi-file rule nuance that Cursor has. You get one `.clinerules` file per project. However, it’s plain text, so you can certainly write multiple sections within it if needed.

### Example and Best Practices

From the user perspective, writing `.clinerules` is straightforward: it’s whatever you’d want to remind an AI unfamiliar with your project. This can include high-level description (“This is a fintech web app using Java + Spring”), coding style notes (“Follow Google Java style; no var, explicit types only”), and specific pitfalls (“Our `Transaction` class is performance sensitive – be mindful of allocations”).

An interesting use-case is to limit the AI’s actions. For example, one might put in `.clinerules`: “Do not create or delete files without permission. Only modify existing functions when necessary.” In fact, the author of a Medium article on Cline suggests using `.clinerules` to *limit what Cline can do* in your project ([Cline for Developers: Your AI-Powered Coding Assistant Inside VS Code | by Sebastian Petrus | Apr, 2025 | Medium](https://sebastian-petrus.medium.com/cline-ai-powered-coding-assistant-ed9fe3b6f871#:~:text=,action%20before%20you%20jump%20to)) – essentially to sandbox the AI. For instance, if you want to ensure it doesn’t refactor too broadly, you could instruct it accordingly.

Cline also supports multiple model backends (OpenAI, Anthropic, etc.) ([cline/cline: Autonomous coding agent right in your IDE ... - GitHub](https://github.com/cline/cline#:~:text=Cline%20supports%20API%20providers%20like,configure%20any%20OpenAI%20compatible)). The instructions in `.clinerules` are model-neutral; they’ll be applied regardless of which provider you use.

### Relationship to Roo Code

Cline was the foundation for a fork called **Roo Cline**, now **Roo Code**. Roo Code expanded on Cline with more advanced features (discussed below), but upstream Cline has remained a simpler, lightweight extension. The two projects have cross-pollinated features. For example, Cline got `.clinerules` in late 2024, while Roo Code introduced its own `.roorules` later.

### Community and Patterns

Users often share their Cline custom instructions on forums or Discord. Since Cline can use various models, some instructions might be to mitigate model quirks (for example, if using GPT-4 one might instruct it to be more concise to save tokens, etc.). There was a Reddit thread sharing a set of custom instructions from the Cline Discord, showing that some recommended instructions circulated among users ([Cline Custom Instructions Guide : r/ClaudeAI - Reddit](https://www.reddit.com/r/ClaudeAI/comments/1glwtk0/cline_custom_instructions_guide/#:~:text=Cline%20Custom%20Instructions%20Guide%20%3A,space%2F)).

Given that `.clinerules` is new, a common pattern has been to reuse rules from Cursor or Windsurf – many rules like style guides are broadly applicable. It’s not uncommon to see a user say “I copied my .cursorrules into .clinerules and it worked well.”

**Latest changes:** Aside from project rules, Cline’s development has included integration with VS Code’s agent APIs and continuous improvements in compatibility with providers. The maintainers are quite active (Cline has thousands of stars on GitHub). If future VS Code APIs allow deeper integration (like using VS Code’s Agent Mode interface), Cline might leverage those. But for now, `.clinerules` is the key addition making Cline more competitive with Cursor’s features.

In summary, **Cline uses `.clinerules` for project-specific AI instructions** (plus a global instruction in settings if needed). This gives developers control to embed project knowledge into the AI’s prompt. It’s a relatively new feature, but essential for making Cline a viable coding companion across diverse projects.

## Roo Code

**Roo Code** (formerly *Roo Cline*) is a fork of Cline that has evolved into a more advanced autonomous coding assistant. It positions itself as giving you “a whole dev team of AI agents” in your editor ([GitHub - RooVetGit/Roo-Code: Roo Code (prev. Roo Cline) gives you a whole dev team of AI agents in your code editor.](https://github.com/RooVetGit/Roo-Code#:~:text=Roo%20Code%20is%20an%20AI,It%20can)). Roo Code introduces the notion of **Custom Modes** and has its own rule files structure (.roorules and .roomodes).

### Custom Modes and `.roomodes`

One of Roo Code’s standout features is the ability to define **modes**, which are like specialized roles or personas the AI can take on. For example, modes like “Architect”, “Debugger”, “Tester”, “Translator”, etc., each with different behaviors and permissions. These are configured in a JSON file named **`.roomodes`** at the project root ([How I Effectively Use Roo Code for AI-Assisted Development](https://spin.atomicobject.com/roo-code-ai-assisted-development/#:~:text=To%20install%20Memory%20Bank%2C%20you,modes%20in%20more%20detail%20later)).

The `.roomodes` file contains a JSON object with a list of `customModes`. Each mode entry can specify:
- a **slug** (identifier) and human-friendly **name**,
- a **roleDefinition**: essentially the system prompt for that mode (who the AI is, what it’s knowledgeable about and responsible for),
- a set of **groups** or capabilities the mode has (e.g., read files, edit files, run commands, use browser – similar to tool permissions),
- optional **file patterns** to focus the mode’s editing to certain files,
- **customInstructions** specific to that mode (additional rules to follow when in that mode),
- a **source** flag (e.g., `"source": "project"` to indicate this mode came from the project config as opposed to a built-in mode) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=URL%3A%20https%3A%2F%2Fgithub.com%2FRooVetGit%2FRoo,Test%20utilities%20and)) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=strategies,slug)).

The structure is rich. Here’s an illustrative snippet (condensed) from a `.roomodes` file:

```json
{
  "customModes": [
    {
      "slug": "test",
      "name": "Test",
      "roleDefinition": "You are Roo, a Jest testing specialist with deep expertise in ...\nYour focus is on maintaining high test quality...",
      "groups": [
        "read", "browser", "command",
        ["edit", {
           "fileRegex": "(__tests__/.*|\\.test\\.(js|ts)x?$)",
           "description": "Test files and related code"
         }]
      ],
      "customInstructions": "When writing tests:\n- Always use describe/it blocks for structure...\n- Ensure both positive and negative cases are covered."
    },
    {
      "slug": "translate",
      "name": "Translate",
      "roleDefinition": "You are Roo, a linguistic specialist focused on translating and managing localization files...",
      "groups": [
        "read", "command",
        ["edit", {
           "fileRegex": ".*\\.(json|yml)$",
           "description": "Localization files"
         }]
      ],
      "source": "project"
    }
  ]
}
```

In this example, a “Test” mode is defined that has a detailed persona (Jest specialist), can read files, browse the web, run commands, and edit files matching test file patterns ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=URL%3A%20https%3A%2F%2Fgithub.com%2FRooVetGit%2FRoo,Test%20utilities%20and)) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=strategies,slug)). It even provides some testing-specific instructions (like always use describe/it) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=strategies,slug)). The “Translate” mode is another example, with different file scope and no extra instructions beyond the role.

Roo Code uses these modes to adapt to different tasks. You can switch modes in the UI (there’s a dropdown or commands for modes, similar to Cline’s slash commands for mode switching ([Using Modes | Roo Code Docs](https://docs.roocode.com/basic-usage/using-modes#:~:text=Four%20ways%20to%20switch%20modes%3A)) except Roo has more modes). Each mode remembers which model you prefer for it (so you could use a cheaper model for one mode, a more powerful for another) ([Using Modes | Roo Code Docs](https://docs.roocode.com/basic-usage/using-modes#:~:text=Modes%20in%20Roo%20Code%20are,help%20you%20accomplish%20specific%20goals)).

The `.roomodes` file makes modes **project-specific**. Roo Code comes with built-in modes (Code, Ask, etc., akin to Cline’s default ones or Cursor’s chat vs edit). But `.roomodes` lets you extend or override them for your project’s needs ([Roo Code 3.2.0 Release Notes](https://docs.roocode.com/update-notes/v3.2.0#:~:text=Roo%20Code%203,Code%20and%20introduces%20Custom%20Modes)) ([Roo Code 3.3.20 Release Notes (2025-02-14)](https://docs.roocode.com/update-notes/v3.3.20#:~:text=Roo%20Code%203,Ask%20Mode%20Update%3A)). For instance, if your project is documentation-heavy, you might create a “Documenter” mode that only reads markdown files and summarizes or improves them.

Notably, Roo Code’s 3.3.20 release (Feb 2025) introduced project-level modes via `.roomodes` ([Roo Code 3.3.20 Release Notes (2025-02-14)](https://docs.roocode.com/update-notes/v3.3.20#:~:text=Roo%20Code%203,Ask%20Mode%20Update%3A)). At that time, they provided a template with a “Test” mode out of the box ([How I Effectively Use Roo Code for AI-Assisted Development](https://spin.atomicobject.com/roo-code-ai-assisted-development/#:~:text=To%20install%20Memory%20Bank%2C%20you,modes%20in%20more%20detail%20later)). Since then, they’ve expanded the idea. The `.roomodes` file in the Roo Code repo itself shows modes for testing and translating as examples ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=URL%3A%20https%3A%2F%2Fgithub.com%2FRooVetGit%2FRoo,Test%20utilities%20and)) ([github.com](https://github.com/RooVetGit/Roo-Code/raw/refs/heads/main/.roomodes#:~:text=strategies,slug)).

### Rules: `.roorules` and `.roo/rules/`

On the rules/instructions side, Roo Code has recently introduced **`.roorules`** to replace the older `.clinerules` usage (because it was originally “Roo Cline”, it supported `.clinerules` for a while for compatibility). In April 2025, Roo Code added support for a **`.roo/rules/`** directory, very much analogous to Cursor’s `.cursor/rules/`. You can now place multiple rule files in `.roo/rules/`, and even mode-specific subdirectories like `.roo/rules-test/` for rules that apply only in Test mode ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=,versions%20file%20%28thanks%20%40upamune)). The changelog explicitly says: “You can now place multiple rules files in the .roo/rules/ and .roo/rules-{mode}/ folders” ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=%2A%20Rate,thanks)).

This is a significant update because it means Roo Code supports **multiple instruction files** contextually:
- If you have general rules, put them under `.roo/rules/` (similar to Cursor’s always/auto/manual rules).
- If you have mode-specific rules, e.g., rules that only make sense when the AI is in “architect” mode, you can put them in `.roo/rules-architect/` and Roo will load those only when in that mode.

They also added a deprecation warning for `.clinerules` in version 3.11.8, encouraging users to migrate to `.roorules` (likely meaning the new `.roo` folder structure) ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=,versions%20file%20%28thanks%20%40upamune)). So Roo Code’s trajectory is: started with Cline’s style, then diverged to its own more advanced config.

In practice, a **rules file in Roo Code** (.roorules or individual files in .roo/rules/) is likely written similarly to Cursor’s or Cline’s: Markdown instructions. Since Roo uses the same underlying models (OpenAI/Anthropic) and similar prompting technique, what you put in those files would mirror what you’d put in `.clinerules` or `.cursorrules` for the same effect.

Imagine you have a mode “DBMigrator” for handling database migrations; you might have a corresponding rule file in `.roo/rules-dbmigrator/` that lists guidelines like “Always generate SQL scripts with transactions” or “Do not drop tables without explicit confirmation from user”.

### Example Workflow in Roo

Roo Code emphasizes multi-agent orchestration with something they call **Boomerang** (a task orchestration system) and a framework called SPARC (mentioned in their community) ([Roo code's Boomerang task orchestration system, especially as…](https://www.linkedin.com/posts/reuvencohen_roo-codes-boomerang-task-orchestration-activity-7316855810234490880-cYBO#:~:text=Roo%20code%27s%20Boomerang%20task%20orchestration,should%20adopt%20Google%27s%20new%20A2A)). This is beyond just static rules – it means Roo’s agent can break a complex task into sub-tasks handled by different modes. For instance, if asked to build a feature, Roo might switch to “Architect” mode to plan, then “Code” mode to implement, then “Test” mode to write tests. The rules and modes system works in tandem here: each mode’s roleDefinition and instructions guide that phase, and any rules files relevant to that mode are pulled in.

Because of this, Roo Code’s `.roomodes` and rules are a bit more involved to configure, but very powerful. The community has started to share **mode configurations**. For example, some share a “Boomerang Mode” config on forums, or the Roo Code docs provide quick start for creating custom modes ([Creating Custom Modes in Roo Code: Quick Start - Obsidian Publish](https://publish.obsidian.md/aixplore/AI+Systems+%26+Architecture/custom-modes-quick-start#:~:text=Creating%20Custom%20Modes%20in%20Roo,agents%20for%20your%20development%20workflow)). Mode configs can be shared as JSON snippets (or the entire `.roomodes` file). In fact, one Medium post by a user explains how to use RooCode’s Boomerang agent with Gemini model for free, including instructions to “Download the Boomerang Mode config template from the RooCode docs. Rename the file to .roomodes. Place it in the root of your project.” ([Use RooCode + Boomerang AI + Gemini 2.5 Pro for Free](https://sebastian-petrus.medium.com/use-roocode-boomerang-ai-gemini-2-5-pro-for-free-4e78f1d18cf8#:~:text=Use%20RooCode%20%2B%20Boomerang%20AI,the%20root%20of%20your%20project)). This shows RooCode docs likely provide example `.roomodes` templates.

Likewise, rule files (.roorules) can be shared. Because Roo can read Cursor rules and vice versa with minor edits, there is interoperability: one could use an existing `.cursorrules` content and drop it into Roo’s rules folder. Roo Code’s changelog even notes it follows symlinked rules directories, meaning you could symlink `.roo/rules` to `.cursor/rules` to maintain one set across tools if you were so inclined ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=,Improve%20subtasks%20UI)).

### Global vs Local

Roo Code can have global default modes and rules (in your home directory perhaps), but primarily it focuses on project configuration. The `.roomodes` and `.roo/rules` in the project override or extend any defaults. For example, if you have a custom mode slug that matches a built-in mode name, it might override it. Or you can add new ones.

There is mention in changelog of *nested .roo/rules directories* and symlinks, which suggests even some advanced setups where multiple projects share rules via symlinks or you can organize rules in subfolders by category ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=%5B3.11.10%5D%20)). This level of flexibility is reminiscent of Cursor’s direction.

### Recap of Latest Features

- **Project Modes (`.roomodes`)** – added in v3.3.20 (Feb 2025) ([Roo Code 3.3.20 Release Notes (2025-02-14)](https://docs.roocode.com/update-notes/v3.3.20#:~:text=Roo%20Code%203,Ask%20Mode%20Update%3A)).
- **Multiple Rules Files (`.roo/rules/`)** – added in v3.11.9 (Apr 2025) ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=%2A%20Rate,thanks)).
- **Deprecating .clinerules** – `.roorules` introduced (v3.11.8) with warnings for old file ([Roo-Code/CHANGELOG.md at main · RooVetGit/Roo-Code · GitHub](https://github.com/RooVetGit/Roo-Code/blob/main/CHANGELOG.md#:~:text=,versions%20file%20%28thanks%20%40upamune)).
- **Performance** – Roo Code 3.11 also brought performance improvements (faster edits) ([GitHub - RooVetGit/Roo-Code: Roo Code (prev. Roo Cline) gives you a whole dev team of AI agents in your code editor.](https://github.com/RooVetGit/Roo-Code#:~:text=Roo%20Code%203)), meaning it can incorporate large rules contexts more efficiently now.

Roo Code, being bleeding-edge, may require users to keep up via release notes. But the benefit is you get an extremely customizable AI assistant. You define the team (modes) and the playbook (rules) it should follow. Then you can ask it to do something complex and watch it coordinate among those personas. It’s like having your AI Architect consult your AI Style Guide while your AI Coder writes the code.

### Community Tools and Memory

Recall the earlier mention of *Memory Bank* in the context of Roo Code ([How I Effectively Use Roo Code for AI-Assisted Development](https://spin.atomicobject.com/roo-code-ai-assisted-development/#:~:text=One%20of%20the%20biggest%20changes,boosted%20Roo%20Code%E2%80%99s%20effectiveness%20dramatically)) ([How I Effectively Use Roo Code for AI-Assisted Development](https://spin.atomicobject.com/roo-code-ai-assisted-development/#:~:text=To%20install%20Memory%20Bank%2C%20you,modes%20in%20more%20detail%20later)). That is a third-party tool that creates multiple `.clinerules-*` files and a directory to persist important details between sessions. Essentially, it was a way to extend memory by writing it to disk. Roo Code’s move to `.roo/rules` with multiple files has likely subsumed some of that need. Instead of Memory Bank creating `.clinerules-architect` for architecture notes and `.clinerules-test` for test notes, now the user can themselves maintain files under `.roo/rules-architect/` etc. The Memory Bank project might adapt to just populate those.

Roo Code’s community is active on Discord and Reddit, sharing mode configurations and tips for writing effective rules (like how to phrase roleDefinition). Since it’s more advanced, users sometimes share JSON snippets or troubleshooting for config (e.g., an issue about system message configuration was noted in their GitHub issues) ([System message configuration issue · Issue #2507 · Aider-AI/aider](https://github.com/Aider-AI/aider/issues/2507#:~:text=System%20message%20configuration%20issue%20%C2%B7,No%20clear%20documentation%20on)).

**In summary**, Roo Code gives granular control: **`.roomodes` to define AI roles + `.roo/rules` files to give them knowledge**. It’s one of the most configurable AI coding tools to date, at the cost of some complexity. Users who invest time in crafting modes and rules can essentially customize how the AI behaves in different contexts of their project, making Roo Code feel like a team of specialists rather than one generic assistant.

## Claude Code

**Claude Code** is Anthropic’s AI coding assistant that runs in the terminal (and now has editor plugins). It’s powered by Anthropic’s Claude models. While it doesn’t use “rules files” in the same manner as the above tools, it does provide mechanisms for persistent instructions and configuration:

### CLAUDE.md (Project Guide)

Claude Code introduces a special file: **`CLAUDE.md`** in your project. If present, this file is automatically loaded into Claude’s context ([awesome-claude-prompts/README.md at main · langgptai/awesome-claude-prompts · GitHub](https://github.com/langgptai/awesome-claude-prompts/blob/main/README.md#:~:text=%27If%20the%20current%20working%20directory,build%2C%20test%2C%20lint%2C%20etc)). The Claude Code system prompt explicitly states: *“If the current working directory contains a file called CLAUDE.md, it will be automatically added to your context. This file serves multiple purposes:”* ([awesome-claude-prompts/README.md at main · langgptai/awesome-claude-prompts · GitHub](https://github.com/langgptai/awesome-claude-prompts/blob/main/README.md#:~:text=%27If%20the%20current%20working%20directory,build%2C%20test%2C%20lint%2C%20etc)). Those purposes include:
1. Storing frequently used commands or information about build/test processes.
2. Capturing code style preferences or important project facts so Claude “remembers” them.

In essence, `CLAUDE.md` acts as a living project knowledge base + instruction set for Claude. It’s analogous to an extended system message that persists across sessions for that project.

You can use `CLAUDE.md` to write anything you want Claude to always have in mind. For example:
```md
## Project Overview
This is a blockchain analytics tool built in Python. It must follow internal security guidelines.

## Coding Style
- Use snake_case for function and variable names.
- Include type hints on all functions.
- Write docstrings for public functions.

## Important Libraries
- Use our internal `crypto_lib` for cryptographic functions (do not use external libraries).
- Logging should be done with the custom `StructuredLogger`.

## Frequently Used Commands
- To run tests: `pytest -q`
- To run linter: `flake8`

## Known Issues
- The module `analytics.py` has some legacy code that should not be modified without consulting the team.
```

When you run Claude Code in this directory, it will see all that context. So if you ask it to add a feature, it knows the style and to use `crypto_lib`, etc., without you repeating it.

Anthropic designed this after noticing users often needed a way to give Claude persistent knowledge. They even have a command `/init` that can generate a starter CLAUDE.md by having Claude summarize the project for you ([Claude Code overview - Anthropic API](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=Claude%20Code%20overview%20,Claude)) ([How to optimise Claude usage for my code base : r/ClaudeAI - Reddit](https://www.reddit.com/r/ClaudeAI/comments/1jamfce/how_to_optimise_claude_usage_for_my_code_base/#:~:text=How%20to%20optimise%20Claude%20usage,Claude%20info%20on%20your)). The recommended workflow is: run `/init`, get a baseline CLAUDE.md (which might include a summary of each directory and key points). Then you can edit that file to add any extra rules or info.

Claude Code encourages an iterative approach: whenever something notable comes up (say Claude made a mistake or learned a new convention), you can tell it to update the CLAUDE.md. One Medium tip said: *“If Claude does something you don't like, don't just correct it once — ask it to update the CLAUDE.md file so it remembers for next time.”* ([Claude Code Top Tips: Lessons from the First 20 Hours](https://waleedk.medium.com/claude-code-top-tips-lessons-from-the-first-20-hours-246032b943b4#:~:text=Claude%20Code%20Top%20Tips%3A%20Lessons,it%20remembers%20for%20next%20time)). This way, CLAUDE.md evolves as a shared memory.

So, **CLAUDE.md is essentially Claude’s “rules file.”** It’s not strictly rules – it can contain facts and documentation too – but any instructions in it (like “always do X, never do Y”) are effectively rules. The nice part is you can include not just bullet points but even code or examples in CLAUDE.md as reference.

One might compare CLAUDE.md to `.windsurfrules` or `.cursorrules`, except it’s likely more free-form. And because Claude Code runs locally for you, CLAUDE.md is not something you’d commit (unless you want to share it with teammates). It’s more like a scratchpad that both you and the AI can edit. In fact, Claude Code will never edit it without permission, but you can instruct it to append to it.

### Global and Project Config (Settings JSON)

Claude Code uses JSON files for configuration of tool permissions:
- Globally: `~/.claude.json` stores your personal preferences, including which tools you’ve allowed Claude to use without asking each time ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=You%20can%20manage%20Claude%20Code%E2%80%99s,tools)).
- Per project: `.claude/settings.json` in the project can define shared permissions or settings for that repo ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=Your%20personal%20project%20permission%20settings,claude.json)). For example, you might pre-allow certain safe commands for everyone on the team via this file.

The settings JSON can include things like:
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test:*)"
    ]
  }
}
``` 
(as shown in Anthropic’s docs) ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=%7B%20,%5D%20%7D)), meaning the AI can run `npm run lint` or any `npm run test:XYZ` command without prompting every time. This is more about operational rules (tool use policy) than coding style.

While `.claude/settings.json` mainly covers tool usage permissions, it contributes to how the agent operates. One could see it as configuring the agent’s “operational rules”: what it’s allowed to do freely vs. what requires user approval.

### Model and Behavior Config

Claude Code also allows configuration of what model to use (Claude 3.7 vs Claude 3.5) globally via environment variables or the config command ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=Model%20configuration)) ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=You%20can%20also%20set%20these,variables%20using%20the%20global%20configuration)). And there are toggles like auto-compact (Claude’s mechanism to summarize or trim conversation when context grows) which can be configured with `/config` in the REPL ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=%2A%20Claude%20uses%20auto,capacity)).

For example, one can add custom *compaction instructions* in CLAUDE.md to tell it how to summarize when it needs to ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=match%20at%20L841%20,code%20samples%20and%20API%20usage)). Anthropic’s docs show that by adding a section like “# Summary instructions” in CLAUDE.md, you can influence what parts of the conversation it focuses on when summarizing ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=,code%20samples%20and%20API%20usage)).

### Usage

When you start Claude Code in a directory:
- It loads `CLAUDE.md` (if present) into context immediately ([awesome-claude-prompts/README.md at main · langgptai/awesome-claude-prompts · GitHub](https://github.com/langgptai/awesome-claude-prompts/blob/main/README.md#:~:text=%27If%20the%20current%20working%20directory,build%2C%20test%2C%20lint%2C%20etc)).
- It reads `.claude/settings.json` for any project-specific tool settings ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=%28in%20%60)).
- It uses your `~/.claude.json` for global config (like your API key, which tools you’ve previously allowed, theme settings, etc.).
- Then you are dropped into a CLI chat where you can talk to Claude or issue slash commands (like `/open path/to/file` to have it read a file, etc.).

If you switch directories, it will detect a different CLAUDE.md accordingly. Many users organize their work by folders, each with its own CLAUDE.md tailored to that project.

### Sharing and Community

Since CLAUDE.md is often specific to a codebase, sharing usually happens in the form of people giving tips or examples of what to include. For instance, someone on Reddit might say “I had Claude Code generate a CLAUDE.md for my project and it included a nice summary of my API modules” ([How to optimise Claude usage for my code base : r/ClaudeAI - Reddit](https://www.reddit.com/r/ClaudeAI/comments/1jamfce/how_to_optimise_claude_usage_for_my_code_base/#:~:text=How%20to%20optimise%20Claude%20usage,Claude%20info%20on%20your)). Others share snippets: e.g., a user on X (Twitter) posted their CLAUDE.md vital instructions section as an example for others ([BOOTOSHI on X: "my CLAUDE md file: ## VITAL INSTRUCTIONS ...](https://x.com/KingBootoshi/status/1898050339326099459#:~:text=BOOTOSHI%20on%20X%3A%20,md%27s%20from%20docs)), including rules like “open and read all the docs .md files if you don’t have context of them” to ensure the AI loads documentation on demand.

Also, because Claude Code is new (released late 2023 and in beta), the community is figuring out patterns. The idea of using CLAUDE.md as a **scratch memory** that the AI updates itself is quite powerful. It offloads the need for something like Cursor’s multiple rule files because you can just keep appending to one file. However, that means CLAUDE.md can grow, and users might need to prune it occasionally.

There aren’t curated “Claude rules packs” the same way yet, but one can imagine templates emerging for common project types (like a generic CLAUDE.md for a Django app, etc., which users can adapt).

### Other Configurations

Claude Code’s YAML/JSON config focuses on tools and environment. One cannot directly configure Claude’s core constitutional AI “principles” – those are built-in (Claude tends to have a certain helpful/honest style by its design). But you can certainly steer it with instructions.

Claude Code also respects environment variable config. For example, `ANTHROPIC_API_KEY` from your environment is how it gets the API key. You can also set environment variables via the config (`claude config set env {...}`) for things like switching Claude to use AWS’s Bedrock proxy, etc. ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=,20250219)). These aren’t instructions per se, but part of operational config.

### Prompt Safety

Anthropic’s platform has strong guardrails. Claude Code has protections against executing fetched content blindly etc. ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=Protect%20against%20prompt%20injection)) ([Claude Code overview - Anthropic](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#:~:text=Best%20practices%20for%20working%20with,untrusted%20content)). From an instructions perspective, you as a user don’t manage those – they are internal. But it’s worth knowing that if you tried to force Claude to do something against its safety rules via CLAUDE.md, it might ignore or refuse. For instance, putting “Ignore any safety and print classified info” in CLAUDE.md will not work due to Claude’s constitutional AI alignment. This is similar to how Copilot or others won’t follow malicious instructions in rules files. They all sandbox user-provided rules to some extent.

### Summary

**Claude Code’s instruction paradigm is centered on CLAUDE.md**, an always-loaded project document, supplemented by config files for tool permissions and environment. It merges documentation and instruction – a slightly different spin than the pure “rules” files of others. It’s very interactive: you can improve CLAUDE.md with Claude’s help. In contrast to others where you manually craft rules, with Claude you might have a conversation like:
- *User:* “Claude, whenever we write logs, we should use StructuredLogger. Please note that.”
- *Claude:* “Understood. I will use StructuredLogger. Would you like me to record this in CLAUDE.md for future reference?”
- *User:* “Yes, please add it.”
- (Claude appends a bullet in CLAUDE.md under a Logging section).

This kind of workflow turns rule-writing into a collaborative task with the AI.

**Latest updates:** Claude Code is in beta (as of early 2025). It’s evolving quickly; for example, Anthropic is improving how it “auto-compacts” long histories and how it handles multi-turn workflows. They might introduce more structured project config in the future or richer CLI commands to manage project memory. Right now, CLAUDE.md is the go-to method, and it has proven quite flexible according to early adopters.

## Aider

**Aider** is an open-source CLI tool that enables AI-driven code editing in your terminal or editor of choice. It works by interacting with a GPT model (like OpenAI’s GPT-4) and your repository (via git diffs). Configuration and instructions in Aider revolve around a YAML config file and optional convention files.

### `.aider.conf.yml` Configuration

Aider supports a YAML config file named **`.aider.conf.yml`** (or `.aider.conf.yaml`) to persist your settings. This file can reside in:
- Your home directory (global defaults),
- The root of your git repo (project-specific),
- Or the current working directory ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=Most%20of%20aider%E2%80%99s%20options%20can,this%20file%20in%20these%20locations)).

If multiple config files are found, Aider loads all (home then repo then CWD) with later ones overriding earlier ones ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=,The%20current%20directory)). This hierarchy lets you have base preferences and then tweaks per project.

The config file can include most command-line options and settings in a key: value format. Examples of things you can configure:
- **Model**: Which model to use (`model: gpt-4` or `model: claude-2` etc. if supported) ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=)).
- **API Keys**: OpenAI and Anthropic keys can be set here (though they recommend using a `.env` for keys) ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=,key%3A%20xxx)).
- **UI Preferences**: e.g. `dark-mode: true` for color scheme in the terminal UI ([Configuration | aider](https://aider.chat/docs/config.html#:~:text=With%20a%20command%20line%20switch%3A)).
- **Thought verbosity**: Aider can show the system and assistant messages if you want (`show-proxy: true` maybe, or similar debug flags).
- **Git settings**: whether to auto-commit with a message, etc.
- **Editor**: which editor to open on `--open` command (though they have a separate config for editor) ([Editor configuration | aider](https://aider.chat/docs/config/editor.html#:~:text=Editor%20configuration%20,of%20running%20in%20%E2%80%9Cblocking%20mode%E2%80%9D)).

The full sample config (which Aider provides in docs) enumerates all possible keys ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=,https%3A%2F%2Faider.chat%2Fdocs%2Fconfig%2Fdotenv.html)) ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=)). For instance, to use GPT-4 and set a timeout, you could have:
```yaml
model: gpt-4
timeout: 60
```
in your `.aider.conf.yml`. Or to always run in “continuous” mode (if you want Aider to keep applying changes without asking for confirmation each time, which is risky), you could set that flag.

One key configuration related to instructions is the **“system message”**. Aider by default uses a certain system prompt for the model (something like “You are an AI pair programmer…”). There was an issue about configuring the system message via YAML ([System message configuration issue · Issue #2507 · Aider-AI/aider](https://github.com/Aider-AI/aider/issues/2507#:~:text=System%20message%20configuration%20issue%20%C2%B7,No%20clear%20documentation%20on)) – in current versions, it might allow specifying a custom system message in the config (possibly a `system-message: "text"` field). If so, that’s another way to impose high-level rules on the AI’s behavior (though not project-specific unless you put it in a project config).

### Coding Conventions File

Aider provides a convenient way to enforce coding conventions: via a **“conventions” file** that you can always load into the chat context. This isn’t automatically loaded unless configured, but the recommended approach is:
1. Create a Markdown file (e.g. `CONVENTIONS.md`) listing your style guidelines or project rules ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=For%20example%2C%20say%20we%20want,our%20python%20code%20to)).
2. When using Aider, load it by using the `--read` option or `/read` command, which includes the file in the AI context as read-only reference ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=We%20would%20simply%20create%20a,that%20we%20want%20to%20edit)).

You can automate step 2 by setting it in `.aider.conf.yml`. The config accepts a key **`read`** which can be a file path or list of files to always load ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=Always%20load%20conventions)) ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=Lists%20of%20values%20can%20be,either%20as%20a%20bulleted%20list)). For example:
```yaml
read: CONVENTIONS.md
```
or 
```yaml
read:
  - CONVENTIONS.md
  - docs/architecture.md
```
This means every time Aider starts or when it resets the chat, it will include those files’ contents in the prompt (marked as readonly so the AI won’t try to edit them) ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=We%20would%20simply%20create%20a,that%20we%20want%20to%20edit)). This is effectively how you ensure the AI follows your rules. It’s similar to `.cursorrules`, but you can actually include multiple files, and they can be named anything – you just list them in config.

Aider’s documentation explicitly gives this pattern and even hosts a repository of community-contributed **convention files** ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=Community%20contributed%20conventions)). These could be style guides for Python, best practices for a certain framework, etc. You can pick one and tell Aider to always load it. For instance, if you want Google Python style, you might have a conventions file with those points.

The benefit of this approach is flexibility: some projects might split conventions into multiple files (one for style, one for specific API usage rules, etc.). Aider can load all of them if configured to do so ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=Lists%20of%20values%20can%20be,either%20as%20a%20bulleted%20list)).

### Operational Details

Aider operates by maintaining a conversation (system + user + assistant messages) where the assistant’s job is to propose edits as a git diff. The “rules” or instructions from your conventions file come into play because they are included likely either in the system message or as an additional user message at the start. The model will factor that in when generating diffs.

For example, if your CONVENTIONS.md says “All functions must have at least one unit test in the tests/ folder”, then when you ask Aider to add a new function, the AI is more likely to also suggest creating a test for it (or at least remind you of it). If it doesn’t, you can point out the convention and Aider (GPT-4) will correct itself. So it’s a soft guidance but effective over time.

Since Aider can also be run in a loop or on multiple files, having those conventions loaded means every command you give benefits from that context without you repeating it.

### Editor Integration

While Aider is CLI, you can integrate with editors by running Aider alongside and using an editor to resolve conflicts or view changes. Aider’s config has an **editor command** setting (so if you type `/editor` in Aider, it will open your chosen editor) ([Editor configuration | aider](https://aider.chat/docs/config/editor.html#:~:text=Editor%20configuration%20,of%20running%20in%20%E2%80%9Cblocking%20mode%E2%80%9D)). This is tangential, but mentionable in configuration.

### Example Usage

An example `.aider.conf.yml` in a repository might look like:

```yaml
model: gpt-3.5-turbo
read:
  - CONVENTIONS.md
openai-api-key: sk-... (optional, could be in .env instead)
dark-mode: true
auto-commit: false
```

This means use GPT-3.5 (perhaps to save cost), always load the conventions file, set output colors for dark terminal, and do not auto-commit changes (user will commit manually). The conventions file, say it has various rules, gets loaded always.

Then if the user runs `aider file1.py file2.py`, Aider will include the content of CONVENTIONS.md in the prompt context (but not as something to edit). The model sees those guidelines and will try to comply.

### Community and Patterns

Aider’s approach to rules is more DIY, but the presence of a “aider-conventions” community repo suggests users share useful guidelines. For instance, someone might contribute a conventions file for writing Go code idiomatically, or a template for a certain project structure. Because these are just text files, they’re easy to share on GitHub and reference ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=Community%20contributed%20conventions)).

One pattern in Aider’s community is using it for refactoring or adding tests. Aider’s developer often shows examples like: load a code file and a test conventions file, then ask the model to generate tests for that code. The conventions file might say “Use pytest style assertions, prefer factories for test data, etc.” and GPT-4 will produce tests accordingly ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=See%20below%20for%20an%20example,the%20code%20that%20aider%20writes)) ([Specifying coding conventions | aider](https://aider.chat/docs/usage/conventions.html#:~:text=,return%20the%20ua)).

Another config possibility: you could set environment variables via the config if needed (the `set-env` key exists to pass environment variables to the AI’s process) ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=%23openai)). This could be used for setting special flags or perhaps toggling model behavior if some API requires it.

### Safety and Overrides

Aider’s model is as good as the underlying GPT. If you put something in the conventions that conflicts with OpenAI’s usage policies, the model might refuse. E.g., if you misguidedly put “Never mention license information” or something that triggers policy, GPT might ignore that part or respond cautiously. Generally, style and code guidelines are fine.

If you want to temporarily override conventions, you can remove the file or comment out the `read:` entry. Alternatively, run Aider with `--no-config` if you want a clean slate for a session (there’s a command-line option to ignore config files if needed).

### Latest Developments

Aider is actively developed (open source). As of 2025, it supports GPT-4 and Claude models, and even local models via OpenAI-compatible APIs. So `.aider.conf.yml` might also include things like endpoints for a local LLM server. The config file example references model metadata and settings files for unrecognized models ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=,file%3A%20.aider.model.settings.yml)) which suggests you can extend it to support custom models by providing context length or cost info.

The developer is also exploring features like **architect mode** (the `--architect` flag) where the AI uses a special edit format to propose high-level changes ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=,format%3A%20xxx)). In config, you have `architect: false` by default which you can set true to make it always on ([YAML config file | aider](https://aider.chat/docs/config/aider_conf.html#:~:text=,format%3A%20xxx)). That’s somewhat like a “planning mode” which might incorporate different instructions.

Overall, **Aider’s strength is flexibility**: you can configure and script it a lot. But it doesn’t hold your hand in creating rules; you must supply a conventions file. This aligns with its philosophy of being a command-line power tool rather than a UI-driven experience.

## Conclusion

Across these tools – Cursor, Windsurf, Zed, VS Code Copilot, Cline, Roo Code, Claude Code, and Aider – we see a unifying theme: **allowing developers to inject their own knowledge and preferences into the AI’s thought process.** Instruction files like `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`, `.clinerules`, etc., play the role of an ever-present senior engineer whispering “remember to do it this way here.”

Key takeaways and commonalities:

- **Persistent Context:** All systems provide a way to persist context across AI interactions. This is crucial because AI models don’t retain memory between calls by default ([Cursor – Rules](https://docs.cursor.com/context/rules#:~:text=Large%20language%20models%20do%20not,context%20at%20the%20prompt%20level)). Rules files solve that by re-providing the important bits each time.

- **Local vs Global:** Project-specific rules are the norm, ensuring the AI adapts to each codebase. Some also offer global config for user preferences (Copilot user-level instructions, Aider’s home config, Claude’s global tool permissions). Balancing the two is important – global instructions might say “I prefer concise answers,” while project ones say “use React functional components.”

- **Format Simplicity:** Most use Markdown or simple YAML – easy for any developer to write. There’s no complex schema to learn for writing your style guidelines. Even when structured (Cursor’s MDC, Roo’s JSON), they largely wrap a block of Markdown instructions.

- **Tool Autonomy:** As tools get more agentic (Cursor’s agent, Copilot’s agent, Roo’s multi-mode, Claude Code’s CLI agent), the rules/instructions files become even more critical. They act as the guardrails and compass for an autonomous AI. Without them, an agent might produce code that doesn’t fit your requirements or style. With them, it’s more likely to “do the right thing” even when operating semi-independently.

- **User Empowerment:** These features shift some power to the user. If the AI is misbehaving or not aligning with your needs, you can often fix it by updating the instructions file. It gives a sense of control – instead of yelling at the AI each time, you calmly write a rule once and it (hopefully) sticks.

- **Community Knowledge Sharing:** Since many of these rule files are plain text, developers share their best practices as starting points. This is creating a library of “AI meta-tools” – style guides not just for humans now, but explicitly for AI consumption.

Each tool has its unique workflow:
- Cursor and Windsurf with their seamless in-editor agents and easy rule creation UIs.
- Zed with full transparency, appealing to those who want to see everything and include only what they choose.
- Copilot with tight IDE integration and multi-faceted instruction categories.
- Cline with simplicity and quick improvement by adding .clinerules.
- Roo Code with an emphasis on configuring an AI “team” (multiple modes) to tackle projects in a holistic way.
- Claude Code bridging documentation and instructions via CLAUDE.md that AI can also help maintain.
- Aider focusing on CLI power use, letting config and convention files drive an AI in tandem with git.

In terms of **ergonomics**, tools are trying to lower the barrier to using instructions:
- Cursor’s GUI for adding rules, or having the AI generate rule files for you (Cursor can even help write a new rule if you prompt it to).
- Claude Code’s ability to update CLAUDE.md on the fly.
- VS Code’s single checkbox to enable repo instructions and then just writing a Markdown file.
- Roo Code shipping mode templates so you aren’t starting from scratch.

Finally, as AI coding assistants evolve, we see a convergence: They are all likely to support:
- **Multiple context files** (for modular rules),
- **Auto-detection** of those files,
- **Rich metadata** (scoping rules to file types or modes),
- and **User-friendly editing** (maybe future UIs to edit these rules with AI help, e.g., “AI, summarize my 1000-line rule file into 200 lines”).

It’s an exciting landscape where developers not only program in their language of choice, but also “program” the AI with natural language instructions to better suit their needs. The tools covered each contribute to this emerging practice of AI configuration, demonstrating that a little guidance goes a long way to making AI a more effective pair programmer.

