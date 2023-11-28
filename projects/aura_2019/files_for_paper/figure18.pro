  dir = './'
  expid2 = 'GEOS.baseline'
  expid1 = 'GEOS.OAloss+updated_optics'

; Get a model field
  filen1 = dir+expid1+'.monthly.AOT.nc'
  nc4readvar, filen1, 'totexttau', low, lon=lon, lat=lat
  filen1c = dir+expid1+'.monthly.clouds_forcing.nc'
  nc4readvar, filen1c, 'CLDLO', clow, lon=lon, lat=lat
  nc4readvar, filen1c, 'swtnet', swtnet, lon=lon, lat=lat
  nc4readvar, filen1c, 'swtnetna', swtnetna, lon=lon, lat=lat
  nc4readvar, filen1c, 'swgnet', swgnet, lon=lon, lat=lat
  nc4readvar, filen1c, 'swgnetna', swgnetna, lon=lon, lat=lat
  lowtoa = (swtnet-swtnetna);-(swgnet-swgnetna)
  lowatm = (swtnet-swtnetna)-(swgnet-swgnetna)

; Get a model field
  filen2 = dir+expid2+'.monthly.AOT.nc'
  nc4readvar, filen2, 'totexttau', base, lon=lon, lat=lat
  filen2c = dir+expid2+'.monthly.clouds_forcing.nc'
  nc4readvar, filen2c, 'CLDLO', cbase, lon=lon, lat=lat
  nc4readvar, filen2c, 'swtnet', swtnet, lon=lon, lat=lat
  nc4readvar, filen2c, 'swtnetna', swtnetna, lon=lon, lat=lat
  nc4readvar, filen2c, 'swgnet', swgnet, lon=lon, lat=lat
  nc4readvar, filen2c, 'swgnetna', swgnetna, lon=lon, lat=lat
  basetoa = (swtnet-swtnetna);-(swgnet-swgnetna)
  baseatm = (swtnet-swtnetna)-(swgnet-swgnetna)

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  set_plot, 'ps'
  device, file='figure18.ps', /color, /helvetica, font_size=12, $
   xsize=36, ysize=24
  !p.font=0

; Aod Difference
  dlevels=[-2.5,-1.5,-1,-.5,-.1,.1,.5,1]/10
  dcolors=[255,224,200,176,128,80,40,16]
  loadct, 0
  position = [.05,.6,.45,.94]
  p0 = 0
  p1 = 0
  geolimits=[-40,-20,5,50]
  map_set, p0, p1, position=position, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  diff = base-low
  diff_ = diff
  diff_[*] = 0.
  loadct, 0
  plotgrid, diff_, [-.1], [200], lon, lat, dx, dy, /map
; plot data
  loadct, 72
  nokey = 0
  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=80, thick=5
  map_continents, color=80, thick=1, /countries
  map_set, p0, p1, /noerase, position = position, limit=geolimits
  map_grid, /box

  format = '(f5.2)'
  if(isa(dlevels,/integer)) then format='(i3)'
  labelarray = string(dlevels,format=format)
  labelarray[0] = ' '
  align=0.5
  loadct, 0
  makekey, .05, .535, .4, .025, 0, -0.015, $
   color=make_array(n_elements(dlevels),val=255), label=labelarray, $
   align=align
  loadct, 72
  makekey, .05, .535, .4, .025, 0, -0.015, color=dcolors, $
   label=make_array(n_elements(dlevels),val=' '), $
   align=align

  loadct, 0
  xyouts, .05, .97, '(a) AOD September 2016, Baseline - Updated', /normal



; SWTOA Difference
  dlevels=[-2.5,-1.5,-1,-.5,-.1,.1,.5,1,1.5]
  dcolors=[255,224,200,176,128,100,80,40,16]
  loadct, 0
  position = [.05,.1,.45,.44]
  p0 = 0
  p1 = 0
  geolimits=[-40,-20,5,50]
  map_set, p0, p1, position=position, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  diff = basetoa-lowtoa
  diff_ = diff
  diff_[*] = 0.
  loadct, 0
  plotgrid, diff_, [-.1], [200], lon, lat, dx, dy, /map
; plot data
  loadct, 72
  nokey = 0
  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=80, thick=5
  map_continents, color=80, thick=1, /countries
  map_set, p0, p1, /noerase, position = position, limit=geolimits
  map_grid, /box

  format = '(f5.2)'
  if(isa(dlevels,/integer)) then format='(i3)'
  labelarray = string(dlevels,format=format)
  labelarray[0] = ' '
  align=0.5
  loadct, 0
  makekey, .05, .035, .4, .025, 0, -0.015, $
   color=make_array(n_elements(dlevels),val=255), label=labelarray, $
   align=align
  loadct, 72
  makekey, .05, .035, .4, .025, 0, -0.015, color=dcolors, $
   label=make_array(n_elements(dlevels),val=' '), $
   align=align

  loadct, 0
  xyouts, .05, .47, '(c) TOA All-sky SW Aerosol Forcing [W m!E-2!N], Baseline - Updated', /normal

; SWATM Difference
  dlevels=[-10,-1.5,-.5,-.1,.1,.5,1.,1.5,2.]
  dcolors=[255,224,180,160,128,100,60,30,0]
  loadct, 0
  position = [.55,.1,.95,.44]
  p0 = 0
  p1 = 0
  geolimits=[-40,-20,5,50]
  map_set, p0, p1, position=position, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  diff = baseatm-lowatm
  diff_ = diff
  diff_[*] = 0.
  loadct, 0
  plotgrid, diff_, [-.1], [200], lon, lat, dx, dy, /map
; plot data
  loadct, 72
  nokey = 0
  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=80, thick=5
  map_continents, color=80, thick=1, /countries
  map_set, p0, p1, /noerase, position = position, limit=geolimits
  map_grid, /box

  format = '(f5.2)'
  if(isa(dlevels,/integer)) then format='(i3)'
  labelarray = string(dlevels,format=format)
  labelarray[0] = ' '
  align=0.5
  loadct, 0
  makekey, .55, .035, .4, .025, 0, -0.015, $
   color=make_array(n_elements(dlevels),val=255), label=labelarray, $
   align=align
  loadct, 72
  makekey, .55, .035, .4, .025, 0, -0.015, color=dcolors, $
   label=make_array(n_elements(dlevels),val=' '), $
   align=align

  loadct, 0
  xyouts, .55, .47, '(d) Atmosphere All-sky SW Aerosol Forcing [W m!E-2!N], Baseline - Updated', /normal



; Low Clouds
  dlevels=[.1,.2,.4,.8]
  dcolors=[160,128,60,0]
  loadct, 0
  position = [.55,.6,.95,.94]
  p0 = 0
  p1 = 0
  geolimits=[-40,-20,5,50]
  map_set, p0, p1, position=position, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  diff = cbase
  diff_ = diff
  diff_[*] = 0.
  loadct, 0
  plotgrid, diff_, [-.1], [200], lon, lat, dx, dy, /map
; plot data
  loadct, 72
  nokey = 0
  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=80, thick=5
  map_continents, color=80, thick=1, /countries
  map_set, p0, p1, /noerase, position = position, limit=geolimits
  map_grid, /box

  format = '(f5.2)'
  if(isa(dlevels,/integer)) then format='(i3)'
  labelarray = string(dlevels,format=format)
;  labelarray[0] = ' '
  align=0
  loadct, 0
  makekey, .55, .535, .4, .025, 0, -0.015, $
   color=make_array(n_elements(dlevels),val=255), label=labelarray, $
   align=align
  loadct, 72
  makekey, .55, .535, .4, .025, 0, -0.015, color=dcolors, $
   label=make_array(n_elements(dlevels),val=' '), $
   align=align

  loadct, 0
  xyouts, .55, .97, '(b) Low Cloud Fraction, Baseline', /normal

  device, /close
end
