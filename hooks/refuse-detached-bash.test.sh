#!/bin/sh
# Self-check for refuse-detached-bash.sh: sh hooks/refuse-detached-bash.test.sh
hook=$(dirname "$0")/refuse-detached-bash.sh
fail=0
check() { # expected-exit run_in_background command
  jq -nc --arg c "$3" --argjson b "$2" '{tool_input:{command:$c,run_in_background:$b}}' | sh "$hook" 2>/dev/null
  got=$?; [ "$got" = "$1" ] || { echo "FAIL want $1 got $got: $3"; fail=1; }
}
check 2 false 'nohup python x.py > log 2>&1 &'
check 2 false 'cd /a && nohup ~/bin/limited -- job &'
check 2 false "ssh h 'cd /root && nohup job &'"
check 2 false 'bash -lc "nohup job >log 2>&1 &"'
check 2 false 'job & disown'
check 2 false 'setsid job'
check 2 false 'for m in 5 3; do nohup job &; done'
check 0 true  'setsid -w nohup job >log 2>&1 </dev/null & wait $!; tail -20 log'
check 0 false 'grep -c nohup /tmp/x.txt'
check 0 false 'echo "nohup setsid disown"'
check 0 false "printf '%s\n' 'nohup in text only'"
check 0 false 'python train.py'
[ $fail = 0 ] && echo ok
exit $fail
