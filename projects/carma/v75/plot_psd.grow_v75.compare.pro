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
  rcm = r*100.
  rum = r*1e6


; Get a model profile
  expid = 'c90F_pI33p9_volc'
  filename = '/misc/prc18/colarco/'+expid+'/'+expid+'.tavg3d_carma_v.monthly.201201.nc4'
  wantlat = [0.1]
  wantlon = [-180.]
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Get the layer altitude
  filename2 = '/misc/prc18/colarco/'+expid+'/'+expid+'.geosgcm_diag.monthly.201201.nc4'
  nc4readvar, filename2, 'zl', z, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename2, 't', t, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  z = z/1000.

  expid = 'c90F_pI33p9_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/'+expid+'.tavg3d_carma_v.monthly.201201.nc4'
  nc4readvar, filename, 'su0', su_, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem



; Find 20 km
  a = where(z gt 19.5 and z lt 20.5)
  rhuse = rh[a[0]]
  tempuse = t[a[0]]
  n  = fltarr(nbin)
  dn = fltarr(nbin)
  dn_ = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   dn_[ibin] = su_[a[0],ibin] / rmass[ibin] * rhoa[a[0]] 
   dn[ibin] = su[a[0],ibin] / rmass[ibin] * rhoa[a[0]] 
   n[ibin]  = total(su[a[0],ibin:nbin-1] / rmass[ibin:nbin-1]) * rhoa[a[0]] * 1.e-6
  endfor

  rwetum = fltarr(nbin)
  a = where(z gt 19.5 and z lt 20.5)
  for ibin = 0, nbin-1 do begin
   rwetum[ibin] = grow_v75(rhuse,rcm[ibin],t=tempuse)*rum[ibin]
  endfor


; plot
  set_plot, 'ps'
  device, file='plot_psd.grow_v75.ps', /helvetica, font_size=12, /color, $
   xsize=30, ysize=14, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, rwetum, dn*r/dr, /nodata, /noerase, position=[.5,.2,.95,.9], $
   xrange=[.0002,1], yrange=[1e-3,1e10], /xlog, /ylog, ystyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dN/dlogr [# cm!E-3!N]', $
   title = 'Number Concentration'

  oplot, rwetum, dn*r/dr, thick=6
  oplot, rwetum, dn_*r/dr, thick=6, color=180

  device, /close

end
