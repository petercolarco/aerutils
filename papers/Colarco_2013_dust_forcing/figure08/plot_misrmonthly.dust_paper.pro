; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  satid = 'MISR'
  mm    = 'JJA'
  mon   = [' ','January','February','March','April','May','June', $
               'July','August','September','October','November','December']
  nymd = '2003'+mm+'15'
  nhms = '120000'
  nhms = '120000'
  geolimits = [-60,-180,80,180]
  geolimits = [-10,-90,40,10]
  varwant = [ 'aodtau']

  filetemplate = '/Volumes/bender/science/terra/misr/data/Level3/b/GRITAS/clim/MISR_L2.aero_tc8_F12_0022.noqawt.clim'+mm+'.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotocn, lon=lon, lat=lat, lev=lev, rc=rc
  aotocn = aotocn[*,*,1]

  filetemplate = '/Volumes/bender/science/terra/misr/data/Level3/b/GRITAS/clim/MISR_L2.aero_tc8_F12_0022.noqawt.clim'+mm+'.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotlnd, lon=lon, lat=lat, lev=lev
  aotlnd = aotlnd[*,*,1]

; Now average results together
  a = where(aotocn gt 100.)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 100.)
  aotlnd[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor


  set_plot, 'ps'
  yyyymm = string(nymd/100L,format='(i6)')
;  device, file='./output/plots/'+satId+'.aodtau550.'+yyyymm+'.ps', $
  device, file='./'+satId+'.aodtau550.JJA.eps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=20, ysize=16, /encap
 !p.font=0


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
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=geolimits
;   titlestr = 'MISR Climatological AOT [550 nm] ('+mon[mm]+', 2000 - 2011)'
   titlestr = 'MISR Climatological AOT [550 nm] (JJA, 2000 - 2011)'
   xyouts, .05, .96, titlestr,  /normal
   map_grid, /box, charsize=.8


; Some points
  usersym, [-1,0,1,0,-1]*2, [0,-1,0,1,0]*2, /fill, color=0
  plots, -59.43, 13.17, psym=8
;  plots, -80.16, 25.73, psym=8
  plots, -64.87, 32.27, psym=8
  plots, -22.935, 16.73, psym=8
  plots, -67.04, 17.97, psym=8
  plots,   5.53, 22.79, psym=8
  plots, -15.95, 23.72, psym=8
  plots, -16.32, 28.48, psym=8

  xyouts, -62, 32.25, '!4Bermuda', color=255
  xyouts, -65, 18., '!4La Parguera'
  xyouts, -57.5, 13., '!4Ragged Point'
  xyouts, -25, 17, '!4Cape Verde', align=1
  xyouts, -18, 24, '!4Dahkla', align=1
  xyouts, -18.5, 28.5, '!4Santa Cruz', align=1, color=255
  xyouts,  5, 19, '!4Tamanrasset!3', align=1

   makekey, .05, .1, .9, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
