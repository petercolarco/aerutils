  set_plot, 'ps'
  device, file='test.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
; this is normalized so that for large number of angles
; total(p11*fac*dmu)*2*pi = 1
  fac = 1./(4.*!pi)
  plot, findgen(10), /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='Scattering Angle', xticks=6, xminor=3, $
        yrange=[0.1,1000], ystyle=9, /ylog, ytitle='Phase Function', ytickv=[.1,1,10,100,1000]
;        yrange=[0.005,50], ystyle=9, /ylog, ytitle='Phase Function', ytickv=[.005,.01,.1,1,5,50]


  filename = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-bc_wide-raw.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ang')
  ncdf_varget, cdfid, id, ang
  id = ncdf_varid(cdfid,'s11')
  ncdf_varget, cdfid, id, s11
  ncdf_close, cdfid
  s11 = s11[*,6,0,0]
  nang = n_elements(ang)
  mu = cos(ang*2.*!dpi/360.)
  dmu = mu[0:nang-2]-mu[1:nang-1]
  dmu = [dmu,dmu[nang-2]]
; normalize
  fac = 4.*!dpi/total(s11*dmu)
  s11 = s11*fac
  oplot, ang, s11, thick=6

  filename = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-oc_wide-raw.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ang')
  ncdf_varget, cdfid, id, ang
  id = ncdf_varid(cdfid,'s11')
  ncdf_varget, cdfid, id, s11
  ncdf_close, cdfid
  s11 = s11[*,6,0,0]
; normalize
  fac = 4.*!dpi/total(s11*dmu)
  s11 = s11*fac
  oplot, ang, s11, thick=6, color=176

  filename = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-mix_wide-raw.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ang')
  ncdf_varget, cdfid, id, ang
  id = ncdf_varid(cdfid,'s11')
  ncdf_varget, cdfid, id, s11
  ncdf_close, cdfid
  s11 = s11[*,6,0,0]
; normalize
  fac = 4.*!dpi/total(s11*dmu)
  s11 = s11*fac
  oplot, ang, s11, thick=6, color=254

device, /close

end
