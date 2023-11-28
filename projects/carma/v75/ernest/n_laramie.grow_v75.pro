; Colarco, April 2020
; Some example code to pull CARMA PSD from local files at desired lat
; and lon locations; at the end you will have the cumulative and
; differential number distributions and dry and wet particle sizes at
; some specified lon/lat/alt

; Enter here a latitude/longitude/altitude to pluck out
  wantlon = -105. ; longitude of Laramie
  wantlat = 41.   ; latitude of Laramie
  wantalt = 20.   ; altitude in km

; Bins - this sets up the dry radii of the CARMA size bins used
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/22.d)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  rcm = r*100.
  rum = r*1e6


; Get a model profile - this gets the aerosol profile, relative
;                       humidity, air density, and pressure thickness
;                       of the model levels for the profile selected
  expid = 'c90F_pI33p4_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.200506.nc4'
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Get the model profile of altitude and temperature, stored in a
; different file than the aerosol model output
  filename2 = '/misc/prc18/colarco/'+expid+'/geosgcm_diag/'+expid+'.geosgcm_diag.monthly.200506.nc4'
  nc4readvar, filename2, 'zl', z, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename2, 't', t, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  z = z/1000. ; Convert from meters to km
  
; Just get the fields at the altitude desired (+/- 0.5 km, makes sense in UTLS)
  a = where(z gt wantalt-0.5 and z lt wantalt+0.5)
  rhuse = rh[a[0]]
  tempuse = t[a[0]]
; su    = dry mass of particles in bin as mixing ratio [kg kg-1]
; rmass = dry mass of nominal particle in bin [kg]
; rhoa  = air density [kg m-3
; above are all MKS; note scale factor to go to cm-3
  dn = fltarr(nbin)
  n  = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   dn[ibin] = su[a[0],ibin] / rmass[ibin] * rhoa[a[0]] * 1.e-6
   n[ibin]  = total(su[a[0],ibin:nbin-1] / rmass[ibin:nbin-1]) * rhoa[a[0]] * 1.e-6
  endfor

  rwetum = fltarr(nbin)
  a = where(z gt wantalt-0.5 and z lt wantalt+0.5)
  for ibin = 0, nbin-1 do begin
   rwetum[ibin] = grow_v75(rhuse,rcm[ibin],t=tempuse)*rum[ibin]
  endfor

; Now abstract some information
  rum = rum       ; this is the dry particle radius [um]
  rwetum = rwetum ; this is the hydrated particle radius; use this [um]
  n = n           ; this is the cumulative number size distribution, 
                  ; as # of particles cm-3 larger than minimum radius
                  ; of the bin index
  dn = dn         ; number of particles in bin in [cm-3]


end
