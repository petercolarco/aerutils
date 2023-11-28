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

; Assumption is dry particle density of 1700 kg m-3
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


; Gin up some number concentrations > than
  n079 = fltarr(nz)
  n161 = fltarr(nz)
  n276 = fltarr(nz)
  a = where(2.*r[0:21]*1e9 gt  79.)
  b = where(2.*r[0:21]*1e9 gt 161.)
  c = where(2.*r[0:21]*1e9 gt 276.)
  for iz = 0, nz-1 do begin
   n079[iz] = total(dndr[iz,a]*dr[a])*1e-6
   n161[iz] = total(dndr[iz,b]*dr[b])*1e-6
   n276[iz] = total(dndr[iz,c]*dr[c])*1e-6
  endfor

  n079I33 = fltarr(nz)
  n161I33 = fltarr(nz)
  n276I33 = fltarr(nz)
  a = where(2.*r*1e9 gt  79.)
  b = where(2.*r*1e9 gt 161.)
  c = where(2.*r*1e9 gt 276.)
  for iz = 0, nz-1 do begin
   n079I33[iz] = total(dndr_spinI33[iz,a]*dr[a])*1e-6
   n161I33[iz] = total(dndr_spinI33[iz,b]*dr[b])*1e-6
   n276I33[iz] = total(dndr_spinI33[iz,c]*dr[c])*1e-6
  endfor

  n079I33p2 = fltarr(nz)
  n161I33p2 = fltarr(nz)
  n276I33p2 = fltarr(nz)
  a = where(2.*r*1e9 gt  79.)
  b = where(2.*r*1e9 gt 161.)
  c = where(2.*r*1e9 gt 276.)
  for iz = 0, nz-1 do begin
   n079I33p2[iz] = total(dndr_spinI33p2[iz,a]*dr[a])*1e-6
   n161I33p2[iz] = total(dndr_spinI33p2[iz,b]*dr[b])*1e-6
   n276I33p2[iz] = total(dndr_spinI33p2[iz,c]*dr[c])*1e-6
  endfor

  n079I33p2cor = fltarr(nz)
  n161I33p2cor = fltarr(nz)
  n276I33p2cor = fltarr(nz)
  for iz = 0, nz-1 do begin
   r_  = fltarr(nbin)
   dr_ = fltarr(nbin)
   for ibin = 0, nbin-1 do begin
    r_[ibin]  = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    dr_[ibin] = grow_v75(rh[iz],r[ibin]*100.d)*dr[ibin]
   endfor
   a = where(2.*r_*1e9 gt  79.)
   b = where(2.*r_*1e9 gt 161.)
   c = where(2.*r_*1e9 gt 276.)
   n079I33p2cor[iz] = total(dndr_spinI33p2[iz,a]*dr_[a])*1e-6
   n161I33p2cor[iz] = total(dndr_spinI33p2[iz,b]*dr_[b])*1e-6
   n276I33p2cor[iz] = total(dndr_spinI33p2[iz,c]*dr_[c])*1e-6
  endfor

; plot
  set_plot, 'ps'
  device, file='n_laramie.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, n079, z, /nodata, position=[.2,.1,.9,.9], $
   xrange=[-3,2], yrange=[5,30], $
   xtitle = 'log(cm!E-3!N)', ytitle='Alt [km]'
;  oplot, alog10(n079), z, thick=6, color=254
;  oplot, alog10(n161), z, thick=6, color=208
;  oplot, alog10(n276), z, thick=6, color=84

  oplot, alog10(n079I33), z, thick=6, color=254, lin=0
  oplot, alog10(n161I33), z, thick=6, color=208, lin=0
  oplot, alog10(n276I33), z, thick=6, color=84, lin=0

  oplot, alog10(n079I33p2), z, thick=6, color=254, lin=1
  oplot, alog10(n161I33p2), z, thick=6, color=208, lin=1
  oplot, alog10(n276I33p2), z, thick=6, color=84, lin=1

  xyouts, -2.8, 20, 'd > 79 nm', color=254
  xyouts, -2.8, 18, 'd > 161 nm', color=208
  xyouts, -2.8, 16, 'd > 276 nm', color=84


  device, /close


; plot
  set_plot, 'ps'
  device, file='n_laramie.corrected.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, n079, z, /nodata, position=[.2,.1,.9,.9], $
   xrange=[-3,2], yrange=[5,30], $
   xtitle = 'log(cm!E-3!N)', ytitle='Alt [km]'
;  oplot, alog10(n079), z, thick=6, color=254
;  oplot, alog10(n161), z, thick=6, color=208
;  oplot, alog10(n276), z, thick=6, color=84

  oplot, alog10(n079I33p2cor), z, thick=6, color=254, lin=0
  oplot, alog10(n161I33p2cor), z, thick=6, color=208, lin=0
  oplot, alog10(n276I33p2cor), z, thick=6, color=84, lin=0

  oplot, alog10(n079I33p2), z, thick=6, color=254, lin=1
  oplot, alog10(n161I33p2), z, thick=6, color=208, lin=1
  oplot, alog10(n276I33p2), z, thick=6, color=84, lin=1


  device, /close

end

