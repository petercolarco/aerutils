  cdfid = ncdf_open('phase.parker.19910304.nc')

; mid-layer altitude [m]
  id = ncdf_varid(cdfid,'altitude')
  ncdf_varget, cdfid, id, h

; wavelength [m]
  id = ncdf_varid(cdfid,'lambda')
  ncdf_varget, cdfid, id, lambda

; angles scattering phase function defined at
  id = ncdf_varid(cdfid,'angles')
  ncdf_varget, cdfid, id, angles

; AOD
  id = ncdf_varid(cdfid,'tau')
  ncdf_varget, cdfid, id, tau

; Single scattering albedo
  id = ncdf_varid(cdfid,'ssa')
  ncdf_varget, cdfid, id, ssa

; Phase functions
  id = ncdf_varid(cdfid,'p11')
  ncdf_varget, cdfid, id, p11

  id = ncdf_varid(cdfid,'p12')
  ncdf_varget, cdfid, id, p12

  id = ncdf_varid(cdfid,'p22')
  ncdf_varget, cdfid, id, p22

  id = ncdf_varid(cdfid,'p33')
  ncdf_varget, cdfid, id, p33

  id = ncdf_varid(cdfid,'p34')
  ncdf_varget, cdfid, id, p34

  id = ncdf_varid(cdfid,'p44')
  ncdf_varget, cdfid, id, p44

  ncdf_close, cdfid

; E.g
  set_plot, 'ps'
  device, filename='./phase.parker.19910304.25km.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /color
  !P.font=0

  !p.multi=[0,2,3]


  iz = 33  ; This height is 20 km
  iz = 29  ; This height is 25 km

  loadct, 39
  colors=findgen(8)*30

  plot,angles, p11[0,iz,*], /ylog, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P11', title='P11', $
   xrange=[0,180], xstyle=9, yrange=[1.e-2,1.e3], ystyle=9
  for ilam = 1, 7 do begin
   oplot, angles, p11[ilam,iz,*], color=colors[ilam]
  endfor
  plot,angles, p12[0,iz,*]/p11[0,iz,*], $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P12/P11', title='P12/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot,angles, p22[0,iz,*]/p11[0,iz,*], $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P22/P11', title='P22/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot,angles, p33[0,iz,*]/p11[0,iz,*], $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P33/P11', title='P33/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot,angles, p34[0,iz,*]/p11[0,iz,*], $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P34/P11', title='P34/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot,angles, p44[0,iz,*]/p11[0,iz,*], $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P44/P11', title='P44/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9


  device, /close

end

