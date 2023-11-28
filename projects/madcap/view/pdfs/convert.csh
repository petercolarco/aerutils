#!/bin/tcsh

  convert gpm.random.freq.200601.png gpm.random.freq.200602.png \
          gpm.random.freq.200603.png gpm.random.freq.200604.png +append f1.png
  convert gpm.random.freq.200605.png gpm.random.freq.200606.png \
          gpm.random.freq.200607.png gpm.random.freq.200608.png +append f2.png
  convert gpm.random.freq.200609.png gpm.random.freq.200610.png \
          gpm.random.freq.200611.png gpm.random.freq.200612.png +append f3.png
  convert f1.png f2.png f3.png -append gpm.random.freq.png

#  foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

#  convert ss450.nadir.freq.2006$mm.png ss450.random.freq.2006$mm.png \
#          +append f1.png
#  convert gpm.nadir.freq.2006$mm.png gpm.random.freq.2006$mm.png \
#          +append f2.png
#  convert f1.png f2.png -append freq.2006$mm.png

#  end
