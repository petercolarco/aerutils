; See also aerutils/projects/omps/scat/scat.pro

; Get an atmosphere
;  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

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
;  expid = 'c90F_pI33p4_ocs'
;  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/2004/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
  expid = 'c90F_pI33p7_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
;  expid = 'c90F_pI33p4_volc'
;  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.198406.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nz = n_elements(lev)

; Get the layer altitude
  filename2 = '/misc/prc18/colarco/'+expid+'/'+expid+'.geosgcm_diag.monthly.200402.nc4'
  nc4readvar, filename2, 'zl', z, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename2, 't', t, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  z = z/1000.
  zl = where(z gt 19.5 and z lt 20.5)

; Convert to dndr - units will be # m-3 m-1
  n       = su
  dndrwet = su
  rwetum = fltarr(nbin)
  drwetum = fltarr(nbin)
; Conditions at 20 - 25 km
  rhuse = 0.026 ; value at 20 km (nominal)
  tempuse = t[zl[0]]
  for ibin = 0, nbin-1 do begin
   rwetum[ibin] = grow_v75(rhuse,rcm[ibin],t=tempuse)*rum[ibin]
   drwetum[ibin] = grow_v75(rhuse,rcm[ibin],t=tempuse)*dr[ibin]*1.e6
  endfor
  for iz = 0, 71 do begin
   for ibin = 0, 21 do begin
    n[iz,ibin] = total(su[iz,ibin:nbin-1] / rmass[ibin:nbin-1]) * rhoa[iz] * 1.e-6
    dndrwet[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin] *dr[ibin]/drwetum[ibin]
   endfor
  endfor



  openw, lun, 'dndr_laramie.'+expid+'.txt', /get
  printf, lun, 'radius [m]', rwetum[0:21]/1.e6, format='(a10,1x,22(1e12.5,2x))'
  printf, lun, 'dr [m]', drwetum[0:21]/1.e6, format='(a10,1x,22(1e12.5,2x))'
  for iz = 0, nz-1 do begin
  alt = string(z[iz],format='(f5.2)')+' km'
  printf, lun, alt, dndrwet[iz,[0:21]], format='(a10,1x,22(1e12.5,2x))'
  print, iz, ' ', alt, rh[iz], t[iz]
  endfor
  free_lun, lun

; Make a plot to compare to Kovilakam and Deshler 2015 Figure 5(b)
  set_plot, 'ps'
  device, file='dndlnr_laramie.'+expid+'.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, r, dndrwet[zl[0],*]*rwetum, /nodata, position=[.2,.1,.9,.9], $
   xrange=[0.01,1], /xlog, yrange=[1.e-4,1.e2], /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N [cm!E-3!N], dNdlnr [cm!E-3!N]'
  oplot, rwetum, dndrwet[zl[0],*]*rwetum/1e6, thick=6, color=0, lin=2
  oplot, rwetum, n[zl[0],*], thick=6, color=0
  plots, rwetum, dndrwet[zl[0],*]*rwetum/1e6, psym=sym(1), symsize=.75, noclip=0
  plots, rwetum, n[zl[0],*], psym=sym(1), symsize=.75, noclip=0

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

