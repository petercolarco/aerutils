; This doubles the range of the bins I am using for dust
; with the same rmrat (figured out from nbin = 22)
  nbin = 44
;  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmrat = 2.2587828
  rmin = 0.05
  carmabins, nbin, rmrat, rmin, 2400., $
             rmass, rmassup, r, rup, dr, rlow, masspart

; Parameters for a Pinatubo ash particle size distribution after
; Niemeier et al. 2009 (parameters for a number distribution with
; reff = 5.7 um
  r1 = 2.4
  s1 = 1.8
  p1 = 1.
  lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup;, /volume

; Total particle number:
  ntot = total(dndr*dr)

; Total particle volume
  vtot = total(dvdr*dr)

; print out the code for normalized dv for first 22 bins
  print, dvdr[0:21]*dr[0:21]/vtot, format='(8(f6.4,2x))'


end
