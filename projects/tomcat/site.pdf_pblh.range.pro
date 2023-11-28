; Tenerife
;  fnoff = 0 & nts = 720 & ymax = 2000
;  wantlon = [-18,-16] & wantlat = [27,29] & filetag = 'tenerife.01deg.jun1-jun30'
;  wantlon = [-20,-14] & wantlat = [25,31] & filetag = 'tenerife.03deg.jun1-jun30'

; GSFC
;  fnoff = 0  & nts = 720 & ymax = 4000
;  wantlon = [-78,-76] & wantlat = [38,40] & filetag = 'gsfc.01deg.jun1-jun30'
;  wantlon = [-80,-74] & wantlat = [36,42] & filetag = 'gsfc.03deg.jun1-jun30'

; Beijing
  fnoff = 0  & nts = 720 & ymax = 4000
;  wantlon = [115,117] & wantlat = [39,41] & filetag = 'beijing.01deg.jun1-jun30'
  wantlon = [113,119] & wantlat = [37,43] & filetag = 'beijing.03deg.jun1-jun30'


  ddf = 'full.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nday = n_elements(filename)/24
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  lhrs = (lon/15)   ; every 15 degrees is 1 hour, what is offset?
  ilhrs = lhrs
  a = where(lhrs lt 0)
  ilhrs[a] = fix(lhrs[a]-.5)  ; bunch it as integer hours to offset
  a = where(lhrs ge 0)
  ilhrs[a] = fix(lhrs[a]+.5)
  ilhrs = fix(ilhrs)
; now make a lon x UTC hour array of offsets
  lhr = intarr(nx,ny,24)
  for it = 0, 23 do begin
   for ix = 0, nx-1 do begin
    lhr[ix,*,it] = it+ilhrs[ix]
    if(lhr[ix,0,it] lt 0)  then lhr[ix,*,it] = lhr[ix,*,it]+24
    if(lhr[ix,0,it] gt 23) then lhr[ix,*,it] = lhr[ix,*,it]-24
   endfor
  endfor
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  full = histogram(aot,binsize=200,min=0,max=4000)
  fullhr = reform(aot,nx*ny*24L,nday)
  fullhr_ = fltarr(24)
  fullhr__ = fltarr(24)
  fullhr___ = fltarr(24)
  fullhr____ = fltarr(24)
  fullhrhst = fltarr(24,7)
  fullhrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   fullhr_[it] = mean(fullhr[a,*],/nan)
   fullhr__[it] = stddev(fullhr[a,*],/nan)
   fullhr___[it] = min(fullhr[a,*],/nan)
   fullhr____[it] = max(fullhr[a,*],/nan)
   inp = reform(fullhr[a,*],n_elements(a)*nday*1L)
   b = where(finite(inp) eq 1)
   if(b[0] ne -1) then begin
    inp = inp[b]
    c = sort(inp)
    inp = inp[c]
    n = n_elements(inp)
    if(n ge 10) then begin    
     fullhrn[it] = n
     fullhrhst[it,0:4] = createboxplotdata(inp)
     fullhrhst[it,0] = inp[long(.1*n)]
     fullhrhst[it,4] = inp[long(.9*n)]
     fullhrhst[it,5] = mean(inp)
     fullhrhst[it,6] = stddev(inp)
    endif
   endif
  endfor
  fullhr = fullhr_
  fullhrs = fullhr__
  fullhrmn = fullhr___
  fullhrmx = fullhr____

; Get ISS1
  ddf = 'iss1.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  iss1 = histogram(aot,binsize=200,min=0,max=4000,/nan)
  niss1 = n_elements(aot[where(finite(aot) eq 1)])
  iss1hr = reform(aot,nx*ny*24L,nday)
  iss1hr_ = fltarr(24)
  iss1hr__ = fltarr(24)
  iss1hr___ = fltarr(24)
  iss1hr____ = fltarr(24)
  iss1hrhst = fltarr(24,7)
  iss1hrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   if(a[0] ne -1) then begin
    iss1hr_[it] = mean(iss1hr[a,*],/nan)
    iss1hr__[it] = stddev(iss1hr[a,*],/nan)
    iss1hr___[it] = min(iss1hr[a,*],/nan)
    iss1hr____[it] = max(iss1hr[a,*],/nan)
    inp = reform(iss1hr[a,*],n_elements(a)*nday*1L)
    b = where(finite(inp) eq 1)
    if(b[0] ne -1) then begin
     inp = inp[b]
     c = sort(inp)
     inp = inp[c]
     n = n_elements(inp)
     if(n ge 10) then begin
      iss1hrn[it] = n
      iss1hrhst[it,0:4] = createboxplotdata(inp)
      iss1hrhst[it,0] = inp[long(.1*n)]
      iss1hrhst[it,4] = inp[long(.9*n)]
      iss1hrhst[it,5] = mean(inp)
      iss1hrhst[it,6] = stddev(inp)
     endif
    endif
   endif
  endfor
  iss1hr = iss1hr_
  iss1hrs = iss1hr__
  iss1hrmn = iss1hr___
  iss1hrmx = iss1hr____

; Get CALIPSO
  ddf = 'calipso.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  cali = histogram(aot,binsize=200,min=0,max=4000,/nan)
  ncali = n_elements(aot[where(finite(aot) eq 1)])
  calihr = reform(aot,nx*ny*24L,nday)
  calihr_ = fltarr(24)
  calihr__ = fltarr(24)
  calihr___ = fltarr(24)
  calihr____ = fltarr(24)
  calihrhst = fltarr(24,7)
  calihrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   if(a[0] ne -1) then begin
    calihr_[it] = mean(calihr[a,*],/nan)
    calihr__[it] = stddev(calihr[a,*],/nan)
    calihr___[it] = min(calihr[a,*],/nan)
    calihr____[it] = max(calihr[a,*],/nan)
    inp = reform(calihr[a,*],n_elements(a)*nday*1L)
    b = where(finite(inp) eq 1)
    if(b[0] ne -1) then begin
     inp = inp[b]
     c = sort(inp)
     inp = inp[c]
     n = n_elements(inp)
     if(n ge 10) then begin
      calihrn[it] = n
      calihrhst[it,0:4] = createboxplotdata(inp)
      calihrhst[it,0] = inp[long(.1*n)]
      calihrhst[it,4] = inp[long(.9*n)]
      calihrhst[it,5] = mean(inp)
      calihrhst[it,6] = stddev(inp)
     endif
    endif
   endif
  endfor
  calihr = calihr_
  calihrs = calihr__
  calihrmn = calihr___
  calihrmx = calihr____

; Get DUALISS
  ddf = 'dualiss.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', aot, wantlat=wantlat, wantlon=wantlon
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  issc = histogram(aot,binsize=200,min=0,max=4000,/nan)
  nissc = n_elements(aot[where(finite(aot) eq 1)])
  isschr = reform(aot,nx*ny*24L,nday)
  isschr_ = fltarr(24)
  isschr__ = fltarr(24)
  isschr___ = fltarr(24)
  isschr____ = fltarr(24)
  isschrhst = fltarr(24,7)
  isschrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   if(a[0] ne -1) then begin
    isschr_[it] = mean(isschr[a,*],/nan)
    isschr__[it] = stddev(isschr[a,*],/nan)
    isschr___[it] = min(isschr[a,*],/nan)
    isschr____[it] = max(isschr[a,*],/nan)
    inp = reform(isschr[a,*],n_elements(a)*nday*1L)
    b = where(finite(inp) eq 1)
    if(b[0] ne -1) then begin
     inp = inp[b]
     c = sort(inp)
     inp = inp[c]
     n = n_elements(inp)
     if(n ge 10) then begin
      isschrn[it] = n
      isschrhst[it,0:4] = createboxplotdata(inp)
      isschrhst[it,0] = inp[long(.1*n)]
      isschrhst[it,4] = inp[long(.9*n)]
      isschrhst[it,5] = mean(inp)
      isschrhst[it,6] = stddev(inp)
     endif
    endif
   endif
  endfor
  isschr = isschr_
  isschrs = isschr__
  isschrmn = isschr___
  isschrmx = isschr____

  set_plot, 'ps'
  device, file='site.pdf_pblh.range.'+filetag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=42, ysize=12
  !p.font=0
  bins = findgen(21)*200
  loadct, 39
  plot, bins, float(full)/max(full), thick=6, $
   xtitle='PBL Height [m]', ytitle='Relative Frequency', $
   position=[.04,.1,.31,.95]
  oplot, bins, float(iss1)/max(iss1), thick=4, color=254
  oplot, bins, float(cali)/max(cali), thick=4, color=176
  oplot, bins, float(issc)/max(issc), thick=6, color=84
  xyouts, 300, .95, 'Full', /data
  xyouts, 300, .91, 'CALIPSO', /data, color=176
  xyouts, 300, .87, 'CATS', /data, color=254
  xyouts, 300, .83, 'TOMCAT', /data, color=84

;  plot, fullhr, yrange=[0,3000], thick=6, $
;   xtitle='Local Hour', ytitle='PBL Height [m]'
;  plots, indgen(24), iss1hr, thick=4, color=254
;  plots, indgen(24), calihr, thick=4, color=176
;  plots, indgen(24), isschr, thick=6, color=84, lin=2

;  plot, fullhr, yrange=[-400,400], thick=6, /nodata, $
;   xtitle='Local Hour', ytitle='stddev PBL Height [m] (difference from full)'
;  plots, [0,25], [0,0], lin=2
;  plots, indgen(24), iss1hrs-fullhrs, thick=4, color=254
;  plots, indgen(24), calihrs-fullhrs, thick=4, color=176
;  plots, indgen(24), isschrs-fullhrs, thick=6, color=84


;  plot, fullhr, yrange=[0,6000], thick=6, /nodata, $
;   xtitle='Local Hour', ytitle='Min/Max PBL Height [m]'
;  plots, indgen(24), fullhrmn, thick=6
;  plots, indgen(24), iss1hrmn, thick=4, color=254
;  plots, indgen(24), calihrmn, thick=4, color=176
;  plots, indgen(24), isschrmn, thick=6, color=84
;  plots, indgen(24), fullhrmx, thick=6
;  plots, indgen(24), iss1hrmx, thick=4, color=254
;  plots, indgen(24), calihrmx, thick=4, color=176
;  plots, indgen(24), isschrmx, thick=6, color=84

  plot, fullhr, yrange=[0,ymax], thick=6, /nodata, /noerase, $
   xrange=[-1,24], xstyle=1, $
   xtitle='Local Hour', ytitle='PBL Height [m]', $
   position=[.38,.1,.98,.95]
  loadct, 0
  for i = 0, 23 do begin
   x0 = i-.4
   x1 = i-.2
   y0 = fullhrhst[i,1]
   y1 = fullhrhst[i,3]
   ym = fullhrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=200
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i-.3, [fullhrhst[i,0],y0]
    plots, i-.3, [fullhrhst[i,4],y1]
    plots, [i-.35,i-.25], [fullhrhst[i,0],fullhrhst[i,0]]
    plots, [i-.35,i-.25], [fullhrhst[i,4],fullhrhst[i,4]]
   endif
  endfor
; TOMCAT
  loadct, 39
  for i = 0, 23 do begin
   x0 = i-.2
   x1 = i
   y0 = isschrhst[i,1]
   y1 = isschrhst[i,3]
   ym = isschrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=84
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i-.1, [isschrhst[i,0],y0]
    plots, i-.1, [isschrhst[i,4],y1]
    plots, [i-0.15,i-.05], isschrhst[i,0]
    plots, [i-0.15,i-.05], isschrhst[i,4]
   endif
  endfor
; CATS
  loadct, 39
  for i = 0, 23 do begin
   x0 = i
   x1 = i+.2
   y0 = iss1hrhst[i,1]
   y1 = iss1hrhst[i,3]
   ym = iss1hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=254
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i+.1, [iss1hrhst[i,0],y0]
    plots, i+.1, [iss1hrhst[i,4],y1]
    plots, [i+.15,i+.05], iss1hrhst[i,0]
    plots, [i+.15,i+.05], iss1hrhst[i,4]
   endif
  endfor
; CALIPSO
  loadct, 39
  for i = 0, 23 do begin
   x0 = i+.2
   x1 = i+.4
   y0 = calihrhst[i,1]
   y1 = calihrhst[i,3]
   ym = calihrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=176
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i+.3, [calihrhst[i,0],y0]
    plots, i+.3, [calihrhst[i,4],y1]
    plots, [i+.35,i+.25], calihrhst[i,0]
    plots, [i+.35,i+.25], calihrhst[i,4]
   endif
  endfor

   x0 = -0.125
   x1 =  0.125
   y0 = .8*ymax
   y1 = .925*ymax
   ym = .85*ymax
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   plots, [x0,x1],[ym,ym], thick=4
   plots, 0, [.75*ymax,y0]
   plots, 0, [.95*ymax,y1]
   plots, [.05,-0.05], .95*ymax
   plots, [.05,-0.05], .75*ymax
   xyouts, .2, ym-0.00625*ymax, /data, 'median', charsize=.5
   xyouts, .2, y0-0.00625*ymax, /data, '25%', charsize=.5
   xyouts, .2, y1-0.00625*ymax, /data, '75%', charsize=.5
   xyouts, .2, .75*ymax-0.00625*ymax, /data, '10%', charsize=.5
   xyouts, .2, .95*ymax-0.00625*ymax, /data, '90%', charsize=.5

   x0 = 2-0.125
   x1 = 2+0.125
   loadct, 0
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=200
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   loadct, 39
   x0 = 2.5-0.125
   x1 = 2.5+0.125
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=84
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   x0 = 3-0.125
   x1 = 3+0.125
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=254
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   x0 = 3.5-0.125
   x1 = 3.5+0.125
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=176
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   xyouts, 1.9, y0-0.025*ymax, 'Full', orient=-60, charsize=.75
   xyouts, 2.4, y0-0.025*ymax, 'TOMCAT', orient=-60, charsize=.75, color=84
   xyouts, 2.9, y0-0.025*ymax, 'CATS', orient=-60, charsize=.75, color=254
   xyouts, 3.4, y0-0.025*ymax, 'CALIPSO', orient=-60, charsize=.75, color=176


   x0 = min(wantlon)
   x1 = max(wantlon)
   y0 = min(wantlat)
   y1 = max(wantlat)
   dlat = y1-y0
   dlon = x1-x0
   loadct, 0
   map_set, /noerase, /mercator, $
    limit=[y0-dlat,x0-dlon,y1+dlat,x1+dlon], $
    position=[.78,.6,.91,.9]
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=200
   map_continents, /hires, /countries
   map_continents, /hires


  device, /close

  openw, lun, 'site.pdf_pblh.range.'+filetag+'.stats.txt', /get
  printf, lun, 'full'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, fullhrn[i], fullhrhst[i,*], fullhrmn[i], fullhrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  printf, lun, 'cats'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, iss1hrn[i], iss1hrhst[i,*], iss1hrmn[i], iss1hrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  printf, lun, 'calipso'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, calihrn[i], calihrhst[i,*], calihrmn[i], calihrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  printf, lun, 'tomcat'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, isschrn[i], isschrhst[i,*], isschrmn[i], isschrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  free_lun, lun


end
