---
id: 01H1F0F8XRZQY4VS6N0N6D7D0Q
created: 2023-05-27T16:25:39Z
updated: 2023-10-30T08:20:48Z
type: memo
title: Multi-Architecture Images
imported_from: Obsidian
---
27-05-2023 17:26

Tags: #docker 


---
List all current builders
```Bash
docker buildx ls
```

Create a new builder with access to multi-arch features
```Bash
docker buildx create --name mybuilder
```
```Bash
docker buildx use mybuilder
```
```Bash
docker buildx inspect --bootstrap
```

Build and push amd64 and arm64 images to docker hub
```Bash
docker buildx build --platform linux/amd64,linux/arm64 -t stevevine/ismsct:latest --push .
```

Inspect the image
```Bash
docker buildx imagetools inspect stevevine/ismsct:latest
```

---
## References