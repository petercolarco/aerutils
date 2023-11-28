; Plot the regional tag map from Dongchul Kim

  cdfid = ncdf_open('tagmap_12regions.x360_y181.nc')
  id = ncdf_varid(cdfid,'REGION_MASK')
  ncdf_varget, cdfid, id, regions
  NCDF_close, cdfid

  lon = -180.+findgen(360)
  lat =  -90.+findgen(181)
  dx  = 1.
  dy  = 1.

; Get the dust source
  filename = '/share/colarco/fvInput/AeroCom/sfc/gocart.dust_source.v5a.x1152_y721.nc'
  nc4readvar, filename, 'du_src', src, lon=lon_, lat=lat_
; Make a plot
  set_plot, 'ps'
  device, filename = 'plot_tagmap_source.ps', /color, /helvetica
  !p.font=0

  loadct, 0
  map_set, /continents, limit=[0,-20,40,60], E_CONTINENTS={FILL:1}, color=180, $
   position=[.05,.15,.95,.95], /hires


  loadct, 39
  levels = findgen(12)+.99
  colors = indgen(12)*20+15
  colors[6] = 0
  colors=[15,35,55,75,95,115,145,175,195,208,215,254]
  plotgrid, regions, levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, /countries, color=140
  map_continents, thick=3, /hires
  contour, /over, src, lon_, lat_, levels=findgen(5)*.2+.1

  loadct, 39
  makekey, .05, .075, .9, .05, 0, -.035, align=0, $
   colors=colors, labels=string(levels+.1,format='(i2)')

  device, /close
end
