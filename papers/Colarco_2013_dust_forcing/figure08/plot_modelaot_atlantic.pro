; Colarco, Feb. 2013
; Plot AOT from model diag files

; File you want to read
  modstr = 'bF_F25b9-base-v1'
  seastr = 'JJA'
  filedir  = '/Volumes/bender/prc14/colarco/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'

; Variable wanted
  varwant = 'duexttau'

  nc4readvar, filewant, varwant, aot, lon=lon, lat=lat

  set_plot, 'ps'
  yyyymm = 'clim'+seastr
  device, file='./'+modstr+'.duexttau.'+yyyymm+'.eps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=20, ysize=16, /encap
 !p.font=0

   geolimits=[-10,-90,40,10]

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.05,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   levelarray = [.05,.1,.15,.2,.25,.3,.4,.5,.6,.75]
   labelArray = ['0.05','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   labelArray = ['0.05','0.10','0.15','0.20','0.25','0.30','0.40','0.50','0.60','0.75']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]
   colorArray = [30,64,80,96,144,176,192,199,208,254]

   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, aot, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   titlestr = seastr + ' Dust AOT [550 nm] (OPAC-Spheres Model, climatology 2011 - 2050)'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8


  modstr = 'b_F25b9-base-v1'
  seastr = 'JJA'
  filedir  = '/Volumes/bender/prc14/'+modstr+'/tavg2d_carma_x/'
  filewant = filedir + modstr+'.tavg2d_carma_x.monthly.clim.'+seastr+'.nc4'
  varwant = 'duexttau'
  nc4readvar, filewant, varwant, aot, lon=lon, lat=lat

  contour, /overplot, aot, lon, lat, levels=levelarray, c_thick=6, c_color=[0,0,0,0,0,0,0,0,0,0,0,0], c_label=[1,1,1,1,1,1,1,1,1,1,1]


   makekey, .05, .1, .9, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

   device, /close


end
