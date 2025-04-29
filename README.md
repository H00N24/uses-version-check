# GitHub Actions Version Check

This actions uses a simple bash script to check the versions of used actions in GitHub
workflows.

Example:

```yaml
name: Check Action Versions
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  schedule:
    - cron: "0 0 * * 0"
jobs:
  check_action_versions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: H00N24/uses-version-check@main
        with:
          files: action.yml .github
          ignore_version_regex: main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
