#!/bin/bash -e

if [[ "$BLOCK_BUTTON" =~ 1|3 ]]; then
  gsimplecal
fi

date '+%d.%m.%Y'

