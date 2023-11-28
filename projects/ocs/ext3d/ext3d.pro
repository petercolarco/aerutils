  dtitle= '2001FMA'

; Get the optics stuff
  filename = 'c48F_G40b11_ocs.tavg3d_ext-532nm_v.monthly.'+dtitle+'.nc4'
  nc4readvar, filename, 'extinction', ext, lon=lon, lat=lat
  filename = 'c48F_G40b11_ocs.tavg3d_ext-470nm_v.monthly.'+dtitle+'.nc4'
  nc4readvar, filename, 'extinction', ext470
  filename = 'c48F_G40b11_ocs.tavg3d_ext-870nm_v.monthly.'+dtitle+'.nc4'
  nc4readvar, filename, 'extinction', ext870

  ang     = -alog(ext470/ext870)/alog(470./870.)

; Zonal mean
  ext     = reform(total(ext,1))/144.
  ang     = reform(total(ang,1))/144.

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa
  z = z/1000.
  delz = delz/1000.
  colors = 25. + findgen(8)*30
  colors = reverse(colors)
  set_plot, 'ps'
  device, file='extinction.'+dtitle+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.93], $
        xtitle='latitude', ytitle='Altitude [km]', $
        title='Extinction [532 nm], Angstrom Parameter', $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9
;        xrange=[-90,90], yrange=[1000,1], /ylog, xstyle=9, ystyle=9
  loadct, 72
  levels = [.001,.005,.01,.05,.1,.15,.2,.25,.3]*1e-3
  levels = [-6,-5.7,-5.4,-5.1,-4.8,-4.5,-4.2,-3.9,-3.6,-3.3,-3]
  levels = [-6,-5.6,-5.2,-4.8,-4.4,-4.0,-3.6,-3.2]
  plotgrid, alog10(ext), levels, colors, lat, z, 2., delz
  loadct, 0
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.93], $
        xrange=[-90,90], yrange=[10,45], xstyle=9, ystyle=9


  xyouts, .15, .11, 'log!D10!N(Extinction [532 nm])', /normal
  makekey, .15, .05, .8, .05, 0., -.035, align=.5, $
           color=colors, labels=[string(levels,format='(f5.1)'),'-2.8']
  loadct, 72
  makekey, .15, .05, .8, .05, 0., -.035, align=0, $
           color=colors, labels=make_array(8,val='')

; Overplot the zonal mean Angstrom exponent
  loadct, 0
  contour, ang, lat, z, levels=findgen(6)*.25+1.5,/over, color=80, c_label=indgen(6)

  xyouts, .15, .2, dtitle, /normal

device, /close

end
