  pro iso_to_nymd, isotime, nymd, nhms

  nymd = lonarr(n_elements(isotime))
  nhms = lonarr(n_elements(isotime))

  for i = 0, n_elements(isotime)-1 do begin

  isotime_ = isotime[i]
  nymd[i] = fix(strmid(isotime_,0,4))*10000L + $
            fix(strmid(isotime_,5,2))*100L + $
            fix(strmid(isotime_,8,2))

  nhms[i] = fix(strmid(isotime_,11,2))*10000L + $
            fix(strmid(isotime_,14,2))*100L

  endfor

 end


