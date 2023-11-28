; What are the numbers of sub-micron aerosols per unit mass?

; Example: sulfate
  r0    = 0.0695e-6  ; number mode radius [m]
  rmax0 = 0.3e-6     ; maximum radius to compute to (Chin et al., 2002)
  sigma = 2.03
  rhop = 1700.
  nbin = 1000
  rmin = .001e-6
  rmrat = (rmax0/rmin)^3.^(1./float(nbin))
  ntot = 1.        ; number per unit m3 used in lognormal
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  lognormal, r0, sigma, ntot, r, dr, dNdr, dSdr, dVdr
  dMdr = rhop*dVdr

; Now back out the number per unit kg of mass
  mFac = 1./total(dMdr*dr)
  nPkg = total(dNdr*dr)*mFac
  print, 'sulfate: ', nPkg                 ; number is number per kg





; Example: black carbon
  r0    = 0.0118e-6  ; number mode radius [m]
  rmax0 = 0.3e-6     ; maximum radius to compute to (Chin et al., 2002)
  sigma = 2.0
  nbin = 1000
  rmin = .001e-6
  rmrat = (rmax0/rmin)^3.^(1./float(nbin))
  rhop = 1000.
  ntot = 1.        ; number per unit m3 used in lognormal
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  lognormal, r0, sigma, ntot, r, dr, dNdr, dSdr, dVdr
  dMdr = rhop*dVdr

; Now back out the number per unit kg of mass
  mFac = 1./total(dMdr*dr)
  nPkg = total(dNdr*dr)*mFac
  print, 'black carbon: ', nPkg                 ; number is number per kg


; Example: organic carbon
  r0    = 0.0212e-6  ; number mode radius [m]
  rmax0 = 0.3e-6     ; maximum radius to compute to (Chin et al., 2002)
  sigma = 2.2
  nbin = 1000
  rmin = .001e-6
  rmrat = (rmax0/rmin)^3.^(1./float(nbin))
  rhop = 1800.
  ntot = 1.        ; number per unit m3 used in lognormal
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  lognormal, r0, sigma, ntot, r, dr, dNdr, dSdr, dVdr
  dMdr = rhop*dVdr

; Now back out the number per unit kg of mass
  mFac = 1./total(dMdr*dr)
  nPkg = total(dNdr*dr)*mFac
  print, 'organic carbon: ', nPkg                 ; number is number per kg



; Example: Dust
; Dust is a bit different.  We have 1 bin containing dust.  For optics we
; partition to 4 size bins with "radius" [.14, .24, .45, .8 um] and mass
; fraction [.009, .081, .234, .676]
  radsub = [.14, .24, .45, .8]*1e-6     ; m
  rhop   = 2500.                        ; kg m-3
  volsub = 4./3.*!pi*radsub^3.
  frcsub = [0.009, 0.081, 0.234, 0.8]   ; fractions sum to 1.
; number is mass/mass_of_particle
  numsub = frcsub/(rhop*volsub)
  nPkg = total(numsub)
  print, 'dust: ', nPkg                 ; number is number per kg

; Example: Seasalt
; Seasalt is a bit different.  We have 5 bins, three of which contribute
; to the submicron mass.  We apportion using the Gong size scheme to do it.
  nbin = 1000
  rmin = .03e-6
  rmax = 10.e-6
  rmrat = (rmax/rmin)^3.^(1./float(nbin))
  rhop = 2200.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  r80  = 1.65*r*1.e6   ; um
  dr80 = 1.65*dr*1.e6  ; um
  aFac = 4.7*(1.+30.*r80)^(-0.017*r80^(-1.44))
  bFac = (0.433-alog10(r80))/0.433
; number m-2 s-1 um-1
  dNdr80 = 1.373*r80^(-aFac)*(1.+0.057*r80^3.45) $
          *10.^(1.607*exp(-bFac^2.))
; to dry radius m-2 s-1 m-1
  dNdr = dNdr80*dr80/dr
; to mass [kg m-2 s-1 m-1]
  dMdr = rhop*4./3.*!pi*r^3.*dNdr

; Now, per bin do this:
; bin 1
  a = where(r ge .03e-6 and r lt .1e-6)
  mfac = 1./total(dmdr[a]*dr[a])
  dn = mfac*total(dndr[a]*dr[a])
  print, 'seasalt 1: ', dn

; bin 2
  a = where(r ge .1e-6 and r lt .5e-6)
  mfac = 1./total(dmdr[a]*dr[a])
  dn = mfac*total(dndr[a]*dr[a])
  print, 'seasalt 2: ', dn

; bin 3 is only partial
  a = where(r ge .5e-6 and r lt 1.5e-6)
  mfac = 1./total(dmdr[a]*dr[a])
  b = where(r ge .5e-6 and r lt 1.e-6)
  dn = mfac*total(dndr[b]*dr[b])
  print, 'seasalt 3: ', dn


end
