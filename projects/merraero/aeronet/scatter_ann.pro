; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  colortable = 39
  expid = 'dR_MERRA-AA-r2.inst2d_hwl.aeronet'
  years = ['2004','2005','2006','2007','2008','2009','2010','2011','2012']

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
  season = ['Winter', 'Spring', 'Summer', 'Autumn']

; Skip the seasonal plots
;  goto, total
  for ipage = 0, 2 do begin
   if(ipage eq 0) then title = 'AOD [550 nm]'
   if(ipage eq 1) then title = 'Angstrom Parameter'
   if(ipage eq 2) then title = 'Absorbtion AOD [550 nm]'

  for iseas = 0, 3 do begin
   case ipage of
   0 : begin
       if(iseas eq 0) then x = aotaer_winter
       if(iseas eq 0) then y = aotmod_winter
       if(iseas eq 1) then x = aotaer_spring
       if(iseas eq 1) then y = aotmod_spring
       if(iseas eq 2) then x = aotaer_summer
       if(iseas eq 2) then y = aotmod_summer
       if(iseas eq 3) then x = aotaer_autumn
       if(iseas eq 3) then y = aotmod_autumn
      end
   1 : begin
       if(iseas eq 0) then x = angaer_winter
       if(iseas eq 0) then y = angmod_winter
       if(iseas eq 1) then x = angaer_spring
       if(iseas eq 1) then y = angmod_spring
       if(iseas eq 2) then x = angaer_summer
       if(iseas eq 2) then y = angmod_summer
       if(iseas eq 3) then x = angaer_autumn
       if(iseas eq 3) then y = angmod_autumn
      end
   2 : begin
       if(iseas eq 0) then x = absaer_winter
       if(iseas eq 0) then y = absmod_winter
       if(iseas eq 1) then x = absaer_spring
       if(iseas eq 1) then y = absmod_spring
       if(iseas eq 2) then x = absaer_summer
       if(iseas eq 2) then y = absmod_summer
       if(iseas eq 3) then x = absaer_autumn
       if(iseas eq 3) then y = absmod_autumn
      end
   endcase

   noerase = 1
   if(iseas eq 0) then noerase = 0

;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   if(ipage eq 0) then ymax = 2.
   if(ipage eq 1) then ymax = 2.5
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle,  $
    position=position[*,iseas], noerase=noerase
   xyouts, position[0,iseas], position[3,iseas]+.01, season[iseas]+' '+title, /normal
   usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=70
   plots, x, y, psym=8
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
;   xyouts, -.2,.9, expid, /normal

  endfor

  device, /close


; Plot the total of all the points
total:
  set_plot, 'ps'
  device, file='./output/plots/scatter_ann.annual.'+expid+'.ps', /color, /helvetica, font_size=13, $
          xoff=.5, yoff=.5, xsize=24, ysize=8
  !p.font=0
  !p.multi = [0,3,1]
  loadct, colortable

  n = n_elements(years)
  if(n eq 1) then begin
   yeartitle = years
  endif else begin
   yeartitle = years[0] + ' - '+years[n-1]
  endelse

  x = [aotaer_winter, aotaer_spring, aotaer_summer, aotaer_autumn]
  y = [aotmod_winter, aotmod_spring, aotmod_summer, aotmod_autumn]
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 2.
;ymax =.6
   nt = n_elements(date)
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, title= yeartitle+' AOD [550 nm]'
   usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=70
;; Do density plot instead
;   openr, lun, 'aot_xy.txt', /get
;   xy = fltarr(2,64)
;   readf, lun, xy
;   xy = reform(xy[0,*])
;   free_lun, lun
;   openr, lun, 'aot_density.txt', /get
;   density = fltarr(64,64)
;   readf, lun, density
;   free_lun, lun
;   level = findgen(50)+1
;   color = 55 + findgen(50)*4
;;   plotgrid, density, level, color, xy, xy, 2./64., 2./64.
;contour, /overplot, density, xy, xy, level=level, c_color=color, /fill
!p.multi=[3,3,1]
   plot, indgen(nt+1), /nodata, /noerase, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, title= yeartitle+' AOD [550 nm]'
   plots, x, y, psym=8
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





  x = [angaer_winter, angaer_spring, angaer_summer, angaer_autumn]
  y = [angmod_winter, angmod_spring, angmod_summer, angmod_autumn]
;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 2.5
   nt = n_elements(date)
!p.multi=[2,3,1]
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, $
    title = yeartitle + ' Angstrom Parameter'
   usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=70
;; Do density plot instead
;   openr, lun, 'ang_xy.txt', /get
;   xy = fltarr(2,64)
;   readf, lun, xy
;   xy = reform(xy[0,*])
;   free_lun, lun
;   openr, lun, 'ang_density.txt', /get
;   density = fltarr(64,64)
;   readf, lun, density
;   free_lun, lun
;   level = (findgen(50)+1)/50.
;   color = 55 + findgen(50)*4
;;   plotgrid, density, level, color, xy, xy, 2./64., 2./64.
;contour, /overplot, density, xy, xy, level=level, c_color=color, /fill
!p.multi=[2,3,1]
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, $
    title = yeartitle + ' Angstrom Parameter'
   plots, x, y, psym=8, noclip=0
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


  x = [absaer_winter, absaer_spring, absaer_summer, absaer_autumn]
  y = [absmod_winter, absmod_spring, absmod_summer, absmod_autumn]

; There are some missing values in the model
  a = where(x gt 0 and y gt 0)
  if(a[0] ne -1) then x=x[a]
  if(a[0] ne -1) then y=y[a]

;  Find a suitable maximum value
   ymax = max([max(x),max(y)])
   ymax = 0.2
   nt = n_elements(date)
!p.multi=[1,3,1]
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, $
    title = yeartitle + ' Absorption AOD [550 nm]'
   usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=70
;; Do density plot instead
;   openr, lun, 'abs_xy.txt', /get
;   xy = fltarr(2,64)
;   readf, lun, xy
;   xy = reform(xy[0,*])
;   free_lun, lun
;   openr, lun, 'abs_density.txt', /get
;   density = fltarr(64,64)
;   readf, lun, density
;   free_lun, lun
;   level = (findgen(50)*2.+1)
;   color = 55 + findgen(50)*4
;;   plotgrid, density, level, color, xy, xy, 2./64., 2./64.
;contour, /overplot, density, xy, xy, level=level, c_color=color, /fill
!p.multi=[1,3,1]
   plot, indgen(nt+1), /nodata, $
    xrange=[0,ymax], $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle=xtitle, ytitle=ytitle, $
    title = yeartitle + ' Absorption AOD [550 nm]'
   plots, x, y, psym=8, noclip=0
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

  device, /close

end
