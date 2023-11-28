 pro getregionsocean, nreg, ymaxwant, maskwant, $
                      lon0want, lon1want, $
                      lat0want, lat1want, $
                      regtitle



; Pick regions based on the mask file
  nreg = 11
  ymaxwant = fltarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  regtitle    = strarr(nreg)

; whole world
  i = 0
  ymaxwant[i] =   1. &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  regtitle[i] = 'Global (Ocean)'
 
; tropical north atlantic
  i = 1
  ymaxwant[i] =   1. &  maskwant[i] = 0
  lon0want[i] = -50. &  lon1want[i] = 0.
  lat0want[i] =  10. &  lat1want[i] = 30.
  regtitle[i] = 'Tropical North Atlantic'
 
; caribbean
  i = 2
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] = -100. &  lon1want[i] = -50.
  lat0want[i] =   10. &  lat1want[i] = 30.
  regtitle[i] = 'Caribbean'
 
; satlantic
  i = 3
  ymaxwant[i] =   1. &  maskwant[i] = 0
  lon0want[i] = -70. &  lon1want[i] = 20.
  lat0want[i] = -30. &  lat1want[i] = 10.
  regtitle[i] = 'Tropical South Atlantic'
 
   
; natlantic
  i = 4
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  -80. &  lon1want[i] = 0.
  lat0want[i] =   30. &  lat1want[i] = 60.
  regtitle[i] = 'North Atlantic'
 
; north
  i = 5
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =   60. &  lat1want[i] = 89.
  regtitle[i] = 'Northern Ocean'
 
; south
  i = 6
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =  -60. &  lat1want[i] = -30.
  regtitle[i] = 'Southern Ocean'
 
; indian
  i = 7
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =   20. &  lon1want[i] = 120.
  lat0want[i] =  -30. &  lat1want[i] = 30.
  regtitle[i] = 'Indian Ocean'
 
; pacific
  i = 8
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  120. &  lon1want[i] = 250.
  lat0want[i] =  10. &  lat1want[i] = 60.
  regtitle[i] = 'Northern Pacific'
 
; spacific
  i = 9
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  250. &  lon1want[i] = 290.
  lat0want[i] =  -30. &  lat1want[i] = 10.
  regtitle[i] = 'Southeastern Pacific'
 
; wpacific
  i = 10
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  120. &  lon1want[i] = 250.
  lat0want[i] =  -30. &  lat1want[i] = 10.
  regtitle[i] = 'Southwestern Pacific'
 
; Indonesia
  i = 10
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =   90. &  lon1want[i] = 160.
  lat0want[i] =  -20. &  lat1want[i] = 20.
  regtitle[i] = 'Indonesia'
 
end
