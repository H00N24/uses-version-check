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
          use_error_log: ${{ github.event_name == 'schedule' }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Parameters:

- `files`: The files to check for action versions. It accepts files or directories. The
  default is `.github`.
- `ignore_version_regex`: A regex to ignore certain versions. The default is
  `main|master|latest`.
- `use_error_log`: If set to `true`, the action will use `::error` instead of `::warning`
  messages, and fail if it finds any outdated versions. The default is `false`.
