#!/bin/sh
# PreToolUse hook, matcher Bash.
#
# The commit-messages skill fires when the model is asked to write a
# commit message. It does not fire when a session reaches `git commit`
# after doing something else, which is where most rushed messages come
# from. This hook injects the rules at that moment instead.
#
# It blocks nothing. It adds context and exits 0.

input=$(cat)

emit() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse"},"additionalContext":"%s"}\n' "$1"
}

case "$input" in
  *"gh pr create"*|*"gh pr edit"*)
    emit "You are about to create or edit a pull request. Rules from the commit-messages skill. Title: imperative, specific, 72 characters max, no trailing period. Never a bare ticket ID with no words. Start with the ticket ID only when the repository history does. Body: use the repository pull request template when one exists and do not substitute your own section layout; never leave the body empty. The description covers the problem, why this approach, the user-facing impact, and the risks; it is not a commit list. Testing states what you ran and what happened. List anything you did not verify as not run. Unchecked boxes are a plan, not testing. Demo: a screenshot or recording for visual changes, otherwise one line saying why there is nothing to show. Call out unrelated changes shipping in the same pull request. Project instructions in CLAUDE.md or AGENTS.md win over these rules."
    exit 0
    ;;
esac

case "$input" in
  *git*commit*)
    emit "You are about to run git commit. Rules from the commit-messages skill. Subject: 50 characters or fewer, 72 is the hard cap. Use the imperative mood, so it passes \\\"If applied, this commit will ___\\\". Capitalize it, unless the repository history uses a conventional-commit prefix; then match the repository. No trailing period. Put one change in the subject and secondary changes in an Also paragraph. Leave line 2 blank. Wrap the body at 72. The body explains the symptom, the cause, and why this approach. It never narrates the diff file by file. Project instructions in CLAUDE.md or AGENTS.md win over these rules."
    exit 0
    ;;
esac

exit 0
