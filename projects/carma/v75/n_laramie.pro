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


; Get a model profile
  expid = 'c90F_pI33p4_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/2004/'+expid+'.tavg3d_carma_v.monthly.200402.nc4'
;  expid = 'c90F_pI33p4_volc'
;  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.198406.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Get the layer altitude
  filename2 = '/misc/prc18/colarco/'+expid+'/'+expid+'.geosgcm_diag.monthly.200402.nc4'
  nc4readvar, filename2, 'zl', z, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename2, 't', t, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  z = z/1000.

; Same thing but now get in a +/- 10 degree latitude band and zonally
  wantlat = [31.,51.]
  nc4readvar, filename, 'su0', suz, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  suz = total(suz,1)/n_elements(lon)

; Find 20 km
  a = where(z gt 19.5 and z lt 20.5)
  n = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   n[ibin] = total(su[a[0],ibin:nbin-1] / rmass[ibin:nbin-1]) * rhoa[a[0]] * 1.e-6
  endfor

  nz0 = fltarr(n_elements(lat),3,nbin)
  for iy = 0, n_elements(lat)-1 do begin
   for iz = 0,2 do begin
    for ibin = 0, nbin-1 do begin
     nz0[iy,iz,ibin] = total(suz[iy,a[0]-1+iz,ibin:nbin-1] / rmass[ibin:nbin-1]) * rhoa[a[0]-1+iz] * 1.e-6
    endfor
   endfor
  endfor
  nz0 = reform(nz0,n_elements(lat)*3,nbin)
  a0  = where(nz0[*,0] eq min(nz0[*,0]))
  a1  = where(nz0[*,0] eq max(nz0[*,0]))

; plot
  set_plot, 'ps'
  device, file='n_laramie.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[.01,1], yrange=[1.e-4,100], /xlog, /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N [cm!E-3!N]'

  polymaxmin, r*1e6, transpose([nz0[a0,*],nz0[a1,*]]), fillcolor=180, /noave
  oplot, r*1e6, n, thick=6
  plots, r*1e6, n, psym=sym(1), noclip=0

  files = file_search("/misc/prc10/LARAMIE_DESHLER/NonVolcanic/Nr_Full_Profile/Average_0.5_km/*500m",count=nfiles)
  for ifiles = 0, nfiles-1 do begin
   read_wpc, files[ifiles], alt, pres, temp, pottemp, rh, o3, cn, nl, rl, lat, lon
;print, files[ifiles], r[0]
   a = where(alt eq  20.)
   plots, rl, nl[a,*], psym=sym(13), symsize=.5, noclip=0
   plots, .01, cn[a], psym=sym(13), symsize=.5, noclip=0
  endfor


  device, /close

end
