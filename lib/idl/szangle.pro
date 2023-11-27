; Colarco
; Procedure based on GEOS-5 subroutine to compute the solar zenith
; angle given inputs of the latitude, longitude, date, time
; of day

  pro szangle, nymd, nhms, lon, lat, sza, cossza

; lon and lat are specified here in degree, but internally
; we'll recompute in radians
; jday is the day number of the year
  nymd0 = string(nymd,format='(i8)')
  nymd0 = strmid(nymd0,0,4)+'0101'
  jday1 = julday_nymd(nymd,000000L)
  jday0 = julday_nymd(nymd0,000000L)
  jday  = jday1-jday0+1

  nhms  = long(nhms)
  hh    = long(nhms/10000L)
  mm    = long((nhms-hh*10000l)/100)
  ss    = nhms mod 100L
  xhour = hh*1. + mm/60. + ss/3600.

; Some coefficients
  a0 = 0.006918
  a1 = 0.399912
  a2 = 0.006758
  a3 = 0.002697
  b1 = 0.070257
  b2 = 0.000907
  b3 = 0.000148
  r  = 2.*!dpi*(jday-1.)/365. ; where jday is day # of the year

; dec is the solar declination in radians
  dec = a0 - a1*cos(   r) + b1*sin(   r) $
           - a2*cos(2.*r) + b2*sin(2.*r) $
           - a3*cos(3.*r) + b3*sin(3.*r)

; Adjust hour for longitude
  timloc = xhour + lon/15.
  a = where(timloc lt 0.)
  if(a[0] ne -1 ) then timloc[a] = timloc[a]+24.
  a = where(timloc ge 24.)
  if(a[0] ne -1 ) then timloc[a] = timloc[a]-24.

; ahr = is hour angle in radians
  ahr = abs(timloc - 12.)*15.*!dpi/180.

  rlat = lat *!dpi/180.

  cossza =   sin(rlat)*sin(dec) $
           + cos(rlat)*cos(dec)*cos(ahr)
  n      = n_elements(cossza)
  for in = 0, n-1 do begin
   cossza[in] = min([max([cossza[in],-1.0]),1.0]) ; make sure cos stays
                                                  ; between -1.0 and 1.0
  endfor
  sza    = acos(cossza) * 180./!dpi
  a = where(cossza lt 0)
  if(a[0] ne -1) then cossza[a] = 0.

end
