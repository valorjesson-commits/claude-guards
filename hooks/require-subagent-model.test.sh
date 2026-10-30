#!/bin/sh
# Self-check for require-subagent-model.sh: sh hooks/require-subagent-model.test.sh
hook=$(dirname "$0")/require-subagent-model.sh
fail=0
check() { # expected-exit tool_input-json
  printf '{"tool_input":%s}' "$2" | sh "$hook" 2>/dev/null
  got=$?; [ "$got" = "$1" ] || { echo "FAIL want $1 got $got: $2"; fail=1; }
}
check 2 '{"prompt":"x"}'
check 2 '{"prompt":"x","subagent_type":"Explore","model":""}'
check 2 '{"prompt":"x","model":"   "}'
check 2 '{"prompt":"x","model":null}'
check 0 '{"prompt":"x","model":"haiku"}'
check 0 '{"prompt":"x","subagent_type":"fork"}'
check 0 '{"prompt":"x","subagent_type":"Fork"}'
[ $fail = 0 ] && echo ok
exit $fail
