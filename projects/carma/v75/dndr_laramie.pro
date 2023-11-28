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
  expid = 'c90F_pI33p4_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.199006.nc4'
  expid = 'c90F_pI33p4_volc'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.198406.nc4'
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

; Gin up some number concentrations > than
  n079 = fltarr(nz)
  n161 = fltarr(nz)
  n276 = fltarr(nz)
  n378 = fltarr(nz)
  a = where(2.*r[0:21]*1e9 gt  79.)
  b = where(2.*r[0:21]*1e9 gt 161.)
  c = where(2.*r[0:21]*1e9 gt 276.)
  d = where(2.*r[0:21]*1e9 gt 378.)
  for iz = 0, nz-1 do begin
   n079[iz] = total(dndr[iz,a]*dr[a])*1e-6
   n161[iz] = total(dndr[iz,b]*dr[b])*1e-6
   n276[iz] = total(dndr[iz,c]*dr[c])*1e-6
   n378[iz] = total(dndr[iz,d]*dr[d])*1e-6
  endfor



  n079cor = fltarr(nz)
  n161cor = fltarr(nz)
  n276cor = fltarr(nz)
  n378cor = fltarr(nz)
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
   d = where(2.*r_*1e9 gt 378.)
   n079cor[iz] = total(dndr[iz,a]*dr_[a])*1e-6
   n161cor[iz] = total(dndr[iz,b]*dr_[b])*1e-6
   n276cor[iz] = total(dndr[iz,c]*dr_[c])*1e-6
   n378cor[iz] = total(dndr[iz,d]*dr_[d])*1e-6
  endfor

; plot
  set_plot, 'ps'
  device, file='n_laramie.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, n079, z, /nodata, position=[.2,.1,.9,.9], $
   xrange=[-3,2], yrange=[5,30], $
   xtitle = 'log(cm!E-3!N)', ytitle='Alt [km]'

  files = file_search("/misc/prc10/LARAMIE_DESHLER/NonVolcanic/Nr_Full_Profile/Average_0.5_km/200004*500m",count=nfiles)
  for ifiles = 0, nfiles-1 do begin
   read_wpc, files[ifiles], alt, pres, temp, pottemp, rh, o3, cn, n, r, lat, lon
;print, files[ifiles], r[0]
   oplot, alog10(cn[*,0]), alt
  endfor

  oplot, alog10(n079), z, thick=6, color=254
  oplot, alog10(n161), z, thick=6, color=208
  oplot, alog10(n276), z, thick=6, color=84
  oplot, alog10(n378), z, thick=6, color=0

  oplot, alog10(n079cor), z, thick=6, color=254, lin=2
  oplot, alog10(n161cor), z, thick=6, color=208, lin=2
  oplot, alog10(n276cor), z, thick=6, color=84, lin=2
  oplot, alog10(n378cor), z, thick=6, color=0, lin=2

  xyouts, -2.8, 20, 'd > 79 nm', color=254
  xyouts, -2.8, 18, 'd > 161 nm', color=208
  xyouts, -2.8, 16, 'd > 276 nm', color=84
  xyouts, -2.8, 14, 'd > 378 nm', color=0


  device, /close

end

