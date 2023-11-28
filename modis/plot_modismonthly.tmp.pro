; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  satid = 'MYD04'
  yyyy  = '2007'
  mm    = '07'
  mon   = [' ','January','February','March','April','May','June', $
               'July','August','September','October','November','December']
  nymd = yyyy+mm+'15'
  nhms = '120000'
  geolimits = [-60,-180,80,180]
  geolimits = [-10,-100,60,100]
;  geolimits = [-45,-45,15,60]
  varwant = [ 'aot']

  read_modis, aotsat, lon, lat, yyyy, mm, satid=satid, res='b', /old, season='JJA'
  aotsat = reform(aotsat)

  set_plot, 'ps'
  yyyymm = string(nymd/100L,format='(i6)')
;  device, file='./output/plots/'+satId+'.aodtau550.'+yyyymm+'.ps', $
  device, file='./output/plots/'+satId+'.aodtau550.JJA.ps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=20, ysize=16
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   if(satid eq 'MYD04') then satstr = 'Aqua'
   if(satid eq 'MOD04') then satstr = 'Terra'
   titlestr = 'MODIS '+satstr+' AOT [550 nm] ('+mon[mm]+', '+yyyy+')'
   titlestr = 'MODIS '+satstr+' Climatological AOT [550 nm] (JJA, 2003 - 2011)'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
