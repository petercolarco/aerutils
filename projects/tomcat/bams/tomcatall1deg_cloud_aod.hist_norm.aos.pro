  filetag = 'natl'


  ymax = 1.

; Get the full
  get_sample, 'full.1deg', filetag, full, fullhr, fullhrn, fullhrhst, fullhrs, fullhrmn, fullhrmx;, /tcld, /taod               
  get_sample, 'full.1deg', filetag, full_, fullhr_, fullhrn_, fullhrhst_, fullhrs_, fullhrmn_, fullhrmx_, /tcld, /taod               

; Get "TOMCAT1"
  get_sample, 'tomcat1.1deg.nadir', filetag, tom1, tom1hr, tom1hrn, tom1hrhst, tom1hrs, tom1hrmn, tom1hrmx, $
                  /tcld, /taod
; Get "TOMCAT2:
  get_sample, 'tomcatall.1deg.nadir', filetag, tom2, tom2hr, tom2hrn, tom2hrhst, tom2hrs, tom2hrmn, tom2hrmx, $
                  /tcld, /taod

; Get "TOMCAT3"
  get_sample, 'tomcat1.1deg.450km', filetag, tom3, tom3hr, tom3hrn, tom3hrhst, tom3hrs, tom3hrmn, tom3hrmx, $
                  /tcld, /taod

; Get "TOMCAT4"
  get_sample, 'tomcatall.1deg.450km', filetag, tom4, tom4hr, tom4hrn, tom4hrhst, tom4hrs, tom4hrmn, tom4hrmx, $
                  /tcld, /taod

  set_plot, 'ps'
  device, file='tomcatall1deg_cloud_aod01.site.pdf_pm25.range.'+filetag+'.norm.aos.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=42, ysize=12
  !p.font=0
  bins = findgen(21)*2
  loadct, 39
  plot, bins, float(full)/max(full), /nodata, thick=6, $
   xtitle='PM2.5 [!9m!3g m!E-3!N]', ytitle='Relative Frequency', $
   position=[.04,.11,.31,.95]
  oplot, bins, float(full_)/max(full_), thick=12
  oplot, bins, float(tom1)/max(tom1), thick=12, color=254
;  oplot, bins, float(tom2)/max(tom2), thick=4, color=254
;  oplot, bins, float(tom1)/max(tom1), thick=4, color=176
;  oplot, bins, float(tom4)/max(tom4), thick=12, color=84, lin=2
  xyouts, 16, .94, 'GEOS Nature Run', /data
;  xyouts, 20, .91, 'Full (dash)', /data
;  xyouts, 20, .87, 'TOMCAT1 (n)', /data, color=176
;  xyouts, 20, .83, 'TOMCATA (n)', /data, color=254
  xyouts, 16, .89, 'AOS-I ALICAT', /data, color=254
;  xyouts, 16, .84, 'TOMCAT X4', /data, color=84
;  xyouts, 31, .95, 'n='+string(total(full),format='(i-9)'), /data
  xyouts, 31, .94, 'n='+string(total(full_),format='(i-9)'), /data
;  xyouts, 31, .87, 'n='+string(total(tom1),format='(i-9)'), /data
;  xyouts, 31, .83, 'n='+string(total(tom2),format='(i-9)'), /data
  xyouts, 31, .89, 'n='+string(total(tom1),format='(i-9)'), /data
;  xyouts, 31, .84, 'n='+string(total(tom4),format='(i-9)'), /data

  plot, fullhr, yrange=[0.5,1.05], thick=6, /nodata, /noerase, $
   xrange=[-1,24], xstyle=1, $
   xtitle='Local Hour', ytitle='Normalized PM2.5', $
   position=[.38,.11,.98,.95], $
   yticks=6, ytickv=[0.5,0.6,0.7,0.8,0.9,1,1.05], $
   ytickname=['0.5','0.6','0,7','0.8','0.9','1.0',' ']
  loadct, 39
;  oplot, indgen(24), fullhrhst[*,2]/max(fullhrhst[*,2]), thick=6
  oplot, indgen(24), fullhrhst_[*,2]/max(fullhrhst_[*,2]), thick=12
;  oplot, indgen(24), tom1hrhst[*,2]/max(tom1hrhst[*,2]), thick=6, color=176
  oplot, indgen(24), tom1hrhst[*,2]/max(tom1hrhst[*,2]), thick=12, color=254
;  oplot, indgen(24), tom3hrhst[*,2]/max(tom3hrhst[*,2]), thick=12, color=254
;  oplot, indgen(24), tom4hrhst[*,2]/max(tom4hrhst[*,2]), thick=12, color=84

  device, /close

end
