; See also aerutils/projects/omps/scat/scat.pro

; Get a model profile
  filename = '/misc/prc18/colarco/c90Fc_H54p3_ctrl/tavg3d_carma_v/c90Fc_H54p3_ctrl.tavg3d_carma_v.monthly.clim.JJA.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Fake up an altitude
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.  ; km


; Do another example for Ernest's bimodal PSD
  rhop = 1700.
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow

; Assumption is dry particle density of 1700 kg m-3
; Convert to dadr -- m2 m-3
  dadr = su
  for iz = 0, 71 do begin
   for ibin = 0, 21 do begin
    dadr[iz,ibin] = su[iz,ibin] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin] * (4.*!pi*r[ibin]^2.)
   endfor
  endfor

  openw, lun, 'dadr_laramie.txt', /get
  printf, lun, 'radius [m]', r, format='(a10,1x,22(1e12.5,2x))'
  printf, lun, 'dr [m]', dr, format='(a10,1x,22(1e12.5,2x))'
  for iz = 0, nz-1 do begin
  alt = string(z[iz],format='(f5.2)')+' km'
  printf, lun, alt, dadr[iz,*], format='(a10,1x,22(1e12.5,2x))'
  print, iz, ' ', alt
  endfor
  free_lun, lun

; Make a plot to compare to Kovilakam and Deshler 2015 Figure 5(b)
  set_plot, 'ps'
  device, file='dadlnr_laramie.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, r, dadr[33,*]*r, /nodata, position=[.2,.1,.9,.9], $
   xrange=[0.01,1], /xlog, yrange=[1.e-7,0.1], /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dAdlnr [cm!E2!N m!E-3!N]'
  oplot, r*1e6, dadr[33,*]*r*1e4, thick=6, color=254, lin=2
  device, /close

end

