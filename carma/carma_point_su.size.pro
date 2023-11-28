; Get the CARMA optics
  filedir = '/share/colarco/fvInput/AeroCom/x/'
  filename = 'carma_optics_SU.v5.nbin=42.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

; Get the GOCART optics
  filename = 'optics_SU.v1_3.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bextg, bscag, g, bbck, $
              rh, rmass, refreal, refimag



;  Set up the GOCART size bins for fixed mode distribution
   rmax = 3.5e-6
   rmin = 0.01e-6
   rnum = 0.35e-6
   sigma = 1.59
   rho = 1.923

   decade = fix(alog10(rmax/rmin)+1)
   nbin = 20*decade
   rat = rMax/rMin
   rmRat = (rat^3.d0)^(1./double(nBin))
   rMinUse = rMin*((1.+rmRat)/2.)^(1.d/3)
   carmabins, nBin, rmrat, rminUse, rho, $
              rMass, rMassup, rg, rUp, drg, rLow, masspart
   dndrg = 1./rg*exp(-(alog(rg/rNum)^2.)/(2.*alog(sigma)^2.))
   re   = total(rg^3.*dndrg*drg)/total(rg^2.*dndrg*drg)




; Set up the CARMA size bins
  nbin = 42
  rmrat = 1.9988272
  rmin = 2.2891d-10*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow, masspart
  rhop = 1923.  ; kg m-3


; Baseline Injection
  expid = 'bF_F25b27-pin_carma'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.199108.nc4'
  nc4readvar, filedir+filename, 'su', su, /template
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat
  su      = reform(total(su,1))/144.
  delp    = reform(total(delp,1))/144.
  rhoa    = reform(total(rhoa,1))/144.
  ps      = reform(total(ps,1))/144.

; Baseline Injection (tesvf)
  expid = 'bF_F25b27-pin_testvf'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.199108.nc4'
  nc4readvar, filedir+filename, 'su', su5, /template
  nc4readvar, filedir+filename, 'airdens', rhoa5
  nc4readvar, filedir+filename, 'delp', delp5, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps5, lon=lon, lat=lat
  su5      = reform(total(su5,1))/144.
  delp5    = reform(total(delp5,1))/144.
  rhoa5    = reform(total(rhoa5,1))/144.
  ps5      = reform(total(ps5,1))/144.

; High Injection
  expid = 'bF_F25b27-pin_alt16_25'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.199108.nc4'
  nc4readvar, filedir+filename, 'su', su2, /template
  nc4readvar, filedir+filename, 'airdens', rhoa2
  nc4readvar, filedir+filename, 'delp', delp2, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps2, lon=lon, lat=lat
  su2      = reform(total(su2,1))/144.
  delp2    = reform(total(delp2,1))/144.
  rhoa2    = reform(total(rhoa2,1))/144.
  ps2      = reform(total(ps2,1))/144.


; Baseline injection (CARMA active)
  expid = 'bFc_F25b27-pin_carma'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.199108.nc4'
  nc4readvar, filedir+filename, 'su', su4, /template
  nc4readvar, filedir+filename, 'airdens', rhoa4
  nc4readvar, filedir+filename, 'delp', delp4, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps4, lon=lon, lat=lat
  su4      = reform(total(su4,1))/144.
  delp4    = reform(total(delp4,1))/144.
  rhoa4    = reform(total(rhoa4,1))/144.
  ps4      = reform(total(ps4,1))/144.


; Higher injection (CARMA active)
  expid = 'bFc_F25b27-pin_alt16_25'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.199108.nc4'
  nc4readvar, filedir+filename, 'su', su3, /template
  nc4readvar, filedir+filename, 'airdens', rhoa3
  nc4readvar, filedir+filename, 'delp', delp3, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps3, lon=lon, lat=lat
  su3      = reform(total(su3,1))/144.
  delp3    = reform(total(delp3,1))/144.
  rhoa3    = reform(total(rhoa3,1))/144.
  ps3      = reform(total(ps3,1))/144.


; Select off the point to plot
  set_plot, 'ps'
  device, file='sizes.ps', /helvetica, font_size=12, $
    xoff=.5, yoff=.5, xsize=25, ysize=16, /color
  !p.font=0
  loadct, 39
  !p.multi=[0,2,2]


  iy = 45   ; 0 lat
  iz = 29   ; 26 hPa
;  iz = 24   ; 10 hPa
  aot  = total(su[iy,iz,*]*bext[6,0,*])
  ang  = - alog(total(su[iy,iz,*]*bext[4,0,*])/total(su[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot2  = total(su2[iy,iz,*]*bext[6,0,*])
  ang2  = - alog(total(su2[iy,iz,*]*bext[4,0,*])/total(su2[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot3  = total(su3[iy,iz,*]*bext[6,0,*])
  ang3  = - alog(total(su3[iy,iz,*]*bext[4,0,*])/total(su3[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot4  = total(su4[iy,iz,*]*bext[6,0,*])
  ang4  = - alog(total(su4[iy,iz,*]*bext[4,0,*])/total(su4[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot5  = total(su5[iy,iz,*]*bext[6,0,*])
  ang5  = - alog(total(su5[iy,iz,*]*bext[4,0,*])/total(su5[iy,iz,*]*bext[12,0,*])) / alog (450./900.)

  dndr = reform(su[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa[iy,iz]  ; # m-1 m-3
  reff = 1e6*total(r^3.*dndr*dr) / total(r^2.*dndr*dr) ; effective radius in um

  dndr2 = reform(su2[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa2[iy,iz]  ; # m-1 m-3
  reff2 = total(r^3.*dndr2*dr) / total(r^2.*dndr2*dr)*1e6  ; effective radius in um

  dndr3 = reform(su3[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa3[iy,iz]  ; # m-1 m-3
  reff3 = total(r^3.*dndr3*dr) / total(r^2.*dndr3*dr)*1e6  ; effective radius in um

  dndr4 = reform(su4[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa4[iy,iz]  ; # m-1 m-3
  reff4 = total(r^3.*dndr4*dr) / total(r^2.*dndr4*dr)*1e6  ; effective radius in um

  dndr5 = reform(su5[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa5[iy,iz]  ; # m-1 m-3
  reff5 = total(r^3.*dndr5*dr) / total(r^2.*dndr5*dr)*1e6  ; effective radius in um

  plot, r*1e6, 4./3.*!pi*dndr*r^4 * 1.e18, /xlog, /ylog, /nodata, $
        yrange=[1.e-8,1.e8], ytitle='dV / d(ln r) [!9m!3m m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]', $
        title='August 1991, 0!Eo!NN, 26 hPa'
  oplot, r*1e6, dndr*r^4 * 1.e18, thick=8, color=254
  oplot, r*1e6, dndr2*r^4 * 1.e18, thick=8, color=254, lin=2
  oplot, r*1e6, dndr3*r^4 * 1.e18, thick=8, color=58, lin=2
  oplot, r*1e6, dndr4*r^4 * 1.e18, thick=8, color=58
  oplot, r*1e6, dndr5*r^4 * 1.e18, thick=8, color=159

; Volume equivalent version of GOCART
  vt = total(r^3.*dndr*dr)
  vtg = total(rg^3.*dndrg*drg)
  dvdrg = rg^3.*dndrg
  dvdrg = dvdrg*vt/vtg
  dndrg = dvdrg/rg^3.
  oplot, rg*1e6, dndrg*rg^4 * 1.e18, thick=8


  xyouts, .0002, 1e8, '!416 - 18 km injection!3', charsize=.75
  xyouts, .0003, 1e7, 'reff = '+string(reff,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang,format='(f6.3)'), $
                      charsize=.75, color=254
  xyouts, .0003, 1e6, 'reff = '+string(reff4,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot4*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang4,format='(f6.3)'), $
                      charsize=.75, color=58
  xyouts, .0003, 1e5, 'reff = '+string(reff5,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot5*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang5,format='(f6.3)'), $
                      charsize=.75, color=159
  xyouts, .0002, 1e3, '!416 - 25 km injection!3', charsize=.75
  xyouts, .0003, 1e2, 'reff = '+string(reff2,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot2*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang2,format='(f6.3)'), $
                      charsize=.75, color=254
  xyouts, .0003, 1e1, 'reff = '+string(reff3,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot3*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang3,format='(f6.3)'), $
                      charsize=.75, color=58

  !p.multi=[2,2,2]
  plot, r*1e6, 4./3.*!pi*dndr*r, /xlog, /ylog, /nodata, $
        ytitle='dN / d(ln r) [m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]'
  oplot, r*1e6, dndr*r, thick=8, color=254
  oplot, r*1e6, dndr2*r, thick=8, color=254, lin=2
  oplot, r*1e6, dndr3*r, thick=8, color=58, lin=2
  oplot, r*1e6, dndr4*r, thick=8, color=58
  oplot, r*1e6, dndr5*r, thick=8, color=159
  oplot, rg*1e6, dndrg*rg, thick=8


  iy = 55   ; 20 lat
  iz = 29   ; 26 hPa
;  iz = 24   ; 10 hPa
  aot  = total(su[iy,iz,*]*bext[6,0,*])
  ang  = - alog(total(su[iy,iz,*]*bext[4,0,*])/total(su[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot2  = total(su2[iy,iz,*]*bext[6,0,*])
  ang2  = - alog(total(su2[iy,iz,*]*bext[4,0,*])/total(su2[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot3  = total(su3[iy,iz,*]*bext[6,0,*])
  ang3  = - alog(total(su3[iy,iz,*]*bext[4,0,*])/total(su3[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot4  = total(su4[iy,iz,*]*bext[6,0,*])
  ang4  = - alog(total(su4[iy,iz,*]*bext[4,0,*])/total(su4[iy,iz,*]*bext[12,0,*])) / alog (450./900.)
  aot5  = total(su5[iy,iz,*]*bext[6,0,*])
  ang5  = - alog(total(su5[iy,iz,*]*bext[4,0,*])/total(su5[iy,iz,*]*bext[12,0,*])) / alog (450./900.)

  dndr = reform(su[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa[iy,iz]  ; # m-1 m-3
  reff = 1e6*total(r^3.*dndr*dr) / total(r^2.*dndr*dr) ; effective radius in um

  dndr2 = reform(su2[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa2[iy,iz]  ; # m-1 m-3
  reff2 = total(r^3.*dndr2*dr) / total(r^2.*dndr2*dr)*1e6  ; effective radius in um

  dndr3 = reform(su3[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa3[iy,iz]  ; # m-1 m-3
  reff3 = total(r^3.*dndr3*dr) / total(r^2.*dndr3*dr)*1e6  ; effective radius in um

  dndr4 = reform(su4[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa4[iy,iz]  ; # m-1 m-3
  reff4 = total(r^3.*dndr4*dr) / total(r^2.*dndr4*dr)*1e6  ; effective radius in um

  dndr5 = reform(su5[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa5[iy,iz]  ; # m-1 m-3
  reff5 = total(r^3.*dndr5*dr) / total(r^2.*dndr5*dr)*1e6  ; effective radius in um

  !p.multi=[3,2,2]
  plot, r*1e6, 4./3.*!pi*dndr*r^4 * 1.e18, /xlog, /ylog, /nodata, $
        yrange=[1.e-8,1.e8], ytitle='dV / d(ln r) [!9m!3m m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]', $
        title='August 1991, 20!Eo!NN, 26 hPa'
  oplot, r*1e6, dndr*r^4 * 1.e18, thick=8, color=254
  oplot, r*1e6, dndr2*r^4 * 1.e18, thick=8, color=254, lin=2
  oplot, r*1e6, dndr3*r^4 * 1.e18, thick=8, color=58, lin=2
  oplot, r*1e6, dndr4*r^4 * 1.e18, thick=8, color=58
  oplot, r*1e6, dndr5*r^4 * 1.e18, thick=8, color=159
  oplot, rg*1e6, dndrg*rg^4*1.e18, thick=8


  xyouts, .0002, 1e8, '!416 - 18 km injection!3', charsize=.75
  xyouts, .0003, 1e7, 'reff = '+string(reff,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang,format='(f6.3)'), $
                      charsize=.75, color=254
  xyouts, .0003, 1e6, 'reff = '+string(reff4,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot4*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang4,format='(f6.3)'), $
                      charsize=.75, color=58
  xyouts, .0003, 1e5, 'reff = '+string(reff5,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot5*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang5,format='(f6.3)'), $
                      charsize=.75, color=159
  xyouts, .0002, 1e3, '!416 - 25 km injection!3', charsize=.75
  xyouts, .0003, 1e2, 'reff = '+string(reff2,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot2*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang2,format='(f6.3)'), $
                      charsize=.75, color=254
  xyouts, .0003, 1e1, 'reff = '+string(reff3,format='(f5.3)')+' !9m!3m' + $
                      ', !9t!3x1000 = '+string(aot3*1000,format='(f4.2)') + $
                      ', !9a!3 = '+string(ang3,format='(f6.3)'), $
                      charsize=.75, color=58

  !p.multi=[1,2,2]
  plot, r*1e6, 4./3.*!pi*dndr*r, /xlog, /ylog, /nodata, $
        ytitle='dN / d(ln r) [m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]'
  oplot, r*1e6, dndr*r, thick=8, color=254
  oplot, r*1e6, dndr2*r, thick=8, color=254, lin=2
  oplot, r*1e6, dndr3*r, thick=8, color=58, lin=2
  oplot, r*1e6, dndr4*r, thick=8, color=58
  oplot, r*1e6, dndr5*r, thick=8, color=159
  oplot, rg*1e6, dndrg*rg, thick=8


device, /close
end
