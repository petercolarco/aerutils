#!/bin/csh
  set expid  = "t003_c32"
  set expdir = "/misc/prc10/colarco/$expid/tau/"

  foreach YYYY (2000 2001 2002 2003 2004 2005 2006)
  foreach MM   (01 02 03 04 05 06 07 08 09 10 11 12)

  foreach file (`\ls -1 $expdir/Y$YYYY/M$MM/$expid.*.??????.hdf`)
   h4zip -shave $file &
  end
  wait


end
end
