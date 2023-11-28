  for k = 0, 60 do begin
   kk = string(k,format='(i02)')
   filename = 'psg_rad.usatm_iss.'+kk+'km.txt'
   read_rad, filename, wavelength, rad_
   if(k eq 0) then radiance = fltarr(n_elements(wavelength),61)
   radiance[*,k] = rad_

  endfor

  set_plot, 'ps'
  device, file='get_profile.2.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=28
  !p.font=0

  loadct, 39
  plot, indgen(20), /nodata, $
   xrange=[4,8], xtitle='!9l!3 [!9m!3m]', $
   yrange=[1e-8,.1], ytitle = 'radiance [W m!E-2!N sr!E-1!N]', /ylog, $
   position=[.1,.2,.95,.95]
  oplot, reform(wavelength), radiance[*,0], thick=4, color=0
  oplot, reform(wavelength), radiance[*,10], thick=4, color=30
  oplot, reform(wavelength), radiance[*,20], thick=4, color=60
  oplot, reform(wavelength), radiance[*,30], thick=4, color=90
  oplot, reform(wavelength), radiance[*,40], thick=4, color=120
  oplot, reform(wavelength), radiance[*,50], thick=4, color=200
  oplot, reform(wavelength), radiance[*,60], thick=4, color=254

  device, /close

end
