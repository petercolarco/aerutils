; Colarco
; Plot time series of global mean volcanic SO2

  filetemplate = 'c48Fc_H43_pinatubo15.tavg2d_carma_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', succ, lon=lon, lat=lat

  filetemplate = 'c48Fc_H43_pinatubo15+sulfate.tavg2d_carma_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucsc, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15.tavg2d_carma_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', suc, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15+sulfate.tavg2d_carma_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucs, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmassvolc', su, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15+sulfate.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmassvolc', sus, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15_2.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmassvolc', su_2, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15_3.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmassvolc', su_3, lon=lon, lat=lat

  nt = n_elements(filename)

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; Global integration
  so4cc     = fltarr(nt)
  so4csc    = fltarr(nt)
  so4c      = fltarr(nt)
  so4cs     = fltarr(nt)
  so4volcs  = fltarr(nt)
  so4volc   = fltarr(nt)
  so4volc_2 = fltarr(nt)
  so4volc_3 = fltarr(nt)
  for it = 0, nt-1 do begin
   so4cc[it]     = total(succ[*,*,it]*area)/1.e9  ; Tg
   so4csc[it]    = total(sucsc[*,*,it]*area)/1.e9  ; Tg
   so4cs[it]     = total(sucs[*,*,it]*area)/1.e9  ; Tg
   so4volcs[it]  = total(sus[*,*,it]*area)/1.e9  ; Tg
   so4c[it]      = total(suc[*,*,it]*area)/1.e9  ; Tg
   so4volc[it]   = total(su[*,*,it]*area)/1.e9  ; Tg
   so4volc_2[it] = total(su_2[*,*,it]*area)/1.e9  ; Tg
   so4volc_3[it] = total(su_3[*,*,it]*area)/1.e9  ; Tg
  endfor

  x = findgen(nt)*3.  ; hours since June 1, 01:30z
  ymax = max([so4volcs,so4volc,so4volc_2,so4volc_3])

  set_plot, 'ps'
  device, file='plot_so4volc.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0

  plot, x, so4volc, /nodata, thick=3, $
   xtitle='Hours from June 1, 1991', $
   ytitle='Volcanic SO4 [Tg]', $
   yrange=[0,ymax]

  oplot, x, so4c, thick=6, color=0
  oplot, x, so4volc, thick=6, color=120
  oplot, x, so4volc_2, thick=6, color=120, lin=1
  oplot, x, so4volc_3, thick=6, color=120, lin=2

  loadct, 39
  oplot, x, so4cs, thick=6, color=70
  oplot, x, so4volcs, thick=6, color=254
  oplot, x, so4cc, thick=6, color=176
  oplot, x, so4csc, thick=6, color=208

  device, /close

end
