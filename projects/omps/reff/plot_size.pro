
; Get the GOCART optics
;  filename = '/share/colarco/fvInput/AeroCom/x/optics_SU.v1_5.nc'
;  readoptics, filename, reff, lambda, qext, qsca, bextg, bscag, g, bbck, $
;              rh, rmass, refreal, refimag



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


  yyyymm = '199910'

; Baseline Injection
  expid = 'c48F_G41-pin'
  filedir = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_v/'
  filename = expid+'.tavg3d_carma_v.monthly.'+yyyymm+'.nc4'
  nc4readvar, filedir+filename, 'su', su, /template
  nc4readvar, filedir+filename, 'airdens', rhoa
  nc4readvar, filedir+filename, 'delp', delp, lon=lon, lat=lat, lev=lev
  nc4readvar, filedir+filename, 'ps', ps
  nc4readvar, filedir+filename, 'rh', rh
  su      = reform(su[0,*,*,*])
  delp    = reform(delp[0,*,*])
  rhoa    = reform(rhoa[0,*,*])
  rh      = reform(rh[0,*,*])
  ps      = reform(ps[0,*])


; Select off the point to plot
  set_plot, 'ps'
  device, file='sizes.'+yyyymm+'.0N.ps', /helvetica, font_size=11, $
    xoff=.5, yoff=.5, xsize=14, ysize=8, /color
  !p.font=0
  loadct, 39

; Get the standard atmosphere
  atmosphere, p_, pe_, delp_, z_, ze_, delz_, t_, te_, rhoa_
  z = z_/1000.


; Plot a first size
  iy = 45   ; 0 lat
  iz = 38   ; 15 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
  plot, r_*1e6, 4./3.*!pi*dndr*r_^4 * 1.e18, /xlog, /ylog, /nodata, $
        yrange=[1.e-5,1.e6], ytitle='dV / d(ln r) [!9m!3m m!E-3!N]', ystyle=1, $
        xtitle='particle radius [!9m!3m]', xrange=[.001,3], xstyle=1, $
        title=yyyymm+', 0!Eo!NN'
  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=254

  iz = 33   ; 20 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
;  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=208

  iz = 29   ; 25 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=176

  iz = 25   ; 30 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
;  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=120

  iz = 21   ; 35 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=84

; Volume equivalent version of GOCART
  vt = total(r^3.*dndr*dr)
  vtg = total(rg^3.*dndrg*drg)
  dvdrg = rg^3.*dndrg
  dvdrg = dvdrg*vt/vtg
  dndrg = dvdrg/rg^3.
  vt = total(r^3.*dndr*dr)
  oplot, rg*1e6, dndrg*rg^4 * 1.e18, thick=8

device, /close

; Select off the point to plot
  set_plot, 'ps'
  device, file='sizes.'+yyyymm+'.80S.ps', /helvetica, font_size=11, $
    xoff=.5, yoff=.5, xsize=14, ysize=8, /color
  !p.font=0
  loadct, 39

; Different latitude
  iy = 5   ; 70 S
  iz = 38   ; 15 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
  plot, r_*1e6, 4./3.*!pi*dndr*r_^4 * 1.e18, /xlog, /ylog, /nodata, $
        yrange=[1.e-5,1.e6], ytitle='dV / d(ln r) [!9m!3m m!E-3!N]', ystyle=1, $
        xtitle='particle radius [!9m!3m]', xrange=[.001,3], xstyle=1, $
        title=yyyymm+', 80!Eo!NS'
  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=254

  iz = 33   ; 20 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
;  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=208

  iz = 29   ; 25 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=176

  iz = 25   ; 30 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
;  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=120

  iz = 21   ; 35 km
  gf  = sulfate_growthfactor(rh[iy,iz])
  r_  = r*gf
  dr_ = dr*gf
  dndr = reform(su[iy,iz,*]/dr_ / (4./3.*rhop*r_^3.))*rhoa[iy,iz]  ; # m-1 m-3
  oplot, r_*1e6, dndr*r_^4 * 1.e18, thick=8, color=84


; Volume equivalent version of GOCART
  oplot, rg*1e6, dndrg*rg^4 * 1.e18, thick=8


device, /close
end
