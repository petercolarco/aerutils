; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  expid = 't003_c32.v2'
  years = ['2000','2001','2002','2003','2004','2005','2006']
  read_mon_mean, expid, years, location, latitude, longitude, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd
  date = strcompress(string(date),/rem)

; exclude Mauna_Loa from results
  a = where(location ne 'Mauna_Loa')
  location  = location[a]
  latitude  = latitude[a]
  longitude = longitude[a]
  angaeronet = angaeronet[*,a]
  aotaeronet = aotaeronet[*,a]
  angaeronetstd = angaeronetstd[*,a]
  aotaeronetstd = aotaeronetstd[*,a]
  angmodel   = angmodel[*,a]
  aotmodel   = aotmodel[*,a]
  angmodelstd   = angmodelstd[*,a]
  aotmodelstd   = aotmodelstd[*,a]

  

; Create a plot file
  set_plot, 'ps'
  device, file='./output/plots/scatter_ann.color.'+expid+'.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=21, xsize=20, ysize=20, /landscape
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.1,.6,.45,.95]
  position[*,1] = [.625,.6,.975,.95]
  position[*,2] = [.1,.1,.45,.45]
  position[*,3] = [.625,.1,.975,.45]

; segregate by season
  nloc = n_elements(location)
  winter = where(strmid(date,4,2) le 3)
  aotaer_winter = reform(aotaeronet[winter,*])
  aotmod_winter = reform(aotmodel[winter,*])
  angaer_winter = reform(angaeronet[winter,*])
  angmod_winter = reform(angmodel[winter,*])
  b = where(finite(aotaer_winter) eq 1)
  aotaer_winter = aotaer_winter[b]
  aotmod_winter = aotmod_winter[b]
  angaer_winter = angaer_winter[b]
  angmod_winter = angmod_winter[b]

  spring = where(strmid(date,4,2) gt 3 and strmid(date,4,2) le 6)
  aotaer_spring = reform(aotaeronet[spring,*])
  aotmod_spring = reform(aotmodel[spring,*])
  angaer_spring = reform(angaeronet[spring,*])
  angmod_spring = reform(angmodel[spring,*])
  b = where(finite(aotaer_spring) eq 1)
  aotaer_spring = aotaer_spring[b]
  aotmod_spring = aotmod_spring[b]
  angaer_spring = angaer_spring[b]
  angmod_spring = angmod_spring[b]

  summer = where(strmid(date,4,2) gt 6 and strmid(date,4,2) le 9)
  aotaer_summer = reform(aotaeronet[summer,*])
  aotmod_summer = reform(aotmodel[summer,*])
  angaer_summer = reform(angaeronet[summer,*])
  angmod_summer = reform(angmodel[summer,*])
  b = where(finite(aotaer_summer) eq 1)
  aotaer_summer = aotaer_summer[b]
  aotmod_summer = aotmod_summer[b]
  angaer_summer = angaer_summer[b]
  angmod_summer = angmod_summer[b]

  autumn = where(strmid(date,4,2) gt 9)
  aotaer_autumn = reform(aotaeronet[autumn,*])
  aotmod_autumn = reform(aotmodel[autumn,*])
  angaer_autumn = reform(angaeronet[autumn,*])
  angmod_autumn = reform(angmodel[autumn,*])
  b = where(finite(aotaer_autumn) eq 1)
  aotaer_autumn = aotaer_autumn[b]
  aotmod_autumn = aotmod_autumn[b]
  angaer_autumn = angaer_autumn[b]
  angmod_autumn = angmod_autumn[b]

  xtitle = 'AERONET'
  ytitle = 'Model'
  season = ['Winter', 'Spring', 'Summer', 'Autumn']
  for ipage = 0, 1 do begin
   if(ipage eq 0) then title = 'AOT [550 nm]'
   if(ipage eq 1) then title = 'Angstrom Parameter'

  for iseas = 0, 3 do begin
   if(ipage eq 0) then begin
    if(iseas eq 0) then x = aotaer_winter
    if(iseas eq 0) then y = aotmod_winter
    if(iseas eq 0) then z = angaer_winter
    if(iseas eq 1) then x = aotaer_spring
    if(iseas eq 1) then y = aotmod_spring
    if(iseas eq 1) then z = angaer_spring
    if(iseas eq 2) then x = aotaer_summer
    if(iseas eq 2) then y = aotmod_summer
    if(iseas eq 2) then z = angaer_summer
    if(iseas eq 3) then x = aotaer_autumn
    if(iseas eq 3) then y = aotmod_autumn
    if(iseas eq 3) then z = angaer_autumn
   endif else begin
    if(iseas eq 0) then x = angaer_winter
    if(iseas eq 0) then y = angmod_winter
    if(iseas eq 0) then z = angaer_winter
    if(iseas eq 1) then x = angaer_spring
    if(iseas eq 1) then y = angmod_spring
    if(iseas eq 1) then z = angaer_spring
    if(iseas eq 2) then x = angaer_summer
    if(iseas eq 2) then y = angmod_summer
    if(iseas eq 2) then z = angaer_summer
    if(iseas eq 3) then x = angaer_autumn
    if(iseas eq 3) then y = angmod_autumn
    if(iseas eq 3) then z = angaer_autumn
   endelse

   noerase = 1
   if(iseas eq 0) then noerase = 0

;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   if(ipage eq 0) then ymax = 2.
   if(ipage eq 1) then ymax = 2.5
   loadct, 39
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle,  $
    position=position[*,iseas], noerase=noerase
   xyouts, position[0,iseas], position[3,iseas]+.01, season[iseas]+' '+title, /normal

   a = where(z lt 0.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=208
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 0.5 and z lt 1)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=84
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 1 and z lt 1.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=176
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 1.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=254
    plots, x[a], y[a], psym=8
   endif
   ymax = !x.crange[1]
   plots, [0,ymax], [0,ymax], thick=2
   plots, [0,ymax], [0,0.5*ymax], lin=1, thick=2
   plots, [0,0.5*ymax], [0,ymax], lin=1, thick=2

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(x)
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
    n = strcompress(string(n, format='(i4)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif

  endfor
   xyouts, -.2,.9, expid, /normal

  endfor

; Plot the total of all the points
  n = n_elements(years)
  if(n eq 1) then begin
   yeartitle = years
  endif else begin
   yeartitle = years[0] + ' - '+years[n-1]
  endelse

  x = [aotaer_winter, aotaer_spring, aotaer_summer, aotaer_autumn]
  y = [aotmod_winter, aotmod_spring, aotmod_summer, aotmod_autumn]
  z = [angaer_winter, angaer_spring, angaer_summer, angaer_autumn]
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 2.
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle,  $
    position=position[*,0]
   xyouts, position[0,0], position[3,0]+.01, yeartitle+' AOT [550nm]', /normal
   a = where(z lt 0.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=208
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 0.5 and z lt 1)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=84
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 1 and z lt 1.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=176
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 1.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=254
    plots, x[a], y[a], psym=8
   endif
   ymax = !x.crange[1]
   plots, [0,ymax], [0,ymax], thick=2
   plots, [0,ymax], [0,0.5*ymax], lin=1, thick=2
   plots, [0,0.5*ymax], [0,ymax], lin=1, thick=2

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(x)
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
    n = strcompress(string(n, format='(i4)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif





  x = [angaer_winter, angaer_spring, angaer_summer, angaer_autumn]
  y = [angmod_winter, angmod_spring, angmod_summer, angmod_autumn]
  z = [angaer_winter, angaer_spring, angaer_summer, angaer_autumn]
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 2.5
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle,  $
    position=position[*,1], /noerase
   xyouts, position[0,1], position[3,1]+.01, yeartitle + ' Angstrom Parameter', /normal
   a = where(z lt 0.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=208
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 0.5 and z lt 1)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=84
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 1 and z lt 1.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=176
    plots, x[a], y[a], psym=8
   endif
   a = where(z ge 1.5)
   if(a[0] ne -1) then begin
    usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=254
    plots, x[a], y[a], psym=8
   endif
   ymax = !x.crange[1]
   plots, [0,ymax], [0,ymax], thick=2
   plots, [0,ymax], [0,0.5*ymax], lin=1, thick=2
   plots, [0,0.5*ymax], [0,ymax], lin=1, thick=2

   do_stat = 1
   if(do_stat) then begin
    n = n_elements(x)
    statistics, x, y, $
                mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
    plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
    n = strcompress(string(n, format='(i4)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f6.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.7,.7,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f5.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif
   xyouts, -.2,.9, expid, /normal

  device, /close

end
