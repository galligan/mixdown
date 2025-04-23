# Working title: One Prompt to Rule Them All: Why I'm Building Mixdown

I spend most of my day inside **Cursor**, asking an AI to sketch ideas, refactor a method, or sanity-check a migration. It's magical—until the moment I want to use **Roo Code** for more autonomous agent-driven programming, or fire up **Claude Code** in Termius on my iPhone while I'm on the move.

Every tool wants its own rules and instruction systems, each with its own little quirks:

- Cursor uses individual Markdown-formatted `.mdc` "rules" in `.cursor/rules`
- Roo Code is similar, but introduces "Modes" and other things, which don't all have a 1:1 mapping to Cursor rules
- Claude Code is a lot of fun to use, but has its own CLAUDE.md file, with special "slash commands" in `.claude/commands`

After the 1,000th copy-paste-tweak cycle I realized: **I'm version-controlling boilerplate, not knowledge.** Maybe if I update "always keep track of your progress in tasks.md" in Cursor, I might forget to change it in Roo. If I add new project-specific coding guidelines, I'm diff-hunting three random folders to see where it belongs.

That's when the idea for **Mixdown** clicked.

I borrowed the name from music production, where a "mixdown" is that magical moment when a chaotic pile of individual tracks finally becomes the cohesive song everyone will hear. And that's exactly what this tool does: it takes my jumbled prompt rules and transforms them into something clean that every AI agent can understand.

Think of it as **"Terraform for AI prompts"**—declare your ideal prompts once, target dozens of coding agents, and guarantee every teammate (human or bot) runs with the same authoritative instructions. No copy-paste, no drift, just high-quality, version-controlled context.

The idea is simple: you create one "mix" (your gold-master prompt), and Mixdown generates the correct "artifacts" (tool-specific files) for each AI tool.

## Itch, meet scratch

1. **Context drift**
    - I want every AI coding agent to share the *same* core rules so they behave predictably.
2. **Zero-copy edits**
    - I should be able to update one file and trust it shows up everywhere—like Terraform does with infra.
3. **Try new tools guilt-free**
    - "Will I spend an hour porting my prompts?" should never stop me from test-driving the hot new agent dev tool everyone's talking about.

## The shape of the solution

Mixdown is a CLI + Node library that lets me:

- **Write one "gold-master" prompt** (I call it a *mix* and it's just Markdown with some fancy syntax).
- Specify which things might go to Cursor, Roo, Claude Code, etc.
- Hit `mixdown build` and watch it spit out each tool's native rule files in the right place.

That's it.

## Who is Mixdown for?

- **Indie hackers** juggling multiple AI coding agents across different tools.
- **Teams** that want every developer—and every agent—to share the same authoritative coding standards.
- **Tinkerers** who like installing a new CLI-based agent on Friday without rewriting their entire stack by Monday.

## What's next

The core spec is nailed down, the open-source repo is live, and I'm dog-fooding it on my own projects this month. Early testers and nit-pickers are welcome—especially if you use a niche agent Mixdown doesn't support yet.

Because the end-game is simple: **one prompt, thirty tools, zero drift.**  Then we all get to spend our time solving problems, not playing "find-and-replace" with rule files.
