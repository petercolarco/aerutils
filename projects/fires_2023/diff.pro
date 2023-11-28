  filename = ['forecast.inst1_2d_hwl_Nx.20230601.nc',$
              'forecast.inst1_2d_hwl_Nx.20230602.nc',$
              'forecast.inst1_2d_hwl_Nx.20230603.nc',$
              'forecast.inst1_2d_hwl_Nx.20230604.nc',$
              'forecast.inst1_2d_hwl_Nx.20230605.nc',$
              'forecast.inst1_2d_hwl_Nx.20230606.nc',$
              'forecast.inst1_2d_hwl_Nx.20230607.nc',$
              'forecast.inst1_2d_hwl_Nx.20230608.nc',$
              'forecast.inst1_2d_hwl_Nx.20230609.nc',$
              'forecast.inst1_2d_hwl_Nx.20230610.nc' ]

  loc = ['WASH_DC','NEW_YORK']

  for iloc = 0, 1 do begin


; make a plot
  set_plot, 'ps'
  device, file='diff.'+loc[iloc]+'.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  xtickn = indgen(11)
;  xtickn[where(xtickn gt 31)] = xtickn[where(xtickn gt 31)]-31
  xtickn = string(xtickn,format='(i2)')

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[0,24*10], yrange=[-3,2], xstyle=9, ystyle=9, $
   xticks=10, xtickn=xtickn, $
   ytitle='Difference AOD from Analysis', xtitle='Forecast Lead Days'

  loadct, 65
  x = indgen(240)

; Get the analysis series
  cdfid = ncdf_open('ana.inst1_2d_hwl_Nx.nc')
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, duext_
  ncdf_close, cdfid
  duext_ = [duext_[*,iloc],make_array(240,val=!values.f_nan)]

  for i = 0, 9 do begin
   cdfid = ncdf_open(filename[i])
    id = ncdf_varid(cdfid,'TOTEXTTAU')
    ncdf_varget, cdfid, id, duext
   ncdf_close, cdfid
   duext = duext[*,iloc] ; DC
;   oplot, x+i*24, duext-duext_[x+i*24], thick=6, color=255-i*25
   oplot, x, duext-duext_[x+i*24], thick=6, color=255-i*25
   polyfill, [12,24,24,12,12], 1.8-i*.15+0.035*[-1,-1,1,1,-1], color=255-i*25
  endfor

  loadct, 0
  for i = 0, 9 do begin
   xyouts, 26, 1.77-i*.15, /data, 'June '+string(i+1,format='(i2)'), chars=.6, color=0
  endfor

  device, /close

  endfor

end
