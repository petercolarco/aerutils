; Make a plot
  set_plot, 'ps'
  device, file='rh.ps', /helvetica, font_size=14, /color
  !p.font=0
  plot, indgen(10)+1, /nodata, position=[.2,.1,.9,.9], $
   xrange=[0,1], yrange=[5,30], $
   xtitle = 'RH', ytitle='Alt [km]'

  files = file_search("*500m",count=nfiles)
  for ifiles = 0, nfiles-1 do begin
   read_wpc, files[ifiles], alt, pres, temp, pottemp, rh, o3, cn, n, r, lat, lon
   oplot, rh/100., alt
  endfor

  device, /close

 end
