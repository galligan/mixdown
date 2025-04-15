# Planning Template

## IMPORTANT

- ✅ For task within a phase that require the user's input, review, approval, or actions they must take, set it up as its own task in the sequence. Prefix the title with `[USER]`
  - For these user-tasks, provide the user with a clear set of instructions and necessary information so they may complete the task.
  - Do not proceed with the next task until the user has completed their task and provided you with confirmation of the results.
  - Example: `[USER] Set up API keys for <service>`

## User-task Interaction Example

~~~xml
<interaction>
  <agent>
    For this next step, you'll need to go to {{URL}} to set up the API keys. I'll provide you with the instructions and required information. Let me know once you've completed the task.
    
    **Required API Keys:**
    - API Key for authentication service
    - API Key for data service
    - Secret key for encryption
    
    **Setup Instructions:**
    1. Log into the {{ Service name destination }} at {{ Service URL }}
    2. Navigate to {{ Settings > API Keys }}
    3. Generate new keys for each service listed above
    4. Copy each key to your .env file using the following format:
       ```
       AUTH_API_KEY=your_key_here
       DATA_API_KEY=your_key_here
       ENCRYPTION_SECRET=your_secret_here
       ```
    
    Please let me know once you've generated and saved these API keys.
  </agent>
  <user>
    Ok, I'll go set that up now.
  </user>
  <user>
    I've set up the API keys.
  </user>
  <agent>
    Great! I'll update the tasks list to reflect that you've completed the task.

    {{ Update scratchpad, await confirmation, and then proceed to next task }}
    
    ✅ Ok that's done. Now, let's move on to the next step.
  </agent>
</interaction>
~~~

`````md
# YYYY-MM-DD Plan: {{TITLE}}

## Overview

- **Objective:** {{Clear statement of what this plan aims to accomplish}}
- **Scope:** {{Boundaries and limitations of the plan}}
- **Expected Outcome:** {{What success looks like when implemented}}

## Prerequisites

- {{ Required tasks to complete by the user }}
  - [In Phase {{ phase_number }}](#link-to-section-in-plan):
    - {{ User task title }}: {{ User task description }}
    - ...
  ...
- {{Required components, tools, or dependencies}}
- {{Required access or permissions}}
- {{Required knowledge or skills}}
- {{References to other plans or documents}}

## Background Research

{{Summary of research findings relevant to this plan. Include sources, key considerations, and alternatives evaluated.}}

### Key Findings

- **{{Finding 1}}:** {{Details}}
- **{{Finding 2}}:** {{Details}}
- **{{Finding 3}}:** {{Details}}

### Alternatives Considered

| Option | Pros | Cons | Decision |
|--------|------|------|----------|
| {{Option 1}} | {{Pros}} | {{Cons}} | {{Selected/Rejected}} |
| {{Option 2}} | {{Pros}} | {{Cons}} | {{Selected/Rejected}} |

## Implementation Plan

### Dependencies and Sequence

{{Visual or textual representation of task dependencies and optimal sequence}}

### Phase 1: {{Initial Setup/Preparation}}

1. {{Step description}}
   - **Complexity:** {{Low/Medium/High}}
   - **Dependencies:** {{Any prerequisite steps or conditions}}
   - {{Details or sub-steps}}
   - {{Command examples}}

   ```bash
   # Example command
   command --option value
   ```

2. {{Step description}}
   - **Complexity:** {{Low/Medium/High}}
   - **Dependencies:** {{Any prerequisite steps or conditions}}
   - {{Details or sub-steps}}

### Phase 2: {{Core Implementation}}

1. {{Step description}}
   - **Complexity:** {{Low/Medium/High}}
   - **Dependencies:** {{Any prerequisite steps or conditions}}
   - {{Details or sub-steps}}
   - {{Potential challenges or edge cases}}
2. {{Step description}}
   - **Complexity:** {{Low/Medium/High}}
   - **Dependencies:** {{Any prerequisite steps or conditions}}
   - {{Details or sub-steps}}

### Phase 3: {{Verification and Testing}}

1. {{Step description}}
   - **Success criteria:** {{How to determine if this step succeeded}}
   - {{Details or sub-steps}}
2. {{Step description}}
   - **Success criteria:** {{How to determine if this step succeeded}}
   - {{Details or sub-steps}}

## Technical Considerations

### Docker Configuration

{{Specific Docker-related considerations, volumes, networks, etc.}}

### Security Considerations

{{Security-related considerations, best practices, and safeguards}}

### Performance Considerations

{{Performance-related considerations, resource requirements, limits}}

## Verification Process

{{How to verify the implementation was successful}}

1. {{Verification step}}
   - {{Expected result}}
2. {{Verification step}}
   - {{Expected result}}
3. ...

## Proposed Tasks

- [ ] 1. {{Task 1 title}}
  - {{Description}}
  - **Complexity:** {{Low/Medium/High}}
  - **Dependencies:** {{List any dependencies on other tasks}}
  - **Potential challenges:** {{Specific challenges or edge cases}}
  - **Subtasks:**
    - [ ] {{Subtask 1 title}}
      - {{Description}}
      - **Complexity:** {{Low/Medium/High}}
      - **Dependencies:** {{List any dependencies on other subtasks}}
      - **Potential challenges:** {{Specific challenges or edge cases}}
    - ...
- [ ] 2. {{Task 2 title}}
  - {{Description}}
  - **Complexity:** {{Low/Medium/High}}
  - **Dependencies:** {{List any dependencies on other tasks}}
  - **Potential challenges:** {{Specific challenges or edge cases}}
- [ ] 3. {{Task 3 title}}
  - {{Description}}
  - **Complexity:** {{Low/Medium/High}}
  - **Dependencies:** {{List any dependencies on other tasks}}
  - **Potential challenges:** {{Specific challenges or edge cases}}
- ...

## References

- {{Reference 1}}
- {{Reference 2}}
- {{Reference 3}}
- ...

## Appendix

{{Additional information, code snippets, configuration examples, etc.}}

`````
