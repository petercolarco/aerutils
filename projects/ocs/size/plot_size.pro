
; Get the GOCART optics
  filename = '/share/colarco/fvInput/AeroCom/x/optics_SU.v1_5.nc'
  readoptics, filename, reff, lambda, qext, qsca, bextg, bscag, g, bbck, $
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
print, re*1e6
   rmax = 3.5e-6
   rmin = 0.01e-6
   rnum = 0.0695e-6
   sigma = 2.03
   rho = 1.923

   decade = fix(alog10(rmax/rmin)+1)
   nbin = 20*decade
   rat = rMax/rMin
   rmRat = (rat^3.d0)^(1./double(nBin))
   rMinUse = rMin*((1.+rmRat)/2.)^(1.d/3)
   carmabins, nBin, rmrat, rminUse, rho, $
              rMass, rMassup, rg, rUp, drg, rLow, masspart
   dndrg2 = 1./rg*exp(-(alog(rg/rNum)^2.)/(2.*alog(sigma)^2.))
   re2   = total(rg^3.*dndrg2*drg)/total(rg^2.*dndrg2*drg)
print, re2*1e6



; Set up the CARMA size bins
  nbin = 22
  rmrat =  3.7515201
  rmin =  2.6686863e-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow, masspart
  rhop = 1923.  ; kg m-3


  yyyymm = '199110'

; Baseline Injection
  expid = 'c48F_G41-pin'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.'+yyyymm+'.nc4'
  nc4readvar, filedir+filename, 'su', su, /template
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps, lon=lon, lat=lat
  su      = reform(total(su,1))/144.
  delp    = reform(total(delp,1))/144.
  rhoa    = reform(total(rhoa,1))/144.
  ps      = reform(total(ps,1))/144.

; Baseline Injection
  expid = 'c48F_G41-pinc'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.'+yyyymm+'.nc4'
  nc4readvar, filedir+filename, 'su', su2, /template
  nc4readvar, filedir+filename, 'airdens', rhoa2
  nc4readvar, filedir+filename, 'delp', delp2, lon=lon, lat=lat
  nc4readvar, filedir+filename, 'ps', ps2, lon=lon, lat=lat
  su2      = reform(total(su2,1))/144.
  delp2    = reform(total(delp2,1))/144.
  rhoa2    = reform(total(rhoa2,1))/144.
  ps2      = reform(total(ps2,1))/144.




; Select off the point to plot
  set_plot, 'ps'
  device, file='sizes.'+yyyymm+'.ps', /helvetica, font_size=12, $
    xoff=.5, yoff=.5, xsize=25, ysize=16, /color
  !p.font=0
  loadct, 39
  !p.multi=[0,2,2]


  iy = 45   ; 0 lat
  iz = 29   ; 26 hPa
;  iz = 24   ; 10 hPa

  dndr = reform(su[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa[iy,iz]  ; # m-1 m-3
  reff = 1e6*total(r^3.*dndr*dr) / total(r^2.*dndr*dr) ; effective radius in um

  dndr2 = reform(su2[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa2[iy,iz]  ; # m-1 m-3
  reff2 = total(r^3.*dndr2*dr) / total(r^2.*dndr2*dr)*1e6  ; effective radius in um

print, reff, reff2

;  dndr3 = reform(su3[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa3[iy,iz]  ; # m-1 m-3
;  reff3 = total(r^3.*dndr3*dr) / total(r^2.*dndr3*dr)*1e6  ; effective radius in um

;  dndr4 = reform(su4[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa4[iy,iz]  ; # m-1 m-3
;  reff4 = total(r^3.*dndr4*dr) / total(r^2.*dndr4*dr)*1e6  ; effective radius in um

;  dndr5 = reform(su5[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa5[iy,iz]  ; # m-1 m-3
;  reff5 = total(r^3.*dndr5*dr) / total(r^2.*dndr5*dr)*1e6  ; effective radius in um

  plot, r*1e6, 4./3.*!pi*dndr*r^4 * 1.e18, /xlog, /ylog, /nodata, $
        yrange=[1.e-8,1.e8], ytitle='dV / d(ln r) [!9m!3m m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]', $
        title=yyyymm+', 0!Eo!NN, 26 hPa'
  oplot, r*1e6, dndr*r^4 * 1.e18, thick=8, color=254
  oplot, r*1e6, dndr2*r^4 * 1.e18, thick=8, color=58
;  oplot, r*1e6, dndr3*r^4 * 1.e18, thick=8, color=58, lin=2
;  oplot, r*1e6, dndr4*r^4 * 1.e18, thick=8, color=58
;  oplot, r*1e6, dndr5*r^4 * 1.e18, thick=8, color=159

; Volume equivalent version of GOCART
  vt = total(r^3.*dndr*dr)
  vtg = total(rg^3.*dndrg*drg)
  dvdrg = rg^3.*dndrg
  dvdrg = dvdrg*vt/vtg
  dndrg = dvdrg/rg^3.
  vt = total(r^3.*dndr*dr)
  vtg2 = total(rg^3.*dndrg2*drg)
  dvdrg2 = rg^3.*dndrg2
  dvdrg2 = dvdrg2*vt/vtg2
  dndrg2 = dvdrg2/rg^3.
  oplot, rg*1e6, dndrg*rg^4 * 1.e18, thick=8
  oplot, rg*1e6, dndrg2*rg^4 * 1.e18, thick=8, lin=2

  !p.multi=[2,2,2]
  plot, r*1e6, 4./3.*!pi*dndr*r, /xlog, /ylog, /nodata, $
        ytitle='dN / d(ln r) [m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]'
  oplot, r*1e6, dndr*r, thick=8, color=254
  oplot, r*1e6, dndr2*r, thick=8, color=58
 ; oplot, r*1e6, dndr3*r, thick=8, color=58, lin=2
 ; oplot, r*1e6, dndr4*r, thick=8, color=58
 ; oplot, r*1e6, dndr5*r, thick=8, color=159
 ; oplot, rg*1e6, dndrg*rg, thick=8


  iy = 55   ; 20 lat
  iz = 29   ; 26 hPa
;  iz = 24   ; 10 hPa

  dndr = reform(su[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa[iy,iz]  ; # m-1 m-3
  reff = 1e6*total(r^3.*dndr*dr) / total(r^2.*dndr*dr) ; effective radius in um

  dndr2 = reform(su2[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa2[iy,iz]  ; # m-1 m-3
  reff2 = total(r^3.*dndr2*dr) / total(r^2.*dndr2*dr)*1e6  ; effective radius in um
print, reff, reff2

;  dndr3 = reform(su3[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa3[iy,iz]  ; # m-1 m-3
;  reff3 = total(r^3.*dndr3*dr) / total(r^2.*dndr3*dr)*1e6  ; effective radius in um

;  dndr4 = reform(su4[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa4[iy,iz]  ; # m-1 m-3
;  reff4 = total(r^3.*dndr4*dr) / total(r^2.*dndr4*dr)*1e6  ; effective radius in um

;  dndr5 = reform(su5[iy,iz,*]/dr / (4./3.*rhop*r^3.))*rhoa5[iy,iz]  ; # m-1 m-3
;  reff5 = total(r^3.*dndr5*dr) / total(r^2.*dndr5*dr)*1e6  ; effective radius in um

  !p.multi=[3,2,2]
  plot, r*1e6, 4./3.*!pi*dndr*r^4 * 1.e18, /xlog, /ylog, /nodata, $
        yrange=[1.e-8,1.e8], ytitle='dV / d(ln r) [!9m!3m m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]', $
        title=yyyymm+', 20!Eo!NN, 26 hPa'
  oplot, r*1e6, dndr*r^4 * 1.e18, thick=8, color=254
  oplot, r*1e6, dndr2*r^4 * 1.e18, thick=8, color=58
;  oplot, r*1e6, dndr3*r^4 * 1.e18, thick=8, color=58, lin=2
;  oplot, r*1e6, dndr4*r^4 * 1.e18, thick=8, color=58
;  oplot, r*1e6, dndr5*r^4 * 1.e18, thick=8, color=159
;  oplot, rg*1e6, dndrg*rg^4*1.e18, thick=8
  oplot, rg*1e6, dndrg*rg^4 * 1.e18, thick=8
  oplot, rg*1e6, dndrg2*rg^4 * 1.e18, thick=8, lin=2


  !p.multi=[1,2,2]
  plot, r*1e6, 4./3.*!pi*dndr*r, /xlog, /ylog, /nodata, $
        ytitle='dN / d(ln r) [m!E-3!N]', $
        xtitle='dry particle radius [!9m!3m]'
  oplot, r*1e6, dndr*r, thick=8, color=254
  oplot, r*1e6, dndr2*r, thick=8, color=58
 ; oplot, r*1e6, dndr3*r, thick=8, color=58, lin=2
 ; oplot, r*1e6, dndr4*r, thick=8, color=58
 ; oplot, r*1e6, dndr5*r, thick=8, color=159
 ; oplot, rg*1e6, dndrg*rg, thick=8


device, /close
end
