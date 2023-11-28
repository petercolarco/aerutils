; Colarco, Sept. 2006
; Get some MODIS data (nominally a year's worth)
; Assemble a set of seasonal plots of land/ocn combined and correlate

  yyyy = ['2009','2009']
  explist = ['YOTC.inst2d_ext_x']

  for iexp = 0, n_elements(explist)-1 do begin

  datewant=[yyyy[0]+'01', yyyy[1]+'12']
  satid = 'MISR'
  expid = explist[iexp]

; plotfile name
  yearstr = strmid(datewant[0],0,4)+'_'+strmid(datewant[1],0,4)

; Sampled
  mask_monthly = 0
  plotfile = './output/plots/'+expid+'.'+satid+'.'+yearstr+'.ps'
  ctlfilelnd = [expid+'.noqawt.'+satid+'.ctl',satid+'.e_6hr.ctl']

; Unsampled
;  mask_monthly = 1
;  plotfile = './output/plots/'+expid+'.unsampled_monthly_masked.'+satid+'.'+yearstr+'.ps'
;  mask_monthly = 0
;  plotfile = './output/plots/'+expid+'.unsampled.'+satid+'.'+yearstr+'.ps'
;  ctlfilelnd = [expid+'.ctl',satid+'.ctl']

  ga_getvar, ctlfilelnd[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint

  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(time)

; Get the model
  var = ['aodtau']
  var = ['du','ss','bcphilic','bcphobic','s04','ocphilic','ocphobic']
  nvars = n_elements(var)
  date = strarr(nt)
; land
  inp = fltarr(nx,ny,nt)
  for ivar = 0, nvars-1 do begin
    bin = 0
    if(var[ivar] eq 'du' or var[ivar] eq 'ss') then bin = 1
    ga_getvar, ctlfilelnd[0], var[ivar], varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=5.5e-7, bin=bin
    inp = inp + varout
  endfor
  a = where(inp ge 1e14)
  if(a[0] ne -1) then inp[a] = !values.f_nan
  aotmod = inp
  aotmod = reform(aotmod)

; Get the satellite
  var = ['aodtau']
  nvars = n_elements(var)
; land
  inp = fltarr(nx,ny,nt)
  for ivar = 0, nvars-1 do begin
    ga_getvar, ctlfilelnd[1], var[ivar], varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=550.
    inp = inp + varout
  endfor
  a = where(inp ge 1e14)
  if(a[0] ne -1) then inp[a] = !values.f_nan
  aotsat = inp
  aotsat = reform(aotsat)

; Mask model monthly
  if(mask_monthly) then begin
   a = where(finite(aotsat) ne 1)
   if(a[0] ne -1) then aotmod[a] = !values.f_nan
  endif



; Now do the seasonal average
  date = strmid(time,0,4)+strmid(time,5,2)

  a = where(strmid(date,4,2) le 3)
  aotmod_winter = fltarr(nx,ny)
  aotsat_winter = fltarr(nx,ny)
  aotcor_winter = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx -1 do begin
   for iy = 0, ny-1 do begin
    aotmod_winter[ix,iy] = mean(aotmod[ix,iy,a],/nan)
    aotsat_winter[ix,iy] = mean(aotsat[ix,iy,a],/nan)
    b = where(finite(aotsat[ix,iy,a]) eq 1)
    if(n_elements(b) ge 3) then $
     aotcor_winter[ix,iy] = correlate(aotmod[ix,iy,a[b]],aotsat[ix,iy,a[b]])
   endfor
  endfor

  a = where(strmid(date,4,2) gt 3 and strmid(date,4,2) le 6)
  aotmod_spring = fltarr(nx,ny)
  aotsat_spring = fltarr(nx,ny)
  aotcor_spring = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx -1 do begin
   for iy = 0, ny-1 do begin
    aotmod_spring[ix,iy] = mean(aotmod[ix,iy,a],/nan)
    aotsat_spring[ix,iy] = mean(aotsat[ix,iy,a],/nan)
    b = where(finite(aotsat[ix,iy,a]) eq 1)
    if(n_elements(b) ge 3) then $
     aotcor_spring[ix,iy] = correlate(aotmod[ix,iy,a[b]],aotsat[ix,iy,a[b]])
   endfor
  endfor

  a = where(strmid(date,4,2) gt 6 and strmid(date,4,2) le 9)
  aotmod_summer = fltarr(nx,ny)
  aotsat_summer = fltarr(nx,ny)
  aotcor_summer = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx -1 do begin
   for iy = 0, ny-1 do begin
    aotmod_summer[ix,iy] = mean(aotmod[ix,iy,a],/nan)
    aotsat_summer[ix,iy] = mean(aotsat[ix,iy,a],/nan)
    b = where(finite(aotsat[ix,iy,a]) eq 1)
    if(n_elements(b) ge 3) then $
     aotcor_summer[ix,iy] = correlate(aotmod[ix,iy,a[b]],aotsat[ix,iy,a[b]])
   endfor
  endfor

  a = where(strmid(date,4,2) ge 10)
  aotmod_autumn = fltarr(nx,ny)
  aotsat_autumn = fltarr(nx,ny)
  aotcor_autumn = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx -1 do begin
   for iy = 0, ny-1 do begin
    aotmod_autumn[ix,iy] = mean(aotmod[ix,iy,a],/nan)
    aotsat_autumn[ix,iy] = mean(aotsat[ix,iy,a],/nan)
    b = where(finite(aotsat[ix,iy,a]) eq 1)
    if(n_elements(b) ge 3) then $
     aotcor_autumn[ix,iy] = correlate(aotmod[ix,iy,a[b]],aotsat[ix,iy,a[b]])
   endfor
  endfor


; Now to the global total
  aotmod_global = fltarr(nx,ny)
  aotsat_global = fltarr(nx,ny)
  aotcor_global = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx -1 do begin
   for iy = 0, ny-1 do begin
    aotmod_global[ix,iy] = mean(aotmod[ix,iy,*],/nan)
    aotsat_global[ix,iy] = mean(aotsat[ix,iy,*],/nan)
    b = where(finite(aotsat[ix,iy,*]) eq 1)
    if(n_elements(b) ge 3) then $
     aotcor_global[ix,iy] = correlate(aotmod[ix,iy,b],aotsat[ix,iy,b])
   endfor
  endfor

; Now make the plots
  set_plot, 'ps'
  device, file=plotfile, /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=25, ysize=20
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.05,.555,.45,.905]
  position[*,1] = [.55,.555,.95,.905]
  position[*,2] = [.05,.03,.45,.38]
  position[*,3] = [.55,.03,.95,.38]

  season = ['Winter', 'Spring', 'Summer', 'Autumn', 'Global']

  for iseas = 0, 4 do begin
   titlestr = season[iSeas]
   case iseas of
    0: begin
       aotmod = aotmod_winter
       aotsat = aotsat_winter
       aotcor = aotcor_winter
       end
    1: begin
       aotmod = aotmod_spring
       aotsat = aotsat_spring
       aotcor = aotcor_spring
       end
    2: begin
       aotmod = aotmod_summer
       aotsat = aotsat_summer
       aotcor = aotcor_summer
       end
    3: begin
       aotmod = aotmod_autumn
       aotsat = aotsat_autumn
       aotcor = aotcor_autumn
       end
    4: begin
       aotmod = aotmod_global
       aotsat = aotsat_global
       aotcor = aotcor_global
       end
   endcase

   a =  where(finite(aotsat) ne 1)
   if(a[0] ne -1) then aotmod[a] = !values.f_nan

   diff = aotmod-aotsat
   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=position[*,0], /noborder
   plotgrid, aotmod, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = position[*,0]
   xyouts, position[0,0], position[3,0]+.03, 'Model', /normal, charsize=.8
   xyouts, position[0,0], position[3,0]+.06, season[iseas], /normal
   map_grid, /box, charsize=.8


   map_set, position=position[*,2], /noborder, /noerase
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan , /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = position[*,2]
   xyouts, position[0,2], position[3,2]+.03, satid, /normal, charsize=.8
   map_grid, /box, charsize=.8

   makekey, .05, .465, .4, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0, charsize=.65


   colorArray = [64,80,96,144,176,255,192,199,208,254,10]

   map_set, position=position[*,1], /noborder, /noerase
;  plot the negative differences
   levelarray = [-5,-.25,-.2,-.15,-.1,-.05]
   plotgrid, diff, levelarray, colorarray[0:5], lon, lat, dx, dy, undef=!values.f_nan, /map 

   levelarray = [.05,.1,.15,.2,.25]
   plotgrid, diff, levelarray, colorarray[6:10], lon, lat, dx, dy, undef=!values.f_nan , /map

   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = position[*,1]
   xyouts, position[0,1], position[3,1]+.03, 'Model-'+satid, /normal, charsize=.8
   map_grid, /box, charsize=.8


   levelarray = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]
   labelarray = string(levelarray,format='(f5.2)')
   labelarray[0] = ''
   makekey, .55, .465, .4, .025, 0, .03, color=colorarray, label=labelarray, $
    align=.5, charsize=.65

   levelArray = [-5.,-.9,-.75,-.5,-.25,-.1,.1,.25,.5,.75,.9]
   labelarray = string(levelarray,format='(f5.2)')
   labelarray[0] = ''

   map_set, position=position[*,3], /noborder, /noerase
   plotgrid, aotcor, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan , /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = position[*,3]
   xyouts, position[0,3], position[3,3]+.03, 'Correlation', /normal, charsize=.8
   map_grid, /box, charsize=.8

;   makekey, .55, .465, .4, .025, 0, -.02, color=colorarray, label=labelarray, $
;    align=.5, charsize=.65


  endfor

  device, /close

  endfor

end
