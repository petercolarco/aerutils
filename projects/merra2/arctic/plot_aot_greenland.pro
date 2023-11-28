; Plot the monthly mean AOT over Greenland

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [.05,.1,.15,.2,.25,.3,.5]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

; Data file
  filename = '/misc/prc13/MERRA2/d5124_m2_jan10/Y2011/M07/d5124_m2_jan10.tavg1_2d_aer_Nx.monthly.201107.nc4'
  nc4readvar, filename, 'totexttau', tau, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  set_plot, 'ps'
  device, file='MERRA2.201107.ps', font_size=14, /helvetica, /color, $
   xsize=12, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  map_set, /stereo, 75, -45, /iso, limit=[55,-180,85,180], /hires, $
   position=[.05,.2,.95,.9]
  plotgrid, tau, levels, dcolors, lon, lat, dx, dy, /map
  map_continents, /hires, color=iblack
  map_grid, color=igrey, glinestyle=2, glinethick=.5

  loadct, 0
  makekey, .05, .15, .9, .03, 0, -.025, $
     color=make_array(7,val=0), $
     label=string(levels,format='(f4.2)'), $
     charsize=.7, align=0

  tvlct, red, green, blue
  makekey, .05, .15, .9, .03, 0, -.025, $
     color=dcolors[0:6], bcolor=iblack, $
     label=make_array(7,val=' ')
   

  

  device, /close

end

