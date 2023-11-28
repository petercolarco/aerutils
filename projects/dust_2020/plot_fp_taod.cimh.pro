; Make plots of the dust AOD from the BSC group
  index = 144 ; 24 hour forecast from the dates indicated

  yyyymmddhh = '2020061800'

  yyyymmdd = strmid(yyyymmddhh,0,8)

  while(long(yyyymmdd) le 20200618L) do begin
   print, yyyymmdd
   read_fp, yyyymmdd, 'totexttau', index, lon, lat, aod

;  Make a plot
   set_plot, 'ps'
   device, file='fp_taod.cimh.'+yyyymmdd+'.+'+string(index*1,format='(i03)')+'.ps', $
    /color, /helvetica, font_size=12, xsize=30, ysize=12
   !p.font=0
   red   =[  0,  0,  0,  0,255,255,255,255,220]
   green =[  0,  0,128,255,255,128,  0,  0,188]
   blue  =[  0,255,255,  0,  0,  0,  0,255,128]
   tvlct, red, green, blue
   dcolors = indgen(n_elements(red))

;  hack to fit the forecast date as the plot title
   yyyymmddhh = incstrdate(yyyymmddhh,index)
   yyyymmdd = strmid(yyyymmddhh,0,8)

   map_set, limit=[0,-95,35,60], $
    position=[0.05,0.2,0.95,0.9]
   map_continents, /hires, $
    fill_continents=1, color=8

   loadct, 33
   levels=[.1,.2,.3,.4,.5,.6,.7,.8,.9,.95,1,1.2,1.5]
   colors=[16,32,48,64,80,96,112,128,144,160,176,224,240]
   contour, /overplot, aod, lon, lat, /cell, c_colors=colors, levels=levels

   loadct, 0
   makekey, .1,.1,.8,.05, $
    0, -0.035, colors=colors, $
    labels=string(levels,format='(f4.2)'), align=0, charsize=1.2
   loadct, 33
   makekey, .1,.1,.8,.05, $
    0, -0.035, colors=colors, $
    labels=make_array(n_elements(levels),val=' '), align=0, charsize=1.2

   loadct, 0
   map_set, limit=[0,-95,35,60], /noerase, $
    position=[0.05,0.2,0.95,0.9], /cont, /hires
   map_continents, /countries
   map_continents, thick=8, color=0
   map_grid, /box, color=0

;   xyouts, .5, 0.95, yyyymmdd, align=.5, /normal, chars=1.5
   str = '00Z '+strmid(yyyymmdd,6,2)+'/06 2020'
   xyouts, .5, 0.95, 'Total Aerosol Optical Depth Valid '+str, align=.5, /normal, chars=1.5, color=0

   device, /close

  endwhile

end
