; Colarco, September 2018
; Compare the zonal mean profile of particle size for two model runs

; See also aerutils/projects/omps/scat/scat.pro

; Get an atmosphere
;  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Model runs
  filename1 = 'c48F_pI33p2_spinup.tavg3d_carma_v.monthly.199406.nc4'
  filename2 = 'c48F_pI33p2_sulfate.tavg3d_carma_v.monthly.197706.nc4'

; Bins - for model run1 
  rhop = 1923.
  nbin = 24
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow


; Get a profile
  filename = filename1
  wantlat = 41.
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


  rthresh = [0.15,0.23,0.35,0.5,0.78,1] ; microns
  
  run_0_ = fltarr(nz,10)
  run_0_cor = fltarr(nz,10)
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
    run_0_[iz,ib] = total(dndr[iz,a]*dr[a])*1e-6
    a = where(r_*1e6 gt rthresh[ib] )
    run_0_cor[iz,ib] = total(dndr[iz,a]*dr_[a])*1e-6
   endfor
  endfor



; Get a profile
  filename = filename2
  wantlat = 41.
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
   r_  = fltarr(nbin)
   dr_    = fltarr(nbin)
   for ibin = 0, nbin-1 do begin
;    rh[iz] = .1
    r_[ibin]  = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    dr_[ibin]    = grow_v75(rh[iz],r[ibin]*100.d)*dr[ibin]
   endfor
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
  device, file='dndr_zonal.sulfate.corrected.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, run_0_[*,0], z, /nodata, position=[.2,.1,.9,.9], $
   xrange=[1.e-5,10], yrange=[5,30], /xlog, $
   xtitle = '# cm!E-3!N', ytitle='Alt [km]'

  for ib = 0, n_elements(rthresh)-1 do begin
;   oplot, run_0_[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=0
   oplot, run_0_cor[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=0
  endfor

  for ib = 0, n_elements(rthresh)-1 do begin
;   oplot, run_1_[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=0
   oplot, run_1_cor[*,ib], z, thick=6, color=ib*(255./(n_elements(rthresh)+1)), lin=2
  endfor


  device, /close

end

