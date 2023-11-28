; Colarco, November 2018
; Plot a simple size distribution from CARMA compared to some balloon
; observations from Deshler's Laramie data

; Bins
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/22.d)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  rcm = rlow*100.
  rum = rlow*1e6


; Get a model profile
  expid = 'c90F_pI33p4_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/2004/'+expid+'.tavg3d_carma_v.monthly.200402.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Same thing but now get in a +/- 10 degree latitude band and zonally
  wantlat = [31.,51.]
  nc4readvar, filename, 'su0', suz, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  suz = total(suz,1)/n_elements(lon)

; Fake up an altitude
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.  ; km

; Find 20 km
  a = where(z gt 19.5 and z lt 20.5)
  rn = fltarr(19)
  rn[0:9] = findgen(10)*.01 + .01
  rn[10:18] = findgen(9)*.1 +.2
  n = fltarr(19)
  for ibin = 0, 18 do begin
;  Find minimum radius where wet r >= rn[ibin]
   for i = 0, nbin-1 do begin
    rwetum = grow_v75(rh[a[0]],rcm[i])*rum[i]
    if(rwetum gt rn[ibin]) then break ; print, i, rwetum, rn[ibin]
   endfor
   n[ibin] = total(su[a[0],i-1:nbin-1] * rhoa[a[0]] / (4./3.*!pi*r[i-1:nbin-1]^3.*rhop)) * 1.e-6
  endfor

  nz0 = fltarr(n_elements(lat),3,19)
  for iy = 0, n_elements(lat)-1 do begin
   for iz = 0,2 do begin
    for ibin = 0, 18 do begin
;    Find minimum radius where wet r >= rn[ibin]
     for i = 0, nbin-1 do begin
      rwetum = grow_v75(rh[a[0]-1+iz],rcm[i])*rum[i]
      if(rwetum gt rn[ibin]) then break ; print, i, rwetum, rn[ibin]
     endfor
     nz0[iy,iz,ibin] = total(suz[iy,a[0]-1+iz,i-1:nbin-1] / (4./3.*!pi*r[i-1:nbin-1]^3.*rhop)) * rhoa[a[0]-1+iz] * 1.e-6
    endfor
   endfor
  endfor
  nz0 = reform(nz0,n_elements(lat)*3,19)
  a0  = where(nz0[*,0] eq min(nz0[*,0]))
  a1  = where(nz0[*,0] eq max(nz0[*,0]))

; plot
  set_plot, 'ps'
  device, file='n_laramie.grow_v75.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[.01,1], yrange=[1.e-4,100], /xlog, /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N [cm!E-3!N]'

  files = file_search("/misc/prc10/LARAMIE_DESHLER/NonVolcanic/Nr_Full_Profile/Average_0.5_km/200004*500m",count=nfiles)
  for ifiles = 0, nfiles-1 do begin
   read_wpc, files[ifiles], alt, pres, temp, pottemp, rh, o3, cn, nl, rl, lat, lon
;print, files[ifiles], r[0]
   a = where(alt eq  20.)
   plots, rl, nl[a,*], psym=4
   plots, .01, cn[a], psym=4
  endfor

  polymaxmin, rn, transpose([nz0[a0,*],nz0[a1,*]]), fillcolor=180, /noave
  oplot, rn, n, thick=6

  device, /close

end
