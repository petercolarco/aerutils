* Colarco, June 1, 2007
* sample some aot from some sfc diagnostic files
reinit
clear
xdfopen ../ctl/a0105.ddf
xdfopen ../ctl/a0107.ddf
xdfopen ../ctl/a0104.ddf
* xdfopen ../../aerutils_save/ctl/t002_b55.ctl
xdfopen ../ctl/t002_b55.chem_diag.sfc.ctl
set time 1jan2004 1dec2004

set lon -76
set lat 38
set dfile 4
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
draw title GSFC
set dfile 1
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
set dfile 2
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
set dfile 3
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
printim gsfc.png




clear
set lon -22
set lat 16
set dfile 4
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
draw title Capo Verde
set dfile 1
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
set dfile 2
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
set dfile 3
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
printim capoverde.png




clear
set lon 23
set lat 15
set dfile 4
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
draw title Mongu
set dfile 1
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
set dfile 2
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
set dfile 3
d duexttau+ssexttau+suexttau+bcexttau+ocexttau
printim mongu.png
