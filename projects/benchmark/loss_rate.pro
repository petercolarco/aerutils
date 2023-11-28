  expid = 'c180R_pI33p7'
;  expid = 'c180R_J10p12p3'
  expid = 'c180R_J10p12p3dev_asd'
  ddf   = expid+'.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename_ = strtemplate(parsectl_dset(ddf),nymd,nhms)
  filename_ = filename_[6]
;expid = 'c180R_J10p12p3dev_asd_fp'
;filename_ = '/misc/prc18/colarco/'+expid+'/'+expid+'.tavg2d_aer_x.monthly.201907.nc4'

  nc4readvar, filename_[0], 'ducmass', ducmass, lon=lon, lat=lat
  nc4readvar, filename_[0], 'dusv',    dusv, /sum, /tem
  nc4readvar, filename_[0], 'duwt',    duwt, /sum, /tem
  dusv = -1.*dusv*86400.
  if(expid eq 'c180R_pI33p7') then dusv = -1.*dusv
  duwt =     duwt*86400.

; throw out low column mass
  ducmass[where(ducmass lt 2.e-5)] = !values.f_nan

; Make a plot of scavenging rate
  set_plot, 'ps'
  device, file='scav_rate.'+expid+'.july.ps', /color
  !p.font=0

  map_set, position=[.05,.15,.95,.95]
  loadct, 0
  contour, /overplot, dusv/ducmass, lon, lat, /cell, $
   levels=-1000., c_colors=140
  loadct, 39
  colors = findgen(9)*30
  levels = reverse(1./ [1,2,5,10,20,50,100,200,500.])
  contour, /overplot, dusv/ducmass, lon, lat, /cell, $
   levels=levels, c_colors=colors
  map_continents
  makekey, .1,.08,.8,.05,0,-0.035,align=0,$
   colors=colors, label=string(levels,format='(f5.3)')
  device, /close


; Make a plot of wet removal rate
  set_plot, 'ps'
  device, file='wet_rate.'+expid+'.july.ps', /color
  !p.font=0

  map_set, position=[.05,.15,.95,.95]
  loadct, 0
  contour, /overplot, duwt/ducmass, lon, lat, /cell, $
   levels=-1000., c_colors=140
  loadct, 39
  colors = findgen(9)*30
  levels = reverse(1./[1,2,5,10,20,50,100,200,500.])
  contour, /overplot, duwt/ducmass, lon, lat, /cell, $
   levels=levels, c_colors=colors
  map_continents
  makekey, .1,.08,.8,.05,0,-0.035,align=0,$
   colors=colors, label=string(levels,format='(f5.3)')
  device, /close


end
