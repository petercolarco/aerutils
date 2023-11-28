; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  satid = 'MYD04'
  nymd = '20090515'
  nhms = '120000'
  geolimits = [-90,-180,90,180]
  geolimits = [-10,30,60,140]
  varwant = [ 'aodtau']

  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/e/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qawt.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotocn, /sum, lon=lon, lat=lat, lev=lev
  aotocn = aotocn[*,*,1]

  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/e/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qawt3.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotlnd, /sum, lon=lon, lat=lat, lev=lev
  aotlnd = aotlnd[*,*,1]

; Now average results together
  a = where(aotocn gt 1.e14)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 1.e14)
  aotlnd[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor


  set_plot, 'ps'
  yyyymm = string(nymd/100L,format='(i6)')
  device, file='./output/plots/'+satId+'.aodtau550.'+yyyymm+'.ps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   if(satid eq 'MYD04') then satstr = 'Aqua'
   if(satid eq 'MOD04') then satstr = 'Terra'
   titlestr = 'MODIS '+satstr+' AOT [550 nm] ('+yyyymm+')'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
