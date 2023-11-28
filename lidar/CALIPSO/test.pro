  cdfid = ncdf_open('dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc')
  id = ncdf_varid(cdfid,'reff_fine')
  ncdf_varget, cdfid, id, reff_fine
  id = ncdf_varid(cdfid,'reff_coarse')
  ncdf_varget, cdfid, id, reff_coarse
  id = ncdf_varid(cdfid,'reff')
  ncdf_varget, cdfid, id, reff
  ncdf_close, cdfid

  reff = reff[62:71,*]
  reff_fine = reff_fine[62:71,*]
  reff_coarse = reff_coarse[62:71,*]
  
  reff = reff*1e6
  reff_fine = reff_fine*1.e6
  reff_coarse = reff_coarse*1.e6

  loadct, 39
  pdf = histogram(reff,binsize=.02,locations=r)
  print, total(pdf)
  plot, r, pdf, thick=6, xrange=[.03,15], xstyle=1, /xlog, yrange=[0,12000], $
        xtitle='effective radius [um]'
  pdf = histogram(reff_fine,binsize=.02,locations=r)
  print, total(pdf)
  oplot, r, pdf, thick=6, color=84
  pdf = histogram(reff_coarse,binsize=.02,locations=r)
  print, total(pdf)
  oplot, r, pdf, thick=6, color=176

end
