#!/bin/sh
# Check Markdown or plain-text prose against the plain-word list and a
# few pattern rules. Reports findings; changes nothing.
#
# Usage: check-prose.sh FILE [FILE ...]
#
# Checks every prose line against plain-words.txt and these patterns:
# "and/or", "click here", and exclamation points. Warns, without
# failing, on sentences over 25 words. Skips fenced code blocks,
# inline code spans, blockquote lines, and any file containing the
# marker "writing-style:disable".
#
# Exits 1 when any file has a violation, 0 otherwise.

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
list="${WRITING_STYLE_WORDLIST:-$dir/../skills/writing/clear-writing/references/plain-words.txt}"
status=0

if [ ! -f "$list" ]; then
  echo "check-prose: word list not found at $list" >&2
  exit 2
fi

for f in "$@"; do
  [ -f "$f" ] || { echo "check-prose: no such file: $f" >&2; status=2; continue; }
  if grep -q 'writing-style:disable' "$f" 2>/dev/null; then continue; fi
  awk -v LISTFILE="$list" -v FNAME="$f" '
    function esc(s) { gsub(/[][\\.^$(){}|*+?\/]/, "\\\\&", s); return s }
    BEGIN {
      split("this that they them then than have will your with from once into when what does only more most some such been were also here there thing", stopw, " ")
      for (z in stopw) stop[stopw[z]] = 1
      while ((getline line < LISTFILE) > 0) {
        if (line ~ /^[ \t]*(#|$)/) continue
        p = index(line, "|")
        if (p == 0) continue
        b = substr(line, 1, p - 1)
        bad[++n] = b
        good[n] = substr(line, p + 1)
        pat[n] = "(^|[^a-z0-9])" esc(tolower(b)) "([^a-z0-9]|$)"
      }
    }
    /^[ \t]*```/ { incode = !incode; next }
    incode       { next }
    /^[ \t]*>/   { next }
    {
      text = $0
      gsub(/`[^`]*`/, " ", text)
      lt = tolower(text)
      for (i = 1; i <= n; i++)
        if (lt ~ pat[i]) {
          printf "%s:%d: \"%s\" -> %s\n", FNAME, NR, bad[i], good[i]
          viol++
        }
      if (lt ~ /(^|[^a-z0-9])and\/or([^a-z0-9]|$)/) {
        printf "%s:%d: \"and/or\" -> \"a or b, or both\"\n", FNAME, NR
        viol++
      }
      if (lt ~ /click here/) {
        printf "%s:%d: \"click here\" -> name the destination\n", FNAME, NR
        viol++
      }
      noimg = text
      gsub(/!\[/, " ", noimg)
      if (noimg ~ /!/) {
        printf "%s:%d: exclamation point in prose\n", FNAME, NR
        viol++
      }
      if (text !~ /^[ \t]*(#|\||[-*] |[0-9]+\. )/) {
        m = split(text, sents, /[.?] /)
        for (s = 1; s <= m; s++) {
          nw = split(sents[s], w, /[ \t]+/)
          if (nw > 25)
            printf "%s:%d: warning: sentence over 25 words\n", FNAME, NR
          # A short sentence echoing a content word from the one before it is
          # usually an aphoristic punch line. Warn only: some are legitimate.
          if (nw <= 6 && prev != "") {
            for (k = 1; k <= nw; k++) {
              tok = tolower(w[k]); gsub(/[^a-z0-9]/, "", tok)
              if (length(tok) < 4 || tok in stop) continue
              if (index(prev, " " tok " ") > 0) {
                printf "%s:%d: warning: short sentence echoes \"%s\" from the previous sentence\n", FNAME, NR, tok
                break
              }
            }
          }
          if (nw > 0) {
            prev = tolower(sents[s])
            gsub(/[^a-z0-9]+/, " ", prev)
            prev = " " prev " "
          }
        }
      }
    }
    END { exit viol ? 1 : 0 }
  ' "$f" || status=1
done
exit $status
