; Plot the curtain of ozone concentration in units of DU km-1
  expid0 = 'c48Fc_H43_pin15v2+sulf+cerro_3'
  expid1 = 'c48Fc_H43_pin15v2+sulf_3'

  datewant = '199110'

; Get the ozone VMR
  filedir = '/misc/prc18/colarco/'
  filename0 = filedir+expid0+'/geosgcm_prog/'+expid0+'.geosgcm_prog.monthly.'+datewant+'.nc4'
  nc4readvar, filename0, 'u', u_0, lon=lon, lat=lat, lev=lev
  filename1 = filedir+expid1+'/geosgcm_prog/'+expid1+'.geosgcm_prog.monthly.'+datewant+'.nc4'
  nc4readvar, filename1, 'u', u_1, lon=lon, lat=lat, lev=lev

  a = where(u_0 gt 1.e14)
  u_0[a] = !values.f_nan
  a = where(u_1 gt 1.e14)
  u_1[a] = !values.f_nan

; zonal mean
  u_0 = mean(u_0,dim=1,/nan)
  u_1 = mean(u_1,dim=1,/nan)

; Get a vertical profile to go from level to altitude
; and interpolate levels to altitude
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  p = p/100.  ; hPa
  z = z/1000. ; km
  iz = interpol(indgen(n_elements(p)),p,lev)
  alt = interpolate(z,iz)

; Make a plot of the difference
  set_plot, 'ps'
  device, file='plot_u_curtain.'+datewant+'.ps', $
   /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0

  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  loadct, 64
  levels = [-100,-27+findgen(10)*3]
  colors = 255-findgen(11)*25
  contour, u_0-u_1, lat, alt, /overplot, /cell, $
   levels=levels, c_colors=colors
  loadct, 0
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  xyouts, .15, .12, '!9D!3Zonal Wind [m s!E-1!N]', /normal
  levstr = string(levels,format='(i3)')
  levstr[0] = ' '
  makekey, .15, .06, .8, .05, 0., -.05, align=.5, $
           color=colors, labels=levstr
  loadct, 64
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(n_elements(colors),val=' ')


  device, /close

end
