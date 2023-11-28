; Get the profile of effective radius and extinction coefficient for 2
; model runs
  filedir = '/misc/prc18/colarco/'
  expid1  = 'c90F_pI33p2_ocs'
  expid2  = 'c90F_pI33p2_sulfate'

  wantlat = 40

  filename = filedir+expid1+'/tavg3d_carma_p/'+expid1+'.tavg3d_carma_p.monthly.197812.nc4'
  nc4readvar, filename, 'sureff', sureff1, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'suextcoef', suext1, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  a = where(sureff1 gt 1e14) & sureff1[a] = !values.f_nan
  a = where(suext1  gt 1e14) & suext1[a]  = !values.f_nan
  sureff1 = mean(sureff1,dim=1,/nan)*1e6
  suext1  = mean(suext1,dim=1,/nan)

  filename = filedir+expid2+'/tavg3d_carma_p/'+expid2+'.tavg3d_carma_p.monthly.197812.nc4'
  nc4readvar, filename, 'sureff', sureff2, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'suextcoef', suext2, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  a = where(sureff2 gt 1e14) & sureff2[a] = !values.f_nan
  a = where(suext2  gt 1e14) & suext2[a]  = !values.f_nan
  sureff2 = mean(sureff2,dim=1,/nan)*1e6
  suext2  = mean(suext2,dim=1,/nan)

  set_plot, 'ps'
  device, file='plot_psd.ps', /helvetica, font_size=12, /color, $
   xsize=30, ysize=14, xoff=.5, yoff=.5
  !p.font=0

  plot, lev, /nodata, $
   position=[.07,.2,.36,.9], $
   xrange=[0,.5], xtitle='Effective Radius [!Mm!Nm]', $
   yrange=[1000,10], ytitle='p [hPa]', /ylog, $
   title='Zonal mean @ 40!Eo!NN, 197812'
  oplot, sureff2, lev, thick=6
  oplot, sureff1, lev, thick=6, lin=2

  loadct, 39
  xyouts, .25, 40, 'All sulfate sources'
  xyouts, .25, 50, 'OCS sulfate only'
  plots, [.2,.24], 37, thick=6
  plots, [.2,.24], 46, thick=6, lin=2
  xyouts, .25, 65, 'Effective radius'
  xyouts, .25, 80, 'Extinction coefficient', color=90

; Axis for extnction coefficient
  axis, 0.01, 2000, xrange=[.01,10], /xlog, $
   xtitle='Extinction Coefficient [Mm-1]', /save, color=90
  oplot, suext2*1e6, lev, thick=6, color=90
  oplot, suext1*1e6, lev, thick=6, color=90, lin=2


; Get the PSD for sulfate

; sulfate primary group dry bins
  nbin=24
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  rhop = 1923.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow
  filename = filedir+expid1+'/tavg3d_carma_v/'+expid1+'.tavg3d_carma_v.monthly.197812.nc4'
  nc4readvar, filename, 'delp', delp1, lon=lon, lat=lat, wantlat=wantlat, lev=lev
  nc4readvar, filename, 'rh', rh1, lon=lon, lat=lat, wantlat=wantlat
  nc4readvar, filename, 'airdens', rhoa1, lon=lon, lat=lat, wantlat=wantlat
  nc4readvar, filename, 'su0', sus1, /template, rc=rc, wantlat=wantlat
  rh   = mean(rh1,dim=1)
  delp = mean(delp1,dim=1)
  rhoa = mean(rhoa1,dim=1)
  su1  = mean(sus1,dim=1)

; Fake up an altitude
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.  ; km

  filename = filedir+expid2+'/tavg3d_carma_v/'+expid2+'.tavg3d_carma_v.monthly.197812.nc4'
  nc4readvar, filename, 'su0', sus2, /template, rc=rc, wantlat=wantlat
  su2  = mean(sus2,dim=1)

; make particle size distribution
  dndr1 = su1
  dndr2 = su2
  re1   = fltarr(nz)
  re2   = fltarr(nz)
  nz = n_elements(lev)
  for iz = 0, nz-1 do begin
   for ibin = 0, nbin-1 do begin
    dndr1[iz,ibin] = su1[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
    dndr2[iz,ibin] = su2[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
    re1[iz] = total(dndr1[iz,*]*dr*r^3)/total(dndr1[iz,*]*dr*r^2)
    re2[iz] = total(dndr2[iz,*]*dr*r^3)/total(dndr2[iz,*]*dr*r^2)
   endfor
  endfor

  plot, r*1e6, dndr1[0,*]*r, /nodata, /noerase, position=[.5,.2,.95,.9], $
   xrange=[.0002,1], yrange=[1e-3,1e6], /xlog, /ylog, ystyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dN/dlogr [# cm!E-3!N]', $
   title = 'Zonal mean number @ 40!Eo!NN'

  xyouts, .025, 3e5, 'All sulfate sources'
  xyouts, .025, 1e5, 'OCS sulfate only'
  plots, [.01,.02], 3.7e5, thick=6
  plots, [.01,.02], 1.3e5, thick=6, lin=2
  xyouts, .025, 3e4, '50 hPa [~20 km]'
  xyouts, .025, 1e4, '930 hPa [~1 km]', color=90

  iz = 33
  r_    = fltarr(nbin)
  dr_   = fltarr(nbin)
  rlow_ = fltarr(nbin)
  rup_  = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
    rlow_[ibin] = grow_v75(rh[iz],rlow[ibin]*100.d)*rlow[ibin]
    r_[ibin]    = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    rup_[ibin]   = grow_v75(rh[iz],rup[ibin]*100.d)*rup[ibin]
  endfor
  dr_ = rup_-rlow_

  for ibin = 0, nbin-1 do begin
   x0 = rlow_[ibin]*1e6
   x1 = x0+dr_[ibin]*1e6
   y  = dndr1[iz,ibin]*r_[ibin]*1e-6
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr1[iz,ibin-1]*r_[ibin-1]*1e-6
   plots, [x0,x0,x1], [y0,y,y], thick=6, lin=2, noclip=0
   y  = dndr2[iz,ibin]*r_[ibin]*1e-6
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2[iz,ibin-1]*r_[ibin-1]*1e-6
   plots, [x0,x0,x1], [y0,y,y], thick=6, noclip=0
  endfor

  iz = 64
  r_    = fltarr(nbin)
  dr_   = fltarr(nbin)
  rlow_ = fltarr(nbin)
  rup_  = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
    rlow_[ibin] = grow_v75(rh[iz],rlow[ibin]*100.d)*rlow[ibin]
    r_[ibin]    = grow_v75(rh[iz],r[ibin]*100.d)*r[ibin]
    rup_[ibin]   = grow_v75(rh[iz],rup[ibin]*100.d)*rup[ibin]
  endfor
  dr_ = rup_-rlow_


  for ibin = 0, nbin-1 do begin
   x0 = rlow_[ibin]*1e6
   x1 = x0+dr_[ibin]*1e6
   y  = dndr1[iz,ibin]*r_[ibin]*1e-6
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr1[iz,ibin-1]*r_[ibin-1]*1e-6
   plots, [x0,x0,x1], [y0,y,y], thick=6, lin=2, noclip=0, color=90
   y  = dndr2[iz,ibin]*r_[ibin]*1e-6
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2[iz,ibin-1]*r_[ibin-1]*1e-6
   plots, [x0,x0,x1], [y0,y,y], thick=6, noclip=0, color=90
  endfor

  device, /close

end
