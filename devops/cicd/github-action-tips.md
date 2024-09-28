# Github Action Tips

## Get Github Action event json file

Use `$GITHUB_EVENT_PATH`

## GitHub Action events

- `pull_request`
  - triggered when performing actions with Pull Request.
  - By default, a workflow only runs when a `pull_request` event's activity type is `opened`, `synchronize`, or `reopened`
  - To trigger workflows by different activity types, use the `types` keyword
  - [Ref](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#pull_request)
- `pull_request_target`
  Same as `pull_request` but run with the workflow template in the base branch

## GitHub Action get the latest commit before merging PR

```yaml
name: Deploy

on:
  push:
    branches: ["dev", "prod"]

jobs:
  prepare:
    name: Prepare config
    runs-on: ubuntu-latest
    steps:
      - name: checkout repo
        uses: actions/checkout@v4
        with:
          fetch-depth: 2

      - name: Install dependencies
        run: pnpm install

      - id: deployed_services
        run: |
          before_commit=$(git rev-parse HEAD^1)
          echo $before_commit
```
