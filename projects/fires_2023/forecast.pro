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
  device, file='forecast.'+loc[iloc]+'.ps', /color, /helvetica, font_size=18, $
   xsize=30, ysize=16
  !p.font=0

  xtickn = indgen(20)+1
;  xtickn[where(xtickn gt 31)] = xtickn[where(xtickn gt 31)]-31
  xtickn = string(xtickn,format='(i2)')

  loadct, 0
  plot, indgen(100), /nodata, $
   xrange=[0,24*19], yrange=[0,3], xstyle=9, ystyle=9, $
   xticks=19, xtickn=xtickn, $
   ytitle='Total AOD', xtitle='Day of June 2023'

  loadct, 65
  x = indgen(240)

  for i = 0, 9 do begin
   cdfid = ncdf_open(filename[i])
    id = ncdf_varid(cdfid,'TOTEXTTAU')
    ncdf_varget, cdfid, id, duext
   ncdf_close, cdfid
   duext = duext[*,iloc] ; DC
   oplot, x+i*24, duext, thick=6, color=255-i*25
   polyfill, [12,36,36,12,12], 2.8-i*.15+0.025*[-1,-1,1,1,-1], color=255-i*25
  endfor

; Overplot the analysis
  loadct, 0
  cdfid = ncdf_open('ana.inst1_2d_hwl_Nx.nc')
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, duext
  ncdf_close, cdfid
  duext = duext[*,iloc] ; DC
  oplot, x, duext, thick=12, color=0
;  polyfill, [12,36,36,12,12], 1.9-i*.1+0.025*[-1,-1,1,1,-1], color=0

  for i = 0, 9 do begin
   xyouts, 42, 2.77-i*.15, /data, 'June '+string(i+1,format='(i2)'), chars=.8
  endfor

  device, /close

  endfor

end
