  filetemplate = 'v7.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[0:15]
  nymd = nymd[0:15]
  nhms = nhms[0:15]
  nc4readvar, filename, 'so2cmass', so2, lon=lon, lat=lat, lev=lev, time=time

  nt = n_elements(nymd)

  for i = 0, nt-1 do begin

  set_plot, 'ps'
  device, file='plot_so2.v7.'+nymd[i]+'.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=14, ysize=16, font_size=14
  !p.font=0

  loadct, 0
  map_set, limit=[45,150,55,170], position=[.1,.2,.9,.9]
  map_continents, /hires, /coasts, fill_continents=1, color=200

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 39
  levels = [5,10,20,50,100,200]
  colors = [64,112,160,192,208,254]
  f = 1./0.064*6.022e23/2.6867e20  ; convert kg m-2 to DU SO2
  plotgrid, so2[*,*,i]*f, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, /hires, /coasts, fill_continents=1, color=200
  map_continents, /hires, color=120, thick=3
  map_grid, /box

  plots, 153.25, 48.2, psym=sym(13)

  loadct, 39
  makekey, .15, .08, .7, .05, 0, -0.05, colors=colors, $
   labels=[5,10,20,50,100,200], align=0
  device, /close

  endfor

end

