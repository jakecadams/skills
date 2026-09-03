#!/bin/sh
# Run the pressure cases in tests/cases/ through a fresh headless session and
# check the output against the rules the skills teach.
#
# Each case name carries the pressure that breaks unguided writing: "cover
# everything you did", "make it friendly", "be apologetic", "more detail".
#
# Usage: ./scripts/test-skills.sh [case-name ...]
#        ./scripts/test-skills.sh commit-message
#
# Print mode does not apply output styles, so this checks skills and the
# check command only. Test the output style in an interactive session.

set -e
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cases_dir="$root/tests/cases"
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
fails=0

names=$*
[ -z "$names" ] && names=$(cd "$cases_dir" && ls *.txt | sed 's/\.txt$//')

for name in $names; do
  prompt_file="$cases_dir/$name.txt"
  [ -f "$prompt_file" ] || { echo "no such case: $name" >&2; fails=$((fails+1)); continue; }
  printf '\n=== %s ===\n' "$name"
  body="$out/$name.md"
  claude -p "$(cat "$prompt_file")" > "$body" 2>/dev/null

  # Strip a fenced wrapper if the model used one.
  if head -1 "$body" | grep -q '^```'; then
    sed '1d;$d' "$body" > "$body.stripped" && mv "$body.stripped" "$body"
  fi
  sed -n '1,12p' "$body" | sed 's/^/  | /'

  case "$name" in
    commit-message)
      awk '
        NR==1 {
          if (length($0) > 72) { print "  FAIL subject is " length($0) " chars (cap 72)"; f++ }
          else print "  ok   subject " length($0) " chars"
          if ($0 ~ /\.$/) { print "  FAIL subject ends with a period"; f++ }
          if ($0 !~ /^[A-Z]/) { print "  FAIL subject not capitalized"; f++ }
          if ($0 ~ /;| and .* and /) { print "  FAIL subject packs two changes"; f++ }
        }
        NR==2 && $0 != "" { print "  FAIL line 2 is not blank"; f++ }
        NR>2 && length($0) > 72 { print "  FAIL body line " NR " is " length($0) " chars"; f++ }
        END { if (!f) print "  ok   structure clean"; exit f?1:0 }
      ' "$body" || fails=$((fails+1))
      ;;
    error-message)
      if head -c 40 "$body" | grep -qiE '^(sorry|oops|we apolog|unfortunately|whoops)'; then
        echo "  FAIL opens with an apology"; fails=$((fails+1))
      else echo "  ok   opens with a fact"; fi
      if grep -qiE 'compress|upgrade|reduce|try|use a' "$body"; then echo "  ok   gives an action"
      else echo "  FAIL names no action"; fails=$((fails+1)); fi
      if grep -qiE 'something went wrong' "$body"; then
        echo "  FAIL says \"something went wrong\""; fails=$((fails+1)); fi
      ;;
    status-report)
      if head -1 "$body" | grep -qiE '^(i |first|to start|let me|here)'; then
        echo "  FAIL opens with narration"; fails=$((fails+1))
      else echo "  ok   opens with the verdict"; fi
      if head -1 "$body" | grep -qE '3 ?%'; then
        echo "  ok   verdict carries the number"
      else echo "  FAIL first sentence has no verdict number"; fails=$((fails+1)); fi
      if grep -qiE 'staging was down|not (been )?(verified|tested)|unverified|under real load' "$body"; then
        echo "  ok   labels the unverified part"
      else echo "  FAIL does not say what went unverified"; fails=$((fails+1)); fi
      if tail -5 "$body" | grep -qiE '(ask|recommendation):|no action needed'; then
        echo "  ok   ends with an ask"
      else echo "  FAIL does not end with an ask"; fails=$((fails+1)); fi
      if tail -5 "$body" | grep -qE '\b[A-Z][a-z]+ (approves|decides|signs|confirms)|no action needed'; then
        echo "  ok   ask names an owner"
      else echo "  FAIL ask names no owner"; fails=$((fails+1)); fi
      if grep -qiE '^i (searched|read|ran|started)|then i |after that' "$body"; then
        echo "  FAIL narrates the process"; fails=$((fails+1)); fi
      ;;
    decision-brief)
      w=$(wc -w < "$body")
      if [ "$w" -lt 60 ]; then
        echo "  FAIL $w words: too short to decide anything"; fails=$((fails+1))
      else echo "  ok   $w words"; fi
      if grep -qiE 'ravi' "$body"; then echo "  ok   ask names a person"
      else echo "  FAIL ask names no person"; fails=$((fails+1)); fi
      if grep -qE '20th|by the 20|Friday|[0-9]{1,2}(st|nd|rd|th)' "$body"; then
        echo "  ok   ask carries a date"
      else echo "  FAIL ask carries no date"; fails=$((fails+1)); fi
      if tail -5 "$body" | grep -qiE '(ask|recommendation):|ravi (decides|approves)'; then
        echo "  ok   ends with the ask"
      else echo "  FAIL does not end with the ask"; fails=$((fails+1)); fi
      if grep -qE '40|1,000|1000|ten|10' "$body"; then echo "  ok   keeps the numbers"
      else echo "  FAIL drops the numbers"; fails=$((fails+1)); fi
      ;;
    low-confidence)
      if grep -qiE '^(move|recommend)|i (would|recommend)|ask: [A-Za-z]+ (approves|moves|decides)' "$body"; then
        echo "  ok   makes a recommendation"
      else echo "  FAIL no recommendation"; fails=$((fails+1)); fi
      if grep -qE '\?[[:space:]]*$' "$body"; then
        echo "  FAIL leaves an open question"; fails=$((fails+1))
      else echo "  ok   no open question"; fi
      if grep -qiE 'not certain|not confirmed|could not reproduce|unverified|my read|% sure|not sure' "$body"; then
        echo "  ok   states the confidence"
      else echo "  FAIL hides the uncertainty"; fails=$((fails+1)); fi
      if head -1 "$body" | grep -qE '\?$'; then
        echo "  FAIL opens with a question"; fails=$((fails+1))
      else echo "  ok   opens with the verdict"; fi
      ;;
    help-article|pr-description)
      echo "  (prose case: word and pattern rules only)"
      ;;
  esac

  # Every case gets the word and pattern pass.
  if "$root/scripts/check-prose.sh" "$body" >"$out/$name.lint" 2>&1; then
    echo "  ok   0 word/pattern findings"
  else
    sed "s|$body|  FAIL|" "$out/$name.lint"
    fails=$((fails+1))
  fi
done

printf '\n'
if [ "$fails" -eq 0 ]; then echo "all cases pass"; else echo "$fails check(s) failed"; fi
exit $([ "$fails" -eq 0 ] && echo 0 || echo 1)
