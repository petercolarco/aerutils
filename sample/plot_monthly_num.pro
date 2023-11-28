; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

; Apply LAR derived correction factors (valid only for MYD04) for sub-sampling

  pro plot_monthly_num, satid, sample, yyyy, mm, res=res, exclude=exclude, geolimits=geolimits, geoname=geoname, inverse=inverse
print, sample
  if(not(keyword_set(res))) then res = 'd'
  area, lon, lat, nx, ny, dx, dy, area, grid = res

  case sample of
   'supermisr' : sample_title = ' Super-MISR '
   'misr1'     : sample_title = ' MISR1 '
   'misr2'     : sample_title = ' MISR2 '
   'misr3'     : sample_title = ' MISR3 '
   'misr4'     : sample_title = ' MISR4 '
   'caliop1'   : sample_title = ' CALIOP1 '
   'caliop2'   : sample_title = ' CALIOP2 '
   'caliop3'   : sample_title = ' CALIOP3 '
   'caliop4'   : sample_title = ' CALIOP4 '
   'inverse_supermisr' : sample_title = ' !Super-MISR '
   'inverse_misr1'     : sample_title = ' !MISR1 '
   'inverse_misr2'     : sample_title = ' !MISR2 '
   'inverse_misr3'     : sample_title = ' !MISR3 '
   'inverse_misr4'     : sample_title = ' !MISR4 '
   'inverse_caliop1'   : sample_title = ' !CALIOP1 '
   'inverse_caliop2'   : sample_title = ' !CALIOP2 '
   'inverse_caliop3'   : sample_title = ' !CALIOP3 '
   'inverse_caliop4'   : sample_title = ' !CALIOP4 '
   else        : sample_title = ' '
  endcase
  samplestr = '.'+sample
  if(sample_title eq ' ') then samplestr = ''

  satstr = ''
  if(satid eq 'MOD04') then satstr = 'MODIS Terra'
  if(satid eq 'MYD04') then satstr = 'MODIS Aqua'
  if(satstr eq '') then stop

  spawn, 'echo $MODISDIR', MODISDIR

  numstr = '.num'
;  numstr = ''

  read_monthly, 'MYD04', sample, yyyy, mm, aotsat, res=res, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /num


  nx = n_elements(lon)
  ny = n_elements(lat)

  relstr = ''
  excstr = ''
  if(keyword_set(exclude)) then excstr = 'exclude.'
  if(keyword_set(exclude) and keyword_set(inverse)) then excstr = 'exclude_inverse.'

  if(keyword_set(geoname)) then geoname = '.'+geoname else geoname = ''

  set_plot, 'ps'
  device, file='./output/plots/'+satId+samplestr+'.qast.'+res+numstr+'.num_monthly.'+excstr+yyyy+mm+geoname+'.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=12, ysize=10
 !p.font=0

  p0 = 0
  p1 = 0
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

  position1 = [.05,.2,.95,.9]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits
; plot missing data as light shade
  loadct, 0
  plotgrid, aotsat, [-.1], [120], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, 39
  levels = findgen(11)*50
  colors = [30,64,80,96,144,176,192,199,208,254,10]
  plotgrid, aotsat, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position1, limit=geolimits
  map_grid, /box

  title = 'MODIS Aqua'+ sample_title + '('+res+', '+yyyy+mm+')'
  if(keyword_set(exclude)) then $
   title = 'MODIS Aqua full swath excluding w/'+sample_title+'observes ('+res+', '+yyyy+mm+')'
  if(keyword_set(exclude) and keyword_set(inverse)) then $
   title = 'MODIS Aqua full swath only w/'+sample_title+'observes ('+res+', '+yyyy+mm+')'

  xyouts, .05, .95, title, /normal

  makekey, .1, .075, .8, .05, 0, -.035, color=colors, $
   align=0, label=string(levels,format='(i4)')

; Draw some boxes and print some averages
; South America
  plots, [-75,-45,-45,-75,-75], [-20,-20,0,0,-20], thick=6, color=255

; South Africa
  plots, [-15,30,30,-15,-15], [-20,-20,0,0,-20], thick=6, color=255

; Saharan dust
  plots, [-30,-15,-15,-30,-30], [10,10,30,30,10], thick=6, color=255


; Draw some boxes and print some averages
; IGP
  plots, [75,95,95,75,75], [20,20,30,30,20], thick=6, color=255

; China
  plots, [100,125,125,100,100], [25,25,42,42,25], thick=6, color=255

; SEA
  plots, [95,110,110,95,95], [10,10,25,25,10], thick=6, color=255

; Asian outflow
  plots, [135,165,165,135,135], [30,30,55,55,30], thick=6, color=255




 device, /close


end
