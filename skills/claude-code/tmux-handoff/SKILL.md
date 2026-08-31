---
name: tmux-handoff
description: Use when the user wants the current Claude Code session moved into, continued in, or resumed inside a named tmux session — "put this in tmux", "tmuxify this session", "hand this off to tmux", "make this session survive closing the terminal".
---

# tmux Handoff

Move the current interactive Claude Code session into a new named tmux session by resuming the same session ID there.

Claude Code only, and assumes macOS (`pbcopy`, BSD `ps`) with tmux installed.

**Core principle:** `claude --resume <session-id>` continues the SAME transcript.
Two live processes appending to one transcript interleave their writes, so the tmux side must wait for the current process to exit before it resumes.

## Procedure

1. **Pick the session name.**
   Use the argument if given, else derive a short kebab-case name from the current work.
   The same name is used for both the tmux session and the Claude session's display name.
   Check for collisions first: `tmux has-session -t <name> 2>/dev/null && echo taken`.

2. **Identify the current session ID.**
   It is the UUID in your scratchpad directory path (`.../<project-slug>/<session-uuid>/scratchpad`).
   Verify it with a nonce — never guess:

   ```bash
   # Bash call 1: land a nonce in this session's transcript
   echo "tmux-handoff-nonce-$RANDOM$RANDOM"

   # Bash call 2 (must be a SEPARATE call): exactly one file may match,
   # and it must be <session-id>.jsonl for the ID you derived above
   slug=$(echo "$PWD" | sed 's|[/.]|-|g')
   grep -l "<the nonce>" ~/.claude/projects/$slug/*.jsonl
   ```

   If they disagree or more than one file matches, stop and tell the user.

3. **Find the current claude process PID** (walk up from the Bash shell):

   ```bash
   pid=$$; while [ "$pid" -gt 1 ]; do case "$(ps -o comm= -p $pid)" in *claude*) echo "$pid"; break;; esac; pid=$(ps -o ppid= -p $pid | tr -d ' '); done
   ```

4. **Create the detached tmux session with a wait-guard.**
   Resolve the absolute claude path — tmux's shell may not share your PATH:

   ```bash
   CLAUDE_BIN=$(command -v claude)
   tmux new-session -d -s "<name>" -c "$PWD" \
     "trap ':' INT; echo 'Waiting for the old Claude session to exit. /exit it and this pane resumes it.'; while kill -0 <claude-pid> 2>/dev/null; do sleep 0.5; done; trap - INT; $CLAUDE_BIN --resume <session-id> --name '<name>' --dangerously-skip-permissions; exec \${SHELL:-zsh}"
   ```

   `--name` sets the Claude session's display name (prompt box, terminal title, `/resume` picker) to match the tmux session.
   `--dangerously-skip-permissions` starts the resumed session with permissions bypassed.
   The trailing `exec \${SHELL:-zsh}` drops the pane into a shell when claude exits, so quitting claude does not kill the tmux session.
   `trap ':' INT` keeps a stray Ctrl+C in the waiting pane from killing the handoff; the `trap - INT` reset before `exec` hands normal signal handling back to claude.

5. **Copy the attach command to the clipboard and tell the user how to complete the handoff.**

   ```bash
   printf 'tmux attach -t <name>' | pbcopy
   ```

   The tmux pane shows the waiting message until this session exits — that is the guard.
   Tell the user: the attach command is on their clipboard — exit here (`/exit`), then paste and run it.
   (If they are already inside tmux, `tmux switch-client -t <name>` instead.)
   To abort instead: `tmux kill-session -t <name>`.

## Common mistakes

| Mistake | Reality |
|---|---|
| Using the newest `.jsonl` as "the current session" | Concurrent sessions in the same directory make this wrong. Use the nonce check. |
| Expecting `$CLAUDE_SESSION_ID` in Bash | Not exposed to Bash tool calls. Use the scratchpad path plus the nonce verification. |
| Resuming without the wait-guard | Both processes append to one transcript and messages interleave. |
| Nonce echo and grep in one Bash call | The result may not be flushed to the transcript yet. Two separate calls. |
| Bare `claude` in the tmux command | tmux may spawn a shell without your PATH. Resolve with `command -v claude` first. |
| Adding `--fork-session` "to be safe" | That creates a NEW session ID and leaves the original behind. Only for when the user wants a copy, not a move. |
| A silent guard pane | A user who attaches early sees a blank pane, and Ctrl+C kills the handoff. Print the waiting message and trap INT until the resume. |
