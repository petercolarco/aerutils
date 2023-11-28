; Make a plot of the mean profiles of GEOS-5 during VIRGAS flights of
; October 20, 22, 27, 29, 30
; For each, profiles are stored in 6x16 array.
; First column is height, 16 values from 10 km to 25 km
; Second through sixth columns are each of five days profiles of SO2
; in pptv

; Make a plot
  set_plot, 'x'
  loadct, 39
  plot, indgen(20), /nodata, $
   xrange=[0,45], xtitle='SO2 [pptv]', $
   yrange=[12,20], ytitle='Altitude [km]'

; Get the GEOS-5 assimilation, 18z, zonal mean average of 10 - 25 N
  openr, lun, 'GEOS5_virgas2_profiles.assim_zonal.txt', /get
  data = fltarr(6,16)
  readf, lun, data
  free_lun, lun
  oplot, mean(data[1:5,*], dim=1), data[0,*], thick=6, color=254

; Get the MERRA2 reanalysis, 18z, zonal mean average of 10 - 25 N
  openr, lun, 'GEOS5_virgas2_profiles.merra2_zonal.txt', /get
  data = fltarr(6,16)
  readf, lun, data
  free_lun, lun
  oplot, mean(data[1:5,*], dim=1), data[0,*], thick=6, color=84

; Get the GEOS-5 assimilation flight sampled mean
  openr, lun, 'GEOS5_virgas2_profiles.txt', /get
  data = fltarr(6,16)
  readf, lun, data
  free_lun, lun
  oplot, mean(data[1:5,*], dim=1,/nan), data[0,*], thick=6, color=254, lin=2

; Get the MERRA2 reanalysis flight sampled mean
  openr, lun, 'GEOS5_virgas2_merra2_profiles.txt', /get
  data = fltarr(6,16)
  readf, lun, data
  free_lun, lun
  oplot, mean(data[1:5,*], dim=1,/nan), data[0,*], thick=6, color=84, lin=2


end
