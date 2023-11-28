; Plot satellite, model, model-satellite
  pro seasonplot, satellite, model, lon, lat, dx, dy

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   position = [.1,.25,.9,.9]
   map_set, /noborder, limit=[0,270,40,359], position=position
   plotgrid, satellite, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, limit=[0,270,40,359], position=position
;   xyouts, position[0,0], position[3,0]+.03, 'MODIS', /normal, charsize=.8
;   xyouts, position[0,0], position[3,0]+.06, season[iseas], /normal
   map_grid, /box, charsize=.8
   makekey, .1, .1, .8, .05, 0, -.035, color=colorarray, label=labelarray, $
    align=0, charsize=.65
   axisplot, satellite, lon, lat, 2

   position = [.1,.25,.9,.9]
   map_set, /noborder, limit=[0,270,40,359], position=position
   plotgrid, model, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, limit=[0,270,40,359], position=position
;   xyouts, position[0,0], position[3,0]+.03, 'MODIS', /normal, charsize=.8
;   xyouts, position[0,0], position[3,0]+.06, season[iseas], /normal
   map_grid, /box, charsize=.8
   makekey, .1, .1, .8, .05, 0, -.035, color=colorarray, label=labelarray, $
    align=0, charsize=.65
   axisplot, model, lon, lat,0

   colorArray = [64,80,96,144,176,255,192,199,208,254,10]
   position = [.1,.25,.9,.9]
   map_set, /noborder, limit=[0,270,40,359], position=position
   levelarray = [-5,-.25,-.2,-.15,-.1,-.05]
   plotgrid, model-satellite, levelarray, colorarray[0:5], lon, lat, dx, dy, undef=!values.f_nan 
   levelarray = [.05,.1,.15,.2,.25]
   plotgrid, model-satellite, levelarray, colorarray[6:10], lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, limit=[0,270,40,359], position=position
;   xyouts, position[0,0], position[3,0]+.03, 'MODIS', /normal, charsize=.8
;   xyouts, position[0,0], position[3,0]+.06, season[iseas], /normal
   map_grid, /box, charsize=.8

   levelarray = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]
   labelarray = string(levelarray,format='(f5.2)')
   labelarray[0] = ''
   makekey, .1, .1, .8, .05, 0, -.035, color=colorarray, label=labelarray, $
    align=.5, charsize=.65
   axisplot, satellite, lon, lat,2
   axisplot, model, lon, lat,0


end
