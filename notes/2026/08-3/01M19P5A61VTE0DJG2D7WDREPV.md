---
id: 01M19P5A61VTE0DJG2D7WDREPV
created: 2026-08-30T15:56:09.79346Z
updated: 2026-08-30T15:56:11.315353Z
type: task
title: Table of contents
project: 01KY6W9951TW0904DT0GGJVGE7
number: 410
sprint: segj1dz
assignee: steve
priority: medium
task_status: todo
---
Create a table of contents control that can be added onto forms. 

The TOC can be defined with custom markdown, I'm thinking [[toc,x]] unless that will clash with something else. Where x is the number of Header layers it shows, E.g. 
[[toc,1]] Would show

Heading1

[[toc,3]] Would show

Heading1
  Heading2
    Heading3

Each heading is a link to that part of the document