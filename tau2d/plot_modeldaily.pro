; Colarco, October 8, 2008
; Read in a and plot a model monthly mean AOT
  modid = 'd5_arctas_02'
  filehead = '/output/colarco/ARCTAS_REPLAY/GEOSdas-2_1_2/d5_arctas_02/tau/'
  yyyy = '2008'
  mm   = '07'
  dd   = '14'
  fileland = filehead+'/Y'+yyyy+'/M'+mm+'/' $
             +modid+'.inst2d_ext_x.total.'+yyyy+mm+dd+'_1800z.hdf'

  geolimits=[20,-150,80,-60]

; Get the satellite
  ga_getvar, fileland, 'aodtau', aotlnd, lon=lon, lat=lat, time=time, wantlev=5.5e-7

  set_plot, 'ps'
  device, file='./output/plots/'+modid+'.aodtau550.'+yyyy+mm+dd+'.ps', /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=[.05,.2,.95,.9], limit=geolimits, /noborder
   plotgrid, aotlnd, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, limit=geolimits, position = [.05,.2,.95,.9]
   xyouts, .05, .96, 'ARCTAS_REPLAY ('+yyyy+mm+dd+'_18z)', /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
