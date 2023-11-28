; Make a plot of the global mean sulfate column mass
  expid = 'c48F_pI33p2_sulfate'
  ctl   = expid+'.tavg2d_carma_x.ctl'
  ga_times, ctl, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucmass, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', suexttau, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid='b'
  if(nx eq 288) then grid='c'
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  suc48 = aave(sucmass,area)*total(area)/1e9
  suextc48 = aave(suexttau,area)

; Get the c90F case
  expid = 'c90F_pI33p2_sulfate'
  ctl   = expid+'.tavg2d_carma_x.ctl'
  ga_times, ctl, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucmass, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', suexttau, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid='b'
  if(nx eq 288) then grid='c'
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  suc90 = aave(sucmass,area)*total(area)/1e9
  suextc90 = aave(suexttau,area)


  set_plot, 'ps'
  device, file='plot_sucmass.compare_sulfate.ps', /helvetica, font_size=12, /color, $
   xsize=24, ysize=14, xoff=.5, yoff=.5
  !p.font=0

  nt = n_elements(nhms)

  nticks = 2.*n_elements(nymd)/12
  xtickn = strarr(nticks+1)
  for iticks = 0, (nticks)/2-1 do begin
   xtickn[2*iticks] = 'Jan!C'+strmid(nymd[iticks*12],0,4)
   xtickn[2*iticks+1] = 'Jul'
  endfor
  xtickn[nticks] = ' '
  
  loadct, 39
  plot, indgen(nt), suc48, /nodata, $
   position=[.25, .2, .9, .9], $
   xtitle = '', xrange=[0,nt], xstyle=1, $
   xticks = nticks, $
   xminor = 2, $
   xtickname = xtickn, $
   ytitle = 'Sulfate column loading [Tg]', yrange=[.6,2]
  oplot, indgen(nt), suc48, thick=6
  oplot, indgen(nt), suc90, thick=6, color=254

  device, /close

end
