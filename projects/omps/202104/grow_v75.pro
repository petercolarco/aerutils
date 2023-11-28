; Calculate CARMA growth factor using v75 algorithm...
; see wetr.F90 and sulfate_utils.F90

  function grow_v75, relhum, rdry, t=t

; rdry in cm

; Assumed dry density of sulfate
  rhopdry = 1.923  ; g cm-3

  mw_h2so4 = 98. ; molecular weight of H2SO4 [g mol-1]

  rgas = 8.31447e7 ;erg mol-1 K-1

; If temperature not given assume 273.16K (0 C)
  if(not(keyword_set(t))) then t = 273.16

  temp = t

; Calculate the mass concentration of water given relhum and temp
; first, saturation vapor pressure (Curry & Webster, 4.31)
  llv = 2.501e6 ; J kg-1, Curry & Webster Table 4.2 @ 0 C
  rv  = 461.    ; J K-1 kg-1, Curry & Webster pg. 438, gas constant for water
  ttr = 273.16   ; triple point [K]
  estr = 611.   ; Pa
  es = estr*exp(llv/rv*(1./ttr - 1/temp))
; ideal gas law, pv = nkT, rearrange to n/v = p/(kT)
  k   = 1.38e-23     ; Boltzman constant mks
  n_v = relhum*es / (k*temp)  ; number per m-3
  navogad = 6.022e23 ; mole-1
  mw_h2o  = 0.018    ; kg mole-1
; And finally to mass concentration, and note conversion to g cm-3
  h2o_mass = n_v / navogad *mw_h2o * 1000. / 1.e6


; Adjust calculation for the Kelvin effect of H2O:
  wtpkelv = 80.d                         ; start with assumption of 80 wt % H2SO4 
  den1 = 2.00151d - 0.000974043d * temp  ; density at 79 wt %
  den2 = 2.01703d - 0.000988264d * temp  ; density at 80 wt %
  drho_dwt = den2-den1                   ; change in density for change in 1 wt %
      
  sig1 = 79.3556d - 0.0267212d * temp   ; surface tension at 79.432 wt %
  sig2 = 75.608d  - 0.0269204d * temp   ; surface tension at 85.9195 wt %      
  dsigma_dwt = (sig2-sig1) / (85.9195d - 79.432d) ; change in density for change in 1 wt %
  sigkelv = sig1 + dsigma_dwt * (80.0d - 79.432d)
      
  rwet = rdry * (100.d * rhopdry / wtpkelv / den2)^(1.d / 3.d)

  rkelvinH2O_b = 1.d + wtpkelv * drho_dwt / den2 - 3.d * wtpkelv $
          * dsigma_dwt / (2.d*sigkelv)

  rkelvinH2O_a = 2.d * mw_h2so4 * sigkelv / (den1 * rgas * temp * rwet)     

  rkelvinH2O = exp (rkelvinH2O_a*rkelvinH2O_b)
            
  h2o_kelv = h2o_mass / rkelvinH2O

; wtpct just wants a relative humidity, but it is recalculated here
; based on the calculated terms from above
  k_cgs = 1.3807e-16 ; cm2 g s-2 K-1
  mw_h2o_cgs = 18. ; g mol-1
  relhum_ = h2o_kelv*navogad/mw_h2o_cgs*k_cgs*temp / (es*10.) ; es now dyne cm-2
  rhopwet = dens(relhum_,t=temp)
  rwet    = rdry * (100.d * rhopdry / wtpct(relhum_) / rhopwet)^(1.d / 3.d)   


;  print, temp, relhum, relhum_, rwet/rdry

  return, rwet/rdry
end
