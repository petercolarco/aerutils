; Colarco
; Plot time series of global mean volcanic SO2

  filetemplate = 'c48F_H43_pinatubo15.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'supso4gvolc', su, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15_2.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'supso4gvolc', su_2, lon=lon, lat=lat

  filetemplate = 'c48F_H43_pinatubo15_3.tavg2d_aer_x.daily.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'supso4gvolc', su_3, lon=lon, lat=lat

  nt = n_elements(filename)

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; Global integration
  supso4gvolc   = fltarr(nt)
  supso4gvolc_2 = fltarr(nt)
  supso4gvolc_3 = fltarr(nt)
  for it = 0, nt-1 do begin
   supso4gvolc[it]   = total(su[*,*,it]*area)*3600/1.e9  ; Tg hr-1
   supso4gvolc_2[it] = total(su_2[*,*,it]*area)*3600/1.e9  ; Tg hr-1
   supso4gvolc_3[it] = total(su_3[*,*,it]*area)*3600/1.e9  ; Tg hr-1
  endfor

  x = findgen(nt)*3.  ; hours since June 1, 01:30z
  ymax = max([supso4gvolc,supso4gvolc_2,supso4gvolc_3])

  set_plot, 'ps'
  device, file='plot_supso4gvolc.ps', /helvetica, font_size=14
  !p.font=0

  plot, x, supso4gvolc, /nodata, thick=3, $
   xtitle='Hours from June 1, 1991', $
   ytitle='Gas Phase Production of Sulfate [Tg hr!E-1!N]', $
   yrange=[0,ymax]

  oplot, x, supso4gvolc, thick=6, color=120
  oplot, x, supso4gvolc_2, thick=6, color=120, lin=1
  oplot, x, supso4gvolc_3, thick=6, color=120, lin=2

  xd = 360.+indgen(1000)
  y  = 14.5*exp(-0.0017*(xd-360.))
  yy = 14.5*exp(-0.0021*(xd-360.))

  oplot, xd, y, thick=6
  oplot, xd, yy, thick=6, lin=2

  device, /close

end
