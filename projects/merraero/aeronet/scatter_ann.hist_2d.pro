; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  colortable = 39
  expid = 'dR_MERRA-AA-r2.inst2d_hwl.aeronet'

  years = ['2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013']

;  expid = 'bR_25b1_test.inst2d_hwl.aeronet'
;  expid = 'dR_Fortuna-M-1-1.inst2d_hwl.aeronet'
;  years = ['2003','2004']
  read_mon_mean, expid, years, location, latitude, longitude, date, $
                     aotaeronet, angaeronet, aotmodel, angmodel, $
                     aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                     absaeronet, absmodel, $
                     absaeronetstd, absmodelstd
  date = strcompress(string(date),/rem)

; Criteria to select valid sites
; For the multi-year comparison, we require two of each mon (J,F,M,A...)
; to be valid
  nloc = n_elements(location)
  useloc = make_array(nloc,val=0)
  nyr = n_elements(date)/12
  for iloc = 0, nloc-1 do begin
   siteok = 1
   nyr = n_elements(date)/12
   nreq = 1
   if(nyr ge 3) then nreq = 2  ; require at least two of each month
   for imn = 0, 11 do begin
    a = where(finite(aotaeronet[imn:imn+12*(nyr-1):12,iloc]) eq 1)
    if(n_elements(a) lt nreq) then siteok = 0
   endfor
   if(location[iloc] eq 'Mauna_Loa') then siteok = 0
   useloc[iloc] = siteok
  endfor

  a = where(useloc eq 1)
  location  = location[a]
  latitude  = latitude[a]
  longitude = longitude[a]
  angaeronet = angaeronet[*,a]
  aotaeronet = aotaeronet[*,a]
  absaeronet = absaeronet[*,a]
  angaeronetstd = angaeronetstd[*,a]
  aotaeronetstd = aotaeronetstd[*,a]
  absaeronetstd = absaeronetstd[*,a]
  angmodel   = angmodel[*,a]
  aotmodel   = aotmodel[*,a]
  absmodel   = absmodel[*,a]
  angmodelstd   = absmodelstd[*,a]
  aotmodelstd   = aotmodelstd[*,a]
  absmodelstd   = absmodelstd[*,a]

; Create a plot file
  set_plot, 'ps'
  device, file='./output/plots/scatter_ann.seasonal.'+expid+'.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=20, ysize=20
  !p.font=0
  loadct, colortable

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
  absaer_winter = reform(absaeronet[winter,*])
  absmod_winter = reform(absmodel[winter,*])
  b = where(finite(absaer_winter) eq 1)
  absaer_winter = absaer_winter[b]
  absmod_winter = absmod_winter[b]

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
  absaer_spring = reform(absaeronet[spring,*])
  absmod_spring = reform(absmodel[spring,*])
  b = where(finite(absaer_spring) eq 1)
  absaer_spring = absaer_spring[b]
  absmod_spring = absmod_spring[b]

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
  absaer_summer = reform(absaeronet[summer,*])
  absmod_summer = reform(absmodel[summer,*])
  b = where(finite(absaer_summer) eq 1)
  absaer_summer = absaer_summer[b]
  absmod_summer = absmod_summer[b]

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
  absaer_autumn = reform(absaeronet[autumn,*])
  absmod_autumn = reform(absmodel[autumn,*])
  b = where(finite(absaer_autumn) eq 1)
  absaer_autumn = absaer_autumn[b]
  absmod_autumn = absmod_autumn[b]

  xtitle = 'AERONET'
  ytitle = 'Model'

; Plot the total of all the points
total:
  set_plot, 'ps'
  device, file='./output/plots/scatter_ann.annual.'+expid+'.ps', /color, /helvetica, font_size=13, $
          xoff=.5, yoff=.5, xsize=24, ysize=10
  !p.font=0
;  !p.multi = [0,3,1]
  loadct, colortable

  n = n_elements(years)
  if(n eq 1) then begin
   yeartitle = years
  endif else begin
   yeartitle = years[0] + ' - '+years[n-1]
  endelse

  x = [aotaer_winter, aotaer_spring, aotaer_summer, aotaer_autumn]
  y = [aotmod_winter, aotmod_spring, aotmod_summer, aotmod_autumn]
  openw, lun, 'aod.txt', /get
  printf, lun, n_elements(x)
  printf, lun, x
  printf, lun, y
  free_lun, lun
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = .4
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    position = [.05, .25, .3, .9], $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, title= yeartitle+' AOD [550 nm]'
   result = hist_2d(x,y,min1=0.,min2=0.,max1=.4,max2=.4,bin1=.008,bin2=.008)
print, total(result), max(result)
   nlev = 10
   level = [1,2,5,10,20,30,40,50,80,100]
   dc = 200./(nlev-1)
   color = reverse(254 - findgen(nlev)*dc)
   xx = findgen(51)*.008
   loadct, 39
; Try to normalize the histogram
  red   = [247,224,204,168,123,78,43,8,8]
  green = [252,243,235,221,204,179,140,104,64]
  blue  = [240,219,197,181,196,211,190,172,129]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  result = float(result) / max(result)
  level = [.01, .02, .05, .1, .2, .3, .5, .7, .9]
   plotgrid, result, level, dcolors, xx, xx, .008, .008
;;;
  loadct, 39
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
    n = strcompress(string(n, format='(i5)'),/rem)
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
  openw, lun, 'ang.txt', /get
  printf, lun, n_elements(x)
  printf, lun, x
  printf, lun, y
  free_lun, lun
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 2.5
   nt = n_elements(date)
!p.multi=[2,3,1]
   plot, indgen(nt+1), /nodata, /noerase, $
    position = [.38, .25, .63, .9], $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, $
    title = yeartitle + ' Angstrom Parameter'
   result = hist_2d(x,y,min1=0.,min2=0.,max1=2.5,max2=2.5,bin1=.05,bin2=.05)
print, total(result), max(result)
   nlev = 10
   level = [1,2,5,10,20,30,40,50,80,100]
   dc = 200./(nlev-1)
   color = reverse(254 - findgen(nlev)*dc)
   xx = findgen(51)*.05
   loadct, 39
; Try to normalize the histogram
  red   = [247,224,204,168,123,78,43,8,8]
  green = [252,243,235,221,204,179,140,104,64]
  blue  = [240,219,197,181,196,211,190,172,129]
  tvlct, red, green, blue
  result = float(result) / max(result)
  level = [.01, .02, .05, .1, .2, .3, .5, .7, .9]
   plotgrid, result, level, dcolors, xx, xx, .05, .05
  loadct, 39
;;;
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
    n = strcompress(string(n, format='(i5)'),/rem)
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


  x = [absaer_winter, absaer_spring, absaer_summer, absaer_autumn]
  y = [absmod_winter, absmod_spring, absmod_summer, absmod_autumn]
  openw, lun, 'aaod.txt', /get
  printf, lun, n_elements(x)
  printf, lun, x
  printf, lun, y
  free_lun, lun

; There are some missing values in the model
  a = where(x gt 0 and y gt 0)
  if(a[0] ne -1) then x=x[a]
  if(a[0] ne -1) then y=y[a]

;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 0.2
   nt = n_elements(date)
!p.multi=[1,3,1]
   plot, indgen(nt+1), /nodata, /noerase, $
    position = [.71, .25, .96, .9], $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, $
    title = yeartitle + ' Absorption AOD [550 nm]'
   result = hist_2d(x,y,min1=0.,min2=0.,max1=.2,max2=.2,bin1=.004,bin2=.004)
print, total(result), max(result)
   nlev = 6
   level = findgen(nlev)+1
   nlev = 10
   level = [1,2,5,10,20,30,40,50,80,100]
   dc = 200./(nlev-1)
   color = reverse(254 - findgen(nlev)*dc)
   xx = findgen(51)*.004
   loadct, 39
; Try to normalize the histogram
  red   = [247,224,204,168,123,78,43,8,8]
  green = [252,243,235,221,204,179,140,104,64]
  blue  = [240,219,197,181,196,211,190,172,129]
  tvlct, red, green, blue
  result = float(result) / max(result)
  level = [.01, .02, .05, .1, .2, .3, .5, .7, .9]
   plotgrid, result, level, dcolors, xx, xx, .004, .004
  loadct, 39
;;;
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

  makekey, .2, .11, .6, .05, 0., -.04, $
    color=make_array(n_elements(red),val=0), align=0, charsize=.7, $
    label=['1%','2%','5%','10%','20%','30%','50%','70%','90%']
  red   = [247,224,204,168,123,78,43,8,8]
  green = [252,243,235,221,204,179,140,104,64]
  blue  = [240,219,197,181,196,211,190,172,129]
  tvlct, red, green, blue
  makekey, .2, .11, .6, .05, 0., -.04, $
    color=dcolors, align=0, charsize=.7, $
    label=make_array(n_elements(red),val=' ')

  device, /close

end
