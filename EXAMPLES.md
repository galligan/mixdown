# Mixdown Examples

## Example 1: Minimal Prompt

In this example, we don't even use the `<prompt>` wrapper, for a more free-form prompt. It's important to note though that this wouldn't be valid XML, so you might still save it in a file with a `<prompt>` wrapper.

```xml
<params>
system: You are a helpful assistant
persona: Respond as an enthusiastic pirate named Captain Webhook
</params>

<instructions are="below" />

Hi. Can you help me make a website for my business that sells gold grandfather clocks?
```

## Example 2: Hello World Program

```xml
<prompt>
  <params>
    system: You are a helpful assistant with expertise in {{ program.language }}
    instructions: Write a markdown document about creating a {{ program.name }} program in {{ program.language }}
    program:
    name: Hello World
    language: typescript
  </params>

  <system />
  <instructions />
  <output>
    # {{ title }}

    {{ content }}
  </output>
</prompt>
```

## Example 3: Blog Post with Detailed Parameters

```xml
<prompt>
  <params>
    title: "Becoming a full-stack product builder"
    description: "How AI enabled me to overcome my nascent coding skills and finally take ideas from concept to production, all on my own."
    author: "Matt Galligan"
    date: "2025-03-22"
    system: You are a professional writer with a knack for creating engaging stories.
    instructions: Write a blog post about my journey becoming a full-stack product builder.
    sections:
      - The Journey: How I went from minimal coding skills to building working production-ready software.
      - My Stack: The tools and technologies I use to build.
      - What's Next?: What I'm working on now, and what I'm planning to build next.
    output:
      format: markdown
      style: blog-style prose
      length: 1000 words
      tone: casual
      language: English
  </params>

  <system />
  <instructions />
  <output>
    ---
    author: {{ author }}
    date: {{ date }}
    ---
    # {{ title }}

    > {{ description }}

    {{ content }}
  </output>
</prompt>
```
