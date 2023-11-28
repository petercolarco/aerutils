; Colarco, November 2018
; Plot a simple size distribution from CARMA compared to some balloon
; observations from Deshler's Laramie data

; Compare here multiple model runs, possibly multiple data profiles

; Bins
  rhop = 1923.
  nbin = 38
  rmrat = 2.
  rmin = 02.d-10
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow


; Get a model profile
  expid = 'c48F_pI33p6_ocs38'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.198307.nc4'
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
  a    = where(r*1e6 gt 0.01)
  rp   = [r[0],r[a]]*1.e6
  n    = [n[0],n[a]]
  nz0m = [nr[0,0],nr[a,0]]
  nz0p = [nr[0,1],nr[a,1]]



; Second model version
  expid = 'c90F_pI33p4_ocs38'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.198307.nc4'
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
  a = where(z gt 19.5 and z lt 20.5)
  n_ = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   n_[ibin] = total(su[a[0],ibin:nbin-1] / (4./3.*!pi*r[ibin:nbin-1]^3.*rhop)) * rhoa[a[0]] * 1.e-6
  endfor

  nz0_ = fltarr(n_elements(lat),3,nbin)
  for iy = 0, n_elements(lat)-1 do begin
   for iz = 0,2 do begin
    for ibin = 0, nbin-1 do begin
     nz0_[iy,iz,ibin] = total(suz[iy,a[0]-1+iz,ibin:nbin-1] / (4./3.*!pi*r[ibin:nbin-1]^3.*rhop)) * rhoa[a[0]-1+iz] * 1.e-6
    endfor
   endfor
  endfor
  nz0_ = reform(nz0_,n_elements(lat)*3,nbin)
  nr_  = fltarr(nbin,2)
  for ibin = 0, nbin-1 do begin
   nr_[ibin,0] = min(nz0_[*,ibin])
   nr_[ibin,1] = max(nz0_[*,ibin])
  endfor  
  
; Now massage n, nz0 so that smallest bin plotted is at 0.01 um
  a    = where(r*1e6 gt 0.01)
  rp   = [r[0],r[a]]*1.e6
  n_    = [n_[0],n_[a]]
  nz0m_ = [nr_[0,0],nr_[a,0]]
  nz0p_ = [nr_[0,1],nr_[a,1]]






; plot
  set_plot, 'ps'
  device, file='n_laramie.compare38.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[.01,1], yrange=[1.e-4,100], /xlog, /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N [cm!E-3!N]'

;  polymaxmin, rp, [[nz0m],[nz0p]], fillcolor=180, /noave
;  oplot, rp, n, thick=6


  polymaxmin, rp, [[nz0m_],[nz0p_]], fillcolor=180, /noave
  loadct, 39
  oplot, rp, n_, thick=6, color=254
  oplot, rp, n, thick=6


; All these profiles are from Laramie in non-volcanic conditions
  loadct, 39
  files = file_search("/misc/prc10/LARAMIE_DESHLER/NonVolcanic/Nr_Full_Profile/Average_0.5_km/*500m",count=nfiles)
  colors = findgen(nfiles)*255./nfiles
  for ifiles = 0, nfiles-1 do begin
   read_wpc, files[ifiles], alt, pres, temp, pottemp, rh, o3, cn, nl, rl, lat, lon
;  print, files[ifiles], r[0], lat
   a = where(alt eq  20.)
   plots, rl, nl[a,*], psym=sym(1), color=colors[ifiles], noclip=0
   plots, .01, cn[a],  psym=sym(1), color=colors[ifiles], noclip=0
  endfor



  device, /close

end
