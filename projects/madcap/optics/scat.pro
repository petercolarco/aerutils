; See also aerutils/projects/omps/scat/scat.pro

; Using here also the Gamma Distribution from Zhong Chen's 2018 AMT paper

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/optics_SU.v1_5.nc'
  fileDU = '/share/colarco/fvInput/AeroCom/x/optics_DU.v15_5.nc'
  fileSS = '/share/colarco/fvInput/AeroCom/x/optics_SS.v3_5.nc'
  fileBC = '/share/colarco/fvInput/AeroCom/x/optics_BC.v1_5.nc'
  fileOC = '/share/colarco/fvInput/AeroCom/x/optics_OC.v1_5.nc'
  fileNI = '/share/colarco/fvInput/AeroCom/x/optics_NI.v2_5.nc'

; Wavelength
  lambdanm = 550.

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  fill_mie_table, fileDU, strDU, lambdanm=lambdanm
  fill_mie_table, fileSS, strSS, lambdanm=lambdanm
  fill_mie_table, fileBC, strBC, lambdanm=lambdanm
  fill_mie_table, fileOC, strOC, lambdanm=lambdanm
  fill_mie_table, fileNI, strNI, lambdanm=lambdanm

  tables = {strSU:strSU, strDU:strDU, strSS:strSS, strBC:strBC, strOC:strOC, strNI:strNI}

; Make up a fake atmosphere
  rh = 0.
  delp = 1000.
  bc = [1.e-6,0]
  const = {constBC:bc}
  get_profile_properties, rh, delp, tables, const, ssabc, taubc, gbc, pmombc
  oc = [6.e-6,0]
  const = {constOC:oc}
  get_profile_properties, rh, delp, tables, const, ssaoc, tauoc, goc, pmomoc
  const = {constOC:oc, constBC:bc}
  get_profile_properties, rh, delp, tables, const, ssa, tau, g, pmom

  nmom = 301

; And construct the phase function
  nangles = 181
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11     = dblarr(nangles)
  p11bc   = dblarr(nangles)
  p11oc   = dblarr(nangles)
  nmom = nmom-1
     for iang = 0, nangles-1 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for imom = 0, nmom do begin
         p11[iang] = p11[iang] + pmom[imom]*leg[imom]
         p11bc[iang] = p11bc[iang] + pmombc[imom]*leg[imom]
         p11oc[iang] = p11oc[iang] + pmomoc[imom]*leg[imom]
        endfor
     endfor

  set_plot, 'ps'
  device, file='scat.divide4pi.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
; this is normalized so that for large number of angles
; total(p11*fac*dmu)*2*pi = 1
  fac = 1./(4.*!pi)
  plot, angles, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='Scattering Angle', xticks=6, xminor=3, $
        yrange=[0.01,1], ystyle=9, /ylog, ytitle='Phase Function', ytickv=[.01,.1,1]

;  oplot, angles, p11*fac, thick=6, color=254
;  oplot, angles, p11bc*fac, thick=6, color=0
;  oplot, angles, p11oc*fac, thick=6, color=208



  filename = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-bc_wide-raw.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ang')
  ncdf_varget, cdfid, id, ang
  id = ncdf_varid(cdfid,'s11')
  ncdf_varget, cdfid, id, s11
  ncdf_close, cdfid
  s11 = s11[*,6,0,0]
  s11bc = s11   ; unnormalized
  nang = n_elements(ang)
  mu = cos(ang*2.*!dpi/360.)
  dmu = mu[0:nang-2]-mu[1:nang-1]
  dmu = [dmu,dmu[nang-2]]
  fac = 1./total(s11*dmu)/(2.*!dpi)
  s11 = s11*fac
  oplot, ang, s11, lin=0, thick=8

  filename = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-oc_wide-raw.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ang')
  ncdf_varget, cdfid, id, ang
  id = ncdf_varid(cdfid,'s11')
  ncdf_varget, cdfid, id, s11
  ncdf_close, cdfid
  s11 = s11[*,6,0,0]
  s11oc = s11     ; unnormalized
  nang = n_elements(ang)
  mu = cos(ang*2.*!dpi/360.)
  dmu = mu[0:nang-2]-mu[1:nang-1]
  dmu = [dmu,dmu[nang-2]]
  fac = 1./total(s11*dmu)/(2.*!dpi)
  s11 = s11*fac
  oplot, ang, s11, lin=0, color=208, thick=8

  filename = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-mix_wide-raw.nc'
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
  fac = 1./total(s11*dmu)/(2.*!dpi)
  s11 = s11*fac
  oplot, ang, s11, lin=0, color=254, thick=8



  device, /close

end

