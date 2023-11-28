; Make plots of the dust AOD from the BSC group
  index = 24 ; 24 hour forecast from the dates indicated

  yyyymmddhh = '2020062300'
  yyyymmdd = strmid(yyyymmddhh,0,8)

  nmem = 7

  while(long(yyyymmdd) le 20200623L) do begin
   print, yyyymmdd

   for imem = 0, nmem-1 do begin
index = 0
    read_icap, yyyymmdd, 'dust_aod', index, imem, lon, lat, aod, rc=rc

    case imem of
     0: model = 'CAMS'
     1: model = 'GEOS'
     2: model = 'NAAPS'
     3: model = 'MASINGAR'
     4: model = 'NGAC'
     5: model = 'MONARCH'
     6: model = 'UKMO'
    endcase

    if(rc ne 1) then begin
print, imem, model
;   Make a plot
    set_plot, 'ps'
    device, file='plot_icap_models_aod.'+model+'.'+yyyymmdd+'.ps', $
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

    xyouts, .5, 0.95, yyyymmdd, align=.5, /normal, chars=1.5

    device, /close
 
    endif
 
   endfor

   yyyymmddhh = incstrdate(yyyymmddhh,24)
   yyyymmdd = strmid(yyyymmddhh,0,8)

  endwhile

end
