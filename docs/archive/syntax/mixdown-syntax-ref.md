# Mixdown Syntax Reference

This document provides a comprehensive reference for Mixdown syntax, including all supported tags, attributes, and formatting conventions.

## Table of Contents

- [Core Structure](#core-structure)
- [Tags Reference](#tags-reference)
- [Variable Interpolation](#variable-interpolation)
- [Attributes Reference](#attributes-reference)
- [Data Formats](#data-formats)
- [Best Practices](#best-practices)

## Core Structure

Mixdown combines XML-like tags, YAML data, and Markdown formatting. Here's the basic structure:

```xml
<prompt>
  <meta>
    <!-- Optional metadata about the prompt -->
  </meta>
  <params>
    <!-- Parameters and configuration -->
  </params>
  <system>
    <!-- System instructions -->
  </system>
  <instructions>
    <!-- Main prompt/query -->
  </instructions>
  <output>
    <!-- Output format specification -->
  </output>
</prompt>
```

## Tags Reference

### Root Tags

#### `<prompt>`

- **Purpose**: Root container for the entire prompt
- **Required**: Highly recommended, but optional
- **Contains**: Any other valid Mixdown tags

**Example**:

```xml
<prompt>
  <!-- Other tags go here -->
</prompt>
```

#### `<meta>`

- **Purpose**: Contains metadata about the prompt
- **Required**: Optional
- **Format**: YAML
- **Common Fields**:
  - `title`: Prompt title
  - `description`: Prompt description
  - `author`: Prompt author
  - `created`: Creation date
  - `version`: Version number
  - `tags`: List of tags

**Example**:

```xml
<meta>
  title: My Prompt
  description: A sample prompt
  author: John Doe
  created: 2024-03-24
  version: 1.0.0
  tags:
    - sample
    - tutorial
</meta>
```

### Configuration Tags

#### `<params>`

- **Purpose**: Defines variables and configuration
- **Required**: Recommended
- **Format**: YAML
- **Usage**: Values defined here can be referenced using `{{ variable_name }}`

**Example**:

```xml
<params>
system: You are a helpful assistant
content:
  type: blog post
  style: instructional
  include:
    - code examples
    - explanations
output:
  format: markdown
  length: 1000 words
</params>
```

### Instruction Tags

#### `<system>`

- **Purpose**: Defines system-level instructions
- **Required**: Recommended
- **Usage**: Can be self-closing if defined in params

**Examples**:

```xml
<system>You are a helpful assistant</system>

<!-- OR using params -->
<system />
```

#### `<assistant>`

- **Purpose**: Defines assistant-specific instructions
- **Required**: Optional
- **Usage**: Often used with `<system>` for more specific behavior

**Example**:

```xml
<assistant>
I am a coding assistant specializing in Python
</assistant>
```

#### `<instructions>`

- **Purpose**: Contains the main prompt or query
- **Required**: Yes
- **Usage**: Can be section or self-closing

**Examples**:

```xml
<instructions>
Write a blog post about {{ topic }}
</instructions>

<!-- OR -->
<instructions are="below" />
Write a blog post about {{ topic }}
```

### Output Tags

#### `<output>` or `<response>`

- **Purpose**: Specifies desired output format
- **Required**: Recommended
- **Usage**: Can be section or self-closing

**Examples**:

```xml
<output>
# {{ title }}

{{ content }}
</output>

<!-- OR -->
<output format="markdown" length="1000 words" />
```

### Example Tags

#### `<examples>`

- **Purpose**: Provides examples for the LLM
- **Required**: Optional
- **Contains**: `<example>` tags or example content

**Example**:

```xml
<examples>
  <example output="correct">
    <input>What is 2 + 2?</input>
    <output>4</output>
  </example>
  <example output="incorrect">
    <input>What is 2 + 2?</input>
    <output>5</output>
  </example>
</examples>
```

## Variable Interpolation

### Basic Syntax

- Uses double curly braces: `{{ variable_name }}`
- Can reference nested values: `{{ user.name }}`
- Can include attributes: `{{ variable attribute="value" }}`

### Common Variables

- `{{ title }}`
- `{{ content }}`
- `{{ summary }}`
- `{{ description }}`
- `{{ author }}`

### Variable Attributes

```xml
<prompt>
<!-- rest of prompt -->
{{ content length="1000 words" }}
{{ summary as="bullet points" }}
{{ code as="markdown code block (python)" }}
</prompt>
```

## Attributes Reference

### Common Attributes

#### Count Attributes

- `count="number"`: Specifies quantity

```xml
{{ examples count="3" }}
```

#### Include/Exclude

- `include="items"`: Specifies items to include
- `exclude="items"`: Specifies items to exclude

```xml
{{ traits include="strength,intelligence" }}
{{ content exclude="sensitive-info" }}
```

#### Output Formatting

- `format="type"`: Specifies output format
- `length="value"`: Specifies content length
- `as="type"`: Specifies presentation format

```xml
<output format="markdown" length="500 words" />
{{ content as="bullet points" }}
```

## Data Formats

### YAML in `<params>`

See [YAML v1.2](https://yaml.org/spec/1.2.2/) for more information.

```xml
<params>
key: value
nested:
  key: value
list:
  - item1
  - item2
</params>
```

### Markdown in Content

- Used for formatting text
- Supported in instructions and output
- Common in content sections

### XML-style Tags

- Used for structure
- Defines sections and components
- Can include attributes

## Best Practices

1. **Structure**
   - Use `<prompt>` as root when possible
   - Include `<params>` for reusable values
   - Define clear output format

2. **Variables**
   - Use descriptive names
   - Document placeholder variables
   - Use nesting for organization

3. **Formatting**
   - Use consistent indentation
   - Keep sections organized
   - Use comments for clarity

4. **Output**
   - Specify clear format requirements
   - Use attributes for precision
   - Include examples when helpful

5. **Metadata**
   - Include version information
   - Document changes
   - Add descriptive tags
