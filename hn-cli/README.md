# Harness Development CLI

## Installation

1. Install Github CLI [README](https://github.com/cli/cli#installation)
2. Create a Github Developer key for the above to access the repos from Settings Page. (read:org and repo permissions)
3. Clone this repo
4. In your `~/.zshrc` or `~/.bashrc` put the following
```
alias z="~/automations/hn-cli/cli_wrapper.sh"
```
Why `z`? -- I don't know, just faster to type commands from left hand maybe! Tried `hn` but seems a bit off to type.
5. Reload the shell from your current terminal window.
```
$ . ~/.zshrc
```
6. Update the `REPO` variable in `cli_wrapper.sh` with path to your portal repo.