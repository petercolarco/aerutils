; Colarco March 2011
; Various vapor pressure relationships

; Tabazadeh 1997, GRL, 1931-1934.
; Based on Clegg and Brimblecombe 1995
; saturation water vapor pressure over liquid water
; valid 185 - 206 K, pressure in 
  t1 = dindgen(86)+185.d   ; temperature [K]
  pvap1 = exp(  18.452406985d  - 3505.1578807d/t1 $
              - 330918.55082d/t1/t1 + 12725068.262d/t1/t1/t1)

; After Curry and Webster, eq. 4.33, valid -50 to 50 C
; liquid water
  t2 = dindgen(101)+223.14
  tr = 273.15d
  a1 = 6.11176750d
  a2 = 0.443986062d
  a3 = .0143053301d
  a4 = .265027242d-3
  a5 = .302246994d-5
  a6 = .203886313d-7
  a7 = .638780966d-10
  tdiff = t2-tr
  pvap2 = a1 + a2*tdiff   + a3*tdiff^2 + a4*tdiff^3 $
             + a5*tdiff^4 + a6*tdiff^5 + a7*tdiff^6

end
