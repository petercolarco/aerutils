  filetag = 'beij'


  ymax = 1.

; Get the full
  get_sample, 'full.c1440_NR_0.5000', filetag, full, fullhr, fullhrn, fullhrhst, fullhrs, fullhrmn, fullhrmx;, /tcld, /taod               
  get_sample, 'full.c1440_NR_0.5000', filetag, full_, fullhr_, fullhrn_, fullhrhst_, fullhrs_, fullhrmn_, fullhrmx_, /tcld, /taod               

; Get "ISS1"
  get_sample, 'iss1.c1440_NR_0.5000.nadir', filetag, tom1, tom1hr, tom1hrn, tom1hrhst, tom1hrs, tom1hrmn, tom1hrmx, $
                  /tcld, /taod
; Get "ISS2:
  get_sample, 'issall.c1440_NR_0.5000.nadir', filetag, tom2, tom2hr, tom2hrn, tom2hrhst, tom2hrs, tom2hrmn, tom2hrmx, $
                  /tcld, /taod

; Get "ISS3"
  get_sample, 'iss1.c1440_NR_0.5000.450km.day', filetag, tom3, tom3hr, tom3hrn, tom3hrhst, tom3hrs, tom3hrmn, tom3hrmx, $
                  /tcld, /taod

; Get "ISS4"
  get_sample, 'issall.c1440_NR_0.5000.450km.day', filetag, tom4, tom4hr, tom4hrn, tom4hrhst, tom4hrs, tom4hrmn, tom4hrmx, $
                  /tcld, /taod

  set_plot, 'ps'
  device, file='iss_cloud_aod01.day.site.pdf_pblh.range.'+filetag+'.norm.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=42, ysize=12
  !p.font=0
  bins = findgen(51)*80
  loadct, 39
  plot, bins, float(full)/max(full), /nodata, thick=6, $
   xtitle='PBLH [m]', ytitle='Relative Frequency', $
   position=[.04,.11,.31,.95]
  oplot, bins, float(full_)/max(full_), thick=12
  oplot, bins, float(tom3)/max(tom3), thick=12, color=254
;  oplot, bins, float(tom2)/max(tom2), thick=4, color=254
;  oplot, bins, float(tom1)/max(tom1), thick=4, color=176
  oplot, bins, float(tom4)/max(tom4), thick=12, color=84, lin=2
  xyouts, 36/100.*4000, .94, 'GEOS Nature Run', /data
;  xyouts, 20, .91, 'Full (dash)', /data
;  xyouts, 20, .87, 'TOMCAT1 (n)', /data, color=176
;  xyouts, 20, .83, 'TOMCATA (n)', /data, color=254
  xyouts, 36/100.*4000, .89, 'Single TOMCAT', /data, color=254
  xyouts, 36/100.*4000, .84, 'TOMCAT X4', /data, color=84
;  xyouts, 31, .95, 'n='+string(total(full),format='(i-9)'), /data
  xyouts, 75/100.*4000, .94, 'n='+string(total(full_),format='(i-9)'), /data
;  xyouts, 31, .87, 'n='+string(total(tom1),format='(i-9)'), /data
;  xyouts, 31, .83, 'n='+string(total(tom2),format='(i-9)'), /data
  xyouts, 75/100.*4000, .89, 'n='+string(total(tom3),format='(i-9)'), /data
  xyouts, 75/100.*4000, .84, 'n='+string(total(tom4),format='(i-9)'), /data

  plot, fullhr, yrange=[0.0,1.05], thick=6, /nodata, /noerase, $
   xrange=[-1,24], xstyle=1, $
   xtitle='Local Hour', ytitle='Normalized PBLH', $
   position=[.38,.11,.98,.95], $
   yticks=11, ytickv=[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.05], $
   ytickname=['0.0','0.1','0.2','0.3','0.4','0.5','0.6','0,7','0.8','0.9','1.0',' ']
  loadct, 39
  oplot, indgen(24), fullhrhst[*,2]/max(fullhrhst[*,2]), thick=12
;  oplot, indgen(24), fullhrhst_[*,2]/max(fullhrhst_[*,2]), thick=12
;  oplot, indgen(24), tom1hrhst[*,2]/max(tom1hrhst[*,2]), thick=6, color=176
;  oplot, indgen(24), tom2hrhst[*,2]/max(tom2hrhst[*,2]), thick=6, color=254
  oplot, indgen(24), tom3hrhst[*,2]/max(tom3hrhst[*,2]), thick=12, color=254
  oplot, indgen(24), tom4hrhst[*,2]/max(tom4hrhst[*,2]), thick=12, color=84

  device, /close

; Output some text files
  openw, lun, filetag+'.full.txt', /get
  printf, lun, fullhrmn, format='(24(f8.3,2x))'  ; min
  printf, lun, fullhrmx, format='(24(f8.3,2x))'  ; max
  printf, lun, fullhrn, format='(24(i8,2x))'     ; number
  for i = 0, 6 do begin
   printf, lun, fullhrhst[*,i], format='(24(f8.3,2x))'
  endfor
  free_lun, lun

  openw, lun, filetag+'.full_sub.txt', /get
  printf, lun, fullhrmn_, format='(24(f8.3,2x))'  ; min
  printf, lun, fullhrmx_, format='(24(f8.3,2x))'  ; max
  printf, lun, fullhrn_, format='(24(i8,2x))'     ; number
  for i = 0, 6 do begin
   printf, lun, fullhrhst_[*,i], format='(24(f8.3,2x))'
  endfor
  free_lun, lun

  openw, lun, filetag+'.iss1.nadir.txt', /get
  printf, lun, tom1hrmn, format='(24(f8.3,2x))'  ; min
  printf, lun, tom1hrmx, format='(24(f8.3,2x))'  ; max
  printf, lun, tom1hrn, format='(24(i8,2x))'     ; number
  for i = 0, 6 do begin
   printf, lun, tom1hrhst[*,i], format='(24(f8.3,2x))'
  endfor
  free_lun, lun

  openw, lun, filetag+'.issall.nadir.txt', /get
  printf, lun, tom2hrmn, format='(24(f8.3,2x))'  ; min
  printf, lun, tom2hrmx, format='(24(f8.3,2x))'  ; max
  printf, lun, tom2hrn, format='(24(i8,2x))'     ; number
  for i = 0, 6 do begin
   printf, lun, tom2hrhst[*,i], format='(24(f8.3,2x))'
  endfor
  free_lun, lun
  

  openw, lun, filetag+'.iss1.day.450km.txt', /get
  printf, lun, tom3hrmn, format='(24(f8.3,2x))'  ; min
  printf, lun, tom3hrmx, format='(24(f8.3,2x))'  ; max
  printf, lun, tom3hrn, format='(24(i8,2x))'     ; number
  for i = 0, 6 do begin
   printf, lun, tom3hrhst[*,i], format='(24(f8.3,2x))'
  endfor
  free_lun, lun

  openw, lun, filetag+'.issall.day.450km.txt', /get
  printf, lun, tom4hrmn, format='(24(f8.3,2x))'  ; min
  printf, lun, tom4hrmx, format='(24(f8.3,2x))'  ; max
  printf, lun, tom4hrn, format='(24(i8,2x))'     ; number
  for i = 0, 6 do begin
   printf, lun, tom4hrhst[*,i], format='(24(f8.3,2x))'
  endfor
  free_lun, lun
  

end
