; Colarco, August 23, 2007
; Sample procedure to illustrate usage of idlgrads interface.
; Assumption is that the grads environment is already set up
; correctly per the README file.

; See example.pro for more comments
; This iteration is specific to reading MODIS files through the
; included control template files.

; A note about these control files:
; If the IDL code freaks out or doesn't work, probably edit the
; "dset" line of the control to make sure the path points to
; where you've actually put the datasets.

; The Aerosol Optical Thickness is stored in files labeled
; "qawt" to indicate that they are quality weighted (aggregated
; from the Level 2 MODIS products and quality weighted as close
; to the "official" MODIS Level 3 product as I could make them).

; There are additionally files labeled "qafl" which contain
; statistics of the quality weighting and the aerosol fine
; mode fraction.  Variables are:
;  num -> number of MODIS Level 2 (approx 10 x 10 km^2 pixels in the grid box
;  qasum -> sum of quality flags of all pixels in the grid box
;  stddev -> stddev of AOT retrievals
;  aotmin -> minimum AOT of all pixels in box
;  aotmax -> maximum AOT of all pixels in box
;  finerat -> fine mode AOT fraction averaged over grid box
;             may be problematic for land pixels
; I don't provide template files for these, but you can easily enough
; mimic what is provided.

; MODIS Terra template file
  terra_ocn_ctl = 'MOD04_L2_005.ocn.ctl'
  terra_lnd_ctl = 'MOD04_L2_005.lnd.ctl'
  aqua_ocn_ctl = 'MYD04_L2_005.ocn.ctl'
  aqua_lnd_ctl = 'MYD04_L2_005.lnd.ctl'

; Display variables and get the lon/lat/lev information
  ga_getvar, terra_ocn_ctl, '', varout, lon=lon, lat=lat, lev=lev
  print, lon
  print, lat
  print, lev

; get the optical thickness at 550 for a day
  ga_getvar, terra_ocn_ctl, 'aodtau', aodtau, lon=lon, lat=lat, lev=lev, $
   wantlev=['550'], wanttime=['12z5jun2000']



end
