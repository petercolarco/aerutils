; Colarco, Sept. 2006
; Get some MODIS data (nominally a year's worth)
; Assemble a set of seasonal plots of land/ocn combined and correlate

  satid   = 'MISR'
  expid   = 'R_QFED_22a1'
  res     = 'b'
  scaledu = 0.1/0.14
  ctlocn  = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
             expid+'.inst2d_hwl_x.MISR_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  ctllnd  = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
             expid+'.inst2d_hwl_x.MISR_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'

; Dates
  nymd0 = '20070115'
  nhms0 = '120000'
  nymd1 = '20101231'
  nhms1 = '120000'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms, /monthly
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)

  nt = n_elements(nymd)
  if(nt/12 ne nt/12.) then stop

; Get the satellite AOT
  for i = 0, nt-1 do begin
   read_aot, aot, lon, lat, yyyy[i], mm[i], satid=satid, res=res
   nx = n_elements(lon)
   ny = n_elements(lat)
   aot = reform(aot,nx*ny*1L)
   if(i eq 0) then aotsat = aot else aotsat = [aotsat,aot]
  endfor
  aotsat = reform(aotsat,nx,ny,nt)

; Get the model AOT
  for i = 0, nt-1 do begin
print, 'doing: ', nymd[i]
   fileocn = strtemplate(ctlocn,nymd[i],nhms[i],str=expid)
   filelnd = strtemplate(ctllnd,nymd[i],nhms[i],str=expid)
   read_aot, aot, lon, lat, yyyy[i],mm[i],satid=satid, res=res, $
    ctlmodelocean=fileocn, ctlmodelland=filelnd, /model
;  First element is dust
   aot[*,*,*,0] = aot[*,*,*,0]*scaledu
   aot = reform(total(aot,4))
   nx = n_elements(lon)
   ny = n_elements(lat)
   aot = reform(aot,nx*ny*1L)
   if(i eq 0) then aotmod = aot else aotmod = [aotmod,aot]
  endfor
  aotmod = reform(aotmod,nx,ny,nt)

  yearstr = min(yyyy)+'_'+max(yyyy)

; Sampled
  mask_monthly = 0
  plotfile = './output/plots/'+expid+'.'+satid+'.'+yearstr+'.ps'

; Mask model monthly
  if(mask_monthly) then begin
   a = where(finite(aotsat) ne 1)
   if(a[0] ne -1) then aotmod[a] = !values.f_nan
  endif




; Now do the seasonal average
  date = yyyymm
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

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=position[*,0], /noborder
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = position[*,0]
   xyouts, position[0,0], position[3,0]+.03, satid, /normal, charsize=.8
   xyouts, position[0,0], position[3,0]+.06, season[iseas], /normal
   map_grid, /box, charsize=.8


   map_set, position=position[*,2], /noborder, /noerase
   plotgrid, aotmod, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan , /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = position[*,2]
   xyouts, position[0,2], position[3,2]+.03, 'Model', /normal, charsize=.8
   map_grid, /box, charsize=.8

   makekey, .05, .465, .4, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0, charsize=.65


   colorArray = [64,80,96,144,176,255,192,199,208,254,10]
   a =  where(finite(aotsat) ne 1)
   if(a[0] ne -1) then aotmod[a] = !values.f_nan
   diff = aotmod-aotsat

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

   makekey, .55, .465, .4, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=.5, charsize=.65

  endfor

  device, /close

; Plot the long average difference plot as a vertical plot

  set_plot, 'ps'
  device, file=plotfile+'_globalvertical', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0

   xycomp, aotmod, aotsat, lon, lat, dx, dy, geolimits=geolimits

   title=expid+' (top), '+satid+' (middle), top-middle (bottom)'
   xyouts, .45, .97, title, align=.5, /normal
;   xyouts, .95, .97, yyyymm, align=.5, /normal

   device, /close


end
