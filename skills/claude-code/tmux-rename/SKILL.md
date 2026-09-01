---
name: tmux-rename
description: Use when the user wants this session renamed — "rename this session", "call this session X", "give this tmux session a better name", "/tmux-rename" — from a Claude Code session running inside tmux.
---

# tmux Rename

Give the current tmux session and the Claude session inside it the same new name.

Claude Code only, and only from a session that is already running inside tmux.

**Core principle:** You cannot type into your own prompt box, but you can send keys to your own tmux pane.
`/rename` is a local command. It runs the moment it arrives, even mid-turn, so the rename lands during this turn and you can read it back.

## Procedure

1. **Pick the name.**
   Use the argument if given, else derive a short kebab-case name from the current work.
   One name is used for both the tmux session and the Claude session.

2. **Find this session's pane.**
   Walk up from the Bash shell to the claude process, then read its entry in the session registry:

   ```bash
   pid=$$; while [ "$pid" -gt 1 ]; do case "$(ps -o comm= -p $pid)" in *claude*) break;; esac; pid=$(ps -o ppid= -p $pid | tr -d ' '); done
   python3 -c "
   import json
   d = json.load(open('$HOME/.claude/sessions/$pid.json'))
   print(d.get('sessionId'), '|', d.get('name'), '|', d.get('tmux'))"
   ```

   Confirm the printed `sessionId` matches the UUID in your scratchpad directory path — never rename a session you have not identified.
   The `tmux` field looks like `work:@1.%3`: the part before `:` is the tmux session name, and the whole string is a valid `-t` target.
   No `tmux` field means this session is not inside tmux. Stop and tell the user.

3. **Check for a tmux collision.**

   ```bash
   tmux has-session -t <new-name> 2>/dev/null && echo taken
   ```

   If it prints `taken`, pick another name or ask — `rename-session` fails when the target already exists.

4. **Rename the tmux session.**

   ```bash
   tmux rename-session -t <old-tmux-name> <new-name>
   ```

5. **Rename the Claude session by sending `/rename` to your own pane.**

   ```bash
   tmux send-keys -t '<tmux-target>' '/rename <new-name>'
   tmux send-keys -t '<tmux-target>' Enter
   ```

   The text lands in your own prompt box and the Enter submits it.

6. **Read the name back.**

   ```bash
   python3 -c "
   import json
   print(json.load(open('$HOME/.claude/sessions/<pid>.json'))['name'])"
   ```

   The new name means it worked. The old name means the keys did not land — most likely they went into a draft the user was already typing.
   Say so and give them `/rename <new-name>` to run themselves.
   A suffixed name (`<new-name>-2`) means another live Claude session holds that name and Claude Code yielded; report the name it actually took.

## Common mistakes

| Mistake | Reality |
|---|---|
| Writing `name` into `~/.claude/sessions/<pid>.json` | The running process keeps its name in memory. The file edit only changes what other sessions see, so you end up answering to two names. |
| Reading `$TMUX` or `$TMUX_PANE` in a Bash call | Not in the Bash tool's environment. The `tmux` field in the registry file is the reliable source. |
| Taking the newest file in `~/.claude/sessions/` | Concurrent sessions make that wrong. Walk up from `$$`, then confirm `sessionId`. |
| Renaming only the tmux session | The ask is both. A tmux session named `deploy` holding a Claude session named `skills-ea` is the problem being fixed. |
| Assuming the send-keys worked | Keys can land in a half-typed message. Read the name back before reporting. |
| Waiting for the turn to end before verifying | `/rename` is immediate. The registry file shows the new name within the same turn. |
| Using `claude --name` or a resume to apply the name | That restarts the session. `/rename` changes the live one. |
