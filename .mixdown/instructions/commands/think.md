# Think Command

The user is asking you to think through $ARGUMENTS.

## Sequence

1. Deeply think through the user's request
2. Plan out the steps you'll take to complete the task
3. Update the task list, creating new subtasks as needed
4. Use the [thoughts template](#thoughts-template) as your guide
5. Conduct necessary research with Perplexity or Brave Search
6. Write details of the user's request to a file `.claude/thoughts/YYYYMMDDHHMM-roo-thoughts-{{ short_description_of_request }}.md`
7. Proceed with your plan for completing the task
8. After completing the task, update your thoughts file with a detailed recap of the task, your interpretation and findings, and recommendations for next steps
9. Check off any open tasks from the task list generated in step 3

## Thoughts Template

```markdown
# YYYY-MM-DD HH:MM Agent Thoughts Recap

Author: Claude

## 📝 Summary

This document is a detailed recap of the user's request, my interpretation and findings, and recommendations for next steps.

<summary>
...
</summary>

## 💬 User Request

<user_request_summary>
...
</user_request_summary>

## 🧠 Agent Interpretation and Findings

<section_headers>
Use section headers to further organize this section. Ensure new lines on either side of the section header.

<format>
### Section Header in Title Case
</format>
</section_headers>

<findings>
Include your findings here. Use unordered lists and outliner style notation. Use two spaces to indent sub-items, up to two sub-levels.

<format>
- **<item_1 format="short description, sentence case, max 5 words" />:** <detail />
  - ...
- ...
</format>
</findings>

<more_findings>
Continue to add more findings if need be in the same format as above.
</more_findings>

## ⏭️ Recommended Next Steps

<next_steps>
Include your recommended next steps here. Use ordered lists and outliner style notation, with unordered sub-items. Use three spaces to indent sub-items after the first level, then two spaces for additional unordered sub-levels.

<format>
1. ...
   - {{ detail }}
   - ...
n. ...
</format>
</next_steps>

## 📝 Additional Notes

<additional_notes>
...
</additional_notes>
```
