    spawn, 'echo ${BASEDIRAER}', basedir
    nx = 288
    ny = 181
    maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
    ga_getvar, maskfile, 'COMASK', mask, lon=lon, lat=lat
    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0

  wlon = 110
  xfrac = (180. - wlon)/360.
  xsize= 25 + xfrac*25.
  set_plot, 'ps'
  device, file='output/plots/regions.ps', color=color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=xsize, ysize=15
  !p.font=0

  loadct, 0
  map_set, 0, wlon-180., /mercator, $
   position=[.025,.15,.025+(1.-xfrac)*.95,.995], /noborder
; North America
  plotgrid, mask, [1,1.1], [140,255], lon, lat, 1.25, 1., /map
; South America
  plotgrid, mask, [2,2.1], [100,255], lon, lat, 1.25, 1., /map
; Africa
  plotgrid, mask, [5,5.1], [180,255], lon, lat, 1.25, 1., /map
; Europe
  plotgrid, mask, [3,3.1], [80,255], lon, lat, 1.25, 1., /map
; Asia
  plotgrid, mask, [4,4.1], [220,255], lon, lat, 1.25, 1., /map
  map_continents, thick=3, /hires

  makekey, .2, .075, .6, .05, .06, .02, $
   color=[140,100,80,180,220], label=['North America',$
   'South America', 'Eruope', 'Africa', 'Asia'], align=.5

; regions
  plots, [110,150],[45,45], thick=3
  plots, [30,110],[45,45], thick=3
  plots, [100,100], [0,45], thick=3
  plots, [10,45], [0,0], thick=3
  xyouts, -10, 20, 'Northern Africa'
  xyouts, 15, -15, 'Southern!CAfrica'
  plots, [-100,-100], [23,50], thick=3
  plots, [-130,-100], [50,50], thick=3
  plots, [-115,-100], [28,28], thick=3
  plots, [-100,-60], [50,50], thick=3
  plots, [-100,-90], [23,23], thick=3
  xyouts, -95, 43, 'Eastern!CUnited!CStates'
  xyouts, -101, 43, 'Western!CUnited!CStates', align=1

; oceans
  plots, [-50,-50],[10,30], thick=3, lin=2
  xyouts, -45, 20, 'Tropical!CN. Atlantic'
  xyouts, -52, 24, 'Caribbean', align=1
  plots, [20,20],[-40,-60], thick=3, lin=2
  plots, [-70,-70],[-60,-55], thick=3, lin=2
  plots, [-55,-10],[10,10], thick=3, lin=2
  xyouts, -25, -35, 'Southern!CAtlantic', align=.5
  plots, [110,180], [-60,-60], thick=3, lin=2
  plots, [180,360], [-60,-60], thick=3, lin=2
  plots, [0,110], [-60,-60], thick=3, lin=2
  xyouts, -25, -67, 'Southern Ocean', align=.5
  plots, [-80,-10],[30,30], thick=3,lin=2
  plots, [-60,5],[60,60], thick=3,lin=2
  xyouts, -32, 45, 'Northern!CAtlantic', align=.5
  plots, [-110,-110],[-60,25], thick=3,lin=2
  plots, [120,180], [10,10], thick=3,lin=2
  plots, [180,280],[10,10], thick=3,lin=2
  plots, [120,120], [-60,-35], thick=3,lin=2
  plots, [120,120], [-20,10], thick=3,lin=2
  xyouts, 185, -30, 'Southwestern Pacific', align=.5
  xyouts, -108, -30, 'Southeastern!CPacific'
  plots, [150,180], [60,60], thick=3,lin=2
  plots, [180,190], [60,60], thick=3,lin=2
  xyouts, 185, 40, 'Northern Pacific', align=.5

  map_set, 0, wlon+(180.-wlon)/2., /noerase, limit=[-80,wlon,80,180], /mercator, $
   position=[.025+(1.-xfrac)*.95,.15,.975,.995], /noborder
; North America
  plotgrid, mask, [1,1.1], [100,255], lon, lat, 1.25, 1., /map
; South America
  plotgrid, mask, [2,2.1], [140,255], lon, lat, 1.25, 1., /map
; Africa
  plotgrid, mask, [5,5.1], [180,255], lon, lat, 1.25, 1., /map
; Europe
  plotgrid, mask, [3,3.1], [80,255], lon, lat, 1.25, 1., /map
; Asia
  plotgrid, mask, [4,4.1], [220,255], lon, lat, 1.25, 1., /map
  map_continents, thick=3, /hires
  plots, [30,150],[45,45], thick=3
  xyouts, 100, 60, 'Northern Asia', align=.5
  xyouts, 105, 35, 'Southeastern!CAsia', align=0
  xyouts, 95, 35, 'Southwestern!CAsia', align=1
  plots, [-100,-100], [23,50], thick=3
  plots, [-130,-100], [50,50], thick=3
  plots, [-115,-100], [28,28], thick=3
  plots, [-100,-60], [50,50], thick=3
  plots, [-100,-90], [23,23], thick=3
;  xyouts, -95, 43, 'Eastern!CUnited!CStates'
;  xyouts, -101, 43, 'Western!CUnited!CStates', align=1
  plots, [110,180], [-60,-60], thick=3, lin=2
  plots, [120,120], [-60,-35], thick=3,lin=2
  plots, [120,120], [-20,10], thick=3,lin=2
  xyouts, 80, -35, 'Indian Ocean', align=.5

  device, /close

end
