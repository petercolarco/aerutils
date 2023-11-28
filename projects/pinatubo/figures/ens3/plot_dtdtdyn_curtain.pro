; Plot the curtain of ozone concentration in units of DU km-1
  expid0 = 'c48Fc_H43_pin15v2+sulf+cerro_3'
  expid1 = 'c48Fc_H43_pin15v2+sulf_3'

  datewant = '199110'

; Get the ozone VMR
  filedir = '/misc/prc18/colarco/'
  filename0 = filedir+expid0+'/geosgcm_tend/'+expid0+'.geosgcm_tend.monthly.'+datewant+'.nc4'
  nc4readvar, filename0, 'dtdtdyn', t_0, lon=lon, lat=lat, lev=lev
  filename1 = filedir+expid1+'/geosgcm_tend/'+expid1+'.geosgcm_tend.monthly.'+datewant+'.nc4'
  nc4readvar, filename1, 'dtdtdyn', t_1, lon=lon, lat=lat, lev=lev

  a = where(t_0 gt 1.e14)
  t_0[a] = !values.f_nan
  a = where(t_1 gt 1.e14)
  t_1[a] = !values.f_nan

; zonal mean
  t_0 = mean(t_0,dim=1,/nan)*86400.
  t_1 = mean(t_1,dim=1,/nan)*86400.

; Get a vertical profile to go from level to altitude
; and interpolate levels to altitude
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  p = p/100.  ; hPa
  z = z/1000. ; km
  iz = interpol(indgen(n_elements(p)),p,lev)
  alt = interpolate(z,iz)

; Make a plot of the difference
  set_plot, 'ps'
  device, file='plot_dtdtdyn_curtain.'+datewant+'.ps', $
   /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0

  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  loadct, 72
  levels = [-100,-2,-1.5,-1,-.5,-.1,.1,.5,1]
  colors = [255-findgen(6)*25,80,40,0]
  contour, t_0-t_1, lat, alt, /overplot, /cell, $
   levels=levels, c_colors=colors
  loadct, 0
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  xyouts, .15, .12, "!9D!3T' (Dynamics) [K day!E-1!N]", /normal
  levstr = string(levels,format='(f4.1)')
  levstr[0] = ' '
  makekey, .15, .06, .8, .05, 0., -.05, align=.5, $
           color=colors, labels=levstr
  loadct, 72
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(n_elements(colors),val=' ')


  device, /close

end
