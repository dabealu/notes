#!/bin/bash -e

SEL=$(xsel -o)
SEL_FMT=$( echo "$SEL" | sed -e 's/ /+/g' -e 's/,//g' )
TR=$( curl -sH "User-agent: Mozilla/5.0" "http://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=ru&dt=t&q=\"|$SEL_FMT|\"" )

notify-send "$SEL" "$(echo $TR | awk -F '|' '{print $2}')"

