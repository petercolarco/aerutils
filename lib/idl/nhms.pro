; Colarco, March 2019
; Given a fraction of a day return the NHMS as a 6 digit long
; 0z is relative to fraction = 0

  function nhms, frac

  hh = fix(frac*24.)
  frac1 = frac-hh/24.d
  mm = fix(frac1*24.d*60.d)
  frac2 = frac1-mm/24./60.
  ss = fix(frac2*86400.d)
  nhms = hh*10000L+mm*100L+ss
  return, nhms

end
