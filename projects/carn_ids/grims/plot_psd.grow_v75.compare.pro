; Colarco, November 2018
; Plot a simple size distribution from CARMA compared to some balloon
; observations from Deshler's Laramie data

; Bins (carmabins call written in MKS; r in m, rmass in kg)
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/22.d)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  rcm = r*100.
  rum = r*1e6


; Get a model profile
  expid = 'c360R'
  exptag = expid+'_J10p17p6_grims'
  filename = '/misc/prc18/colarco/'+exptag+'/'+exptag+'.inst3d_carma_v.20110524_2100z.nc4'
  wantlat = [67.]
  wantlon = [-77.]
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  nc4readvar, filename, 'h', h, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  z = h/1000.

  expid = 'c180R'
  exptag = expid+'_J10p17p6_grims'
  filename = '/misc/prc18/colarco/'+exptag+'/'+exptag+'.inst3d_carma_v.20110524_2100z.nc4'
  nc4readvar, filename, 'su0', su_, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

  expid = 'c90R'
  exptag = expid+'_J10p17p6_grims'
  filename = '/misc/prc18/colarco/'+exptag+'/'+exptag+'.inst3d_carma_v.20110524_2100z.nc4'
  nc4readvar, filename, 'su0', su__, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem



  a = where(z gt 10 and z lt 11)
  rhuse = rh[a[0]]
tempuse=200.
;  tempuse = t[a[0]]
  n  = fltarr(nbin)
  dn = fltarr(nbin)
  dn_ = fltarr(nbin)
  dn__ = fltarr(nbin)
; Here dn is the number concentration in m-3
  for ibin = 0, nbin-1 do begin
   dn__[ibin] = su__[a[0],ibin] / rmass[ibin] * rhoa[a[0]] 
   dn_[ibin] = su_[a[0],ibin] / rmass[ibin] * rhoa[a[0]] 
   dn[ibin] = su[a[0],ibin] / rmass[ibin] * rhoa[a[0]] 
;   n as written is cumulative in cm-3
;   n[ibin]  = total(su[a[0],ibin:nbin-1] / rmass[ibin:nbin-1]) * rhoa[a[0]] * 1.e-6
  endfor

  rwetum = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   rwetum[ibin] = grow_v75(rhuse,rcm[ibin],t=tempuse)*rum[ibin]
  endfor


; plot
  set_plot, 'ps'
  device, file='plot_psd.grow_v75.ps', /helvetica, font_size=12, /color, $
   xsize=32, ysize=14, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
  plot, rwetum, dn*r/dr, /nodata, /noerase, position=[.05,.2,.45,.9], $
   xrange=[.001,10], yrange=[1e-3,1e10], /xlog, /ylog, ystyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dV/dlogr [!Mm!Nm!E3!N m!E-3!N]', $
   title = 'Volume Concentration'

  v = 4./3.*!dpi*rwetum^3.

  oplot, rwetum, v*dn*r/dr, thick=12, color=254
  oplot, rwetum, v*dn_*r/dr, thick=12, color=48
  oplot, rwetum, v*dn__*r/dr, thick=12, color=90


;  plot, rwetum, dn*r/dr, /nodata, /noerase, position=[.55,.2,.95,.9], $
;   xrange=[.0002,20], yrange=[1e-3,1e10], /xlog, /ylog, ystyle=1, $
;   xtitle = 'radius [!Mm!Nm]', ytitle='dA/dlogr [!Mm!Nm!E2!N m!E-3!N]', $
;   title = 'Area Concentration'

;  a = !pi*rwetum^2
;  oplot, rwetum, a*dn*r/dr, thick=12, color=254
;  oplot, rwetum, a*dn_*r/dr, thick=12, color=48
;  oplot, rwetum, a*dn__*r/dr, thick=12, color=90



  plot, rwetum, dn*r/dr, /nodata, /noerase, position=[.55,.2,.95,.9], $
   xrange=[.001,10], yrange=[1e-3,1e10], /xlog, /ylog, ystyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dN/dlogr [# m!E-3!N]', $
   title = 'Number Concentration'

  oplot, rwetum, dn*r/dr, thick=12, color=254
  oplot, rwetum, dn_*r/dr, thick=12, color=48
  oplot, rwetum, dn__*r/dr, thick=12, color=90

  device, /close

end
