---
description: Check writing against the writing-style rules. Reports findings; changes nothing.
argument-hint: "[file path, or nothing to check the most recent draft]"
allowed-tools: Bash, Read, Glob, Grep
---

<!-- writing-style:disable — this file quotes banned words on purpose -->

Check writing against the writing-style rules and report what you would
change. Do not edit anything. Do not rewrite the text unless the user
asks in a later message.

## Step 1: Find the target

`$ARGUMENTS` is one of:

- **A file path or a glob.** Check those files.
- **Pasted text.** Check the text.
- **Empty.** Check the most recent thing written in this conversation:
  a draft, a commit message, a pull request body, or a file just
  edited. Say which one you picked in the first line of your report.

## Step 2: Run the mechanical pass

For a file target, run the checker:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/check-prose.sh" <files>
```

It reports banned words with replacements, "and/or", "click here",
exclamation points, and sentences over 25 words. It exits 1 when it
finds a violation, which is expected output, not a failure to fix.

For a commit message target, add these counts yourself: subject length,
whether line 2 is blank, and whether any body line exceeds 72
characters.

For pasted text with no file, do the same scan yourself using
`${CLAUDE_PLUGIN_ROOT}/skills/writing/clear-writing/references/plain-words.txt`.

## Step 3: Run the judgment pass

The script cannot see these. Read the text and check them yourself:

- **Imperative mood.** Does "If applied, this commit will ___" read as
  a sentence?
- **Why, not how.** Does the body explain the reason, or narrate the
  diff file by file?
- **Noun clusters.** More than three nouns in a row.
- **Term drift.** A thing called two different names.
- **Error shape.** Does the message open with a fact, and does it carry
  what happened, why, and what to do?
- **Lead.** Does the first sentence of each paragraph carry its point?
- **Evidence.** Does a Testing section say what actually ran, or is it
  unchecked boxes?
- **Voice.** "will" or "you'll" describing product behavior.

## Step 4: Report

One finding per line, in this shape:

```
path:line: finding -> what to write instead
```

Group mechanical findings first, then judgment findings. End with a
one-line count. If there are no findings, say so in one line.

Do not soften the report. Do not add praise before the findings.

## Precedence

Project instructions in `CLAUDE.md` or `AGENTS.md` win over these rules.
If a project sets a conventional-commit prefix, a ticket prefix, or a
house copy guide, do not report conformance with it as a violation.
