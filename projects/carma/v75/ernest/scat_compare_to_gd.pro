; See also aerutils/projects/omps/scat/scat.pro

; Using here also the Gamma Distribution from Zhong Chen's 2018 AMT paper

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v6.nbin=24.nc'

; Wavelength
  lambdanm = 675.

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm

  tables = {strSU:strSU}

; Get a model profile
  expid = 'c90F_pI33p7_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

  nz = n_elements(rh)
  nmom = 301

  tau  = fltarr(nz)
  ssa  = fltarr(nz)
  g    = fltarr(nz)
  pmom = fltarr(nz,nmom)

; Get the layer altitude
  filename2 = '/misc/prc18/colarco/'+expid+'/'+expid+'.geosgcm_diag.monthly.200402.nc4'
  nc4readvar, filename2, 'zl', z, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename2, 't', t, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  z = z/1000.
  zl = where(z gt 19.5 and z lt 20.5)

; Handle sulfate
  grav = 9.81
  for iz = 0, nz-1 do begin
   for ib = 0, 23 do begin
    get_mie_table, tables.strSU, table, ib, rh[iz]
    tau_ = su[iz,ib]*delp[iz]/grav*table.bext
    ssa_ = table.bsca / table.bext
    tau[iz] = tau[iz] + tau_
    ssa[iz] = ssa[iz] + ssa_*tau_
    g[iz]   = g[iz]   + table.g*ssa_*tau_
    for imom = 0, nmom-1 do begin
     pmom[iz,imom] = pmom[iz,imom] + table.pmom[imom]*ssa_*tau_
    endfor
   endfor
  endfor

; Normalize
  ssa  = ssa / tau
  g    = g / (ssa*tau)
  for imom = 0, nmom-1 do begin
   pmom[*,imom] = pmom[*,imom] / (ssa*tau)
  endfor

; Do an example for the GD from Zhong Chen's 2018 paper
; see parameters on figure 1 of paper
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
  pmomomps = fltarr(nmom)
  tauomps = 0.
  ssaomps = 0.
  gomps   = 0.
  for ib = 0, 21 do begin
   get_mie_table, tables.strSU, table, ib, 0.
   tau_ = dvdr[ib]*dr[ib]*table.bext
   ssa_ = table.bsca / table.bext
   tauomps = tauomps + tau_
   ssaomps = ssaomps + ssa_*tau_
   gomps   = gomps   + table.g*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmomomps[imom] = pmomomps[imom] + table.pmom[imom]*ssa_*tau_
   endfor
  endfor

; Normalize
  ssaomps  = ssaomps / tauomps
  gomps    = gomps / (ssaomps*tauomps)
  for imom = 0, nmom-1 do begin
   pmomomps[imom] = pmomomps[imom] / (ssaomps*tauomps)
  endfor



; And construct the phase function
  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11     = dblarr(nangles,nz)
  p11omps = dblarr(nangles)
  nmom = nmom-1
  for iz = zl[0], zl[0] do begin
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
        endfor
     endfor
  endfor
  for iang = 0, nangles-1 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for imom = 0, nmom do begin
         p11omps[iang] = p11omps[iang] + pmomomps[imom]*leg[imom]
        endfor
  endfor

  set_plot, 'ps'
  device, file='p11.laramie.compare_to_gd.'+expid+'.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
  plot, angles, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='angle', $
        yrange=[0.02,200], ystyle=9, /ylog, ytitle='P11'
;  oplot, p11[*,50], thick=6 ; 5 km
;  oplot, p11[*,43], thick=6, color=60 ; 10 km
;  oplot, p11[*,38], thick=6, color=84 ; 15 km
  oplot, angles, p11[*,33], thick=6, color=0 ; 20 km
;  oplot, p11[*,29], thick=6, color=208 ; 25 km
;  oplot, p11[*,25], thick=6, color=254 ; 30 km

;  xyouts, 20, 100, '5 km'
;  xyouts, 40, 100, '10 km', color=60
;  xyouts, 60, 100, '15 km', color=84
  xyouts, 5, 100, 'CARMA PSD @20 km', color=0
;  xyouts, 100, 100, '25 km', color=208
;  xyouts, 120, 100, '30 km', color=254

  loadct, 0
  oplot, angles, p11omps, thick=8, color=160   ; omps
  xyouts, 75, 100, 'Gamma Distribution (Chen et al. 2018)', color=160
  
  device, /close



  set_plot, 'ps'
  device, file='p11.laramie.compare_to_gd.'+expid+'.divide4pi.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
; this is normalized so that for large number of angles
; total(p11*fac*dmu)*2*pi = 1
  fac = 1./(4.*!pi)
  plot, angles, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='angle', $
        yrange=[0.01,1], ystyle=9, /ylog, ytitle='P11'
;  oplot, p11[*,50]*fac, thick=6 ; 5 km
;  oplot, p11[*,43]*fac, thick=6, color=60 ; 10 km
;  oplot, p11[*,38]*fac, thick=6, color=84 ; 15 km
  oplot, angles, p11[*,33]*fac, thick=6, color=0 ; 20 km
;  oplot, p11[*,29]*fac, thick=6, color=208 ; 25 km
;  oplot, p11[*,25]*fac, thick=6, color=254 ; 30 km

;  xyouts, 20, 100, '5 km'
;  xyouts, 40, 100, '10 km', color=60
;  xyouts, 60, 100, '15 km', color=84
  xyouts, 5, 1, 'CARMA PSD @ 20 km', color=0
;  xyouts, 100, 100, '25 km', color=208
;  xyouts, 120, 100, '30 km', color=254

  loadct, 0
  oplot, angles, p11omps*fac, thick=8, color=160   ; omps
  xyouts, 75, 1, 'Gamma Distribution (Chen et al. 2018)', color=160
  
  device, /close

; Write the phase function to a file
  openw, lun, 'p11.laramie.compare_to_gd.'+expid+'.divide4pi.txt', /get
  printf, lun, 'Angle      CARMA       Gamma'
  for iang = 0, nangles-1 do begin
   printf, lun, angles[iang], p11[iang,33]*fac, p11omps[iang]*fac, $
           format='(f5.1,5x,f9.6,2x,f9.6)'
  endfor
  free_lun, lun

end

