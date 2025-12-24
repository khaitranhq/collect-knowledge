# Git Worktree - Summary Guide

## Overview

Git worktree allows you to have **multiple working directories** (worktrees) attached to the same repository, each checked out to different branches. Instead of switching branches and stashing changes, you simply switch directories.

## When to Use Git Worktree

### ✅ Ideal Use Cases

1. **Hot Fixes During Feature Work**
   - Working on a feature but need to fix an urgent bug in `main`
   - No need to stash, switch branches, and restore later

2. **Parallel Development Tasks**
   - Working on multiple features/branches simultaneously
   - Testing code while continuing development elsewhere

3. **Code Reviews**
   - Review pull requests in a separate worktree while keeping your work intact
   - Compare implementations side-by-side

4. **CI/CD and Build Testing**
   - Run builds/tests in one worktree while coding in another
   - Avoid interrupting your development workflow

5. **AI Coding Agents**
   - Run multiple AI agents in parallel, each in their own worktree
   - Agents can make edits without interfering with each other

6. **Experimental Changes**
   - Quick experiments or throw-away merges
   - Test merge outcomes without affecting your current work

### ❌ When NOT to Use

- Simple branch switching (regular `git checkout` is sufficient)
- Single linear workflow with no interruptions
- When you don't need multiple branches checked out simultaneously

## How to Use Git Worktree

### Basic Commands

```bash
# Add a new worktree (creates new branch automatically)
git worktree add <path>

# Add worktree for existing branch
git worktree add <path> <existing-branch>

# Add worktree and create new branch
git worktree add -b <new-branch> <path>

# Add worktree and create new branch from specific commit
git worktree add -b <new-branch> <path> <start-point>

# List all worktrees
git worktree list

# Remove a worktree
git worktree remove <path>

# Prune stale worktree metadata
git worktree prune
```

### Typical Workflow

#### Scenario: Hot Fix During Feature Development

```bash
# Currently working on feature branch in ~/project
cd ~/project

# Urgent bug reported! Create worktree for hot fix
git worktree add ../project-hotfix main

# Switch to hot fix directory
cd ../project-hotfix

# Fix bug, commit, push
git commit -am "Fix critical bug"
git push origin main

# Return to feature work
cd ~/project

# Clean up when done
git worktree remove ../project-hotfix
```

#### Scenario: Code Review While Developing

```bash
# Add worktree for reviewing PR
git worktree add ../project-review feature/pr-123

# Review code in separate directory
cd ../project-review

# Run tests, check implementation
npm test

# Return to your work
cd ~/project

# Remove when review is complete
git worktree remove ../project-review
```

## Best Practices

### 1. **Keep a Fixed Number of Long-Lived Worktrees**
```
~/project-main      # Pristine main branch (read-only reference)
~/project-work      # Active development
~/project-review    # Code reviews
~/project-test      # Running tests/experiments
~/project-scratch   # Temporary/throw-away work
```

### 2. **Use Descriptive Directory Names**
```bash
# Good: Descriptive names
git worktree add ../project-hotfix-auth-bug main
git worktree add ../project-review-api-refactor feature/api-refactor

# Avoid: Generic or branch-only names
git worktree add ../worktree1
git worktree add ../feature
```

### 3. **Regular Cleanup**
```bash
# List all worktrees
git worktree list

# Remove unused worktrees
git worktree remove <path>

# Prune stale metadata
git worktree prune
```

### 4. **Avoid Common Pitfalls**
- ⚠️ **Never nest worktrees** (don't create a worktree inside another worktree)
- ⚠️ **Same branch can't be checked out in multiple worktrees** simultaneously
- ⚠️ **Remember to commit or stash in each worktree** before removing it
- ⚠️ **All worktrees share the same `.git` repository** (commits in one affect all)

### 5. **Naming Conventions**
```bash
# Pattern: <project>-<purpose>-<description>
git worktree add ../myapp-hotfix-login-error main
git worktree add ../myapp-feature-dark-mode feature/dark-mode
git worktree add ../myapp-review-pr-456 pr-456
```

## Advanced Usage

### Detached HEAD for Experiments
```bash
# Create worktree at specific commit without branch
git worktree add --detach <path> <commit-hash>
```

### Using with Remote Branches
```bash
# Git automatically tracks remote branches
git worktree add ../project-review origin/feature/new-api
```

### Configuration Options
```bash
# Auto-guess remote tracking branch
git config worktree.guessRemote true

# Automatically prune stale worktrees
git config worktree.pruneExpire "7.days.ago"
```

## Comparison with Traditional Workflow

| Scenario | Traditional Git | Git Worktree |
|----------|----------------|--------------|
| Switch to fix bug | Stash → Checkout → Fix → Checkout → Unstash | `cd` to worktree → Fix → `cd` back |
| Parallel tasks | Constant stashing/unstashing | Each task in separate directory |
| Code review | Stash → Checkout PR → Review → Return | `cd` to review worktree → Review → `cd` back |
| Build while coding | Wait for build or commit WIP | Build in one worktree, code in another |
| Context switch time | Minutes (mental overhead) | Seconds (just change directory) |

## Quick Reference

```bash
# Common workflow commands
git worktree add ../hotfix main                    # Quick hotfix
git worktree add -b new-feature ../feature main    # New feature branch
git worktree list                                  # See all worktrees
git worktree remove ../feature                     # Clean up
git worktree prune                                 # Remove stale entries

# Check worktree status from any location
git worktree list --porcelain    # Machine-readable format
```

## Key Benefits

✅ **No Context Switching** - Keep multiple tasks in progress simultaneously  
✅ **No Stash Conflicts** - Each worktree has independent working state  
✅ **Faster Workflow** - Just `cd` between directories instead of branch switching  
✅ **Safer Parallel Work** - Isolated environments reduce mistakes  
✅ **Better for CI/CD** - Run builds/tests without blocking development

---

**Requirements**: Git 2.5 or higher

**Learn More**: `man git-worktree` or `git worktree --help`
