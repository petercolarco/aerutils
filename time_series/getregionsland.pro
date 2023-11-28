 pro getregionsland, nreg, ymaxwant, maskwant, $
                     lon0want, lon1want, $
                     lat0want, lat1want, $
                     regtitle



; Pick regions based on the mask file
  nreg = 13
  ymaxwant = fltarr(nreg)
  ymaxwant[*] = 0.5
  ymaxwant[8] = 1.
  maskwant = intarr(nreg)
  maskwant[*] = 1
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  regtitle    = strarr(nreg)

; whole world
  i = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  regtitle[i] = 'Global (Land)'
 
; South America
  i = 1
  lon0want[i] = -85. &  lon1want[i] = -30.
  lat0want[i] = -60. &  lat1want[i] = 12.
  regtitle[i] = 'South America'
 
; North America
  i = 2
  lon0want[i] = -170. &  lon1want[i] = -55.
  lat0want[i] =   12. &  lat1want[i] = 72.
  regtitle[i] = 'North America'
 
; Eastern U.S.
  i = 3
  lon0want[i] = -100. &  lon1want[i] = -60.
  lat0want[i] =   23. &  lat1want[i] = 50.
  regtitle[i] =  'Eastern United States'
 
   
; Western U.S.
  i = 4
  lon0want[i] = -130. &  lon1want[i] = -100.
  lat0want[i] =   28. &  lat1want[i] = 50.
  regtitle[i] = 'Western United States'
 
; Central America
  i = 5
  lon0want[i] = -120. &  lon1want[i] = -82.
  lat0want[i] =   12. &  lat1want[i] = 32.
  regtitle[i] = 'Central America'
 
; Canada/Alaska/Greenland
  i = 6
  lon0want[i] = -170. &  lon1want[i] = -10.
  lat0want[i] =   50. &  lat1want[i] = 89.
  regtitle[i] = 'Canada/Alaska/Greenland'
 
; Southern Africa
  i = 7
  lon0want[i] =    0. &  lon1want[i] = 60.
  lat0want[i] =  -40. &  lat1want[i] = 0.
  regtitle[i] = 'Southern Africa'
 
; Northern Africa
  i = 8
  lon0want[i] =  -20. &  lon1want[i] = 60.
  lat0want[i] =    0. &  lat1want[i] = 38.
  regtitle[i] = 'Northern Africa'
 
; North Asia
  i = 9
  lon0want[i] =   60. &  lon1want[i] = 190.
  lat0want[i] =   45. &  lat1want[i] = 89.
  regtitle[i] = 'Northern Asia'
 
; Southeastern Asia
  i = 10
  lon0want[i] =  100. &  lon1want[i] = 180.
  lat0want[i] =    0. &  lat1want[i] = 45.
  regtitle[i] = 'Southeastern Asia'
 
; Southwestern Asia
  i = 11
  lon0want[i] =   60. &  lon1want[i] = 100.
  lat0want[i] =    0. &  lat1want[i] = 45.
  regtitle[i] = 'Southwestern Asia'

; Europe
  i = 12
  lon0want[i] =  -10. &  lon1want[i] = 60.
  lat0want[i] =   38. &  lat1want[i] = 89.
  regtitle[i] = 'Europe'
 
end
