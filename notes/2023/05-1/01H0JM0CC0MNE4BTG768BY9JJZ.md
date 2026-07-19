---
id: 01H0JM0CC0MNE4BTG768BY9JJZ
created: 2023-05-16T15:49:04Z
updated: 2023-12-08T16:57:01Z
type: memo
title: Build a docker image and upload to Github
imported_from: Obsidian
---
 -t steve16-05-2023 16:37

Tags: #docker #github


---
Create the Dockerfile in the current folder

Build the image, e.g.
```Bash
docker build -t stevevine/ansible:2.14.5-amd64 .
```
-t   Tag
.  Current folder

Login to the registry, e.g.
```Bash
docker login -u stevevine
```

Push the image to the registry, e.g.
```Bash
docker push stevevine/ansible:2.14.5-amd64
```

---
## References