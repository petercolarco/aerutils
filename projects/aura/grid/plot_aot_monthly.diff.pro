  filetemplate = 'monthly.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  filetemplate = 'monthly.retrieval.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  nc4readvar, filename, 'aot', aotr, lon=lon, lat=lat
  a = where(aotr gt 1e14)
  aotr[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  nt = n_elements(nymd)

  for it = 0, nt-1 do begin

  plotfile = 'aot.'+strmid(nymd[it],0,6)+'.monthly.diff.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,80,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], title='MERRAero - OMAERUV '+strmid(nymd[it],0,6)
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 70
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]
  colors=reverse(15+findgen(9)*30)
  plotgrid, aot[*,*,it]-aotr[*,*,it], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(9,val=255), align=.5, $
   labels=[' ','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1']
  loadct, 70
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(9,val=' '), $
   colors=colors

  device, /close
  
  endfor


end
