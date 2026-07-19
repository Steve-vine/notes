---
id: 01KJHPHBS1FN1WAHSCPZGBPBA2
created: 2026-02-28T08:41:12.737Z
updated: 2026-02-28T09:27:32.974999Z
type: memo
title: Branches
---
28-02-2026 08:41

Tags: 


---
## List all branches
### Local branches only
```
git branch
```

### Remote branches only
```
git branch -r
```

### All branches (local and remote)
```
git branch -a
```

## Create a new Feature branch from an existing branch

### While switching to the branch 
First, make sure you're on the source branch
```
git checkout <source-branch>
```

Create a new feature branch from it
```
git checkout -b <new-branch>
```

Push the new branch to GitHub
```
git push origin <new-branch>
```
### Without switching to the branch
Create branch from existing branch
```
git branch <source-branch> <new-branch>
```

Push the new branch to GitHub
```
git push origin <new-branch>
```

## Delete a branch

Delete locally
```
git branch -d <branch-name>
```
**Note:** Use `-d` for safe deletion (only if merged) or `-D` to force delete regardless of merge status.

Delete on GitHub
```
git push origin --delete <branch-name>
```

## Copy new branch over existing branch

### Force push, overwrite history
```
git checkout <new-branch>
```

```
git push origin <new-branch>:<existing-branch> --force
```

### Merge, preserve history
```
git checkout <existing-branch>
```

```
git merge <new-branch> -X theirs --allow-unrelated-histories -m
```

```
git push origin <existing-branch>
```

## Check differences between 2 branches

### Compare commits
Show commits in \<branch-1> that aren't in \<branch-2>
```
git log <branch-2>..<branch-1> --oneline
```

Show commits that differ in either direction
```
git log <branch-1>...<branch-2> --oneline
```

### Compare actual code differences
Full diff of all file changes between branches
```
git diff <branch-1>..<branch-2>
```

Just show which files changed (no content)
```
git diff <branch-1>..<branch-2> --name-only
```

Show files with a summary of changes (insertions/deletions)
```
git diff <branch-1>..<branch-2> --stat
```

Compare a specific file
```
git diff <branch-1>..<branch-2> -- path/to/file.yaml
```

Visual comparison
```
git difftool <branch-1>..<branch-2>
```

### Compare differences on GitHub
```
git fetch origin
```

```
git diff origin/<branch-1>..origin/<branch-2> --stat
```
Note: This doesn't overwrite anything locally