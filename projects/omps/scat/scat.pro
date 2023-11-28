; Optics tables
  fileDU = 'ExtData/AeroCom/x/optics_DU.v15_3.nc'
  fileSS = 'ExtData/AeroCom/x/optics_SS.v3_3.nc'
  fileSU = 'ExtData/AeroCom/x/optics_SU.v1_3.nc'
  fileBC = 'ExtData/AeroCom/x/optics_BC.v1_3.nc'
  fileOC = 'ExtData/AeroCom/x/optics_OC.v1_3.nc'

; Wavelength
  lambdanm = 675.

; Get tables
  fill_mie_table, fileDU, strDU, lambdanm=lambdanm
  fill_mie_table, fileSS, strSS, lambdanm=lambdanm
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  fill_mie_table, fileBC, strBC, lambdanm=lambdanm
  fill_mie_table, fileOC, strOC, lambdanm=lambdanm

  tables = {strDU:strDU, strSS:strSS, strOC:strOC, strBC:strBC, strSU:strSU}

; Get a model profile
  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst3d_aer_v/Y2007/M06/dR_MERRA-AA-r2.inst3d_aer_v.20070605_1200z.nc4'
  wantlon = -25.
  wantlat = 10.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'du', du, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'ss', ss, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'so4', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'bc', bc, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'oc', oc, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

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
   for ib = 0, 0 do begin
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

; Handle OC
  for iz = 0, nz-1 do begin
   for ib = 0, 1 do begin
    get_mie_table, tables.strOC, table, ib, rh[iz]
    tau_ = oc[iz,ib]*delp[iz]/grav*table.bext
    ssa_ = table.bsca / table.bext
    tau[iz] = tau[iz] + tau_
    ssa[iz] = ssa[iz] + ssa_*tau_
    g[iz]   = g[iz]   + table.g*ssa_*tau_
    for imom = 0, nmom-1 do begin
     pmom[iz,imom] = pmom[iz,imom] + table.pmom[imom]*ssa_*tau_
    endfor
   endfor
  endfor

; Handle BC
  for iz = 0, nz-1 do begin
   for ib = 0, 1 do begin
    get_mie_table, tables.strBC, table, ib, rh[iz]
    tau_ = bc[iz,ib]*delp[iz]/grav*table.bext
    ssa_ = table.bsca / table.bext
    tau[iz] = tau[iz] + tau_
    ssa[iz] = ssa[iz] + ssa_*tau_
    g[iz]   = g[iz]   + table.g*ssa_*tau_
    for imom = 0, nmom-1 do begin
     pmom[iz,imom] = pmom[iz,imom] + table.pmom[imom]*ssa_*tau_
    endfor
   endfor
  endfor

; Handle DU
  for iz = 0, nz-1 do begin
   for ib = 0, 4 do begin
    get_mie_table, tables.strDU, table, ib, rh[iz]
    tau_ = du[iz,ib]*delp[iz]/grav*table.bext
    ssa_ = table.bsca / table.bext
    tau[iz] = tau[iz] + tau_
    ssa[iz] = ssa[iz] + ssa_*tau_
    g[iz]   = g[iz]   + table.g*ssa_*tau_
    for imom = 0, nmom-1 do begin
     pmom[iz,imom] = pmom[iz,imom] + table.pmom[imom]*ssa_*tau_
    endfor
   endfor
  endfor

; Handle SS
  for iz = 0, nz-1 do begin
   for ib = 0, 4 do begin
    get_mie_table, tables.strSS, table, ib, rh[iz]
    tau_ = ss[iz,ib]*delp[iz]/grav*table.bext
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

; And construct the phase function
  angles = dindgen(181)*1.
  mu     = cos(angles*!dpi/180.d)
  p11 = dblarr(181,nz)
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

  set_plot, 'ps'
  device, file='p11.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39
  plot, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='angle', $
        yrange=[0.1,1000], ystyle=9, /ylog, ytitle='P11'
  oplot, p11[*,71], thick=6
  oplot, p11[*,64], thick=6, color=60 ; 1 km
  oplot, p11[*,54], thick=6, color=84 ; 3 km
  oplot, p11[*,49], thick=6, color=176 ; 5 km
  oplot, p11[*,42], thick=6, color=208 ; 10 km
  oplot, p11[*,32], thick=6, color=254 ; 20 km

  xyouts, 15, 100, 'surface'
  xyouts, 40, 100, '1 km', color=60
  xyouts, 60, 100, '3 km', color=84
  xyouts, 80, 100, '5 km', color=176
  xyouts, 100, 100, '10 km', color=208
  xyouts, 120, 100, '20 km', color=254
  
  device, /close
end

