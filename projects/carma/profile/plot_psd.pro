; See also aerutils/projects/omps/scat/scat.pro

; Get an atmosphere
;  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Bins
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow


; Get a model profile
  expid = 'c90Fc_I10pa3_anth'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Fake up an altitude
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.  ; km

; Convert to dndr - units will be # m-3 m-1
  dndr = su
  for iz = 0, 71 do begin
   for ibin = 0, 21 do begin
    dndr[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
   endfor
  endfor

; Another -- v56 spinup
  filename = 'c48F_pI33_carma_su_spin1975_2.tavg3d_carma_v.monthly.199406.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  dndr_spinI33 = su
  for iz = 0, 71 do begin
   for ibin = 0, 23 do begin
    dndr_spinI33[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
   endfor
  endfor

; Another -- v75 spinup
  filename = 'c48F_pI33p2_spinup.tavg3d_carma_v.monthly.199406.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  dndr_spinI33p2 = su
  for iz = 0, 71 do begin
   for ibin = 0, 23 do begin
    dndr_spinI33p2[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
   endfor
  endfor


; plot
  set_plot, 'ps'
  device, file='plot_psd.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  iz = 35  ; 17 km
;  iz = 32  ; 20 km
;  iz = 42  ; 10 km
  plot, r*1e6, dndr[iz,*]*r, /nodata, position=[.2,.1,.9,.9], $
   xrange=[.0001,1], /xlog, $
;   yrange=[1e-3,1e6], /ylog, $
   yrange=[0,1e2], $
   xtitle = 'radius [!Mm!Nm]', ytitle='dNdlogr [cm!E-3!N]'

  oplot, r*1e6, dndr[iz,*]*r*1e-6, thick=6
  oplot, r*1e6, dndr_spinI33[iz,*]*r*1e-6, thick=6, color=254
  oplot, r*1e6, dndr_spinI33p2[iz,*]*r*1e-6, thick=6, color=84

  device, /close

end

