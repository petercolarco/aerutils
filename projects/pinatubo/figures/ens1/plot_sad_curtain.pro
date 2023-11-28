; Plot the curtain of ozone concentration in units of DU km-1
  expid0 = 'c48Fc_H43_pin15v2+sulf+cerro'
  expid1 = 'c48Fc_H43_pin15v2+sulf'

  datewant = '199110'

; Get the sulfate surface area
  filedir = '/misc/prc18/colarco/'
  filename0 = filedir+expid0+'/tavg3d_carma_p/'+expid0+'.tavg3d_carma_p.monthly.'+datewant+'.nc4'
  nc4readvar, filename0, 'susarea', sad_0, lon=lon, lat=lat, lev=lev
  filename1 = filedir+expid1+'/tavg3d_carma_p/'+expid1+'.tavg3d_carma_p.monthly.'+datewant+'.nc4'
  nc4readvar, filename1, 'susarea', sad_1, lon=lon, lat=lat, lev=lev

  a = where(sad_0 gt 1.e14)
  sad_0[a] = !values.f_nan
  a = where(sad_1 gt 1.e14)
  sad_1[a] = !values.f_nan

; zonal mean and convert units to um2 cm-3
  sad_0 = mean(sad_0,dim=1,/nan)*1e6
  sad_1 = mean(sad_1,dim=1,/nan)*1e6

; Get a vertical profile to go from level to altitude
; and interpolate levels to altitude
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  p = p/100.  ; hPa
  z = z/1000. ; km
  iz = interpol(indgen(n_elements(p)),p,lev)
  alt = interpolate(z,iz)

; Make a plot of the difference
  set_plot, 'ps'
  device, file='plot_sad_curtain.'+datewant+'.ps', $
   /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0

  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  loadct, 65
  levels = findgen(8)*5
  colors = findgen(8)*35
  contour, sad_0, lat, alt, /overplot, /cell, $
   levels=levels, c_colors=colors
  loadct, 0
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  xyouts, .15, .12, 'SAD [!9m!3m!E2!N cm!E-3!N]', /normal
  levstr = string(levels,format='(i3)')
  makekey, .15, .06, .8, .05, 0., -.05, align=.5, $
           color=colors, labels=levstr
  loadct, 65
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(n_elements(colors),val=' ')


  device, /close

end
