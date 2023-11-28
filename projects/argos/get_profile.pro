  for k = 0, 60 do begin
   kk = string(k,format='(i02)')
   filename = 'psg_rad.usatm_iss.'+kk+'km.txt'
   read_rad, filename, wavelength, rad_
   if(k eq 0) then radiance = fltarr(n_elements(wavelength),61)
   radiance[*,k] = rad_

  endfor

  set_plot, 'ps'
  device, file='get_profile.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=28
  !p.font=0

  loadct, 39
  plot, indgen(20), /nodata, $
   xrange=[4,8], xtitle='!9l!3 [!9m!3m]', $
   yrange=[0,60], ytitle = 'Tangent Height [km]', $
   position=[.1,.2,.95,.95]
  levels = 1e-8*10^(findgen(8))
  colors=40+indgen(8)*30
  plotgrid, radiance, levels, colors, reform(wavelength), indgen(61), .025, 1.
  makekey, .1, .12, .85, .03, 0, -.025, $
   label=string(-8+indgen(8),format='(i2)'), colors=colors
  xyouts, .1, .05, /normal, 'log!D10!N(radiance [W m!E-2!N sr!E-1!N])'
  device, /close

end
