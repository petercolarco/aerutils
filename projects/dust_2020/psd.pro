; Dust particle size distributions from paper

; Here is a default set of sizes for a lognormal
  nbin = 1000
  rmrat = (50.d/.01d)^(3.d/(nbin-1))
  rmin = 0.01d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow

; AERONET, Cape Verde, Table 1 in Rob's section
  volume_fraction = [0.094,1.593]
  volume_mean_r   = [0.291,1.797]
  stddev          = [0.481,0.534]
  frac  = volume_fraction/total(volume_fraction)
  rmed  = volume_mean_r*1e-6
  sigma = exp(stddev)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, $
   /vol, rlow=rlow, rup=rup


; MODIS dark target ocean individual models (they are weighted in retrieval)
  rg_um  = [0.07,0.06,0.08,0.1,0.4,0.6,0.8,0.6,0.5] ; um, number
  stddev = [0.4, 0.6, 0.6, 0.6,0.6,0.6,0.6,0.6,0.8] ; take exp(sttdev)

; MODIS dark target land
; https://darktarget.gsfc.nasa.gov/algorithm/land/aerosol-models
  volume_mean_r = [17.6] ; continental land dust
  sigma         = [1.09]
  tau = 1.
  volume_mean_r = [0.1416*tau^0.0519,2.2]
  sigma         = [0.7561*tau^0.148,0.554*tau^(-0.0519)]
  volume        = [0.0871*tau^1.026,0.6786*tau^1.0569]
  volume_fraction = volume/total(volume)

; Deep Blue
  volume_mean_r = [0.19,1.696]
  stddev        = [0.44,0.515]

; SOAR
  volume_mean_r = [0.19,1.682]
  stddev        = [0.44,0.515]

; MAIAC
  tau = 1.
  volume_mean_r = [0.12,1.9]
  stddev        = [0.5,0.6]
  volume        = [0.02*(1.+tau)/(0.9*tau),1.]
  volume_fraction = volume/total(volume)

; MISR
  number_mean_r = [0.5,1.0]  ; range = 0.1 - 1
  sigma         = [1.5,2.0]  ; range = 0.1 - 6

; OMAERUV
  number_mean_r = [0.052,0.67]  ; range = 0.00627 - 0.43125
  sigma         = [1.697,1.806] ; range = 0.06298 - 7.12764
  number        = [13.531,0.0588]
  number_fraction = number/total(number)


end
