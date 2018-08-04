#!/bin/bash -e

SEL=$(xsel -o)
TR=$( curl -sH "User-agent: Mozilla/5.0" \
      "http://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=ru&dt=t&q=$(echo $SEL | tr ' ' '+')" \
      | awk -F ',' '{gsub("\"|\\[", "", $1); print $1}' )

notify-send "$SEL" "$TR"

