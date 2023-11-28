; Colarco, Feb. 2013
; Plot AOT from model diag files

; File you want to read
  modstr = 'c48F_aG40-base-v15'
  seastr = 'DJF'
  filedir  = '/misc/prc14/colarco/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'

; Variable wanted
  varwant = 'duem'

  nc4readvar, filewant, varwant, duem, lon=lon, lat=lat, rc=rc
print, filewant, rc
  set_plot, 'ps'
  device, file='./'+modstr+'.duem.clim.eps', $
          /color, /helvetica, font_size=12, $
          xoff=.5, yoff=.5, xsize=20, ysize=16, /encap
 !p.font=0

  geolimits=[-60,-135,60,160]
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 39
  levelArray = [.05,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
  levelarray = [1,2,5,10,15,20,25,30,40,50]
  labelArray = string(levelarray,format='(i2)')
  colorArray = [30,64,80,96,144,176,192,199,208,254]

; Scale from kg m-2 s-1 to g m-2 mon-1
  scale = 30*86400*1000.

; Season 1
  position = [.05,.55,.45,.9]
  map_set, /noborder, position=position, limit=geolimits
  plotgrid, duem*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-110,-42,-42,-110,-110], [35,35,55,55,35], color=255
  xyouts, -76, 40, align=.5, '!4'+seastr+'!3', charsize=1.5


; Season 2
  seastr = 'MAM'
  filedir  = '/misc/prc14/colarco/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  nc4readvar, filewant, varwant, duem, lon=lon, lat=lat, rc=rc
print, filewant, rc
  position = [.55,.55,.95,.9]
  map_set, /noerase, /noborder, position=position, limit=geolimits
  plotgrid, duem*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-110,-42,-42,-110,-110], [35,35,55,55,35], color=255
  xyouts, -76, 40, align=.5, '!4'+seastr+'!3', charsize=1.5

; Season 3
  seastr = 'JJA'
  filedir  = '/misc/prc14/colarco/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  nc4readvar, filewant, varwant, duem, lon=lon, lat=lat, rc=rc
print, filewant, rc
  position = [.05,.12,.45,.47]
  map_set, /noerase, /noborder, position=position, limit=geolimits
  plotgrid, duem*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-110,-42,-42,-110,-110], [35,35,55,55,35], color=255
  xyouts, -76, 40, align=.5, '!4'+seastr+'!3', charsize=1.5

; Season 4
  seastr = 'SON'
  filedir  = '/misc/prc14/colarco/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  nc4readvar, filewant, varwant, duem, lon=lon, lat=lat, rc=rc
print, filewant, rc

  position = [.55,.12,.95,.47]
  map_set, /noerase, /noborder, position=position, limit=geolimits
  plotgrid, duem*scale, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position=position, limit=geolimits
  map_grid, /box, charsize=.8
  polyfill, [-110,-42,-42,-110,-110], [35,35,55,55,35], color=255
  xyouts, -76, 40, align=.5, '!4'+seastr+'!3', charsize=1.5

  xyouts, .5, .95, align=.5, 'Climatological Seasonal Dust Emissions [g m!E-2!N mon!E-1!N]', /normal, charsize=1.5

   makekey, .15, .04, .7, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

   device, /close


end
