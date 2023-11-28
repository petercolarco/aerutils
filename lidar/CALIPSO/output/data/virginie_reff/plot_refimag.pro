  cdfid = ncdf_open('dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc')
  id = ncdf_varid(cdfid,'h')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'refimag_fine')
  ncdf_varget, cdfid, id, refimag_fine
  id = ncdf_varid(cdfid,'refimag_coarse')
  ncdf_varget, cdfid, id, refimag_coarse
  id = ncdf_varid(cdfid,'refimag')
  ncdf_varget, cdfid, id, refimag
  ncdf_close, cdfid

  x = fltarr(72,8640)
  for i = 0, 71 do begin
   x[i,*] = findgen(8640)*10
  endfor
  loadct, 39

  levels = [0,.005,.01,.02,.05,.1,.2,.3,.4]
  labels = string(levels,format='(f5.3)')
  colors=reverse(254-findgen(9)*30)

  set_plot, 'ps'
  device, file='refimag.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  contour, transpose(refimag), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=levels, c_colors=colors, $
           position=[.1,.2,.95,.9], title='Imag Refractive Index', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=labels
  device, /close


  set_plot, 'ps'
  device, file='refimag_coarse.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(refimag_coarse), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=levels, c_colors=colors, $
           position=[.1,.2,.95,.9], title='Imag Refractive Index (coarse)', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=labels
  device, /close



  set_plot, 'ps'
  device, file='refimag_fine.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(refimag_fine), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=levels, c_colors=colors, $
           position=[.1,.2,.95,.9], title='Imag Refractive Index (fine)', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=labels
  device, /close


  set_plot, 'ps'
  device, file='refimag_hist.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  a = where(h/1000. lt 30)
  pdf = histogram(refimag[a],binsize=.001,locations=x)
  plot, x, pdf, /ylog, /xlog, yrange=[1,1e6], xrange=[.001,.5], $
   xtitle='Imag Refractive Index', ytitle='Frequency'
  pdf = histogram(refimag_coarse[a],binsize=.001,locations=x)
  oplot, x, pdf, color=254
  pdf = histogram(refimag_fine[a],binsize=.001,locations=x)
  oplot, x, pdf, color=84
  xyouts, .1, 200000., 'Total'
  xyouts, .1, 100000., 'Coarse Mode', color=254
  xyouts, .1, 50000., 'Fine Mode', color=84
  device,/close
  

end
