; Colarco, march 2011
; Given a temperature [K] return the wavelengths and blackbody
; irradiance

  pro blackbody, t, lambda, flux, dlam

; constants
  h = 6.63d-34   ; planck's constant, J s
  c = 2.998d8    ; speed of light, m s-1
  k = 1.38d-23   ; boltzmann's constant, J K-1
  sigma = 5.67e-8 ; stefan-boltzmann constant, W m-2 K-4

; Make up some wavelength range, m
; dlam is the wavelength width I choose to do the calculation at
; this formulation covers wavelength range from 0.1 nm - 100 um
  dlam = 1.d-10
  lambda = dindgen(1000000L)*dlam + dlam

; Flux (Curry & Webster, eqn 3.19)
  flux = 2.*!dpi*h*c*c / (lambda^5) / (exp(h*c/k/lambda/t) - 1)

; total energy
  print, 'total energy (exact) : ', sigma*t^4
  print, 'total energy (approx): ', total(flux*dlam)
; above is because I don't compute over all wavelengths
end

