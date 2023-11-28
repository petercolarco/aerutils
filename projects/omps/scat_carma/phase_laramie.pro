; See also aerutils/projects/omps/scat/scat.pro

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v5.nbin=22.nc'

; Wavelength
  lambdanm = 675.

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm

  tables = {strSU:strSU}

; Get a model profile
  filename = '/misc/prc18/colarco/c90Fc_H54p3_ctrl/tavg3d_carma_v/c90Fc_H54p3_ctrl.tavg3d_carma_v.monthly.clim.JJA.nc4'
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

  grav = 9.81

; Fake up an altitude
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.   ; km

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

; Write to a text file
  openw, lun, 'phase_laramie.txt', /get
  printf, lun, 'angle', angles, format='(a10,1x,181(1e12.5,2x))'
  for iz = 0, nz-1 do begin
  alt = string(z[iz],format='(f5.2)')+' km'
  printf, lun, alt, p11[*,iz], format='(a10,1x,181(1e12.5,2x))'
  print, iz, ' ', alt
  endfor
  free_lun, lun

; Open and plot
  openr, lun, 'phase_laramie.txt', /get
  data = strarr(73)
  readf, lun, data
  free_lun, lun
  ang = float(strsplit(strmid(data[0],11),/extract))
  p11 = fltarr(n_elements(ang),72)
  alt = fltarr(72)
  for iz = 0, 71 do begin
   alt_ = strsplit(strmid(data[iz+1],0,10),/extract)
   alt[iz] = float(alt_[0])
   p11[*,iz] = float(strsplit(strmid(data[iz+1],11),/extract))
  endfor

end

