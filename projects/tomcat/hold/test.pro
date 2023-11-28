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
  nc4readvar, filename, 'pblh', pblh, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
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
  a = where(pblh gt 1e14)
  pblh[a] = !values.f_nan
  full = histogram(pblh,binsize=200,min=0,max=4000)
  fullhr = reform(pblh,nx*ny*24L,nday)
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
    fullhrn[it] = n
    if(n ge 10) then begin    
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

; Get "CATS" - equivalent to ISS1 -- but with 66% random sampling
  ddf = 'iss1.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', pblh, wantlat=wantlat, wantlon=wantlon
  a = where(pblh gt 1e14)
  pblh[a] = !values.f_nan
  a = where(finite(pblh) eq 1)
  nfin = n_elements(a)
  nwan = fix(0.66*nfin)
  spawn, 'ps -A | sum | cut -c1-5', seed
  seed = long(seed[0])
  while(nfin gt nwan) do begin
   r = randomu(seed,1)
   irem = fix(r*nfin)
   irem = min([irem,nfin-1])
print, irem, nfin, r
   pblh[a[irem]] = !values.f_nan
   a = where(finite(pblh) eq 1)
   nfin = n_elements(a)
  endwhile
  cats = histogram(pblh,binsize=200,min=0,max=4000,/nan)
  ncats = n_elements(pblh[where(finite(pblh) eq 1)])
  catshr = reform(pblh,nx*ny*24L,nday)
  catshr_ = fltarr(24)
  catshr__ = fltarr(24)
  catshr___ = fltarr(24)
  catshr____ = fltarr(24)
  catshrhst = fltarr(24,7)
  catshrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   if(a[0] ne -1) then begin
    catshr_[it] = mean(catshr[a,*],/nan)
    catshr__[it] = stddev(catshr[a,*],/nan)
    catshr___[it] = min(catshr[a,*],/nan)
    catshr____[it] = max(catshr[a,*],/nan)
    inp = reform(catshr[a,*],n_elements(a)*nday*1L)
    b = where(finite(inp) eq 1)
    if(b[0] ne -1) then begin
     inp = inp[b]
     c = sort(inp)
     inp = inp[c]
     n = n_elements(inp)
     catshrn[it] = n
     if(n ge 10) then begin
      catshrhst[it,0:4] = createboxplotdata(inp)
      catshrhst[it,0] = inp[long(.1*n)]
      catshrhst[it,4] = inp[long(.9*n)]
      catshrhst[it,5] = mean(inp)
      catshrhst[it,6] = stddev(inp)
     endif
    endif
   endif
  endfor
  catshr = catshr_
  catshrs = catshr__
  catshrmn = catshr___
  catshrmx = catshr____

; Get "TOMCAT1" - equivalent to ISS1 -- but only AOD > 0.2
  ddf = 'iss1.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'totexttau', aot, wantlat=wantlat, wantlon=wantlon
  ddf = 'iss1.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', pblh, wantlat=wantlat, wantlon=wantlon
  a = where(pblh gt 1e14 or aot lt 0.2)
  pblh[a] = !values.f_nan
  tom1 = histogram(pblh,binsize=200,min=0,max=4000,/nan)
  ntom1 = n_elements(pblh[where(finite(pblh) eq 1)])
  tom1hr = reform(pblh,nx*ny*24L,nday)
  tom1hr_ = fltarr(24)
  tom1hr__ = fltarr(24)
  tom1hr___ = fltarr(24)
  tom1hr____ = fltarr(24)
  tom1hrhst = fltarr(24,7)
  tom1hrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   if(a[0] ne -1) then begin
    tom1hr_[it] = mean(tom1hr[a,*],/nan)
    tom1hr__[it] = stddev(tom1hr[a,*],/nan)
    tom1hr___[it] = min(tom1hr[a,*],/nan)
    tom1hr____[it] = max(tom1hr[a,*],/nan)
    inp = reform(tom1hr[a,*],n_elements(a)*nday*1L)
    b = where(finite(inp) eq 1)
    if(b[0] ne -1) then begin
     inp = inp[b]
     c = sort(inp)
     inp = inp[c]
     n = n_elements(inp)
     tom1hrn[it] = n
     if(n ge 10) then begin
      tom1hrhst[it,0:4] = createboxplotdata(inp)
      tom1hrhst[it,0] = inp[long(.1*n)]
      tom1hrhst[it,4] = inp[long(.9*n)]
      tom1hrhst[it,5] = mean(inp)
      tom1hrhst[it,6] = stddev(inp)
     endif
    endif
   endif
  endfor
  tom1hr = tom1hr_
  tom1hrs = tom1hr__
  tom1hrmn = tom1hr___
  tom1hrmx = tom1hr____

; Get CALIPSO
  ddf = 'calipso.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', pblh, wantlat=wantlat, wantlon=wantlon
  a = where(pblh gt 1e14)
  pblh[a] = !values.f_nan
  cali = histogram(pblh,binsize=200,min=0,max=4000,/nan)
  ncali = n_elements(pblh[where(finite(pblh) eq 1)])
  calihr = reform(pblh,nx*ny*24L,nday)
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
     calihrn[it] = n
     if(n ge 10) then begin
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

; Get "TOMCAT2" - equivalent to dualiss -- but only AOD > 0.2
  ddf = 'dualiss.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'totexttau', aot, wantlat=wantlat, wantlon=wantlon
  ddf = 'dualiss.pblh.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename= filename[fnoff:fnoff+nts-1]
  nc4readvar, filename, 'pblh', pblh, wantlat=wantlat, wantlon=wantlon
  a = where(pblh gt 1e14 or aot lt 0.2)
  pblh[a] = !values.f_nan
  tom2 = histogram(pblh,binsize=200,min=0,max=4000,/nan)
  ntom2 = n_elements(pblh[where(finite(pblh) eq 1)])
  tom2hr = reform(pblh,nx*ny*24L,nday)
  tom2hr_ = fltarr(24)
  tom2hr__ = fltarr(24)
  tom2hr___ = fltarr(24)
  tom2hr____ = fltarr(24)
  tom2hrhst = fltarr(24,7)
  tom2hrn = lonarr(24)
  for it = 0, 23 do begin
   a = where(lhr eq it)
   if(a[0] ne -1) then begin
    tom2hr_[it] = mean(tom2hr[a,*],/nan)
    tom2hr__[it] = stddev(tom2hr[a,*],/nan)
    tom2hr___[it] = min(tom2hr[a,*],/nan)
    tom2hr____[it] = max(tom2hr[a,*],/nan)
    inp = reform(tom2hr[a,*],n_elements(a)*nday*1L)
    b = where(finite(inp) eq 1)
    if(b[0] ne -1) then begin
     inp = inp[b]
     c = sort(inp)
     inp = inp[c]
     n = n_elements(inp)
     tom2hrn[it] = n
     if(n ge 10) then begin
      tom2hrhst[it,0:4] = createboxplotdata(inp)
      tom2hrhst[it,0] = inp[long(.1*n)]
      tom2hrhst[it,4] = inp[long(.9*n)]
      tom2hrhst[it,5] = mean(inp)
      tom2hrhst[it,6] = stddev(inp)
     endif
    endif
   endif
  endfor
  tom2hr = tom2hr_
  tom2hrs = tom2hr__
  tom2hrmn = tom2hr___
  tom2hrmx = tom2hr____

  set_plot, 'ps'
  device, file='test.site.pdf_pblh.range.'+filetag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=42, ysize=12
  !p.font=0
  bins = findgen(21)*200
  loadct, 39
  plot, bins, float(full)/max(full), thick=6, $
   xtitle='PBL Height [m]', ytitle='Relative Frequency', $
   position=[.04,.1,.31,.95]
  oplot, bins, float(tom1)/max(tom1), thick=4, color=208
  oplot, bins, float(cats)/max(cats), thick=4, color=254
  oplot, bins, float(cali)/max(cali), thick=4, color=176
  oplot, bins, float(tom2)/max(tom2), thick=6, color=84
  xyouts, 500, .95, 'Full', /data
  xyouts, 500, .91, 'CALIPSO', /data, color=176
  xyouts, 500, .87, 'CATS', /data, color=254
  xyouts, 500, .83, 'TOMCAT (1)', /data, color=208
  xyouts, 500, .79, 'TOMCAT (2)', /data, color=84
  xyouts, 1600, .95, 'n='+string(total(full),format='(i6)'), /data
  xyouts, 1600, .91, 'n='+string(total(cali),format='(i6)'), /data
  xyouts, 1600, .87, 'n='+string(total(cats),format='(i6)'), /data
  xyouts, 1600, .83, 'n='+string(total(tom1),format='(i6)'), /data
  xyouts, 1600, .79, 'n='+string(total(tom2),format='(i6)'), /data

  plot, fullhr, yrange=[0,ymax], thick=6, /nodata, /noerase, $
   xrange=[-1,24], xstyle=1, $
   xtitle='Local Hour', ytitle='PBL Height [m]', $
   position=[.38,.1,.98,.95]
  loadct, 0
  for i = 0, 23 do begin
   x0 = i-.4
   x1 = i-.24
   y0 = fullhrhst[i,1]
   y1 = fullhrhst[i,3]
   ym = fullhrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=200
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i-.32, [fullhrhst[i,0],y0]
    plots, i-.32, [fullhrhst[i,4],y1]
    plots, [i-.37,i-.27], [fullhrhst[i,0],fullhrhst[i,0]]
    plots, [i-.37,i-.27], [fullhrhst[i,4],fullhrhst[i,4]]
   endif
  endfor
; CALIPSO
  loadct, 39
  for i = 0, 23 do begin
   x0 = i-.24
   x1 = i-.08
   y0 = calihrhst[i,1]
   y1 = calihrhst[i,3]
   ym = calihrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=176
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i-.16, [calihrhst[i,0],y0]
    plots, i-.16, [calihrhst[i,4],y1]
    plots, [i-.21,i-.11], calihrhst[i,0]
    plots, [i-.21,i-.11], calihrhst[i,4]
   endif
  endfor
; CATS
  loadct, 39
  for i = 0, 23 do begin
   x0 = i-.08
   x1 = i+.08
   y0 = catshrhst[i,1]
   y1 = catshrhst[i,3]
   ym = catshrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=254
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i, [catshrhst[i,0],y0]
    plots, i, [catshrhst[i,4],y1]
    plots, [i-.05,i+.05], catshrhst[i,0]
    plots, [i-.05,i+.05], catshrhst[i,4]
   endif
  endfor
; TOMCAT (1)
  loadct, 39
  for i = 0, 23 do begin
   x0 = i+.08
   x1 = i+.24
   y0 = tom1hrhst[i,1]
   y1 = tom1hrhst[i,3]
   ym = tom1hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=208
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i+.16, [tom1hrhst[i,0],y0]
    plots, i+.16, [tom1hrhst[i,4],y1]
    plots, [i+0.11,i+.21], tom1hrhst[i,0]
    plots, [i+0.11,i+.21], tom1hrhst[i,4]
   endif
  endfor
; TOMCAT (2)
  loadct, 39
  for i = 0, 23 do begin
   x0 = i+.24
   x1 = i+.4
   y0 = tom2hrhst[i,1]
   y1 = tom2hrhst[i,3]
   ym = tom2hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=84
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i+.32, [tom2hrhst[i,0],y0]
    plots, i+.32, [tom2hrhst[i,4],y1]
    plots, [i+0.27,i+.37], tom2hrhst[i,0]
    plots, [i+0.27,i+.37], tom2hrhst[i,4]
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
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=176
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   x0 = 3-0.125
   x1 = 3+0.125
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=254
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   x0 = 3.5-0.125
   x1 = 3.5+0.125
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=208
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   x0 = 4-0.125
   x1 = 4+0.125
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=84
   plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
   xyouts, 1.9, y0-0.025*ymax, 'Full', orient=-60, charsize=.75
   xyouts, 2.4, y0-0.025*ymax, 'CALIPSO', orient=-60, charsize=.75, color=176
   xyouts, 2.9, y0-0.025*ymax, 'CATS', orient=-60, charsize=.75, color=254
   xyouts, 3.4, y0-0.025*ymax, 'TOMCAT (1)', orient=-60, charsize=.75, color=208
   xyouts, 3.9, y0-0.025*ymax, 'TOMCAT (2)', orient=-60, charsize=.75, color=84


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

  openw, lun, 'test.site.pdf_pblh.range.'+filetag+'.stats.txt', /get
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
   printf, lun, i, catshrn[i], catshrhst[i,*], catshrmn[i], catshrmx[i],$
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

  printf, lun, 'tomcat1'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, tom1hrn[i], tom1hrhst[i,*], tom1hrmn[i], tom1hrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  printf, lun, 'tomcat2'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, tom2hrn[i], tom2hrhst[i,*], tom2hrmn[i], tom2hrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  free_lun, lun


end
