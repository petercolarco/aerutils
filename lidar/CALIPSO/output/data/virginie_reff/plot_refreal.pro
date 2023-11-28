  cdfid = ncdf_open('dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc')
  id = ncdf_varid(cdfid,'h')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'refreal_fine')
  ncdf_varget, cdfid, id, refreal_fine
  id = ncdf_varid(cdfid,'refreal_coarse')
  ncdf_varget, cdfid, id, refreal_coarse
  id = ncdf_varid(cdfid,'refreal')
  ncdf_varget, cdfid, id, refreal
  ncdf_close, cdfid

  x = fltarr(72,8640)
  for i = 0, 71 do begin
   x[i,*] = findgen(8640)*10
  endfor
  loadct, 39

  levels = findgen(9)*.03+1.34
  labels = string(levels,format='(f4.2)')
  colors=reverse(254-findgen(9)*30)

  set_plot, 'ps'
  device, file='refreal.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  contour, transpose(refreal), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=levels, c_colors=colors, $
           position=[.1,.2,.95,.9], title='Real Refractive Index', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=labels
  device, /close


  set_plot, 'ps'
  device, file='refreal_coarse.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(refreal_coarse), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=levels, c_colors=colors, $
           position=[.1,.2,.95,.9], title='Real Refractive Index (coarse)', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=labels
  device, /close



  set_plot, 'ps'
  device, file='refreal_fine.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(refreal_fine), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=levels, c_colors=colors, $
           position=[.1,.2,.95,.9], title='Real Refractive Index (fine)', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=labels
  device, /close


  set_plot, 'ps'
  device, file='refreal_hist.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  a = where(h/1000. lt 30)
  pdf = histogram(refreal[a],binsize=.01,locations=x)
  plot, x, pdf, /ylog, yrange=[1,1e5], xrange=[1.3,1.75], $
   xtitle='Real Refractive Index', ytitle='Frequency'
  pdf = histogram(refreal_coarse[a],binsize=.01,locations=x)
  oplot, x, pdf, color=254
  pdf = histogram(refreal_fine[a],binsize=.01,locations=x)
  oplot, x, pdf, color=84
  xyouts, 1.6, 20000, 'Total'
  xyouts, 1.6, 10000, 'Coarse Mode', color=254
  xyouts, 1.6, 5000, 'Fine Mode', color=84
  device,/close
  

end
