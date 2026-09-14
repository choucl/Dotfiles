---
name: herdr-external
description: Use when the agent is outside a Herdr pane and must inspect, create, start, prompt, wait for, or read a running Herdr session, workspace, pane, or agent via the local Herdr CLI or a user-specified SSH host.
---

# External Herdr Management

Use this skill only for automation initiated outside Herdr. The official Herdr skill's `HERDR_ENV=1` guard is for agents inside Herdr panes; do not copy that guard here and do not set `HERDR_ENV=1` just to bypass it.

## Preconditions and safety

Herdr's automation API uses a local Unix socket. Choose the execution route before running any Herdr command:

1. If the current shell is on the host where the Herdr server is running, use the local CLI.
2. Otherwise, use SSH to the host explicitly supplied by the user. Never assume, hard-code, or choose a specific host. If remote execution is required but no host was supplied, ask before acting.
3. Keep the selected route for every subsequent command. For SSH, run each command inside the SSH invocation and keep `HERDR_SESSION` inside the remote shell.
4. List sessions without assuming a target: `herdr session list --json`.
5. Identify the intended session explicitly. If the user has not named one and more than one is available, ask before acting. If no session is available, report that and stop.
6. Set `HERDR_SESSION=<name>` on every subsequent Herdr command.
7. List workspaces, panes, and agents before any operation that targets or changes them:

   ```bash
   HERDR_SESSION="<session-name>" herdr workspace list
   HERDR_SESSION="<session-name>" herdr pane list
   HERDR_SESSION="<session-name>" herdr agent list
   ```

For the SSH route, wrap each command as `ssh <herdr-host> '...'`, with the session variable inside the quoted remote command. Replace every angle-bracket placeholder with an inspected or user-supplied value before execution.

The preflight is complete when the intended session is identified and the inspection output supplies the explicit workspace or pane IDs, or a unique agent name, needed for the requested operation.

Rules for every operation:

- Never use `--current`; an external process has no reliable `HERDR_PANE_ID` context.
- Use explicit workspace, pane, and agent IDs or unique agent names. Never rely on whichever pane the UI currently focuses.
- Use `--no-focus` for background workspace and pane creation.
- Do not close workspaces, panes, agents, or the server unless the user explicitly asks.
- Keep timeouts finite for delegated work and read the agent output/state after waiting.
- If a command fails, or returns `blocked`, `unknown`, or a timeout, stop and report the result before issuing another operation.

Use JSON output where the command provides it and preserve IDs from the result. The preflight and the selected execution route remain in force for the rest of the operation.

## Create and delegate to a worker

Create a background workspace, extract its explicit root pane ID, then start and prompt an agent by name:

```bash
SESSION="<session-name>"
AGENT="<unique-agent-name>"

created=$(HERDR_SESSION="$SESSION" herdr workspace create \
  --cwd "$PWD" \
  --label delegated-task \
  --no-focus)

pane_id=$(printf '%s\n' "$created" | jq -er '.result.root_pane.pane_id')

HERDR_SESSION="$SESSION" herdr agent start "$AGENT" \
  --kind codex \
  --pane "$pane_id"

HERDR_SESSION="$SESSION" herdr agent prompt "$AGENT" \
  "Inspect the repository and implement the requested change." \
  --wait \
  --timeout 120000

HERDR_SESSION="$SESSION" herdr agent read "$AGENT" \
  --source recent-unwrapped \
  --lines 120
```

Use a unique agent name when delegating more than one task. If a pre-existing pane must be split, pass its explicit pane ID:

```bash
HERDR_SESSION="$SESSION" herdr pane split "<workspace-id>:<pane-id>" \
  --direction right \
  --no-focus
```

The delegation step is complete when workspace creation returns a root pane ID, the agent starts successfully, the prompt reaches a readable result, and the final agent read succeeds. If workspace creation or ID extraction fails, stop before starting an agent.

## Wait and read results

For a prompt submitted without `--wait`, wait against the explicit agent name and then read its output:

```bash
HERDR_SESSION="$SESSION" herdr agent wait "$AGENT" --timeout 120000
HERDR_SESSION="$SESSION" herdr agent read "$AGENT" \
  --source recent-unwrapped \
  --lines 120
```

This step is complete when the wait reaches a terminal result and the subsequent read captures the agent's state or output. Report `blocked`, `unknown`, timeout, or command errors and ask the user when intervention or a new target is needed. Do not expose or manipulate the Unix socket path directly when the CLI and session name are sufficient.
