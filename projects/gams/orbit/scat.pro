; See also aerutils/projects/omps/scat/scat.pro

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v1.nbin=22.nc'

; Wavelength
  lambdanm = 675.

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm

  tables = {strSU:strSU}

; Get a model profile
  filename = '/misc/prc18/colarco/c90Fc_H54p3_ctrl/tavg3d_carma_v/c90Fc_H54p3_ctrl.tavg3d_carma_v.monthly.199106.nc4'
  wantlon = -25.
;  wantlon = 145.
  wantlat = 10.
;  wantlat = 60.
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

  grav = 9.81

; Fake up an altitude
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor

; Handle sulfate
  for iz = 0, nz-1 do begin
   for ib = 0, 21 do begin
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

; Do another example for OMPS bimodal PSD
  rmod = [0.09,0.32]*1e-6
  sigm = [1.4,1.6]
  frac = [0.997,0.003]
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow
  lognormal, rmod, sigm, frac, r, dr, dndr, dsdr, dvdr
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

; Do another example for Ernest's bimodal PSD
  rmod = [0.05,0.2]*1e-6
  sigm = [1.44,1.15]
  frac = [0.9606,0.0394]
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow
  lognormal, rmod, sigm, frac, r, dr, dndr, dsdr, dvdr
  pmomerns = fltarr(nmom)
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
    pmomerns[imom] = pmomerns[imom] + table.pmom[imom]*ssa_*tau_
   endfor
  endfor

; Normalize
  ssaomps  = ssaomps / tauomps
  gomps    = gomps / (ssaomps*tauomps)
  for imom = 0, nmom-1 do begin
   pmomerns[imom] = pmomerns[imom] / (ssaomps*tauomps)
  endfor

; And construct the phase function
  angles = dindgen(181)*1.
  mu     = cos(angles*!dpi/180.d)
  p11 = dblarr(181,nz)
  p11omps = dblarr(181)
  p11erns = dblarr(181)
  nmom = nmom-1
  for iz = 0, nz-1 do begin
     for iang = 0, 180 do begin
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
  for iang = 0, 180 do begin
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
  for iang = 0, 180 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for imom = 0, nmom do begin
         p11erns[iang] = p11erns[iang] + pmomerns[imom]*leg[imom]
        endfor
  endfor

  set_plot, 'ps'
  device, file='p11.background.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
  plot, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='angle', $
        yrange=[0.02,200], ystyle=9, /ylog, ytitle='P11'
  oplot, p11[*,50], thick=6 ; 5 km
  oplot, p11[*,43], thick=6, color=60 ; 10 km
  oplot, p11[*,38], thick=6, color=84 ; 15 km
  oplot, p11[*,33], thick=6, color=176 ; 20 km
  oplot, p11[*,29], thick=6, color=208 ; 25 km
  oplot, p11[*,25], thick=6, color=254 ; 30 km

  xyouts, 20, 100, '5 km'
  xyouts, 40, 100, '10 km', color=60
  xyouts, 60, 100, '15 km', color=84
  xyouts, 80, 100, '20 km', color=176
  xyouts, 100, 100, '25 km', color=208
  xyouts, 120, 100, '30 km', color=254

  loadct, 0
  oplot, p11omps, thick=8, color=160   ; omps
  xyouts, 140, 100, 'OMPS (solid)', color=160
  oplot, p11erns, thick=8, color=160, lin=2   ; omps
  xyouts, 140, 60, 'Ernest (dashed)', color=160
  
  device, /close
end

