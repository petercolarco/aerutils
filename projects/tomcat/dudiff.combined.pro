; Plot the difference of the monthly mean hour max/min difference

; Region
  wantlon = [-17,37]
  wantlat = [7,27]
  aotrange= [0,1]

;  wantlon = [-30,-20]
;  wantlat = [15,20]
;  aotrange= [0,1.5]

  ddf = 'iss1.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlon=wantlon, wantlat=wantlat, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  a = where(aot gt 1e5)
  if(a[0] ne -1) then aot[a] = !values.f_nan
  aotsav = aot
; sort hourly and average
  aot1 = reform(aot,nx,ny,24,30)
;  aot1 = mean(aot1,dim=4,/nan)

  ddf = 'iss2.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', aot, wantlon=wantlon, wantlat=wantlat, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  a = where(aot gt 1e5)
  if(a[0] ne -1) then aot[a] = !values.f_nan
  aotsav = aot
; sort hourly and average
  aot2 = reform(aot,nx,ny,24,30)
;  aot2 = mean(aot2,dim=4,/nan)
stop

  aotd = max(aotf,dim=3)-min(aotf,dim=3)

  levels = [0,.05,.1,.15,.2,.25]
  colors = [48,84,144,192,208,254]

  set_plot, 'ps'
  device, file='dudiff.combined.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39

  map_set, limit=[5,-20,30,40], position=[.05,.25,.95,.95]
  contour, aotd, lon, lat, levels=levels, c_color=colors, /cell, /over
  map_continents, /hires, thick=3
  map_continents, /hires, /countries
  makekey, .05, .1, .9, .1, 0, -.05, color=colors, labels=string(levels,format='(f4.2)'), align=0
  device, /close

end
