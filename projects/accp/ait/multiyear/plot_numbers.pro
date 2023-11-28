  restore, file='numbers.sav'

  lon = lon0[0:359]+.5
  lat = lat0[0:179]+.5
  dx = 1
  dy = 1

  out = ['n45','n50','n55','n60','n65', $
         'w45','w50','w55','w60','w65']

  for i = 0, 9 do begin
  
  case i of
   0: var = n1_n45
   1: var = n1_n50
   2: var = n1_n55
   3: var = n1_n60
   4: var = n1_n65
   5: var = n1_w45
   6: var = n1_w50
   7: var = n1_w55
   8: var = n1_w60
   9: var = n1_w65
  endcase

  set_plot, 'ps'
  device, file='num.'+out[i]+'.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=16
  !p.font=0

  map_set, position=[.05,.2,.95,.95]
  loadct, 39
  levels = [100,200,500,1000,2000,5000,10000,20000]
  colors = findgen(8)*30+30
  plotgrid, var, levels, colors, lon, lat, dx, dy, /map
  map_continents, thick=3

  makekey,.1,.1,.8,.05,0,-.035,colors=colors,labels=string(levels), align=0

  device, /close

  endfor

end

