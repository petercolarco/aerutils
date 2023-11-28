;  filename = 'full.totexttau.day.hourly.nc'
;  cdfid = ncdf_open(filename)
;  id = ncdf_varid(cdfid,'totexttau')
;  ncdf_varget, cdfid, id, tau_full
;  ncdf_close, cdfid

  filename = 'full.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_full
  ncdf_close, cdfid

  filename = 'gpm.nodrag.550km.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_gpm
  ncdf_close, cdfid

  filename = 'gpm060.nodrag.550km.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_gpm060
  ncdf_close, cdfid

  filename = 'gpm045.nodrag.550km.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_gpm045
  ncdf_close, cdfid

  filename = 'gpm050.nodrag.550km.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_gpm050
  ncdf_close, cdfid

  filename = 'gpm055.nodrag.550km.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_gpm055
  ncdf_close, cdfid

  filename = 'ss450.nodrag.550km.cloud.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'cldtot')
  ncdf_varget, cdfid, id, tau_ss450
  ncdf_close, cdfid

; reform to get at diurnal cycle
  tau_full   = reform(tau_full,24,365,10)
  tau_gpm    = reform(tau_gpm,24,365,10)
  tau_gpm060 = reform(tau_gpm060,24,365,10)
  tau_gpm045 = reform(tau_gpm045,24,365,10)
  tau_gpm050 = reform(tau_gpm050,24,365,10)
  tau_gpm055 = reform(tau_gpm055,24,365,10)
  tau_ss450  = reform(tau_ss450,24,365,10)

; cases
  tau = fltarr(24,365,10,7)
  tau[*,*,*,0] = tau_full
  tau[*,*,*,1] = tau_gpm
  tau[*,*,*,2] = tau_gpm060
  tau[*,*,*,3] = tau_gpm055
  tau[*,*,*,4] = tau_gpm050
  tau[*,*,*,5] = tau_gpm045
  tau[*,*,*,6] = tau_ss450

; Annual mean diurnal cycle and counts
  d_full   = make_array(24,10,7,val=!values.f_nan)
  n_full   = make_array(24,10,7,val=0)

  for k = 0, 6 do begin
  for j = 0, 9 do begin
  for i = 0, 23 do begin
; select not undef
   a = where(tau[i,*,j,k] lt 1000.)
   if(a[0] ne -1) then begin
    n_full(i,j,k) = n_elements(a)
    d_full(i,j,k) = mean(tau[i,a,j,k])
   endif
  endfor
  endfor
  endfor

  site = ['Moscow', 'Fairbanks', 'Seattle','New York','Los Angeles','New Delhi', $
          'Mexico City','Manila','Jakarta','Nairobi']
  lon = [37.62,-147.72,-122.33,-74.00,-118.24,77.10,-99.13,120.98,106.85,36.82]
  lat = [55.76,64.84,47.61,40.71,34.05,28.70,19.43,14.60,-6.21,-1.29]

; correct to local time
  xs  = (lon-7.5)/15.
  for k = 0,6 do begin
  for j = 0,9 do begin
   n_full[*,j,k] = shift(n_full[*,j,k],xs[j])
   d_full[*,j,k] = shift(d_full[*,j,k],xs[j])
  endfor
  endfor

  for j = 0, 9 do begin
   set_plot, 'ps'
   device, file='diurnal.cloud.num.'+strlowcase(strcompress(site[j],/rem))+'.ps', $
    /helvetica, font_size=14, xsize=28, ysize=14, /color
   !p.font=0

;  plot the number
   xtickn = [' ',string(indgen(24),format='(i2)'),' ']
   plot, indgen(10), /nodata, $
    xrange=[-1,24], xstyle=9, xtickn=xtickn, xticks=25, $
    yrange=[1,365], ystyle=9, yticks=7, ytickv=[1,10,50,100,150,200,300,365], $
    ytickn=['1','10','50','100','150','200','300','365'], /ylog, $
    title=site[j], xtitle='Local Hour', ytitle='days'
   loadct, 39
   plots, indgen(24), n_full[*,j,0], psym=sym(3), symsize=2, color=254
   plots, indgen(24), n_full[*,j,0], psym=sym(8), symsize=2, color=0
   plots, indgen(24), n_full[*,j,6], psym=sym(4), symsize=2, color=254
   plots, indgen(24), n_full[*,j,6], psym=sym(9), symsize=2, color=0
   plots, indgen(24), n_full[*,j,1], psym=sym(1), symsize=2, color=254
   plots, indgen(24), n_full[*,j,1], psym=sym(6), symsize=2, color=0
   plots, indgen(24), n_full[*,j,2], psym=sym(1), symsize=1, color=208
   plots, indgen(24), n_full[*,j,2], psym=sym(6), symsize=1, color=0
   plots, indgen(24), n_full[*,j,3], psym=sym(1), symsize=1, color=192
   plots, indgen(24), n_full[*,j,3], psym=sym(6), symsize=1, color=0
   plots, indgen(24), n_full[*,j,4], psym=sym(1), symsize=1, color=176
   plots, indgen(24), n_full[*,j,4], psym=sym(6), symsize=1, color=0
   plots, indgen(24), n_full[*,j,5], psym=sym(1), symsize=1, color=84
   plots, indgen(24), n_full[*,j,5], psym=sym(6), symsize=1, color=0
   
;  Make a key
   plots, 1, 3, psym=sym(3), color=254
   plots, 1, 3, psym=sym(8), color=0
   me = string(total(n_full[*,j,0],/nan),format='(i4)')
   mx = string(max(n_full[*,j,0]),format='(i4)')
   mn = string(min(n_full[*,j,0]),format='(i4)')
   xyouts, 1.25, 2.8, 'Full:            total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 1, 2.4, psym=sym(4), color=254
   plots, 1, 2.4, psym=sym(9), color=0
   me = string(total(n_full[*,j,6],/nan),format='(i4)')
   mx = string(max(n_full[*,j,6]),format='(i4)')
   mn = string(min(n_full[*,j,6]),format='(i4)')
   xyouts, 1.25, 2.3, 'Sun-synch: total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 1, 2, psym=sym(1), color=254
   plots, 1, 2, psym=sym(6), color=0
   me = string(total(n_full[*,j,1],/nan),format='(i4)')
   mx = string(max(n_full[*,j,1]),format='(i4)')
   mn = string(min(n_full[*,j,1]),format='(i4)')
   xyouts, 1.25, 1.9, '65!Eo!N:             total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 1, 1.6, psym=sym(1), color=208
   plots, 1, 1.6, psym=sym(6), color=0
   me = string(total(n_full[*,j,2],/nan),format='(i4)')
   mx = string(max(n_full[*,j,2]),format='(i4)')
   mn = string(min(n_full[*,j,2]),format='(i4)')
   xyouts, 1.25, 1.5, '60!Eo!N:             total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 10, 2.4, psym=sym(1), color=192
   plots, 10, 2.4, psym=sym(6), color=0
   me = string(total(n_full[*,j,3],/nan),format='(i4)')
   mx = string(max(n_full[*,j,3]),format='(i4)')
   mn = string(min(n_full[*,j,3]),format='(i4)')
   xyouts, 10.25, 2.3, '55!Eo!N:             total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 10, 2, psym=sym(1), color=176
   plots, 10, 2, psym=sym(6), color=0
   me = string(total(n_full[*,j,4],/nan),format='(i4)')
   mx = string(max(n_full[*,j,4]),format='(i4)')
   mn = string(min(n_full[*,j,4]),format='(i4)')
   xyouts, 10.25, 1.9, '50!Eo!N:             total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 10, 1.6, psym=sym(1), color=84
   plots, 10, 1.6, psym=sym(6), color=0
   me = string(total(n_full[*,j,5],/nan),format='(i4)')
   mx = string(max(n_full[*,j,5]),format='(i4)')
   mn = string(min(n_full[*,j,5]),format='(i4)')
   xyouts, 10.25, 1.5, '45!Eo!N:             total/min/max = '+me+'/'+mn+'/'+mx, charsize=.75


   device, /close


   device, file='diurnal.cloud.'+strlowcase(strcompress(site[j],/rem))+'.ps', $
    /helvetica, font_size=14, xsize=28, ysize=14, /color
   !p.font=0

;  plot the number
   xtickn = [' ',string(indgen(24),format='(i2)'),' ']
   plot, indgen(10), /nodata, $
    xrange=[-1,24], xstyle=9, xtickn=xtickn, xticks=25, $
    yrange=[0.,1], ystyle=9, yticks=5, title=site[j], $
    xtitle='Local hour',ytitle='CLDTOT'
   loadct, 39
   plots, indgen(24), d_full[*,j,0], psym=sym(3), symsize=2, color=254
   plots, indgen(24), d_full[*,j,0], psym=sym(8), symsize=2, color=0
   plots, indgen(24), d_full[*,j,6], psym=sym(4), symsize=2, color=254
   plots, indgen(24), d_full[*,j,6], psym=sym(9), symsize=2, color=0
   plots, indgen(24), d_full[*,j,1], psym=sym(1), symsize=2, color=254
   plots, indgen(24), d_full[*,j,1], psym=sym(6), symsize=2, color=0
   plots, indgen(24), d_full[*,j,2], psym=sym(1), symsize=1, color=208
   plots, indgen(24), d_full[*,j,2], psym=sym(6), symsize=1, color=0
   plots, indgen(24), d_full[*,j,3], psym=sym(1), symsize=1, color=192
   plots, indgen(24), d_full[*,j,3], psym=sym(6), symsize=1, color=0
   plots, indgen(24), d_full[*,j,4], psym=sym(1), symsize=1, color=176
   plots, indgen(24), d_full[*,j,4], psym=sym(6), symsize=1, color=0
   plots, indgen(24), d_full[*,j,5], psym=sym(1), symsize=1, color=84
   plots, indgen(24), d_full[*,j,5], psym=sym(6), symsize=1, color=0

;  Make a key
   plots, 1, .2, psym=sym(3), color=254
   plots, 1, .2, psym=sym(8), color=0
   me = string(mean(d_full[*,j,0],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,0]),format='(f4.2)')
   mn = string(min(d_full[*,j,0]),format='(f4.2)')
   xyouts, 1.25, .19, 'Full:            mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 1, .16, psym=sym(4), color=254
   plots, 1, .16, psym=sym(9), color=0
   me = string(mean(d_full[*,j,6],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,6]),format='(f4.2)')
   mn = string(min(d_full[*,j,6]),format='(f4.2)')
   xyouts, 1.25, .15, 'Sun-synch: mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 1, .12, psym=sym(1), color=254
   plots, 1, .12, psym=sym(6), color=0
   me = string(mean(d_full[*,j,1],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,1]),format='(f4.2)')
   mn = string(min(d_full[*,j,1]),format='(f4.2)')
   xyouts, 1.25, .11, '65!Eo!N:             mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 1, .08, psym=sym(1), color=208
   plots, 1, .08, psym=sym(6), color=0
   me = string(mean(d_full[*,j,2],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,2]),format='(f4.2)')
   mn = string(min(d_full[*,j,2]),format='(f4.2)')
   xyouts, 1.25, .07, '60!Eo!N:             mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 10, .16, psym=sym(1), color=192
   plots, 10, .16, psym=sym(6), color=0
   me = string(mean(d_full[*,j,3],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,3]),format='(f4.2)')
   mn = string(min(d_full[*,j,3]),format='(f4.2)')
   xyouts, 10.25, .15, '55!Eo!N:             mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 10, .12, psym=sym(1), color=176
   plots, 10, .12, psym=sym(6), color=0
   me = string(mean(d_full[*,j,4],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,4]),format='(f4.2)')
   mn = string(min(d_full[*,j,4]),format='(f4.2)')
   xyouts, 10.25, .11, '50!Eo!N:             mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   plots, 10, .08, psym=sym(1), color=84
   plots, 10, .08, psym=sym(6), color=0
   me = string(mean(d_full[*,j,5],/nan),format='(f4.2)')
   mx = string(max(d_full[*,j,5]),format='(f4.2)')
   mn = string(min(d_full[*,j,5]),format='(f4.2)')
   xyouts, 10.25, .07, '45!Eo!N:             mean/min/max = '+me+'/'+mn+'/'+mx, charsize=.75

   device, /close

  endfor

end
