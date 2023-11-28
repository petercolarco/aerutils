; Colarco, November 2018
; Plot a simple size distribution from CARMA compared to some balloon
; observations from Deshler's Laramie data

; Compare here multiple model runs, possibly multiple data profiles

; Bins
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/22.d)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  rcm = r*100.
  rum = r*1e6


; Get a model profile
  expid = 'c90F_pI33p9_ocs'
  filename = '/misc/prc18/colarco/c90F_pI33p9_ocs/tavg3d_carma_v/c90F_pI33p9_ocs.tavg3d_carma_v.monthly.clim.JJA.nc4'
  expid = 'c90Fc_I10pacs12_radact'
  filename = 'c90Fc_I10pacs12_radact.tavg3d_carma_v.19900615_1200z.nc4'
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

; Find 20 km
; Just use stupid level
  a = [33]
  n = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   n[ibin] = total(su[a[0],ibin:nbin-1] / (4./3.*!pi*r[ibin:nbin-1]^3.*rhop)) * rhoa[a[0]] * 1.e-6
  endfor

  nz0 = fltarr(n_elements(lat),3,nbin)
  for iy = 0, n_elements(lat)-1 do begin
   for iz = 0,2 do begin
    for ibin = 0, nbin-1 do begin
     nz0[iy,iz,ibin] = total(suz[iy,a[0]-1+iz,ibin:nbin-1] / (4./3.*!pi*r[ibin:nbin-1]^3.*rhop)) * rhoa[a[0]-1+iz] * 1.e-6
    endfor
   endfor
  endfor
  nz0 = reform(nz0,n_elements(lat)*3,nbin)
  nr  = fltarr(nbin,2)
  for ibin = 0, nbin-1 do begin
   nr[ibin,0] = min(nz0[*,ibin])
   nr[ibin,1] = max(nz0[*,ibin])
  endfor  

; Now massage n, nz0 so that smallest bin plotted is at 0.01 um
  b    = where(r*1e6 gt 0.01)
  rp   = [r[0],r[b]]*1.e6
  n    = [n[0],n[b]]
  nz0m = [nr[0,0],nr[b,0]]
  nz0p = [nr[0,1],nr[b,1]]



; plot
  set_plot, 'ps'
  device, file='n_laramie.'+expid+'.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[.01,1], yrange=[1.e-4,100], /xlog, /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N [cm!E-3!N]'

;  polymaxmin, rp, [[nz0m],[nz0p]], fillcolor=180, /noave
;  oplot, rp, n, thick=6

; presuming a value of rh and t...
  rwetum = fltarr(n_elements(b)+1)
  for ibin = 0, n_elements(b) do begin
   rwetum[ibin] = grow_v75(0.035,rp[ibin]/1.e4,t=215.)*rp[ibin]
  endfor

  loadct, 39
  oplot, rwetum, n, thick=6, color=120


; All these profiles are from Laramie in non-volcanic conditions
  loadct, 0
  files = file_search("/misc/prc10/LARAMIE_DESHLER/NonVolcanic/Nr_Full_Profile/Average_0.5_km/*500m",count=nfiles)
  for ifiles = 0, nfiles-1 do begin
   read_wpc, files[ifiles], alt, pres, temp, pottemp, rh, o3, cn, nl, rl, lat, lon
;  print, files[ifiles], r[0], lat
   a = where(alt eq  20.)
   plots, rl, nl[a,*], psym=sym(13), symsize=.5, noclip=0
   plots, .01, cn[a],  psym=sym(13), symsize=.5, noclip=0
  endfor



  device, /close

end
