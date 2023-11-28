; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = 'dRA_arctas'
  nymd = '20080406'
  nhms = '210000'
  geolimits = [20,-240,90,-60]
;  geolimits = [-10,30,60,140]
  varwant = ['duexttau','suexttau','ssexttau','bcexttau','ocexttau']

  filetemplate = '/misc/prc14/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
                 expid+'.inst2d_hwl_x.%y4%m2%d2_%h200z.nc4' 
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotsat, /sum, lon=lon, lat=lat, lev=lev

  set_plot, 'ps'
  datestr = nymd+'_'+strpad(string(nhms/10000L,format='(i2)'),10)+'z'
  device, file='./output/plots/'+expid+'.aodtau550.'+datestr+'.ps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=20, ysize=16
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

p0lon = 0.
if(geolimits[1] lt -180. or geolimits[2] gt 180) then p0lon=180

   map_set, 0, p0lon, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, 0, p0lon, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   titlestr = 'GEOS-5 AOT [550 nm] ('+datestr+')'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
