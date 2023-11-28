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
;  wantlon = [113,119] & wantlat = [37,43] & filetag = 'beijing.03deg.jun1-jun30'
;  wantlon = [111,121] & wantlat = [35,45] & filetag = 'beijing.05deg.jun1-jun30'
;  wantlon = [106,126] & wantlat = [30,50] & filetag = 'beijing.10deg.jun1-jun30'
  nts = 1440
  wantlon = [113,119] & wantlat = [37,43] & filetag = 'beijing.03deg.jun1-jul30'
  wantlon = [113.5,118.5] & wantlat = [37.5,42.5] & filetag = 'beijing.02_5deg.jun1-jul30'
;nts = 2208
;wantlon = [115,117] & wantlat = [39,41] & filetag = 'beijing.01deg.jun1-aug31'
;wantlon = [114,118] & wantlat = [38,42] & filetag = 'beijing.02deg.jun1-aug31'
;wantlon = [113.5,118.5] & wantlat = [37.5,42.5] & filetag = 'beijing.02_5deg.jun1-aug31'

; Houston
  fnoff = 0  & nts = 720 & ymax = 4000
  lat0 = 29.7 & lon0 = -95.3
  nts = 1440
  wantlon = lon0+[-2.5,2.5] & wantlat = lat0+[-2.5,2.5] & filetag = 'houston.02_5deg.jun1-jul30'
  nts = 2208
  wantlon = lon0+[-2.5,2.5] & wantlat = lat0+[-2.5,2.5] & filetag = 'houston.02_5deg.jun1-aug31'

; Mexico City
  fnoff = 0  & nts = 720 & ymax = 4000
  lat0 = 19.3 & lon0 = -99.2
  nts = 1440
  wantlon = lon0+[-2.5,2.5] & wantlat = lat0+[-2.5,2.5] & filetag = 'mexico_city.02_5deg.jun1-jul30'
  nts = 2208
  wantlon = lon0+[-2.5,2.5] & wantlat = lat0+[-2.5,2.5] & filetag = 'mexico_city.02_5deg.jun1-aug31'

; Get the full
  get_sample, 'full', fnoff, nts, full, fullhr, fullhrn, fullhrhst, fullhrs, fullhrmn, fullhrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon

; Get "CATS" - equivalent to ISS1 -- but with 66% random sampling
  get_sample, 'iss1', fnoff, nts, cats, catshr, catshrn, catshrhst, catshrs, catshrmn, catshrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, /trnd, /taod

; Get "TOMCAT1" - equivalent to ISS1 (450km) -- but only AOD > 0.2 
  get_sample, 'iss1day.450km', fnoff, nts, tom1, tom1hr, tom1hrn, tom1hrhst, tom1hrs, tom1hrmn, tom1hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, /taod, unionorbit='iss1'

; Get "TOMCAT2" - equivalent to DUALISS (450km) -- but only AOD > 0.2 and CLDTOT < 0.8
  get_sample, 'dualissday.450km', fnoff, nts, tom2, tom2hr, tom2hrn, tom2hrhst, tom2hrs, tom2hrmn, tom2hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, /taod, unionorbit='dualiss'

; Get CALIPSO
  get_sample, 'calipso', fnoff, nts, cali, calihr, calihrn, calihrhst, calihrs, calihrmn, calihrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, /taod

  set_plot, 'ps'
  device, file='test_nocloud.site.pdf_pblh.range.'+filetag+'.ps', /color, /helvetica, font_size=12, $
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

  openw, lun, 'test_nocloud.site.pdf_pblh.range.'+filetag+'.stats.txt', /get
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
