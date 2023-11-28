; Colarco
; What are some dm values to specify an initial particle size
; distribution for the Pinatubo produced sulfate

  nbin = 22
  rmrat =  3.7515201
  rmin =  2.6686863e-10
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow, masspart

  rmed = .12e-6
  sigma = 1.59
  frac = 1.
  lognormal, rmed, sigma, frac, $
             r, dr, $
             dNdr, dSdr, dVdr

  reff = total(dndr*r^3.*dr)/total(dndr*r^2.*dr)

  vfrac = dvdr*dr/total(dvdr*dr)
  print, reff*1e6
  print, vfrac, format='(8(f7.5,2x))'

end
