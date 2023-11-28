sdfopen  /misc/prc13/MERRA2_GMI/c180/Y2003/M06/MERRA2_GMI.tavg1_2d_aer_Nx.monthly.200306.nc4
sdfopen  /misc/prc13/MERRA2_GMI/c180/Y2009/M06/MERRA2_GMI.tavg1_2d_aer_Nx.monthly.200906.nc4

set lon 20 80
set lat 10 50
set gxout shaded
set mpdset hires

c
xycomp duexttau.2(t=1) duexttau.1(t=1)
printim duexttau.200906_200306.M2GMI.png white

duem1 = (duem001+duem002+duem003+duem004+duem005)*30*86400*1000
duem2 = (duem001.2(t=1)+duem002.2(t=1)+duem003.2(t=1)+duem004.2(t=1)+duem005.2(t=1))*30*86400*1000

c
xycomp duem2 duem1
printim duem.200906_200306.M2GMI.png white


