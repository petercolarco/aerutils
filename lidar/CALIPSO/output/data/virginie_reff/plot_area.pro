  cdfid = ncdf_open('dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc')
  id = ncdf_varid(cdfid,'h')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'area_fine')
  ncdf_varget, cdfid, id, area_fine
  id = ncdf_varid(cdfid,'area_coarse')
  ncdf_varget, cdfid, id, area_coarse
  id = ncdf_varid(cdfid,'area')
  ncdf_varget, cdfid, id, area
  ncdf_close, cdfid

; From m2 m-3 -> um2 cm-3
  fac = 1.e12/1.e6
  area = area*fac
  area_fine = area_fine*fac
  area_coarse = area_coarse*fac


  x = fltarr(72,8640)
  for i = 0, 71 do begin
   x[i,*] = findgen(8640)*10
  endfor
  loadct, 39

  set_plot, 'ps'
  device, file='area.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(area), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=[.01,.05,.1,.5,1,5,10,50,100], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Particle Cross Sectional Area Concentration [!Mmm!E2!N cm!E-3!N]', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.05','0.1','0.5','1','5','10','50','100']
  device, /close


  set_plot, 'ps'
  device, file='area_coarse.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(area_coarse), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=[.01,.05,.1,.5,1,5,10,50,100], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Particle Cross Sectional Area Concentration (coarse) [!Mmm!E2!N cm!E-3!N]', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.05','0.1','0.5','1','5','10','50','100']
  device, /close



  set_plot, 'ps'
  device, file='area_fine.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  colors=reverse(254-findgen(9)*30)
  contour, transpose(area_fine), transpose(x), transpose(h)/1000., /cell, $
           yrange=[0,30], xrange=[0,86400], xstyle=9, ystyle=9, $
           levels=[.01,.05,.1,.5,1,5,10,50,100], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Particle Cross Sectional Area Concentration (fine) [!Mmm!E2!N cm!E-3!N]', $
           ytitle='Altitude [km]', xtitle='seconds'
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.05','0.1','0.5','1','5','10','50','100']
  device, /close


  set_plot, 'ps'
  device, file='area_hist.ps', /color, /helvetica, font_size=14, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  a = where(h/1000. lt 30)
  pdf = histogram(area[a],binsize=.1,locations=x)
  plot, x, pdf, /ylog, /xlog, yrange=[1,1e5], xrange=[.1,1000], $
   xtitle='particle cross sectional area [!Mmm!E2!N cm!E-3!N]', ytitle='Frequency'
  pdf = histogram(area_coarse[a],binsize=.1,locations=x)
  oplot, x, pdf, color=254
  pdf = histogram(area_fine[a],binsize=.1,locations=x)
  oplot, x, pdf, color=84
  xyouts, 10, 20000, 'Total'
  xyouts, 10, 10000, 'Coarse Mode', color=254
  xyouts, 10, 5000, 'Fine Mode', color=84
  device,/close
  

end
