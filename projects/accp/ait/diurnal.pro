  filename = 'full.totexttau.day.hourly.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'totexttau')
  ncdf_varget, cdfid, id, tau_full
  ncdf_close, cdfid

  filename = 'gpm.nodrag.1100km.totexttau.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'totexttau')
  ncdf_varget, cdfid, id, tau_gpm
  ncdf_close, cdfid

  filename = 'gpm045.nodrag.1100km.totexttau.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'totexttau')
  ncdf_varget, cdfid, id, tau_gpm045
  ncdf_close, cdfid

  filename = 'gpm050.nodrag.1100km.totexttau.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'totexttau')
  ncdf_varget, cdfid, id, tau_gpm050
  ncdf_close, cdfid

  filename = 'gpm055.nodrag.1100km.totexttau.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'totexttau')
  ncdf_varget, cdfid, id, tau_gpm055
  ncdf_close, cdfid

  filename = 'ss450.nodrag.1100km.totexttau.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'totexttau')
  ncdf_varget, cdfid, id, tau_ss450
  ncdf_close, cdfid

; reform to get at diurnal cycle
  tau_full   = reform(tau_full,24,365,10)
  tau_gpm    = reform(tau_gpm,24,365,10)
  tau_gpm045 = reform(tau_gpm045,24,365,10)
  tau_gpm050 = reform(tau_gpm050,24,365,10)
  tau_gpm055 = reform(tau_gpm055,24,365,10)
  tau_ss450  = reform(tau_ss450,24,365,10)

; cases
  tau = fltarr(24,365,10,6)
  tau[*,*,*,0] = tau_full
  tau[*,*,*,1] = tau_gpm
  tau[*,*,*,2] = tau_gpm045
  tau[*,*,*,3] = tau_gpm050
  tau[*,*,*,4] = tau_gpm055
  tau[*,*,*,5] = tau_ss450

; Annual mean diurnal cycle and counts
  d_full   = make_array(24,10,6,val=!values.f_nan)
  n_full   = make_array(24,10,6,val=0)

  for k = 0, 5 do begin
  for j = 0, 9 do begin
  for i = 0, 23 do begin
; select not undef and where tau_full daytime is valid
   a = where(tau[i,*,j,k] lt 1000. and tau[i,*,j,0] lt 1000.)
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
  for k = 0,5 do begin
  for j = 0,9 do begin
   n_full[*,j,k] = shift(n_full[*,j,k],xs[j])
   d_full[*,j,k] = shift(d_full[*,j,k],xs[j])
  endfor
  endfor

  for j = 0, 9 do begin
   set_plot, 'ps'
   device, file='diurnal.num.'+strlowcase(strcompress(site[j],/rem))+'.ps', $
    /helvetica, font_size=14, xsize=28, ysize=14, /color
   !p.font=0

;  plot the number
   xtickn = [' ',string(indgen(24),format='(i2)'),' ']
   plot, indgen(10), /nodata, $
    xrange=[-1,24], xstyle=9, xtickn=xtickn, xticks=25, $
    yrange=[1,365], ystyle=9, yticks=7, ytickv=[1,10,50,100,150,200,300,365], $
    ytickn=['1','10','50','100','150','200','300','365'], /ylog, $
    title=site[j], xtitle='Local Hour', ytitle='days'
   plots, indgen(24), n_full[*,j,0], psym=sym(1), symsize=1
   loadct, 39
   plots, indgen(24), n_full[*,j,1], psym=sym(3), symsize=1
   plots, indgen(24), n_full[*,j,2], psym=sym(3), symsize=1, color=84
   plots, indgen(24), n_full[*,j,3], psym=sym(3), symsize=1, color=208
   plots, indgen(24), n_full[*,j,4], psym=sym(3), symsize=1, color=254
   plots, indgen(24), n_full[*,j,5], psym=sym(4), symsize=1
   

   device, /close


   device, file='diurnal.tau.'+strlowcase(strcompress(site[j],/rem))+'.ps', $
    /helvetica, font_size=14, xsize=28, ysize=14, /color
   !p.font=0

;  plot the number
   xtickn = [' ',string(indgen(24),format='(i2)'),' ']
   plot, indgen(10), /nodata, $
    xrange=[-1,24], xstyle=9, xtickn=xtickn, xticks=25, $
    yrange=[0.,.5], ystyle=9, yticks=5, title=site[j], $
    xtitle='Local hour',ytitle='AOD'
   plots, indgen(24), d_full[*,j,0], psym=sym(1), symsize=1
   loadct, 39
   plots, indgen(24), d_full[*,j,1], psym=sym(3), symsize=1
   plots, indgen(24), d_full[*,j,2], psym=sym(3), symsize=1, color=84
   plots, indgen(24), d_full[*,j,3], psym=sym(3), symsize=1, color=208
   plots, indgen(24), d_full[*,j,4], psym=sym(3), symsize=1, color=254
   plots, indgen(24), d_full[*,j,5], psym=sym(4), symsize=1
   device, /close

  endfor

end
