---
id: 01KX0JNDJXQP5P5NSKS99JWHKB
created: 2026-07-08T09:59:06.077423Z
updated: 2026-07-09T15:21:56.269947Z
type: memo
title: Markdown Examples
---
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

Alternate H1
============

Alternate H2
------------

## Paragraphs and Line Breaks

This is a paragraph. To start a new paragraph, leave a blank line
between blocks of text.

To force a line break within a paragraph, end a line with two spaces  
or use a backslash\
at the end of the line.

## Emphasis

*Italic* or _italic_

**Bold** or __bold__

***Bold and italic***

~~Strikethrough~~

## Blockquotes

> This is a blockquote.
>
> > Blockquotes can be nested.
>
> They can contain **other** markdown elements.

## Lists

### Unordered

- Item one
- Item two
  - Nested item
    - Deeper nested item
- Item three

(You can also use `*` or `+` as bullet markers.)

### Ordered

1. First item
2. Second item
   1. Nested ordered item
   2. Another nested item
3. Third item

### Task list

- [x] Completed task
- [ ] Incomplete task
- [ ] Another task

## Code

Inline code uses `backticks`.

Indented code block (four spaces):

    function example() {
      return true;
    }

Fenced code block with language for syntax highlighting:

```python
def greet(name):
    print(f"Hello, {name}!")
```

```bash
echo "Hello, world"
```

## Links

[Inline link](https://example.com)

[Inline link with title](https://example.com "Example title")

[Reference-style link][ref]

Bare URL: <https://example.com>

[ref]: https://example.com

## Images

![Alt text](https://example.com/image.png)

![Alt text with title](https://example.com/image.png "Image title")

Reference-style image:

![Alt text][img-ref]

[img-ref]: https://example.com/image.png

## Tables

| Left | Center | Right |
| :--- | :----: | ----: |
| a    | b      | c     |
| dog  | cat    | bird  |

(The colons in the divider row set column alignment.)

## Horizontal Rule

---

***

___

## Escaping Characters

Use a backslash to render literal markdown characters: \*not italic\*, \`not code\`, \# not a heading.

## Footnotes

Here is a sentence with a footnote.[^1]

[^1]: This is the footnote text.

## Inline HTML

Markdown also allows raw HTML when needed:

<sub>subscript</sub> and <sup>superscript</sup>

<kbd>Ctrl</kbd> + <kbd>C</kbd>