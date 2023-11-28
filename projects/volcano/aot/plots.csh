#!/bin/csh
# Make the plots

  set g5v = ("NHL" "NML" "TRO" "STR" "SML" "SHL")
  set giv = ("NHh" "NHm" "TR0" "TRa" "SHm" "SHh")

  set g5s = ("jan" "apr" "jul" "oct")
  set gis = ("Win_anl" "Spr_anl" "Sum_kt" "Fal_kt")

  foreach volc (1 2 3 4 5 6)

  foreach seas (1 2 3 4)
echo $volc $seas
   sed 's#NHL#'$g5v[$volc]'#g;s#NHh#'$giv[$volc]'#g;s#jan#'$g5s[$seas]'#g;s#Win_anl#'$gis[$seas]'#g' aot.g > $g5v[$volc]$g5s[$seas].g
   gsh $g5v[$volc]$g5s[$seas].g

  end

  end
