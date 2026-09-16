---
id: 01M2JYGY6V0FR6VF79SX3TQR3H
created: 2026-09-15T16:31:11.067754Z
updated: 2026-09-16T13:29:32.297663Z
type: task
title: Add placeholder capability for code blocks
project: 01KY6W9951TW0904DT0GGJVGE7
number: 422
assignee: steve
label: null
priority: medium
task_status: todo
tech: null
---
When writing code blocks it can be helpful to pre-fill certain text before copying it but this means editing the code.
Create a feature that will allow text to be temporarily entered to complete a code block. E.g.

Within the code block use special tags <|my-text|> 
```
echo <|my-text|>
```

When this is rendered, Notuvia see's the special <| |> tags and renders a text box underneath the code block E.g.
my-text: [         ]

As the user enters text into the text box, it gets replaced in the code block so that when they click Copy it copies the code block with the replaced text.  It should be possible to add multiple replacement tags like this in a single code block.