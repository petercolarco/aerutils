sdfopen /misc/prc15/colarco/dR_Fortuna-2-4-b4/inst2d_force_x/Y2009/M07/dR_Fortuna-2-4-b4.inst2d_force_x.monthly.200907.nc4

  set lon 45 90
  set lat 5 35

* plot
  c
  set mpdset hires
  set grads off
  set gxout grfill
  set clevs -30 -25 -20 -15 -10 -5 0 5
  d sw_toa_clr - sw_toa_clr_na
  cbarn
  draw title July 2009 Clear-Sky Direct Radiative Forcing [W m-2]
  plotpng dre_200907.png


* plot
  c
  set mpdset hires
  set grads off
  set gxout grfill
  set clevs -30 -25 -20 -15 -10 -5 0 5
  d sw_toa - sw_toa_na
  cbarn
  draw title July 2009 All-Sky Direct Radiative Forcing [W m-2]
  plotpng dre_allsky_200907.png
