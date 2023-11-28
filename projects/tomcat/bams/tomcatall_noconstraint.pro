; Beijing
  fnoff = 0
  lat0 = 50. & lon0 = 8.
  nts = 2208
  ymax = 40
  wantlon = lon0+[-2.5,2.5] & wantlat = lat0+[-2.5,2.5] & filetag = 'europe.02_5deg.jun1-aug31' ;.nodaod'


; Get the full
  get_sample, 'full', fnoff, nts, full, fullhr, fullhrn, fullhrhst, fullhrs, fullhrmn, fullhrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon

; Get "TOMCAT1"
  get_sample, 'tomcat1.nadir', fnoff, nts, tom1, tom1hr, tom1hrn, tom1hrhst, tom1hrs, tom1hrmn, tom1hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon;, /taod

; Get "TOMCAT2:
  get_sample, 'tomcatall.nadir', fnoff, nts, tom2, tom2hr, tom2hrn, tom2hrhst, tom2hrs, tom2hrmn, tom2hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon;, /trnd;, /taod

; Get "TOMCAT3"
  get_sample, 'tomcat1.450km', fnoff, nts, tom3, tom3hr, tom3hrn, tom3hrhst, tom3hrs, tom3hrmn, tom3hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon

; Get "TOMCAT4"
  get_sample, 'tomcatall.450km', fnoff, nts, tom4, tom4hr, tom4hrn, tom4hrhst, tom4hrs, tom4hrmn, tom4hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon

  set_plot, 'ps'
  device, file='tomcatall_noconstraint.site.pdf_pm25.range.'+filetag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=42, ysize=12
  !p.font=0
  bins = findgen(21)*2
  loadct, 39
  plot, bins, float(full)/max(full), thick=6, $
   xtitle='PM2.5 [!9m!3g m!E-3!N]', ytitle='Relative Frequency', $
   position=[.04,.1,.31,.95]
  oplot, bins, float(tom3)/max(tom3), thick=4, color=208
  oplot, bins, float(tom2)/max(tom2), thick=4, color=254
  oplot, bins, float(tom1)/max(tom1), thick=4, color=176
  oplot, bins, float(tom4)/max(tom4), thick=6, color=84
  xyouts, 20, .95, 'Full', /data
  xyouts, 20, .91, 'TOMCAT1 (n)', /data, color=176
  xyouts, 20, .87, 'TOMCATA (n)', /data, color=254
  xyouts, 20, .83, 'TOMCAT1 (w)', /data, color=208
  xyouts, 20, .79, 'TOMCATA (w)', /data, color=84
  xyouts, 31, .95, 'n='+string(total(full),format='(i-7)'), /data
  xyouts, 31, .91, 'n='+string(total(tom1),format='(i-6)'), /data
  xyouts, 31, .87, 'n='+string(total(tom2),format='(i-6)'), /data
  xyouts, 31, .83, 'n='+string(total(tom3),format='(i-6)'), /data
  xyouts, 31, .79, 'n='+string(total(tom4),format='(i-6)'), /data

  plot, fullhr, yrange=[0,ymax], thick=6, /nodata, /noerase, $
   xrange=[-1,24], xstyle=1, $
   xtitle='Local Hour', ytitle='PM2.5 [!9m!3g m!E-3!N]', $
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
; TOMCAT1
  loadct, 39
  for i = 0, 23 do begin
   x0 = i-.24
   x1 = i-.08
   y0 = tom1hrhst[i,1]
   y1 = tom1hrhst[i,3]
   ym = tom1hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=176
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i-.16, [tom1hrhst[i,0],y0]
    plots, i-.16, [tom1hrhst[i,4],y1]
    plots, [i-.21,i-.11], tom1hrhst[i,0]
    plots, [i-.21,i-.11], tom1hrhst[i,4]
   endif
  endfor
; TOMCAT2
  loadct, 39
  for i = 0, 23 do begin
   x0 = i-.08
   x1 = i+.08
   y0 = tom2hrhst[i,1]
   y1 = tom2hrhst[i,3]
   ym = tom2hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=254
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i, [tom2hrhst[i,0],y0]
    plots, i, [tom2hrhst[i,4],y1]
    plots, [i-.05,i+.05], tom2hrhst[i,0]
    plots, [i-.05,i+.05], tom2hrhst[i,4]
   endif
  endfor
; TOMCAT3
  loadct, 39
  for i = 0, 23 do begin
   x0 = i+.08
   x1 = i+.24
   y0 = tom3hrhst[i,1]
   y1 = tom3hrhst[i,3]
   ym = tom3hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=208
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i+.16, [tom3hrhst[i,0],y0]
    plots, i+.16, [tom3hrhst[i,4],y1]
    plots, [i+0.11,i+.21], tom3hrhst[i,0]
    plots, [i+0.11,i+.21], tom3hrhst[i,4]
   endif
  endfor
; TOMCAT4
  loadct, 39
  for i = 0, 23 do begin
   x0 = i+.24
   x1 = i+.4
   y0 = tom4hrhst[i,1]
   y1 = tom4hrhst[i,3]
   ym = tom4hrhst[i,2]
   if(ym gt 0) then begin
    polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=84
    plots, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]
    plots, [x0,x1],[ym,ym], thick=4
    plots, i+.32, [tom4hrhst[i,0],y0]
    plots, i+.32, [tom4hrhst[i,4],y1]
    plots, [i+0.27,i+.37], tom4hrhst[i,0]
    plots, [i+0.27,i+.37], tom4hrhst[i,4]
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
   xyouts, 2.4, y0-0.025*ymax, 'TOMCAT1 (n)', orient=-60, charsize=.75, color=176
   xyouts, 2.9, y0-0.025*ymax, 'TOMCATA (n)', orient=-60, charsize=.75, color=254
   xyouts, 3.4, y0-0.025*ymax, 'TOMCAT1 (w)', orient=-60, charsize=.75, color=208
   xyouts, 3.9, y0-0.025*ymax, 'TOMCATA (w)', orient=-60, charsize=.75, color=84


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

  openw, lun, 'tomcatall_noconstraint.pdf_pm25.range.'+filetag+'.stats.txt', /get
  printf, lun, 'full'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, fullhrn[i], fullhrhst[i,*], fullhrmn[i], fullhrmx[i],$
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

  printf, lun, 'tomcat1'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, tom1hrn[i], tom1hrhst[i,*], tom1hrmn[i], tom1hrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  printf, lun, 'tomcat3'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, tom3hrn[i], tom3hrhst[i,*], tom3hrmn[i], tom3hrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  printf, lun, 'tomcat4'
  printf, lun, 'hr', 'n', '10%','25%','median','75%','90%','mean','stddev','min','max', $
   format='(a2,2x,a6,9(2x,a8))'
  for i = 0, 23 do begin
   printf, lun, i, tom4hrn[i], tom4hrhst[i,*], tom4hrmn[i], tom4hrmx[i],$
    format='(i2,2x,i6,9(2x,f8.3))'
  endfor
  printf, lun, ''

  free_lun, lun


end
