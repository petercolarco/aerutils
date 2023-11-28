; Colarco, October 8, 2008
; Read in a and plot a model monthly mean AOT
  modid = 'd5_arctas_02'
  filehead = '/misc/prc10/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/tau/'
  yyyy = '2008'
  mm   = '06'
  dd   = '30'
  fileland = filehead+'/Y'+yyyy+'/M'+mm+'/' $
             +modid+'.inst2d_ext_x.'+yyyy+mm+dd+'_1800z.hdf'

  geolimits=[45,-140,70,-90]

; Get the satellite
;  ga_getvar, fileland, ['bcPhilic','bcPhobic','ocPhilic','ocPhobic'], aotlnd, lon=lon, lat=lat, time=time
  ga_getvar, fileland, ['du001','so4','bcPhilic','bcPhobic','ocPhilic','ocPhobic'], aotlnd, lon=lon, lat=lat, time=time
;  ga_getvar, fileland, 'du', aotlnd, lon=lon, lat=lat, time=time, /template
;  ga_getvar, fileland, 'so4', aotlnd, lon=lon, lat=lat, time=time

  set_plot, 'ps'
  device, file='./output/plots/'+modid+'.finemodetau550.'+yyyy+mm+dd+'.ps', /color, /helvetica, font_size=14, $
           xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.05,.1,.15,.2,.25,.3,.4,.5,.7,1.]
   labelArray = ['0','0.05','0.1','0.15','0.2','0.25','0.3','0.4','0.5','0.7','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=[.05,.2,.95,.9], limit=geolimits, /noborder
   plotgrid, aotlnd, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, limit=geolimits, position = [.05,.2,.95,.9]
   xyouts, .05, .96, 'ARCTAS_REPLAY 550 nm Fine-mode AOD ('+yyyy+mm+dd+'_18z)', /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .03, 0, -.035, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
