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
  lambdanm = 675.

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  fill_mie_table, fileDU, strDU, lambdanm=lambdanm
  fill_mie_table, fileSS, strSS, lambdanm=lambdanm
  fill_mie_table, fileBC, strBC, lambdanm=lambdanm
  fill_mie_table, fileOC, strOC, lambdanm=lambdanm
  fill_mie_table, fileNI, strNI, lambdanm=lambdanm

  tables = {strSU:strSU, strDU:strDU, strSS:strSS, strBC:strBC, strOC:strOC, strNI:strNI}

; Get a model profile and set up an altitude grid
; Low volcanic perturbation
  expid = 'MERRA2_GMI'
  filename = '/misc/prc13/MERRA2_GMI/c180/MERRA2_GMI.inst3_3d_aer_Nv.monthly.200008.nc4'
  wantlon = 10.
  wantlat = 10.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor

; Get the model species
  nc4readvar, filename, ['so4','so4v'], su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'BCP', bc, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'OCP', oc, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'DU0', du, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'SS0', ss, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'NO3an', ni, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  const = {constSU:su, constDU:du, constBC:bc, constOC:oc, constNI:ni, constSS:ss}

; Compute the vertical optical properties
  nmom = 301
  tau  = fltarr(nz)
  ssa  = fltarr(nz)
  g    = fltarr(nz)
  pmom = fltarr(nz,nmom)

; Get the aerosol properties
; --------------------------
  get_profile_properties, rh, delp, tables, const, ssa, tau, g, pmom
  susav = su


; Background
; ----------
  filename = '/misc/prc18/colarco/c90F_pI33p4_ocs/tavg3d_aer_v/c90F_pI33p4_ocs.tavg3d_aer_v.monthly.clim.ANN.nc4'
  wantlon = 10.
  wantlat = 10.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat

; Get the model species
  nc4readvar, filename, 'so4', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  const = {constSU:su}

; Compute the vertical optical properties
  nmom = 301
  taumod  = fltarr(nz)
  ssamod  = fltarr(nz)
  gmod    = fltarr(nz)
  pmommod = fltarr(nz,nmom)

; Get the aerosol properties
; --------------------------
  get_profile_properties, rh, delp, tables, const, ssamod, taumod, gmod, pmommod


; Now combine...
; --------------
  susav[*,0] = susav[*,0]+su
  const = {constSU:susav, constDU:du, constBC:bc, constOC:oc, constNI:ni, constSS:ss}
  nmom = 301
  taucom  = fltarr(nz)
  ssacom  = fltarr(nz)
  gcom    = fltarr(nz)
  pmomcom = fltarr(nz,nmom)
  get_profile_properties, rh, delp, tables, const, ssacom, taucom, gcom, pmomcom



; Create an example from the Gamma Distribution Zhong Chen had in his
; 2018 paper
; Use CARMA optics table to construct for Zhong's phase function
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v1.nbin=22.nc'
  lambdanm = 675.
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  tablesOMPS = {strSU:strSU}

  alpha = 2.8
  beta  = 20.5
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
; Put rmin in microns
  rmin = rmin * 1e6
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow
  dndr = 1.*beta^alpha*r^(alpha-1)*exp(-r*beta) / gamma(alpha) / dr
  dvdr = 4./3.*!dpi*r^3*dndr
  constSU = make_array(nz,nbin,val=0.)
  for iz = 0, nz-1 do begin
   constSU[iz,*] = dvdr*dr
  endfor
  constOMPS = {constSU:constSU}
  get_profile_properties, rh, delp, tablesOMPS, constOMPS, ssaomps, tauomps, gomps, pmomomps



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
  p11     = dblarr(nangles,nz)
  p11com  = dblarr(nangles,nz)
  p11mod  = dblarr(nangles,nz)
  p11omps = dblarr(nangles,nz)
  nmom = nmom-1
  for iz = 0, nz-1 do begin
     for iang = 0, nangles-1 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for imom = 0, nmom do begin
         p11[iang,iz] = p11[iang,iz] + pmom[iz,imom]*leg[imom]
         p11com[iang,iz] = p11com[iang,iz] + pmomcom[iz,imom]*leg[imom]
         p11mod[iang,iz] = p11mod[iang,iz] + pmommod[iz,imom]*leg[imom]
         p11omps[iang,iz] = p11omps[iang,iz] + pmomomps[iz,imom]*leg[imom]
        endfor
     endfor
  endfor

  set_plot, 'ps'
  device, file='scat_baseline.'+expid+'.20km.divide4pi.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
; this is normalized so that for large number of angles
; total(p11*fac*dmu)*2*pi = 1
  fac = 1./(4.*!pi)
  plot, angles, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='Scattering Angle', xticks=6, xminor=3, $
        yrange=[0.005,5], ystyle=9, /ylog, ytitle='Phase Function', ytickv=[.005,.01,.1,1,5]

; 20 km
  oplot, angles, p11mod[*,33]*fac, thick=6, color=74
  oplot, angles, p11[*,33]*fac, thick=6, color=208
  oplot, angles, p11com[*,33]*fac, thick=6, color=254

  loadct, 0
  oplot, angles, p11omps[*,33]*fac, thick=10, color=0   ; omps
  
  device, /close




  set_plot, 'ps'
  device, file='scat_baseline.'+expid+'.15km.divide4pi.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
; this is normalized so that for large number of angles
; total(p11*fac*dmu)*2*pi = 1
  fac = 1./(4.*!pi)
  plot, angles, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='Scattering Angle', xticks=6, xminor=3, $
        yrange=[0.005,5], ystyle=9, /ylog, ytitle='Phase Function', ytickv=[.005,.01,.1,1,5]

; 15 km
  oplot, angles, p11mod[*,38]*fac, thick=6, color=74
  oplot, angles, p11[*,38]*fac, thick=6, color=208
  oplot, angles, p11com[*,38]*fac, thick=6, color=254

  loadct, 0
  oplot, angles, p11omps[*,33]*fac, thick=10, color=0   ; omps
  
  device, /close

end

