# Git Feature Branch Dependency Implementation Guide

A comprehensive guide for implementing new features in branches that depend on code from unmerged feature branches.

## Problem Statement

You have:

- Branch `feat/ab` under review that will be merged to `dev` using squash and merge
- Need to implement a new feature in branch `feat/cd` that depends on code in `feat/ab`
- Want to start development before `feat/ab` is merged

## Table of Contents

1. [Method 1: Create feat/cd from feat/ab (Recommended)](#method-1-create-featcd-from-featab-recommended)
2. [Method 2: Cherry-pick Specific Commits](#method-2-cherry-pick-specific-commits)
3. [Method 3: Using Git Worktree (Advanced)](#method-3-using-git-worktree-advanced)
4. [Method 4: Interactive Rebase Cleanup](#method-4-interactive-rebase-cleanup)
5. [Automation Scripts](#automation-scripts)
6. [Git Aliases](#git-aliases)
7. [Verification Commands](#verification-commands)

## Method 1: Create feat/cd from feat/ab (Recommended)

### Step 1: Setup and Create Dependent Branch

```bash
# Navigate to your repository
cd /path/to/your/repository

# Ensure you have the latest changes
git fetch origin

# Checkout the feat/ab branch
git checkout feat/ab

# Pull latest changes from feat/ab
git pull origin feat/ab

# Create your new feature branch from feat/ab
git checkout -b feat/cd

# Verify you're on the correct branch
git branch --show-current
```

### Step 2: Implement Your Feature

```bash
# Start implementing your feature
# ... make your code changes ...

# Stage your changes
git add .

# Commit with descriptive message
git commit -m "feat(cd): implement initial CD feature structure

- Add CD core functionality
- Depends on feat/ab changes
- Add tests for CD feature"

# Push to remote
git push origin feat/cd
```

### Step 3: Continue Development

```bash
# Continue making changes as needed
# ... more code changes ...

git add .
git commit -m "feat(cd): add CD feature validation logic"

# Keep pushing your changes
git push origin feat/cd
```

### Step 4: Handle feat/ab Merge (When it happens)

```bash
# When feat/ab gets merged to dev, update your local dev
git checkout dev
git pull origin dev

# Switch back to your feature branch
git checkout feat/cd

# Rebase your branch onto the updated dev
git rebase dev

# If there are conflicts, resolve them and continue
# git add <resolved-files>
# git rebase --continue

# Force push the rebased branch (use with caution)
git push origin feat/cd --force-with-lease
```

## Method 2: Cherry-pick Specific Commits

### Step 1: Identify Required Commits

```bash
# View commits in feat/ab that you need
git log --oneline feat/ab ^dev

# Example output:
# a1b2c3d feat(ab): add core AB functionality
# e4f5g6h feat(ab): add AB validation
# i7j8k9l feat(ab): add AB tests
```

### Step 2: Create Branch and Cherry-pick

```bash
# Create branch from dev
git checkout dev
git pull origin dev
git checkout -b feat/cd

# Cherry-pick specific commits you need
git cherry-pick a1b2c3d  # Pick core functionality
git cherry-pick e4f5g6h  # Pick validation

# Now implement your feature
# ... make your changes ...
git add .
git commit -m "feat(cd): implement CD feature using AB foundation"

# Push your branch
git push origin feat/cd
```

## Method 3: Using Git Worktree (Advanced)

### Step 1: Create Worktree

```bash
# Create a new worktree for feat/cd based on feat/ab
git worktree add ../project-feat-cd feat/ab

# Navigate to the new worktree
cd ../project-feat-cd

# Create your feature branch
git checkout -b feat/cd

# Verify setup
pwd
git branch --show-current
```

### Step 2: Develop in Parallel

```bash
# Work on your feature in the worktree
# ... make changes ...

git add .
git commit -m "feat(cd): implement CD feature"
git push origin feat/cd

# You can switch between main project and worktree
cd ../original-project  # Back to main working directory
cd ../project-feat-cd   # Back to feat/cd worktree
```

### Step 3: Cleanup Worktree

```bash
# When done, remove the worktree
cd ../original-project
git worktree remove ../project-feat-cd
```

## Method 4: Interactive Rebase Cleanup

### Step 1: Create Branch with All Changes

```bash
# Create feat/cd from feat/ab
git checkout feat/ab
git checkout -b feat/cd

# Implement your feature
# ... make changes ...
git add .
git commit -m "feat(cd): implement CD feature"
git push origin feat/cd
```

### Step 2: Clean History After Merge

```bash
# After feat/ab is merged to dev
git checkout dev
git pull origin dev
git checkout feat/cd

# Interactive rebase to clean up history
git rebase -i dev

# In the editor that opens, you'll see something like:
# pick a1b2c3d feat(ab): add core AB functionality
# pick e4f5g6h feat(ab): add AB validation
# pick i7j8k9l feat(ab): add AB tests
# pick m1n2o3p feat(cd): implement CD feature

# Change 'pick' to 'drop' for feat/ab commits since they're now in dev:
# drop a1b2c3d feat(ab): add core AB functionality
# drop e4f5g6h feat(ab): add AB validation
# drop i7j8k9l feat(ab): add AB tests
# pick m1n2o3p feat(cd): implement CD feature

# Save and close the editor
```

## Automation Scripts

### Create Dependent Branch Script

Create `create-dependent-branch.sh`:

```bash
#!/bin/bash

# Usage: ./create-dependent-branch.sh feat/ab feat/cd

set -e

PARENT_BRANCH=$1
NEW_BRANCH=$2

if [ -z "$PARENT_BRANCH" ] || [ -z "$NEW_BRANCH" ]; then
    echo "Usage: $0 <parent-branch> <new-branch>"
    echo "Example: $0 feat/ab feat/cd"
    exit 1
fi

echo "🔄 Fetching latest changes..."
git fetch origin

echo "📦 Checking out parent branch: $PARENT_BRANCH"
git checkout "$PARENT_BRANCH"

echo "⬇️ Pulling latest changes from $PARENT_BRANCH"
git pull origin "$PARENT_BRANCH"

echo "🌿 Creating new branch: $NEW_BRANCH"
git checkout -b "$NEW_BRANCH"

echo "✅ Successfully created $NEW_BRANCH from $PARENT_BRANCH"
echo "Current branch: $(git branch --show-current)"
echo ""
echo "Next steps:"
echo "1. Implement your feature"
echo "2. git add . && git commit -m 'feat: your changes'"
echo "3. git push origin $NEW_BRANCH"
```

Make it executable and use:

```bash
# Make script executable
chmod +x create-dependent-branch.sh

# Use the script
./create-dependent-branch.sh feat/ab feat/cd
```

### Post-Merge Cleanup Script

Create `rebase-after-merge.sh`:

```bash
#!/bin/bash

# Usage: ./rebase-after-merge.sh feat/cd dev

set -e

FEATURE_BRANCH=$1
TARGET_BRANCH=${2:-dev}

if [ -z "$FEATURE_BRANCH" ]; then
    echo "Usage: $0 <feature-branch> [target-branch]"
    echo "Example: $0 feat/cd dev"
    exit 1
fi

echo "🔄 Fetching latest changes..."
git fetch origin

echo "📦 Updating $TARGET_BRANCH..."
git checkout "$TARGET_BRANCH"
git pull origin "$TARGET_BRANCH"

echo "🌿 Switching to feature branch: $FEATURE_BRANCH"
git checkout "$FEATURE_BRANCH"

echo "🔄 Rebasing $FEATURE_BRANCH onto $TARGET_BRANCH..."
git rebase "$TARGET_BRANCH"

echo "⬆️ Force pushing rebased branch..."
git push origin "$FEATURE_BRANCH" --force-with-lease

echo "✅ Successfully rebased $FEATURE_BRANCH onto $TARGET_BRANCH"
```

Use the cleanup script:

```bash
# Make script executable
chmod +x rebase-after-merge.sh

# Use after feat/ab is merged
./rebase-after-merge.sh feat/cd dev
```

## Git Aliases

Add these aliases to your `~/.gitconfig`:

```ini
[alias]
    # Create dependent branch
    create-dep = "!f() { git checkout $1 && git pull origin $1 && git checkout -b $2; }; f"

    # Clean rebase after parent merge
    clean-rebase = "!f() { git checkout ${2:-dev} && git pull origin ${2:-dev} && git checkout $1 && git rebase ${2:-dev}; }; f"

    # Show branch dependency tree
    branch-tree = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
```

Use the aliases:

```bash
# Create dependent branch
git create-dep feat/ab feat/cd

# Clean rebase after merge
git clean-rebase feat/cd dev

# View branch tree
git branch-tree
```

## Verification Commands

### Check your setup:

```bash
# Verify current branch
git branch --show-current

# Check branch relationships
git log --oneline --graph feat/cd feat/ab dev

# Check what commits are unique to your branch
git log --oneline feat/cd ^dev

# Check if your branch has conflicts with dev
git merge-tree $(git merge-base feat/cd dev) feat/cd dev
```

## Best Practices

1. **Communicate with the team**: Let others know about the dependency so they understand the branch structure.

2. **Keep feat/cd focused**: Only include changes specific to your feature, not modifications to feat/ab code.

3. **Regular synchronization**: Periodically sync with feat/ab if it receives updates.

4. **Document the dependency**: In your PR description, mention the dependency on feat/ab.

5. **Test thoroughly**: After rebasing onto dev, ensure your feature still works correctly.

6. **Use descriptive commit messages**: Make it clear which commits are your feature vs. dependencies.

## Workflow Timeline Example

```
Initial state:
dev -----> feat/ab (under review)
           └─> feat/cd (your new feature)

After feat/ab is merged:
dev -----> (feat/ab squashed and merged)

feat/cd needs rebasing:
dev -----> feat/cd (rebased, clean history)
```

## Troubleshooting

### Common Issues

1. **Merge conflicts during rebase**: Resolve conflicts manually and continue with `git rebase --continue`

2. **Lost commits after rebase**: Use `git reflog` to find lost commits and recover them

3. **Force push rejected**: Use `--force-with-lease` instead of `--force` for safer force pushing

4. **Duplicate commits**: Use interactive rebase to clean up duplicate commits from the parent branch

### Recovery Commands

```bash
# View recent Git operations
git reflog

# Recover lost commits
git checkout <commit-hash>
git checkout -b recovery-branch

# Abort rebase if things go wrong
git rebase --abort

# Reset to previous state
git reset --hard HEAD~1
```
