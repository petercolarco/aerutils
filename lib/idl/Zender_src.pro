; Dust
  nbin = 8
  rmrat = (100.^3.d)^(1.d/nbin)
  rmin = 0.1d*((1.+rmrat)/2.d)^(1./3.d)*1.d-6
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow

; Setup the size distribution from Zender
; Based on D'Almeida [1987]
  rmed = [.416,2.41,9.69]*1.e-6
  sigma = [2.0,1.9,1.6]
  frac = [.036,.957,.007]
rmed = 2.e-6
sigma = 2.0
frac = 1.
  lognormal, rmed, sigma, frac, $
             r, dr, dNdr, dSdr, dVdr, $
             rlow=rlow, rup=rup, /volume

  print, 'particle_radius: ', r*1.e6, format='(a-20,1x,8(f5.2,1x))'
  print, 'radius_lower:    ', rlow*1.e6, format='(a-20,1x,8(f5.2,1x))'
  print, 'radius_upper:    ', rup*1.e6, format='(a-20,1x,8(f5.2,1x))'
  print, 'source_fraction: ', dvdr*dr, format='(a-20,1x,8(f6.4,1x))'
  print, 'soil_density:    ', make_array(nbin,val=rhop), format='(a-20,1x,8(f5.0,1x))'
  print, 'fscav:           ', make_array(nbin,val=0.8), format='(a-20,1x,8(f3.1,1x))'
  

end
