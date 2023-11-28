  expid = '.parker.19910615'

  cdfid = ncdf_open('phase'+expid+'.nc')

; mid-layer altitude [m]
  id = ncdf_varid(cdfid,'altitude')
  ncdf_varget, cdfid, id, h

; wavelength [m]
  id = ncdf_varid(cdfid,'lambda')
  ncdf_varget, cdfid, id, lambda

; angles scattering phase function defined at
  id = ncdf_varid(cdfid,'angles')
  ncdf_varget, cdfid, id, angles

; Phase functions
  id = ncdf_varid(cdfid,'p11')
  ncdf_varget, cdfid, id, p11

  ncdf_close, cdfid





; Get the baseline
  cdfid = ncdf_open('phase.c90F_pI33p9_sulf.nc')

; mid-layer altitude [m]
  id = ncdf_varid(cdfid,'altitude')
  ncdf_varget, cdfid, id, h_

; wavelength [m]
  id = ncdf_varid(cdfid,'lambda')
  ncdf_varget, cdfid, id, lambda_

; angles scattering phase function defined at
  id = ncdf_varid(cdfid,'angles')
  ncdf_varget, cdfid, id, angles_

; Phase functions
  id = ncdf_varid(cdfid,'p11')
  ncdf_varget, cdfid, id, p11_

  ncdf_close, cdfid
  


; E.g
  set_plot, 'ps'
  device, filename='./compare_phase'+expid+'.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=12, /color
  !P.font=0
  !p.multi=[0,2,1]

  iz0 = 33  ; This height is 20 km
  iz1 = 29  ; This height is 25 km

  loadct, 39

  plot,angles, p11[0,iz0,*], /ylog, /nodata, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P11', title='20 km', $
   xrange=[0,180], xstyle=9, yrange=[1.e-1,20], ystyle=9
  oplot, angles, p11[2,iz0,*], color=176, thick=8
  oplot, angles, p11[4,iz0,*], color=208, thick=8
  oplot, angles, p11[6,iz0,*], color=254, thick=8
  oplot, angles, p11_[2,iz0,*], color=176, thick=8, lin=2
  oplot, angles, p11_[4,iz0,*], color=208, thick=8, lin=2
  oplot, angles, p11_[6,iz0,*], color=254, thick=8, lin=2

  plot,angles, p11[0,iz1,*], /ylog, /nodata, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P11', title='25 km', $
   xrange=[0,180], xstyle=9, yrange=[1.e-1,20], ystyle=9
  oplot, angles, p11[2,iz1,*], color=176, thick=8
  oplot, angles, p11[4,iz1,*], color=208, thick=8
  oplot, angles, p11[6,iz1,*], color=254, thick=8
  oplot, angles, p11_[2,iz1,*], color=176, thick=8, lin=2
  oplot, angles, p11_[4,iz1,*], color=208, thick=8, lin=2
  oplot, angles, p11_[6,iz1,*], color=254, thick=8, lin=2

  device, /close

end

