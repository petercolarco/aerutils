; Colarco, September 2018
; Compare the zonal mean profile of particle size for two model runs

; See also aerutils/projects/omps/scat/scat.pro

; Get an atmosphere
;  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Model runs
  filename1 = 'c48F_pI33p2_spinup.tavg3d_carma_v.monthly.199406.nc4'
  filename2 = 'c48F_pI33p2_spinup_38.tavg3d_carma_v.monthly.197906.nc4'

; Bins - for model run1 
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow


; Get a profile
  filename = filename1
  wantlat = -41.
  nc4readvar, filename, 'rh', rh, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
; zonal mean
  rh   = mean(rh,dim=1)
  delp = mean(delp,dim=1)
  rhoa = mean(rhoa,dim=1)
  su   = mean(su,dim=1)
; make particle size distribution
  dndr = su
  nz = n_elements(lev)
  for iz = 0, nz-1 do begin
   for ibin = 0, nbin-1 do begin
    dndr[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
   endfor
  endfor
  dndr_0 = dndr
  r_0    = r
  dr_0   = dr
  rlow_0 = rlow

  rthresh = [0.15,0.23,0.35,0.5,0.78,1] ; microns
  
  run_0_ = fltarr(nz,10)
  run_0_cor = fltarr(nz,10)
  for iz = 0, nz-1 do begin
   r_     = fltarr(nbin)
   rlow_  = fltarr(nbin)
   dr_    = fltarr(nbin)
   for ibin = 0, nbin-1 do begin
;    rh[iz] = .1
    rlow_[ibin] = grow_v75(rh[iz],rlow[ibin]*100.d)*rlow[ibin]
    r_[ibin]  = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    dr_[ibin]    = grow_v75(rh[iz],r[ibin]*100.d)*dr[ibin]
   endfor
if(iz eq 33) then r_0_ = r_
if(iz eq 33) then dr_0_ = dr_
if(iz eq 33) then rlow_0_ = rlow_
   for ib = 0, n_elements(rthresh)-1 do begin
    a = where(rup*1e6 gt rthresh[ib] )
    run_0_[iz,ib] = total(dndr[iz,a]*dr[a])*1e-6
    a = where(r_*1e6 gt rthresh[ib] )
    run_0_cor[iz,ib] = total(dndr[iz,a]*dr_[a])*1e-6
   endfor
  endfor



; Bins - for model run2
  rhop = 1923.
  nbin = 38
  rmrat = 2.
  rmin = 02.d-10
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow


; Get a profile
  filename = filename2
  wantlat = -41.
  nc4readvar, filename, 'rh', rh, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
; zonal mean
  rh   = mean(rh,dim=1)
  delp = mean(delp,dim=1)
  rhoa = mean(rhoa,dim=1)
  su   = mean(su,dim=1)
; make particle size distribution
  dndr = su
  nz = n_elements(lev)
  for iz = 0, nz-1 do begin
   for ibin = 0, nbin-1 do begin
    dndr[iz,ibin] = su[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
   endfor
  endfor

  run_1_ = fltarr(nz,10)
  run_1_cor = fltarr(nz,10)
  for iz = 0, nz-1 do begin
   r_     = fltarr(nbin)
   dr_    = fltarr(nbin)
   rlow_  = fltarr(nbin)
   for ibin = 0, nbin-1 do begin
;    rh[iz] = .1
    rlow_[ibin]  = grow_v75(rh[iz],rlow[ibin]*100.d)*rlow[ibin]
    r_[ibin]  = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    dr_[ibin]    = grow_v75(rh[iz],r[ibin]*100.d)*dr[ibin]
   endfor
if(iz eq 33) then r_1_ = r_
if(iz eq 33) then dr_1_ = dr_
if(iz eq 33) then rlow_1_ = rlow_
   for ib = 0, n_elements(rthresh)-1 do begin
    a = where(rup*1e6 gt rthresh[ib] )
    run_1_[iz,ib] = total(dndr[iz,a]*dr[a])*1e-6
    a = where(r_*1e6 gt rthresh[ib] )
    run_1_cor[iz,ib] = total(dndr[iz,a]*dr_[a])*1e-6
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



; plot
  set_plot, 'ps'
  device, file='dndr_zonal.corrected.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, run_0_[*,0], z, /nodata, position=[.2,.1,.9,.9], $
   xrange=[1.e-5,10], yrange=[5,30], /xlog, $
   xtitle = '# cm!E-3!N', ytitle='Alt [km]', $
   title = 'zonal mean number profile @ 40!Eo!NS'

  plots, [.4,.9], 29, thick=6, color=0
  plots, [.4,.9], 28, thick=6, color=0, lin=2
  xyouts, 1, 28.8, 'NBIN=24', charsize=.8
  xyouts, 1, 27.8, 'NBIN=38', charsize=.8

  for ib = 0, n_elements(rthresh)-1 do begin
;   oplot, run_0_[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=0
   oplot, run_0_cor[*,ib], z, thick=8, color=ib*(255./(n_elements(rthresh)+1)), lin=0
   xyouts, 1, 26.8-ib, 'r > '+string(rthresh[ib],format='(f4.2)')+' !Mm!Nm', $
    charsize=.8, color=ib*(255./(n_elements(rthresh)+1))
  endfor

  for ib = 0, n_elements(rthresh)-1 do begin
;   oplot, run_1_[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=0
   oplot, run_1_cor[*,ib], z, thick=8, color=ib*(255./(n_elements(rthresh)+1)), lin=2
  endfor


  device, /close

; plot
  set_plot, 'ps'
  device, file='dndr_zonal.psd.corrected.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 0
  plot, r*1e6, dndr[33,*]*r, /nodata, position=[.2,.1,.9,.9], $
   xrange=[.0002,3], yrange=[1e-3,1e2], /xlog, /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dN/dlogr [# cm!E-3!N]', $
   title = 'zonal mean number @ 40!Eo!NS and 20 km'

;  oplot, r_0_*1e6, dndr_0[33,*]*r_0*1e-6, thick=8
;  oplot, r_1_*1e6, dndr[33,*]*r*1e-6, thick=8, lin=2

  for ibin = 0, n_elements(r_1_)-1 do begin
   x0 = rlow_1_[ibin]*1e6
   x1 = x0+dr_1_[ibin]*1e6
   y  = dndr[33,ibin]*r_1_[ibin]*1e-6
   plots, [x0,x0,x1,x1], [1.e-3,y,y,1.e-3], thick=4, noclip=0
   polyfill, [x0,x0,x1,x1,x0], [1.e-3,y,y,1.e-3,1.e-3], color=176, noclip=0
  endfor


  for ibin = 0, n_elements(r_0)-1 do begin
   x0 = rlow_0_[ibin]*1e6
   x1 = x0+dr_0_[ibin]*1e6
   y  = dndr_0[33,ibin]*r_0[ibin]*1e-6
   plots, [x0,x0,x1,x1], [1.e-3,y,y,1.e-3], thick=4, noclip=0
  endfor

  plots, [.4,.9], 50, thick=8
  plots, [.4,.9], 30, thick=8, color=176
  xyouts, 1, 45, 'NBIN=24', charsize=.8
  xyouts, 1, 27, 'NBIN=38', charsize=.8

  device, /close

end

