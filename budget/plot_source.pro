  filedir = '/home/colarco/sandbox/Emissions/Dust/e/'
  filename = filedir + 'gocart.dust_source.v5a.x1152_y721.nc'
  nc4readvar, filename, 'du_src', src_old, lat=lat, lon=lon
  filename = filedir + 'gocart.dust_source.v6a.x1152_y721.nc'
  nc4readvar, filename, 'du_src', src_new, lat=lat, lon=lon
  geolimits=[-60,-150,50,150]

  set_plot, 'ps'
  device, file='du_src.ps', /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
  !p.font=0

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  levels = findgen(11)*.1
  levels[0] = 0.001
  xycomp, src_new, src_old, lon, lat, dx, dy, $
          levels=levels, geolimits=geolimits

  device, /close

end
