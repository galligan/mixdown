# Research Command

You'll perform thorough research on the topic provided in $ARGUMENTS, create a well-structured research report, and save it to the notes directory.

## Context

This homelab-stack project is a Docker-based home server setup that includes various self-hosted services. The system uses:

- Docker Compose for container orchestration
- Tailscale for networking
- Organized directory structure for services

## Instructions

1. First, interpret the research topic from $ARGUMENTS
2. Create a concise, descriptive title based on this interpretation
3. Search for information on the topic using Perplexity MCP
4. If specific URLs are mentioned, fetch their content using Firecrawl MCP
5. Analyze all collected information
6. Create a comprehensive research report that includes:
   - Summary of findings
   - Key considerations for implementation
   - Technical requirements
   - Recommended approach
   - Links to relevant documentation
   - Configuration examples where applicable

## Output Format

First, create a clean, descriptive title based on the research topic. For example:

- "adding open webui" → "Open WebUI Integration"
- "tailscale subnet routing" → "Tailscale Subnet Routing Configuration"

Then create a Markdown file at `/Users/mg/Developer/homelab-stack/notes/research-${CLEAN_TITLE}.md` where ${CLEAN_TITLE} is a slugified version of your descriptive title (lowercase, spaces replaced with hyphens).

The report should have the following structure:

```md
# Research: [Descriptive Title]

## Overview

[Brief description of the topic]

## Findings

[Detailed research findings]

## Implementation Considerations

[Factors to consider when implementing]

## Technical Requirements

- [Requirement 1]
   - [Detail 1]
   - [Detail 2]
   - ...
- [Requirement 2]
   - ...
- ...

## Recommended Approach

1. Step 1: [Description of step 1]
   - [Reasoning for step 1]
   - [Any validation needed]
   - [Any additional considerations]
2. Step 2: [Description of step 2]
   - [Reasoning for step 2]
   - [Any validation needed]
   - [Any additional considerations]
3. ...

## Resources

- [Links to documentation and references]

## Configuration Examples

### [Example 1]

[Code or configuration examples if applicable]

### ...
```

Use your knowledge of Docker, networking, and self-hosted services to ensure the research is relevant to this homelab environment.

At the end of your response, confirm the creation of the research document and provide its path.
