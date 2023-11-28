; Make an intial particle size distribution in CARMA bin space similar
; to what is used GOCART optics for BRC

  nbin = 22
  rmrat = 2.2587828d
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin  = 0.005d
  rhop = 2650.d
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow

; parameters
  rmed = 0.0212d
  sigma = 2.12d
  frac = 1.

  lognormal, rmed, sigma, frac, $
                 r, dr, $
                 dNdr, dSdr, dVdr, $
                 volume=volume, $
                 rlow=rlow, rup=rup  

  print, dvdr*dr/(total(dvdr*dr)), format='(8(f7.5,4x))'


end
