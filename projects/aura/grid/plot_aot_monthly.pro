  filetemplate = 'monthly.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  nt = n_elements(nymd)

  for it = 0, nt-1 do begin

  plotfile = 'aot.'+strmid(nymd[it],0,6)+'.monthly.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,80,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], title='MERRAero '+strmid(nymd[it],0,6)
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 65
  levels=findgen(7)*.2+.2
  colors=15+findgen(7)*40
  plotgrid, aot[*,*,it], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(7,val=255), $
   labels=['0.2','0.4','0.6','0.8','1','1.2','1.4']
  loadct, 65
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors

  device, /close
  
  endfor


end
