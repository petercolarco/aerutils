; See also aerutils/projects/omps/scat/scat.pro

; Optics file
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v5.nbin=22.nc'
; Wavelength
  lambdanm = 550.
; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  tables = {strSU:strSU}

; Get a model profile
  expid = 'c90Fc_I10pa3_ctrl'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem

; Now calculate the extinction per bin
  nz = n_elements(rhoa)
  extinction = su
  grav = 9.81
  for iz = 0, nz-1 do begin  
   for ib = 0, 21 do begin
    get_mie_table, tables.strSU, table, ib, rh[iz]
    extinction[iz,ib] = su[iz,ib]*(delp[iz]/grav) / (delp[iz]/grav/rhoa[iz]) *table.bext
   endfor
  endfor

  tau = fltarr(22)
  for ib = 0, 21 do begin
   tau[ib] = total(extinction[*,ib]*delp/grav/rhoa)
  endfor
  tauf = fltarr(22)
  tauf[0] = tau[0]/total(tau)
  for ib = 1, 21 do begin
   tauf[ib] = total(tau[0:ib])/total(tau)
  endfor

; Do another example for Ernest's bimodal PSD
  rhop = 1700.
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow

; Make a plot to compare to Kovilakam and Deshler 2015 Figure 5(b)
  set_plot, 'ps'
  device, file='extinction_v_radius.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, r, extinction[32,*], /nodata, position=[.2,.1,.9,.9], $
   xrange=[0.01,1], /xlog, yrange=[1.e-6,1], /ylog, ystyle=9, $
   xtitle = 'radius [!Mm!Nm]', ytitle='extinction per bin [Mm!E-1!N] (dashed)'
  oplot, r*1e6, extinction[32,*]*1e6, thick=6, color=254, lin=2
  axis, yaxis=1, ylog=0, /save, yrange=[0,1], ytitle = 'cumulative fraction of extinction'
  oplot, r*1e6, tauf, thick=6, color=254
  device, /close

end

