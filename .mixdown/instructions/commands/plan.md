# Plan Command

This command helps you develop comprehensive planning documents with sequential steps, research-based guidance, and actionable task creation for implementation projects.

## Instructions

Create a detailed planning document for: $ARGUMENTS

The planning document will:

1. Break down the request into specific, actionable tasks
2. Determine the optimal sequence for completing these tasks
3. Identify potential dependencies, edge cases, and challenges
4. Estimate complexity and requirements for each step
5. Create a detailed, step-by-step plan before beginning implementation

### IMPORTANT

- ✅ Use Firecrawl MCP's tools (deep research, search, crawl, scrape) over fetch
  - If Firecrawl deep research doesn't provide the information you need, use Perplexity MCP to search for authoritative information
  - Brave Search + Fetch MCP servers can be a good fallback solution
- ✅ ALWAYS use the provided [output format](#output-format)

## Steps

### Step 1: Initial Assessment

Before creating a plan, I'll carefully analyze the request by:

- Breaking down the user's request into specific, actionable components
- Thoroughly understanding the objective and scope
- Identifying key technical components involved
- Determining what information is needed for proper planning
- Reviewing existing documentation to avoid duplication

### Step 2: Repository Search

I'll search for existing documentation related to this plan:

- Check `./.agent/notes/plans/` for similar planning documents
- Review `./docs/` for relevant technical information
- Examine `./.agent/notes/research/` for research documents and related notes
- Look for any configuration examples or templates

### Step 3: Requirements Clarification

If the planning requirements aren't fully clear, I'll:

- Identify specific ambiguous areas requiring clarification
- Ask focused questions to gather missing critical information
- Present initial assumptions for validation or correction
- Outline scope boundaries based on current understanding

### Step 4: Research Phase

For technical components requiring investigation, I'll:

- Use MCP search tools (Firecrawl, Perplexity, Brave Search) to conduct research
- Focus research on Docker-specific implementation details
- Use Firecrawl MCP to generate a LLMs.txt file for the service's documentation
  - Save as `./docs/llmstxt/{service_name}-llms.txt`
- Investigate compatibility with existing architecture & services
  - Include those still in the planning phase e.g. `./docs/plans/`
- Document relevant configuration approaches and best practices
- Identify potential edge cases and challenges for each component
- Estimate resource requirements for implementation

### Step 5: Plan Development

I'll create a structured plan with:

- Clear, descriptive title with date prefix: `YYYY-MM-DD-plan-name.md`
- Task overview explaining the objective and expected outcome
  - IMPORTANT: Do not yet create the tasks. Instead, create a list of tasks in the plan document.
- Prerequisites listing required components, access, or knowledge
- Step-by-step implementation process with optimal sequencing
- Dependencies between steps clearly identified
- Complexity estimates for each major step or component
- Alternative approaches with pros/cons when relevant
- Technical considerations specific to your environment
- Implementation examples and code snippets
- Expected outcomes and verification methods

### Step 6: Task Integration

After the plan is complete, I'll:

- Ask if you want to create tasks based on the plan
- Identify logical breaking points for separate tasks
- Reference specific plan sections in each task
- Use relevant `task-master` commands to create tasks
  - See [dev workflow rule](.cursor/rules/dev_workflow.mdc) for how to use task master

### Step 7: Plan Management

For long-term organization:

- Save the plan to `./.agent/notes/plans/YYYY-MM-DD-plan-name.md`
- Commit the changes when completed
- After implementation, move to `./.agent/notes/plans/.archive/`
- Update references in task list to point to archived plan
- Add any new documentation created during implementation

## Output Format

IMPORTANT: The planning document must follow the [planning template](.ai/templates/template-plan.md) format.
