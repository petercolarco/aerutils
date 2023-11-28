; Get the profile of effective radius and extinction coefficient for 2
; model runs
  filedir = '/misc/prc18/colarco/'
  expid1  = 'c48F_pI33p5_carma_mx'
  expid2  = 'c48F_pI33p5_carma_ex'

  wantlat = 40


  set_plot, 'ps'
  device, file='plot_psd.mixed.ps', /helvetica, font_size=12, /color, $
   xsize=30, ysize=14, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

; sulfate primary group dry bins
  nbin=22
  rmrat = 3.7515201
  rmin = 2.6686863d-10
  rhop = 1923.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow
  nbin=22
  rmrat = 2.2587828
  rmin = 0.05e-6
  rhop = 1923.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rmx, rupmx, drmx, rlowmx
  filename = filedir+expid1+'/'+expid1+'.tavg3d_carma_v.19800415_0900z.nc4'
  nc4readvar, filename, 'delp', delp1, lon=lon, lat=lat, wantlat=wantlat, lev=lev
  nc4readvar, filename, 'rh', rh1, lon=lon, lat=lat, wantlat=wantlat
  nc4readvar, filename, 'airdens', rhoa1, lon=lon, lat=lat, wantlat=wantlat
  nc4readvar, filename, 'su0', sus1, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'mxsu0', mxsus1, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'mxdu0', mxdus1, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'mxss0', mxsss1, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'mxsm0', mxsms1, /template, rc=rc, wantlat=wantlat

  rh   = mean(rh1,dim=1)
  delp = mean(delp1,dim=1)
  rhoa = mean(rhoa1,dim=1)
  su1  = mean(sus1,dim=1)
  mxsu1  = mean(mxsus1,dim=1)
  mxdu1  = mean(mxdus1,dim=1)
  mxss1  = mean(mxsss1,dim=1)
  mxsm1  = mean(mxsms1,dim=1)

; Fake up an altitude
  nz = n_elements(rh)
  grav = 9.81
  z = fltarr(nz)
  z[nz-1] = delp[nz-1]/rhoa[nz-1]/grav / 2.
  for iz = nz-2, 0, -1 do begin
     z[iz] = z[iz+1]+ (delp[iz+1]/rhoa[iz+1] + delp[iz]/rhoa[iz])/grav/2.
  endfor
  z = z / 1000.  ; km

  filename = filedir+expid2+'/'+expid2+'.tavg3d_carma_v.19800415_0900z.nc4'
  nc4readvar, filename, 'su0', sus2, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'du0', dus2, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'ss0', sss2, /template, rc=rc, wantlat=wantlat
  nc4readvar, filename, 'sm0', sms2, /template, rc=rc, wantlat=wantlat
  su2  = mean(sus2,dim=1)
  du2  = mean(dus2,dim=1)
  ss2  = mean(sss2,dim=1)
  sm2  = mean(sms2,dim=1)

; make particle size distribution
  dndr1 = su1
  dndr1_mx = mxsu1
  dndr1_du = mxdu1
  dndr1_ss = mxss1
  dndr1_sm = mxsm1
  dndr2 = su2
  dndr2_du = du2
  dndr2_ss = ss2
  dndr2_sm = sm2
  re1   = fltarr(nz)
  re2   = fltarr(nz)
  nz = n_elements(lev)
  for iz = 0, nz-1 do begin
   for ibin = 0, nbin-1 do begin
    dndr1[iz,ibin] = su1[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
    dndr1_mx[iz,ibin] = mxsu1[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
    dndr1_du[iz,ibin] = mxdu1[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
    dndr1_ss[iz,ibin] = mxss1[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
    dndr1_sm[iz,ibin] = mxsm1[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
    dndr2[iz,ibin] = su2[iz,ibin] *rhoa[iz] / (4./3.*!pi*r[ibin]^3.*rhop) / dr[ibin]
    dndr2_du[iz,ibin] = du2[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
    dndr2_ss[iz,ibin] = ss2[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
    dndr2_sm[iz,ibin] = sm2[iz,ibin] *rhoa[iz] / (4./3.*!pi*rmx[ibin]^3.*rhop) / drmx[ibin]
   endfor
  endfor

  plot, r*1e6, dndr1[0,*]*r, /nodata, /noerase, position=[.05,.1,.45,.9], $
   xrange=[.0002,1], yrange=[1e-3,1e6], /xlog, /ylog, ystyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dN/dlogr [# cm!E-3!N]', $
   title = 'Pure Sulfate Group Number Concentration'

;  xyouts, .025, 3e5, 'All sulfate sources'
;  xyouts, .025, 1e5, 'OCS sulfate only'
;  plots, [.01,.02], 3.7e5, thick=6
;  plots, [.01,.02], 1.3e5, thick=6, lin=2
;  xyouts, .025, 3e4, '50 hPa [~20 km]'
;  xyouts, .025, 1e4, '930 hPa [~1 km]', color=90

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
   plots, [x0,x0,x1], [y0,y,y], thick=12, lin=0, noclip=0
   y  = dndr2[iz,ibin]*r_[ibin]*1e-6
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2[iz,ibin-1]*r_[ibin-1]*1e-6
   plots, [x0,x0,x1], [y0,y,y], thick=12, noclip=0, lin=2
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
   plots, [x0,x0,x1], [y0,y,y], thick=12, lin=0, noclip=0, color=90
   y  = dndr2[iz,ibin]*r_[ibin]*1e-6
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2[iz,ibin-1]*r_[ibin-1]*1e-6
   plots, [x0,x0,x1], [y0,y,y], thick=12, noclip=0, color=90, lin=2
  endfor


; Coarse mode particles
  plot, r*1e6, dndr1[0,*]*r, /nodata, /noerase, position=[.55,.1,.95,.45], $
   xrange=[.05,15], yrange=[1e2,1e8], /xlog, /ylog, ystyle=1, xstyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='dV/dlogr [!Mm!Nm!E3!N m!E-3!N]', $
   title = 'Mixed Group Volume Concentration'

  iz = 64
  for ibin = 0, nbin-1 do begin
   fac = 4./3.*!pi*rmx[ibin]^3*1e18
   if(ibin gt 0) then facm1 = 4./3.*!pi*rmx[ibin-1]^3*1e18
   facdu = 2.65/1.923
   facss = 2.2/1.923
   facsm = 1.35/1.923
   x0 = rlowmx[ibin]*1e6
   x1 = x0+drmx[ibin]*1e6
   y  = dndr1_mx[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr1_mx[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1], [y0,y,y], thick=8, lin=0, noclip=0, color=176
   y  = dndr1_du[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr1_du[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1]*facdu, [y0,y,y], thick=8, lin=0, noclip=0, color=208
   y  = dndr1_ss[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr1_ss[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1]*facss, [y0,y,y], thick=8, lin=0, noclip=0, color=74
   y  = dndr1_sm[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr1_sm[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1]*facsm, [y0,y,y], thick=8, lin=0, noclip=0, color=254
  endfor


; Coarse mode particles
  plot, r*1e6, dndr1[0,*]*r, /nodata, /noerase, position=[.55,.55,.95,.9], $
   xrange=[.05,15], yrange=[1e2,1e8], /xlog, /ylog, ystyle=1, xstyle=1, $
   xtitle = '', ytitle='dV/dlogr [!Mm!Nm!E3!N m!E-3!N]', $
   title = 'External Group Volume Concentration'


  iz = 64
  for ibin = 0, nbin-1 do begin
   fac = 4./3.*!pi*rmx[ibin]^3*1e18
   if(ibin gt 0) then facm1 = 4./3.*!pi*rmx[ibin-1]^3*1e18
   x0 = rlowmx[ibin]*1e6
   x1 = x0+drmx[ibin]*1e6
   y  = dndr2_du[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2_du[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1], [y0,y,y], thick=8, lin=0, noclip=0, color=208
   y  = dndr2_ss[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2_ss[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1], [y0,y,y], thick=8, lin=0, noclip=0, color=74
   y  = dndr2_sm[iz,ibin]*rmx[ibin]*fac
   if(ibin eq 0) then y0 = 1.e-3 else y0 = dndr2_sm[iz,ibin-1]*rmx[ibin-1]*facm1
   plots, [x0,x0,x1], [y0,y,y], thick=8, lin=0, noclip=0, color=254
  endfor



  device, /close

end
