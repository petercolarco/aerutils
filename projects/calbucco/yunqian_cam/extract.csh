#!/bin/tcsh
# Coping with failure of nc4readvar to deal with single file with multiple
# times, so run lats4d.sh to extract single time

  lats4d.sh -i sulfate_dry_mmr.ddf -o sulfate_dry_mmr.20150429 -time 12z29apr2015
  lats4d.sh -i sulfatwt.ddf -o sulfatwt.20150429 -time 12z29apr2015
  lats4d.sh -i nitridwt.ddf -o nitridwt.20150429 -time 12z29apr2015
  lats4d.sh -i sulfatro.ddf -o sulfatro.20150429 -time 12z29apr2015

  lats4d.sh -i sulfate_dry_mmr.ddf -o sulfate_dry_mmr.20150415 -time 12z15apr2015
  lats4d.sh -i sulfatwt.ddf -o sulfatwt.20150415 -time 12z15apr2015
  lats4d.sh -i nitridwt.ddf -o nitridwt.20150415 -time 12z15apr2015
  lats4d.sh -i sulfatro.ddf -o sulfatro.20150415 -time 12z15apr2015
