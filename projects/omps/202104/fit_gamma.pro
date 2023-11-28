; dndr = 1.*beta^alpha*r^(alpha-1)*exp(-r*beta) / gamma(alpha) / dr

  pro gammafunc, r, a, F, pder
   alpha = a[0]
   beta  = a[1]
   F = 1.*beta^alpha*r^(alpha-1)*exp(-r*beta) / gamma(alpha)
  end


; Zhong's PSD
  alpha = 2.8
  beta  = 20.5

  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/22.d)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  rcm = r*100.
  rum = r*1e6
  dndr = 1.*beta^alpha*r^(alpha-1)*exp(-r*beta) / gamma(alpha) / dr
  dvdr = 4./3.*!dpi*r^3*dndr
;  gammafunc, r, [alpha, beta], F


; Get a "climatological" background stratospheric aerosol
; -------------------------------------------------------
  filename = '/misc/prc18/colarco/c90F_pI33p9_ocs/tavg3d_carma_v/c90F_pI33p9_ocs.tavg3d_carma_v.monthly.clim.JJA.nc4'
;  filename = 'c90Fc_I10pacs12_radact.tavg3d_carma_v.19910615_1200z.nc4'
;  expid = 'c90Fc_I10pa3_anth'
;  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  filename = 'GEOS.fp.asm.inst3_3d_asm_Nv.20200605_0000.V01.nc4'
  nc4readvar, filename, 'h', z, wantlon=wantlon, wantlat=wantlat
  iz = 33 ; 20 km
  n  = fltarr(nbin)
  dn = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   dn[ibin] = su[iz,ibin]/(4./3.*!pi*r[ibin]^3.*rhop) * rhoa[iz] * 1.e-6
   n[ibin]  = total(su[iz,ibin:nbin-1] / (4./3.*!pi*r[ibin:nbin-1]^3.*rhop)) * rhoa[iz] * 1.e-6
  endfor
; scale to above
  dn = dn*total(dndr*dr)/total(dn)

; Guess params
  a = [alpha, beta]
  yfit = curvefit(r,dn,1./dn,a,sigma,function_name='gammafunc')

end
