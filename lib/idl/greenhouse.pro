; Colarco, Mar 2011
; calculate the absorption across the CO2 band centered at 15 um for
; pre-industrial (opaque at 13.5 - 17 um) and 4xCO2 (opaque at 13 -
; 17.5 um).  The difference is an approximation of the CO2 greenhouse
; effect.

  tearth = 286.  ; temperature of earth's surface , K
  blackbody, tearth, lambda, flux, dlam

  a = where(lambda ge 13.5e-6 and lambda le 17.e-6)
  b = where(lambda ge 13.e-6 and lambda le 17.5e-6)

  print, total(flux[a]*dlam)/total(flux[b]*dlam)

end
