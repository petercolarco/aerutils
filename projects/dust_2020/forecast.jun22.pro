; Read the forecasts and pluck off only the fields valid at 12zJun22

  filename = ['forecast_20200613.nc',$
              'forecast_20200614.nc',$
              'forecast_20200615.nc',$
              'forecast_20200616.nc',$
              'forecast_20200617.nc',$
              'forecast_20200618.nc',$
              'forecast_20200619.nc',$
              'forecast_20200620.nc',$
              'forecast_20200621.nc',$
              'forecast_20200622.nc'  ]

  nf = 10
  pm25  = fltarr(nf)
  pm    = fltarr(nf)
  ext   = fltarr(nf)
  duext = fltarr(nf)

  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'dusmass25', pm25_, wantlon=[-65.6], wantlat=[18.4]
   nc4readvar, filename[i], 'dusmass', pm_, wantlon=[-65.6], wantlat=[18.4]
   nc4readvar, filename[i], 'totexttau', ext_, wantlon=[-65.6], wantlat=[18.4]
   nc4readvar, filename[i], 'duexttau', duext_, wantlon=[-65.6], wantlat=[18.4]
   pm[i]    = pm_[24*(9-i)+12]
   pm25[i]  = pm25_[24*(9-i)+12]
   ext[i]   = ext_[24*(9-i)+12]
   duext[i] = duext_[24*(9-i)+12]
  endfor
  pm25 = pm25*1e9 ; ug m-3
  pm = pm*1e9 ; ug m-3

; make a plot
  set_plot, 'ps'
  device, file='forecast.jun22.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[12,23], yrange=[0,2], ystyle=9, xminor=1, $
   xticks=11, xtickname=[' ',string(indgen(nf)+13,format='(i2)'), ' '], $
   ytitle='AOD', xtitle='0Z Forecast Initialization Date', $
   position=[.1,.15,.9,.85], $
   title='GEOS Dust Forecast Valid 12z June 22 at Cape San Juan!Cfrom Indicated Forecast Initialization Time'

  oplot, indgen(nf)+13, ext, color=0, thick=12
  oplot, indgen(nf)+13, duext, color=0, thick=12, lin=2

  xyouts, 12.5, 1.8, 'Total AOD'
  xyouts, 12.5, 1.7, 'Dust AOD'
  xyouts, 12.5, 1.6, 'Dust PM', color=160
  xyouts, 12.5, 1.5, 'Dust PM2.5', color=160
  plots, [14.5,15.2], 1.85, thick=12
  plots, [14.5,15.2], 1.75, thick=12, lin=2
  plots, [14.5,15.2], 1.65, thick=12, color=160
  plots, [14.5,15.2], 1.55, thick=12, lin=2, color=160

  axis, yaxis=1, yrange=[0,400], /save, color=0, $
   ytitle='Dust Surface Mass Concentration [!Mm!3g m!E-3!N]'
  oplot, indgen(nf)+13, pm, color=160, thick=12
  oplot, indgen(nf)+13, pm25, color=160, thick=12, lin=2
  

  device, /close

end
