  filename = 'CTL_JO_IC630.inst3d_ext_v.seasonal.subset.nc'
  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filename, 'extinction', extinction, lon=lon, lat=lat
  nc4readvar, filename, 'rh', rh, lon=lon, lat=lat
  nc4readvar, filename, 'tau', tau, lon=lon, lat=lat

  filename = 'RED_JO_IC630.inst3d_ext_v.seasonal.subset.nc'
  nc4readvar, filename, 'delp', delp2, lon=lon, lat=lat
  nc4readvar, filename, 'extinction', extinction2, lon=lon, lat=lat
  nc4readvar, filename, 'rh', rh2, lon=lon, lat=lat
  nc4readvar, filename, 'tau', tau2, lon=lon, lat=lat

; Average
  tau = mean(tau,dim=2)
  tau = total(tau,2)
  tau2 = mean(tau2,dim=2)
  tau2 = total(tau2,2)

; make a plot
  set_plot, 'ps'
  device, file='extinction.ps', /color, /helvetica, font_size=14
  !p.font=0

  plot, indgen(10), /nodata, $
   xrange=[-20,15], xstyle=1, yrange=[0,0.6], $
   position=[.1,.3,.95,.95], $
   ytitle='Seasonal Mean AOD', $
   xtickn=make_array(8,val=' ')
  loadct, 39
  oplot, lon, tau, thick=6, color=66
  oplot, lon, tau2, thick=6, color=254
  oplot, [-5,-5], [0,.6], thick=3, lin=2
  oplot, [10,10], [0,.6], thick=3, lin=2
  xyouts, -12.5, .5, 'C-D', align=.5
  xyouts, 2.5, .5, 'C-I', align=.5

  plot, indgen(10), /nodata, /noerase, $
   xrange=[-20,15], xstyle=1, yrange=[1,1.5], $
   position=[.1,.1,.95,.3], $
   yticks=5, ytickn=['1.0','1.1','1.2','1.3','1.4',' '], yminor=1, $
   xtitle='Longitude', ytitle='Ratio CTL/RED', charsize=.8
  oplot, lon, tau/tau2, thick=6
  oplot, [-5,-5], [1,1.5], thick=3, lin=2
  oplot, [10,10], [1,1.5], thick=3, lin=2

  device, /close


end
