  site = ['Moscow', 'Fairbanks', 'Seattle','New York','Los Angeles','New Delhi', $
          'Mexico City','Manila','Jakarta','Nairobi']
  lon0 = [37.62,-147.72,-122.33,-74.00,-118.24,77.10,-99.13,120.98,106.85,36.82]
  lat0 = [55.76,64.84,47.61,40.71,34.05,28.70,19.43,14.60,-6.21,-1.29]

  set_plot, 'ps'
  device, file='map.ps', /color, font_size=14, /helvetica, xsize=24, ysize=14
  !p.font=0

  map_set
  map_continents, /hires
  loadct, 39
  plots, lon0, lat0, psym=sym(3), symsize=2
  plots, lon0+.1, lat0+.5, psym=sym(3), symsize=1, color=254
  n = n_elements(site)
  for i = 0, n-1 do begin
   x = lon0[i]+2
   y = lat0[i]-8
print, x, y
   polyfill, [x,x+40,x+40,x,x], [y,y,y+7,y+7,y], color=255
   xyouts, x+.5, y+.5, site[i], /data
  endfor

  device, /close

end

