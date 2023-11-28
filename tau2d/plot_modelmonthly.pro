; Colarco, October 8, 2008
; Read in a MODIS sampled model "ocn" and "lnd" file and merge to plot a monthly mean AOT
  modid = 'e530_yotc_01'
  filehead = '/misc/prc10/GEOS5.0/e530_yotc_01/das/'
  yyyy = '2009'
  mm   = '07'
  filemod = filehead+'/Y'+yyyy+'/M'+mm+'/' $
;            +modid+'.tavg3_2d_aer_Cx.aero_tc8_005.modis.MOD04_L2_ocn.aero_tc8_005.qawt.'+yyyy+mm+'.nc4'
;            +modid+'.tavg3_2d_aer_Cx.aero_tc8_005.shift.subpoint.obs_22.MOD04_L2_ocn.aero_005.qawt.'+yyyy+mm+'.nc4'
            +modid+'.tavg3_2d_aer_Cx.aero_F12_0022.misr_subpoint.MISR_L2.aero_F12_0022.noqawt.'+yyyy+mm+'.nc4'


; Mask file
  ga_getvar, '../data/d/ARCTAS.region_mask.x540_y361.2008.nc', 'region_mask', mask, lon=lon, lat=lat

; Get the satellite
  ga_getvar, filemod, 'aodtau', aotmod, lon=lon, lat=lat, time=time, wantlev=5.5e-7

  a = where(aotmod gt 100 or mask gt 0)
  if(a[0] ne -1) then aotmod[a] = !values.f_nan

  set_plot, 'ps'
;  device, file='./output/plots/'+modid+'.aodtau550.modis.'+yyyy+mm+'.ps', /color, /helvetica, font_size=14, $
;  device, file='./output/plots/'+modid+'.aodtau550.shift.subpoint.obs_22.'+yyyy+mm+'.ps', $
  device, file='./output/plots/'+modid+'.aodtau550.misr_subpoint.'+yyyy+mm+'.ps', $
           /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   geolimit = [-70,-180,80,180]
   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimit
   plotgrid, aotmod, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimit
   titlestr = 'GEOS-5 AOT [550 nm] ('+yyyy+'/'+mm+')'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
