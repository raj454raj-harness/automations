# Harness Development CLI

## Setup

1. Install Github CLI ([README](https://github.com/cli/cli#installation))
2. Create a Github Developer key for the above to access the repos from Settings Page. (read:org and repo permissions)
3. Clone this repo
4. In your `~/.zshrc` or `~/.bashrc` put the following
```
alias z="~/automations/hn-cli/cli_wrapper.sh"
```
**Why `z`?** -- I don't know, just faster to type commands from left hand maybe! Tried `hn` but seems a bit off to type.

5. Reload the shell from your current terminal window to update changes in zshrc.
```
$ . ~/.zshrc
```
6. Update the `REPO` variable in `cli_wrapper.sh` with path to your portal repo.

## Commands

1. Build bazel and then maven
```
$ z build
```
2. Format files (build files and clang-format on committed files)
```
$ z format
```
3. Commit by prepending the jira task

**Note:** This requires your branch name to start with jira id. Example branch names: - `cdng-3267`, `cdng-3267-sub-feature`
```
$ z commit this is a new commit
```
This will make the commit message as `[CDNG-3267]: this is a new commit`

4. Push + Create a PR if first remote commit
```
$ z push
```
5. Clean the `~/.m2` for a fresh installation
```
$ z clean
```
6. Clean the `~/.m2` for a fresh installation and trigger install
```
$ z clean_install
```
7. Just bazel_script.sh
```
$ z bazel
```
8. Just mvn clean install
```
$ z mvn
```

