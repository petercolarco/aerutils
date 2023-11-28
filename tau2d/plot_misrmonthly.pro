; Colarco, October 8, 2008
; Read in MISR sampled to plot a monthly mean AOT
  modid = 'MISR_L2'
  filehead = '/misc/prc10/MISR/Level3/d/GRITAS/'
  yyyy = '2009'
  mm   = '07'
  filemod = filehead+'/Y'+yyyy+'/M'+mm+'/' $
            +modid+'.aero_F12_0022.noqawt.subpoint.'+yyyy+mm+'.nc4'


; Mask file
  ga_getvar, '../data/d/ARCTAS.region_mask.x540_y361.2008.nc', $
             'region_mask', mask, lon=lon, lat=lat


; Get the satellite
  ga_getvar, filemod, 'aodtau', aotmod, lon=lon, lat=lat, time=time, wantlev=550
  a = where(aotmod gt 100 or mask gt 0)
  if(a[0] ne -1) then aotmod[a] = !values.f_nan

  set_plot, 'ps'
  outfile ='./output/plots/'+modid+'.aodtau550.misr.subpoint.'+yyyy+mm+'.ps'
  device, file=outfile, /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5', $
                 '0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   geolimit = [-70,-180,80,180]
   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimit
   plotgrid, aotmod, levelarray, colorarray, lon, lat, dx, dy, $
             undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimit
   titlestr = 'MISR Terra AOT [550 nm] ('+yyyy+'/'+mm+')'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
