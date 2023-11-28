  cdfid = ncdf_open('dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc')
  id = ncdf_varid(cdfid,'h')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'vol_fine')
  ncdf_varget, cdfid, id, vol_fine
  id = ncdf_varid(cdfid,'vol_coarse')
  ncdf_varget, cdfid, id, vol_coarse
  id = ncdf_varid(cdfid,'vol')
  ncdf_varget, cdfid, id, vol
  ncdf_close, cdfid

; From m3 m-3 -> um3 cm-3
  fac = 1.e18/1.e6
  vol = vol*fac
  vol_fine = vol_fine*fac
  vol_coarse = vol_coarse*fac


  x = fltarr(72,8640)
  for i = 0, 71 do begin
   x[i,*] = findgen(8640)*10
  endfor
  loadct, 39

  set_plot, 'ps'
  device, file='vol.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(vol), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=[.01,.05,.1,.5,1,5,10,50,100], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Particle Volume Concentration [!Mmm!E3!N cm!E-3!N]', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.05','0.1','0.5','1','5','10','50','100']
  device, /close


  set_plot, 'ps'
  device, file='vol_coarse.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(vol_coarse), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=[.01,.05,.1,.5,1,5,10,50,100], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Particle Volume Concentration (coarse) [!Mmm!E3!N cm!E-3!N]', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.05','0.1','0.5','1','5','10','50','100']
  device, /close



  set_plot, 'ps'
  device, file='vol_fine.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(vol_fine), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=[.01,.05,.1,.5,1,5,10,50,100], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Particle Volume Concentration (fine) [!Mmm!E3!N cm!E-3!N]', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.05','0.1','0.5','1','5','10','50','100']
  device, /close


  set_plot, 'ps'
  device, file='vol_hist.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  a = where(h/1000. lt 30)
  pdf = histogram(vol[a],binsize=.1,locations=x)
  plot, x, pdf, /ylog, /xlog, yrange=[1,1e5], xrange=[.1,1000], $
   xtitle='particle volume [!Mmm!E3!N cm!E-3!N]', ytitle='Frequency'
  pdf = histogram(vol_coarse[a],binsize=.1,locations=x)
  oplot, x, pdf, color=254
  pdf = histogram(vol_fine[a],binsize=.1,locations=x)
  oplot, x, pdf, color=84
  xyouts, 10, 20000, 'Total'
  xyouts, 10, 10000, 'Coarse Mode', color=254
  xyouts, 10, 5000, 'Fine Mode', color=84
  device,/close
  

end
