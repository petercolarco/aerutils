  filetemplate = 'daily.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd eq '20070605')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  nc4readvar, filename, 'prs', prs, lon=lon, lat=lat
  a = where(prs gt 1e14)
  prs[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  nt = n_elements(nymd)

  for it = 0, nt-1 do begin

  plotfile = 'prs.'+nymd[it]+'.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.05,.2,.95,.9], charsize=.75, $
   title='MERRAero Surface Pressure [hPa]'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 64
  levels=[-100,600,650,700,750,800,850,900,925,950,975,1000]
  colors=reverse(findgen(12)*20)
colors=reverse(colors)
  plotgrid, prs[*,*,it], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .1, .1, .8, .05, 0, -.05, $
   colors=make_array(12,val=255), align=.5, $
   labels=[' ','600',' ','700',' ','800',' ','900',' ','950',' ','1000']
  loadct, 64
  makekey, .1, .1, .8, .05, 0, -.05, $
   labels=make_array(12,val=' '), $
   colors=colors

  device, /close
  
  endfor


end
