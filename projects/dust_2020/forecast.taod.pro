  filename = ['forecast_20200612.nc',$
              'forecast_20200613.nc',$
              'forecast_20200614.nc',$
              'forecast_20200615.nc',$
              'forecast_20200616.nc',$
              'forecast_20200617.nc',$
              'forecast_20200618.nc',$
              'forecast_20200619.nc',$
              'forecast_20200620.nc',$
              'forecast_20200621.nc',$
              'forecast_20200622.nc'  ]

  nc4readvar, filename[0], 'totexttau', duext, wantlon=[-65.6], wantlat=[18.4]

; make a plot
  set_plot, 'ps'
  device, file='forecast.taod.0.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[0,24*18], yrange=[0,2], xstyle=9, ystyle=9, $
   xticks=18, xtickn=string(indgen(19)+12,format='(i2)'), $
   ytitle='Total AOD', xtitle='Day of June 2020'

  loadct, 65
  x = indgen(240)
  oplot, x, duext, thick=6, color=255

  device, /close


; make a plot
  set_plot, 'ps'
  device, file='forecast.taod.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[0,24*18], yrange=[0,2], xstyle=9, ystyle=9, $
   xticks=18, xtickn=string(indgen(19)+12,format='(i2)'), $
   ytitle='Total AOD', xtitle='Day of June 2020'

  loadct, 65
  x = indgen(240)
  oplot, x, duext, thick=6, color=255
  polyfill, [12,36,36,12,12], 1.9+0.025*[-1,-1,1,1,-1], color=255

  for i = 1, 10 do begin
   nc4readvar, filename[i], 'totexttau', duext, wantlon=[-65.6], wantlat=[18.4]
   oplot, x+i*24, duext, thick=6, color=255-i*20
   polyfill, [12,36,36,12,12], 1.9-i*.1+0.025*[-1,-1,1,1,-1], color=255-i*20
  endfor

; Overplot the June 18 forecast
  i = 6
  loadct, 0
  nc4readvar, filename[i], 'totexttau', duext, wantlon=[-65.6], wantlat=[18.4]
  oplot, x+i*24, duext, thick=12, color=0
  polyfill, [12,36,36,12,12], 1.9-i*.1+0.025*[-1,-1,1,1,-1], color=0

  for i = 0, 10 do begin
   xyouts, 42, 1.88-i*.1, /data, 'June '+string(i+12,format='(i2)'), chars=.8
  endfor



  device, /close

end
