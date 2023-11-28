* sdfopen /misc/prc11/colarco/dCR_Fortuna-2_4-b5p2/inst3d_carma_v/Y2009/M06/dCR_Fortuna-2_4-b5p2.inst3d_carma_v.20090629_0000z.nc4
sdfopen /misc/prc11/colarco/dCR_Fortuna-2_4-b5p2/inst3d_carma_v/Y2009/M07/dCR_Fortuna-2_4-b5p2.inst3d_carma_v.20090702_0000z.nc4

  set grads off
  set lon -180 180
  set lat -90  90

* dust loading
  ducmass = sum(delp*(du001+du002+du003+du004+du005+du006+du007+du008),z=1,z=72)
  ducmass = ducmass / 9.8

* black carbon loading
  bccmass = sum(delp*(bc001+bc002+bc003+bc004+bc005+bc006+bc007+bc008),z=1,z=72)
  bccmass = bccmass / 9.8

* black carbon core loading
  dubccmass = sum(delp*(dubc001+dubc002+dubc003+dubc004+dubc005+dubc006+dubc007+dubc008),z=1,z=72)
  dubccmass = dubccmass / 9.8


* plot
  set lon 45 90
  set lat 5 35
  set mpdset hires

* dust column w/ bc column
  c
  set grads off
  set gxout grfill
  d ducmass * 1000
  cbarn
  draw title July 2009 Dust (Black Carbon) load [g m-2]
  set gxout contour
  d bccmass * 1000
  plotpng du_bc.png


* dust column w/ bc core column
  c
  set grads off
  set gxout grfill
  d ducmass * 1000
  cbarn
  draw title July 2009 Dust (Black Carbon Core) load [g m-2]
  set gxout contour
  d dubccmass * 1000
  plotpng du_dubc.png



* fractional BC core to dust
  c
  set grads off
  set gxout grfill
  d dubccmass / (ducmass+dubccmass) * 100
  cbarn
  draw title July 2009 % Black Carbon Core / Total Dust + BC
  plotpng du_dubc_percent.png



* fractional BC core to black carbon total
  c
  set grads off
  set gxout grfill
  set clevs .2 .4 .6 .8 1 1.2 1.4 1.6 1.8 2 2.2 2.4
  d dubccmass / (bccmass + dubccmass) * 100
  cbarn
  draw title July 2009 % Black Carbon Core / Black Carbon Total
  plotpng bc_dubc.png


* fractional BC core to black carbon total (global)
  c
  set grads off
  set lon -180 180
  set lat -90  90
  d dubccmass / (bccmass + dubccmass) * 100
  cbarn
  draw title July 2009 % Black Carbon Core / Black Carbon Total
  plotpng bc_dubc_global.png


* fractional BC core to dust (global)
  c
  set grads off
  set gxout grfill
  d dubccmass / (ducmass+dubccmass) * 100
  cbarn
  draw title July 2009 % Black Carbon Core / Total Dust + BC
  plotpng du_dubc_percent_global.png


