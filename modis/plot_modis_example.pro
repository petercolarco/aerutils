; Colarco, October 8, 2008
; Read in a MODIS "ocn" and "lnd" file and merge to plot a monthly mean AOT
  satid = 'MOD04'
  filehead = '/misc/prc10/MODIS/Level3/'+satid+'/d/GRITAS/'
  yyyy = '2002'
  mm   = '07'
  dd   = '07'
;  fileland = filehead+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2_ocn.aero_005.qawt.'+yyyy+mm+dd+'.hdf'
;  fileocn  = filehead+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2_ocn.aero_005.qawt.'+yyyy+mm+dd+'.hdf'
;  fileland = filehead+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2_ocn.aero_005.qawt.shift.misr.'+yyyy+mm+dd+'.hdf'
;  fileocn  = filehead+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2_ocn.aero_005.qawt.shift.misr.'+yyyy+mm+dd+'.hdf'

  filehead = './output/sampling/d/'
  fileland = filehead+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2_ocn.aero_005.qawt.'+yyyy+mm+dd+'.hdf'
  fileocn  = filehead+'/Y'+yyyy+'/M'+mm+'/'+satid+'_L2_ocn.aero_005.qawt.'+yyyy+mm+dd+'.hdf'

  geolimits=[30,-90,60,-40]


; Get the satellite
  ga_getvar, fileland, 'aodtau', aotlnd_, lon=lon, lat=lat, time=time, wanttime=[1,4], wantlev=550.
  ga_getvar, fileocn,  'aodtau', aotocn_, lon=lon, lat=lat, time=time, wanttime=[1,4], wantlev=550.
  a = where(aotocn_ gt 1.e14)
  aotocn_[a] = !values.f_nan
  a = where(aotlnd_ gt 1.e14)
  aotlnd_[a] = !values.f_nan
  nx = n_elements(lon)
  ny = n_elements(lat)
  aotlnd = make_array(nx,ny,val=!values.f_nan)
  aotocn = make_array(nx,ny,val=!values.f_nan)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    aotlnd[ix,iy] = mean(aotlnd_[ix,iy,0,*],/nan)
    aotocn[ix,iy] = mean(aotocn_[ix,iy,0,*],/nan)
   endfor
  endfor

; Now average results together
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor


  set_plot, 'ps'
  device, file='./output/plots/'+satId+'_shift.subpoint.aodtau550.'+yyyy+mm+dd+'.ps', /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]


   map_set, position=[.05,.2,.95,.9], limit=geolimits, /noborder
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, limit=geolimits, position = [.05,.2,.95,.9]
   xyouts, .05, .96, satid+' ('+yyyy+mm+dd+')', /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
