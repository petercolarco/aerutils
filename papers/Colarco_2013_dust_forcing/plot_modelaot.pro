; Colarco, Feb. 2013
; Plot AOT from model diag files

; File you want to read
  modstr = 'b_F25b9-base-v1'
  seastr = 'DJF'
  filedir  = '/Volumes/bender/prc14/colarco/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'

; Variable wanted
  varwant = 'duexttau'

  nc4readvar, filewant, varwant, duexttau, lon=lon, lat=lat

  set_plot, 'ps'
  device, file='./'+modstr+'.duexttau.clim.eps', $
          /color, /helvetica, font_size=12, $
          xoff=.5, yoff=.5, xsize=20, ysize=16, /encap
 !p.font=0

  geolimits=[-60,-135,60,160]
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 39
   levelArray = [.05,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   levelarray = [.05,.1,.15,.2,.25,.3,.4,.5,.6,.75]
   labelArray = ['0.05','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   labelArray = ['0.05','0.10','0.15','0.20','0.25','0.30','0.40','0.50','0.60','0.75']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]
   colorArray = [30,64,80,96,144,176,192,199,208,254]

  scale = 1.

; Season 1
  position = [.05,.55,.45,.9]
  map_set, /noborder, position=position, limit=geolimits
  plotgrid, duexttau*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-130,-62,-62,-130,-130], [35,35,55,55,35], color=255
  xyouts, -96, 40, align=.5, '!4'+seastr+'!3', charsize=1.5


; Season 2
  seastr = 'MAM'
  filedir  = '/Volumes/bender/prc14/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  nc4readvar, filewant, varwant, duexttau, lon=lon, lat=lat
  position = [.55,.55,.95,.9]
  map_set, /noerase, /noborder, position=position, limit=geolimits
  plotgrid, duexttau*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-130,-62,-62,-130,-130], [35,35,55,55,35], color=255
  xyouts, -96, 40, align=.5, '!4'+seastr+'!3', charsize=1.5

; Season 3
  seastr = 'JJA'
  filedir  = '/Volumes/bender/prc14/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  nc4readvar, filewant, varwant, duexttau, lon=lon, lat=lat
  position = [.05,.12,.45,.47]
  map_set, /noerase, /noborder, position=position, limit=geolimits
  plotgrid, duexttau*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-130,-62,-62,-130,-130], [35,35,55,55,35], color=255
  xyouts, -96, 40, align=.5, '!4'+seastr+'!3', charsize=1.5

; Season 4
  seastr = 'SON'
  filedir  = '/Volumes/bender/prc14/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  nc4readvar, filewant, varwant, duexttau, lon=lon, lat=lat
  position = [.55,.12,.95,.47]
  map_set, /noerase, /noborder, position=position, limit=geolimits
  plotgrid, duexttau*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-130,-62,-62,-130,-130], [35,35,55,55,35], color=255
  xyouts, -96, 40, align=.5, '!4'+seastr+'!3', charsize=1.5

  xyouts, .5, .95, align=.5, 'Climatological Seasonal Dust AOT [550 nm]', /normal, charsize=1.5

   makekey, .15, .04, .7, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

   device, /close


end
