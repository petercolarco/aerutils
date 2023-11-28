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


; Get a profile
  filename = 'c90F_pI33p2_spinup.tavg3d_carma_v.monthly.199506.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  dndr = su
  for iz = 0, 71 do begin
   for ibin = 0, 23 do begin
    dndr[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
   endfor
  endfor
; Fake up an altitude
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.  ; km



  rthresh = [0.15,0.23,0.35,0.5,0.78,1] ; microns
  
  nI33p2 = fltarr(nz,10)
  nI33p2cor = fltarr(nz,10)
  for iz = 0, nz-1 do begin
   r_  = fltarr(nbin)
   dr_    = fltarr(nbin)
   for ibin = 0, nbin-1 do begin
;    rh[iz] = .1
    r_[ibin]  = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    dr_[ibin]    = grow_v75(rh[iz],r[ibin]*100.d)*dr[ibin]
   endfor
   for ib = 0, n_elements(rthresh)-1 do begin
    a = where(rup*1e6 gt rthresh[ib] )
    nI33p2[iz,ib] = total(dndr[iz,a]*dr[a])*1e-6
    a = where(r_*1e6 gt rthresh[ib] )
    nI33p2cor[iz,ib] = total(dndr[iz,a]*dr_[a])*1e-6
   endfor
  endfor

; plot
  set_plot, 'ps'
  device, file='n_laramie.4.corrected.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, nI33p2[*,0], z, /nodata, position=[.2,.1,.9,.9], $
   xrange=[1.e-3,1000], yrange=[5,30], /xlog, $
   xtitle = '# cm!E-3!N', ytitle='Alt [km]'

  for ib = 0, n_elements(rthresh)-1 do begin
   oplot, nI33p2[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=0
   oplot, nI33p2cor[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=1
  endfor


  device, /close

end

