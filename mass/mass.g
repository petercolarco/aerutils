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

clear
set lon 0 360
set lat 0 180
define mass1 = aave(ducmass.1,g)
define mass2 = aave(ducmass.2,g)
define mass3 = aave(ducmass.3,g)
define mass4 = aave(ducmass.4,g)
set x 1
set y 1
d mass4
d mass1
d mass2
d mass3
draw title ducmass [global ave, kg m-2]
printim ducmass.png



clear
set lon 0 360
set lat 0 180
define mass1 = aave(bccmass.1,g)
define mass2 = aave(bccmass.2,g)
define mass3 = aave(bccmass.3,g)
define mass4 = aave(bccmass.4,g)
set x 1
set y 1
d mass4
d mass1
d mass2
d mass3
draw title bccmass [global ave, kg m-2]
printim bccmass.png



clear
set lon 0 360
set lat 0 180
define mass1 = aave(occmass.1,g)
define mass2 = aave(occmass.2,g)
define mass3 = aave(occmass.3,g)
define mass4 = aave(occmass.4,g)
set x 1
set y 1
d mass4
d mass1
d mass2
d mass3
draw title occmass [global ave, kg m-2]
printim occmass.png
