; See also aerutils/projects/omps/scat/scat.pro

; Get a model profile
  expid = 'c90Fc_I10pa3_anth'
  filename = '/home/colarco/'+expid+'.tavg3d_carma_v.monthly.199007.nc4'
;  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
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


; Bins
  rhop = 1700.
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow

; Assumption is dry particle density of 1700 kg m-3
; Convert to dn - units will be # cm-3
  dn = su
  for iz = 0, 71 do begin
   for ibin = 0, 21 do begin
    dn[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / 1.e6
   endfor
  endfor


  loadct, 39
  plot, indgen(10), /nodata, $
   yrange=[5,30], ytitle='altitude [km]', $
   xrange=[-6,2], xtitle='N [log cm!E-3!N]'

  r = r*1e6  ; um
  rlow = rlow*1e6

  a = where(r ge 0.12)
  n = total(dn[*,a],2)
  oplot, alog10(n), z, thick=6, color=84

  a = where(r ge 0.28)
  n = total(dn[*,a],2)
  oplot, alog10(n), z, thick=6, color=254

  a = where(r ge 0.51)
  n = total(dn[*,a],2)
  oplot, alog10(n), z, thick=6, color=208

; rlow
  a = where(rlow ge 0.12)
  n = total(dn[*,a],2)
  oplot, alog10(n), z, thick=6, color=84, lin=2

  a = where(rlow ge 0.28)
  n = total(dn[*,a],2)
  oplot, alog10(n), z, thick=6, color=254, lin=2

  a = where(rlow ge 0.51)
  n = total(dn[*,a],2)
  oplot, alog10(n), z, thick=12, color=208, lin=2

end

