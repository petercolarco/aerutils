; Colarco, June 2015

; Calculate sulfate growth factor (ratio of wet to dry radius) as a
; function of relative humidity using the CARMA algorithms for H2SO4

  function sulfate_growthfactor, relhum, t=t

; If temperature not given assume 220K
  if(not(keyword_set(t))) then t = 220.

  wtp = sulfate_wtpct(relhum,t=t)
  den = sulfate_density(relhum,t=t)

; Assumed dry density of sulfate
  rhopdry = 1.923

  return, (rhopdry * 100./wtp/den)^(1./3.)

end
