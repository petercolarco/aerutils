; target date to make plots for
  tyyyymmddhh = '2020062300'
  tyyyymmdd = strmid(tyyyymmddhh,0,8)

  dayslead = [0,1,2,3,4,5]

  for id = 0, n_elements(dayslead)-1 do begin
   yyyymmddhh = incstrdate(tyyyymmddhh,-24*dayslead[id])
   yyyymmdd = strmid(yyyymmddhh,0,8)
   print, yyyymmdd
   index = 4*dayslead[id]
   ii = string(dayslead[id]*24,format='(i03)')
   read_icapmme, yyyymmdd, 'dust_aod_mean', index, lon, lat, aod

;  Make a plot
   set_plot, 'ps'
   device, file='icapmme_aod.forecast.'+tyyyymmdd+'.'+yyyymmdd+'+'+ii+'.ps', $
    /color, /helvetica, font_size=12, xsize=24, ysize=16
   !p.font=0
   red   =[  0,  0,  0,  0,255,255,255,255,220]
   green =[  0,  0,128,255,255,128,  0,  0,188]
   blue  =[  0,255,255,  0,  0,  0,  0,255,128]
   tvlct, red, green, blue
   dcolors = indgen(n_elements(red))

   map_set, limit=[0,-100,60,40], $
    position=[0.05,0.2,0.95,0.9]
   map_continents, /hires, $
    fill_continents=1, color=8

   levels=[0.1,0.2,0.4,0.8,1.2,2.5,5]

   contour, /overplot, aod, lon, lat, /cell, c_colors=indgen(7)+1, levels=levels

   makekey, .1,.1,.8,.05, $
    0, -0.035, colors=indgen(7)+1, $
    labels=string(levels,format='(f3.1)'), align=0, charsize=1.2
   map_set, limit=[0,-100,60,40], /noerase, $
    position=[0.05,0.2,0.95,0.9], /cont, /hires
   map_continents, /countries
   map_grid, /box

   xyouts, .5, 0.95, tyyyymmdd+'.'+yyyymmdd+'+'+ii, align=.5, /normal, chars=1.5

   device, /close

  endfor

end
