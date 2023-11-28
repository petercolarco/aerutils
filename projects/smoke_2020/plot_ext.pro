  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

  cdfid = ncdf_open('ext_sampler.nc')
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  ncdf_close, cdfid

  set_plot, 'ps'
  device, file='plot_ext.ps', /color, /helvetica, font_size=14, $
   xsize=20, ysize=14
  !p.font=0

  contour, transpose(ext), /nodata, $
   xrange=[0,24], xticks=24, xtickn=[string(indgen(24),format='(i02)'),'00'], $
   yrange=[0,20], ytitle='Altitude [km]', xmin=1, $
   xtitle='Hour of September 15, 2020', $
   position=[.1,.25,.9,.9]


  loadct, 39
  levels=[.01,.02,.04,.07,.1,.2,.3]
  colors=findgen(7)*30+60
  contour, /overplot, transpose(ext), indgen(25), z/1000., /fill, $
   c_col=colors, levels=levels

  contour, transpose(ext), /nodata, /noerase, $
   xrange=[0,24], xticks=24, xtickn=[string(indgen(24),format='(i02)'),'00'], $
   yrange=[0,20], ytitle='Altitude [km]', xmin=1, $
   xtitle='Hour of September 15, 2020', $
   position=[.1,.25,.9,.9]

  makekey, .15,.075,.7,.035,0,-.05, align=0, $
   colors=colors, label=string(levels,format='(f4.2)')

  xyouts, 1, 18, 'GEOS FP Aerosol Extinction [km!E-1!N, 532 nm] at GSFC', /data

  device, /close

end
