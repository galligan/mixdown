# Agent Terminal Use Rules

- ✅ Always use non-paginated commands when possible
  - Use the `git --no-pager log` when available
  - Pipe to `cat` instead of pagers e.g. `command | cat`
  - For large outputs, redirect output to a file `command > .agent/logs/YYYYMMDDHHMMSS-{{ command_name max_length="2-words" }}-output.log`
  - Use `-n` or `--no-more` flags when available e.g. `systemctl -n 0 status service-name`
- ✅ For server setup or other long-running processes:
  - Use `nohup` to run the command e.g. `nohup command &`
  - Use `tmux` or `screen` for persistent sessions
  - Specify timeouts when needed `command --timeout=60`
  - If a long running process needs to complete, try to be patient within reason and don't interrupt them, but don't wait indefinitely
- ✅ For time-based commands
  - Use `date [format]` e.g. `date +"%Y-%m-%dT%H:%M:%S%z"`
- ✅ For git commands, first check the [agent version control rules](../../.cursor/rules/agent-version-control.mdc)