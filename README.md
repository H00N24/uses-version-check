# GitHub Actions Version Check

This GitHub action uses a simple bash script to check the versions of the used actions in GitHub
workflows.


Parameters:

- `files`: The files to check for action versions. It accepts files or directories. The
  default is `.github`.
- `ignore_version_regex`: A regex to ignore certain versions. The default is
  `main|master|latest`.
- `use_error_log`: If set to `true`, the action will use `::error` instead of `::warning`
  messages, and fail if it finds any outdated versions. The default is `false`.

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


With `use_error_log=false` (default):

![image](https://github.com/user-attachments/assets/68bc289b-ad13-4068-8309-8d6ca2974095)

With `user_error_log=true`:

![image](https://github.com/user-attachments/assets/5d46ff8f-4216-4825-917c-7cc20a002108)
