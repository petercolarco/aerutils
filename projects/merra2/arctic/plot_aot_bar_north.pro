; Colors
  red   = [0, 120, 253,   5,  35]
  green = [0, 120, 141, 112, 132]
  blue  = [0, 120,  60, 176,  67]

  iblack = 0
  igrey  = 1
  ired   = 2
  iblue  = 3
  igreen = 4

  tvlct, red, green, blue

  filename = '/misc/prc13/MERRA2/d5124_m2_jan10/Y2011/M07/d5124_m2_jan10.tavg1_2d_aer_Nx.monthly.201107.nc4'
  nc4readvar, filename, 'duexttau', dutau11, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', sutau11, lon=lon, lat=lat
  nc4readvar, filename, 'ssexttau', sstau11, lon=lon, lat=lat
  nc4readvar, filename, 'ocexttau', octau11, lon=lon, lat=lat
  nc4readvar, filename, 'bcexttau', bctau11, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  filename = '/misc/prc13/MERRA2/d5124_m2_jan10/Y2012/M07/d5124_m2_jan10.tavg1_2d_aer_Nx.monthly.201207.nc4'
  nc4readvar, filename, 'duexttau', dutau12, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', sutau12, lon=lon, lat=lat
  nc4readvar, filename, 'ssexttau', sstau12, lon=lon, lat=lat
  nc4readvar, filename, 'ocexttau', octau12, lon=lon, lat=lat
  nc4readvar, filename, 'bcexttau', bctau12, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  filename = '/misc/prc13/MERRA2/d5124_m2_jan10/Y2013/M07/d5124_m2_jan10.tavg1_2d_aer_Nx.monthly.201307.nc4'
  nc4readvar, filename, 'duexttau', dutau13, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', sutau13, lon=lon, lat=lat
  nc4readvar, filename, 'ssexttau', sstau13, lon=lon, lat=lat
  nc4readvar, filename, 'ocexttau', octau13, lon=lon, lat=lat
  nc4readvar, filename, 'bcexttau', bctau13, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  a = where(lat ge 30)

  dutau11 = total(dutau11[*,a]*area[*,a])/total(area[*,a])
  sutau11 = total(sutau11[*,a]*area[*,a])/total(area[*,a])
  sstau11 = total(sstau11[*,a]*area[*,a])/total(area[*,a])
  octau11 = total(octau11[*,a]*area[*,a])/total(area[*,a])
  bctau11 = total(bctau11[*,a]*area[*,a])/total(area[*,a])

  dutau12 = total(dutau12[*,a]*area[*,a])/total(area[*,a])
  sutau12 = total(sutau12[*,a]*area[*,a])/total(area[*,a])
  sstau12 = total(sstau12[*,a]*area[*,a])/total(area[*,a])
  octau12 = total(octau12[*,a]*area[*,a])/total(area[*,a])
  bctau12 = total(bctau12[*,a]*area[*,a])/total(area[*,a])

  dutau13 = total(dutau13[*,a]*area[*,a])/total(area[*,a])
  sutau13 = total(sutau13[*,a]*area[*,a])/total(area[*,a])
  sstau13 = total(sstau13[*,a]*area[*,a])/total(area[*,a])
  octau13 = total(octau13[*,a]*area[*,a])/total(area[*,a])
  bctau13 = total(bctau13[*,a]*area[*,a])/total(area[*,a])

  set_plot, 'ps'
  device, file='plot_aot_bar_north.ps', /helvetica, font_size=14, $
   xsize=16, ysize=12, xoff=.5, yoff=.5, /color
  !p.font=0

  plot, findgen(4), /nodata, $
   xrange=[0,7], yrange=[0,.25], $
   yticks=5, yminor=1, ystyle=9, $
   xticks=1, xminor=1, xstyle=9, xtickname=[' ',' ']
  x = 1
  y = 0
  dy = sstau11
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=iblue
  y = sstau11
  dy = dutau11
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=ired
  y = sstau11+dutau11
  dy = sutau11
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=igrey
  y = sstau11+dutau11+sutau11
  dy = octau11+bctau11
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=igreen

  x = 3
  y = 0
  dy = sstau12
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=iblue
  y = sstau12
  dy = dutau12
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=ired
  y = sstau12+dutau12
  dy = sutau12
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=igrey
  y = sstau12+dutau12+sutau12
  dy = octau12+bctau12
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=igreen

  x = 5
  y = 0
  dy = sstau13
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=iblue
  y = sstau13
  dy = dutau13
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=ired
  y = sstau13+dutau13
  dy = sutau13
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=igrey
  y = sstau13+dutau13+sutau13
  dy = octau13+bctau13
  polyfill, x+[0,1,1,0,0], y+[0,0,dy,dy,0], color=igreen

  device, /close


end
