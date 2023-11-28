  cdfid = ncdf_open('dR_MERRA-AA-r2.calipso_355nm-v10.20090715.nc')
  id = ncdf_varid(cdfid,'refreal_fine')
  ncdf_varget, cdfid, id, refreal_fine
  id = ncdf_varid(cdfid,'refreal_coarse')
  ncdf_varget, cdfid, id, refreal_coarse
  id = ncdf_varid(cdfid,'refreal')
  ncdf_varget, cdfid, id, refreal

  id = ncdf_varid(cdfid,'refimag_fine')
  ncdf_varget, cdfid, id, refimag_fine
  id = ncdf_varid(cdfid,'refimag_coarse')
  ncdf_varget, cdfid, id, refimag_coarse
  id = ncdf_varid(cdfid,'refimag')
  ncdf_varget, cdfid, id, refimag

  id = ncdf_varid(cdfid,'area_fine')
  ncdf_varget, cdfid, id, area_fine
  id = ncdf_varid(cdfid,'area_coarse')
  ncdf_varget, cdfid, id, area_coarse
  id = ncdf_varid(cdfid,'area')
  ncdf_varget, cdfid, id, area

; From m2 m-3 -> um2 cm-3
  fac = 1e12/1e4
  area = area*fac
  area_fine = area_fine*fac
  area_coarse = area_coarse*fac


  a = where(finite(area_fine) ne 1)
  print, a

  a = where(finite(area_coarse) ne 1)
  print, a

  a = where(finite(area) ne 1)
  print, a

  id = ncdf_varid(cdfid,'vol_fine')
  ncdf_varget, cdfid, id, vol_fine
  id = ncdf_varid(cdfid,'vol_coarse')
  ncdf_varget, cdfid, id, vol_coarse
  id = ncdf_varid(cdfid,'vol')
  ncdf_varget, cdfid, id, vol

; From m3 m-3 -> um3 cm-3
  fac = 1.e18/1.e6
  vol = vol*fac
  vol_fine = vol_fine*fac
  vol_coarse = vol_coarse*fac


  a = where(finite(vol_fine) ne 1)
  print, a

  a = where(finite(vol_coarse) ne 1)
  print, a

  a = where(finite(vol) ne 1)
  print, a

  id = ncdf_varid(cdfid,'reff_fine')
  ncdf_varget, cdfid, id, reff_fine
  id = ncdf_varid(cdfid,'reff_coarse')
  ncdf_varget, cdfid, id, reff_coarse
  id = ncdf_varid(cdfid,'reff')
  ncdf_varget, cdfid, id, reff
  ncdf_close, cdfid

; From m -> um
  fac = 1.e6
  reff = reff*fac
  reff_fine = reff_fine*fac
  reff_coarse = reff_coarse*fac



  set_plot, 'ps'
  device, file='reff.ps', /color, /helvetica, font_size=16, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  colors=reverse(254-findgen(9)*30)
  contour, transpose(reff), /cell, $
           yrange=[71,0], xrange=[0,8640], xstyle=9, ystyle=9, $
           levels=[.01,.02,.05,.1,.2,.5,1,2,5], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Effective radius [!Mmm]'
  a = where(finite(reff) ne 1)
  for i = 0, n_elements(a)-1 do begin
     y = a[i] mod 72
     x = a[i]/72
     plots, x, y, psym=4, symsize=.5
  endfor
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.02','0.05','0.1','0.2','0.5','1','2','5']
  
  device, /close

  
  set_plot, 'ps'
  device, file='reff_fine.ps', /color, /helvetica, font_size=16, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  colors=reverse(254-findgen(9)*30)
  contour, transpose(reff_fine), /cell, $
           yrange=[71,0], xrange=[0,8640], xstyle=9, ystyle=9, $
           levels=[.01,.02,.05,.1,.2,.5,1,2,5], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Fine Mode Effective radius [!Mmm]'
  a = where(finite(reff_fine) ne 1)
  for i = 0, n_elements(a)-1 do begin
     y = a[i] mod 72
     x = a[i]/72
     plots, x, y, psym=4, symsize=.5
  endfor
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.02','0.05','0.1','0.2','0.5','1','2','5']
  
  device, /close

  
  set_plot, 'ps'
  device, file='reff_coarse.ps', /color, /helvetica, font_size=16, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  colors=reverse(254-findgen(9)*30)
  contour, transpose(reff_coarse), /cell, $
           yrange=[71,0], xrange=[0,8640], xstyle=9, ystyle=9, $
           levels=[.01,.02,.05,.1,.2,.5,1,2,5], c_colors=colors, $
           position=[.1,.2,.95,.9], title='Coarse Mode Effective radius [!Mmm]'
  a = where(finite(reff_coarse) ne 1)
  for i = 0, n_elements(a)-1 do begin
     y = a[i] mod 72
     x = a[i]/72
     plots, x, y, psym=4, symsize=.5
  endfor
  makekey, .1, .05, .85, .05, 0, -.045, color=colors, align=0, $
           label=['0.01','0.02','0.05','0.1','0.2','0.5','1','2','5']
  
  device, /close

  
end
