; Plot the curtain of ozone concentration in units of DU km-1
  expid0 = 'c180Fc_H43_pin15v2+sulf+cerro'
  expid1 = 'c180Fc_H43_pin15v2+sulf'

  datewant = '199110'

; Get the ozone VMR
  filedir = '/misc/prc18/colarco/'
  filename0 = filedir+expid0+'/geosgcm_prog/'+expid0+'.geosgcm_prog.monthly.'+datewant+'.nc4'
  nc4readvar, filename0, 'o3', o3_0, lon=lon, lat=lat, lev=lev
  filename1 = filedir+expid1+'/geosgcm_prog/'+expid1+'.geosgcm_prog.monthly.'+datewant+'.nc4'
  nc4readvar, filename1, 'o3', o3_1, lon=lon, lat=lat, lev=lev

; Get the air density
  filename0 = filedir+expid0+'/tavg3d_carma_p/'+expid0+'.tavg3d_carma_p.monthly.'+datewant+'.nc4'
  nc4readvar, filename0, 'airdens', airdens_0, lon=lon, lat=lat, lev=lev2
  filename1 = filedir+expid1+'/tavg3d_carma_p/'+expid1+'.tavg3d_carma_p.monthly.'+datewant+'.nc4'
  nc4readvar, filename1, 'airdens', airdens_1, lon=lon, lat=lat, lev=lev2

; Now do conversion to DU km-1
; VMR *NA/molwght_air*airdens*fac*1000
  NA = 6.02e23     ; molecules mole-1
  molwght = 0.029  ; kg air mole-1
  fac = 1./2.69e20 ; 1 DU = 2.69e20 molecules m-2
  a = where(o3_0 gt 1.e14 or airdens_0 gt 1.e14)
  o3_0[a] = !values.f_nan
  airdens_0[a] = !values.f_nan
  o3du_0 = o3_0*airdens_0*NA/molwght*fac*1000.
  a = where(o3_1 gt 1.e14 or airdens_1 gt 1.e14)
  o3_1[a] = !values.f_nan
  airdens_1[a] = !values.f_nan
  o3du_1 = o3_1*airdens_1*NA/molwght*fac*1000.

; zonal mean
  o3du_0 = mean(o3du_0,dim=1,/nan)
  o3du_1 = mean(o3du_1,dim=1,/nan)

; Get a vertical profile to go from level to altitude
; and interpolate levels to altitude
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  p = p/100.  ; hPa
  z = z/1000. ; km
  iz = interpol(indgen(n_elements(p)),p,lev)
  alt = interpolate(z,iz)

; Make a plot of the difference
  set_plot, 'ps'
  device, file='plot_o3_curtain.'+datewant+'.ps', $
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
  levels = [-10,-4,-3,-2,-1,-.1,.1,1,2,3,4]
  colors = 255-findgen(11)*25
  contour, o3du_0-o3du_1, lat, alt, /overplot, /cell, $
   levels=levels, c_colors=colors
  loadct, 0
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='Altitude [km]', $
        xrange=[-90,-30], yrange=[10,40], xstyle=9, ystyle=9, $
        xticks=6, xtickv=findgen(7)*10-90
  xyouts, .15, .12, '!9D!3Ozone [DU km!E-1!N]', /normal
  levstr = string(levels,format='(f5.1)')
  levstr[0] = ' '
  makekey, .15, .06, .8, .05, 0., -.05, align=.5, $
           color=colors, labels=levstr
  loadct, 72
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(n_elements(colors),val=' ')


  device, /close

end
