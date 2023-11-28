; Make a plot of the global mean sulfate column mass
  expid = 'c48F_pI33p5_carma_mx'
  ctl   = expid+'.tavg2d_carma_x.ctl'
  ga_times, ctl, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucmass, lon=lon, lat=lat
  nc4readvar, filename, 'mxsucmass', mxsucmass, lon=lon, lat=lat
  nc4readvar, filename, 'mxducmass', mxducmass, lon=lon, lat=lat
  nc4readvar, filename, 'mxsscmass', mxsscmass, lon=lon, lat=lat
  nc4readvar, filename, 'mxsmcmass', mxsmcmass, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid='b'
  if(nx eq 288) then grid='c'
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  sucmass = aave(sucmass,area)*total(area)/1e9
  mxsucmass = aave(mxsucmass,area)*total(area)/1e9
  mxducmass = aave(mxducmass,area)*total(area)/1e9
  mxsscmass = aave(mxsscmass,area)*total(area)/1e9
  mxsmcmass = aave(mxsmcmass,area)*total(area)/1e9

  expid = 'c48F_pI33p5_carma_mx'
  ctl   = expid+'.tavg2d_aer_x.ctl'
  ga_times, ctl, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmass', gsucmass, lon=lon, lat=lat
  nc4readvar, filename, 'ducmass', gducmass, lon=lon, lat=lat
  nc4readvar, filename, 'sscmass', gsscmass, lon=lon, lat=lat
  nc4readvar, filename, ['occmass','brccmass'], gsmcmass, lon=lon, lat=lat, /sum
  nx = n_elements(lon)
  if(nx eq 144) then grid='b'
  if(nx eq 288) then grid='c'
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  gsucmass = aave(gsucmass,area)*total(area)/1e9
  gducmass = aave(gducmass,area)*total(area)/1e9
  gsscmass = aave(gsscmass,area)*total(area)/1e9
  gsmcmass = aave(gsmcmass,area)*total(area)/1e9

  set_plot, 'ps'
  device, file='plot_sscmass.mixed.ps', /helvetica, font_size=12, /color, $
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
  plot, indgen(nt), sucmass, /nodata, $
   position=[.3, .2, .95, .9], $
   xtitle = '', xrange=[0,nt], xstyle=1, $
   xticks = nticks, $
   xminor = 2, $
   xthick=6, ythick=6, $
   xtickname = xtickn, $
   ytitle = 'Sea salt column loading [Tg]', yrange=[0,20]
  oplot, indgen(nt), mxsscmass, thick=12, color=74
  oplot, indgen(nt), gsscmass, thick=12

  device, /close

end
