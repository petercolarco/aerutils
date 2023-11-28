; Assume surface layer
; Assume air density = 1.25 kg m-3
; variable from file is number / kg air
  rhoa = 1.25
  infile = 'gfedv2.aero_num.eta.200201clm.hdf'
  levelArray = [1,10,20,50,100,200,500,1000,2000,5000,10000.]
  labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
  colorArray = [30,64,80,96,144,176,192,199,208,254,10]
  loadct, 39

  set_plot, 'ps'
  device, file='gfedv2.aero_num.sfc.2002clm.ps', /helvetica, font_size=16, $
          /color, /landscape, yoff=26, xoff=.5, xsize=25, ysize=18
  !p.font=0

  !P.multi=[0,3,2]
  ga_getvar, infile, 'so4', var, lon=lon, lat=lat, lev=lev, wantlev=[976.6]
  so4 = var*rhoa/1.e6  ; number cm-3
  check, so4
  map_set, /noborder, title='sulfate'
  plotgrid, so4, levelarray, colorarray, lon, lat, 1.25, 1, /map
  !P.multi=[0,3,2]
  map_set, /noerase
  map_continents, thick=3

  ga_getvar, infile, 'du001', var, lon=lon, lat=lat, lev=lev, wantlev=[976.6]
  du = var*rhoa/1.e6  ; number cm-3
  check, du
  !P.multi=[5,3,2]
  map_set, /noborder, /noerase, title='dust'
  plotgrid, du, levelarray, colorarray, lon, lat, 1.25, 1, /map
  !P.multi=[5,3,2]
  map_set, /noerase
  map_continents, thick=3

  ga_getvar, infile, 'ss', var, lon=lon, lat=lat, lev=lev, $
   wantlev=[976.6], /template, /sum
  ss = var*rhoa/1.e6  ; number cm-3
  check, ss
  !P.multi=[4,3,2]
  map_set, /noborder, /noerase, title='seasalt'
  plotgrid, ss, levelarray, colorarray, lon, lat, 1.25, 1, /map
  !P.multi=[4,3,2]
  map_set, /noerase
  map_continents, thick=3

  ga_getvar, infile, 'bc', var, lon=lon, lat=lat, lev=lev, $
   wantlev=[976.6], /template, /sum
  bc = var*rhoa/1.e6  ; number cm-3
  check, bc
  !P.multi=[3,3,2]
  map_set, /noborder, /noerase, title='black carbon'
  plotgrid, bc, levelarray, colorarray, lon, lat, 1.25, 1, /map
  !P.multi=[3,3,2]
  map_set, /noerase
  map_continents, thick=3

  ga_getvar, infile, 'oc', var, lon=lon, lat=lat, lev=lev, $
   wantlev=[976.6], /template, /sum
  oc = var*rhoa/1.e6  ; number cm-3
  check, oc
  !P.multi=[2,3,2]
  map_set, /noborder, /noerase, title='organic carbon'
  plotgrid, oc, levelarray, colorarray, lon, lat, 1.25, 1, /map
  !P.multi=[2,3,2]
  map_set, /noerase
  map_continents, thick=3

  xyouts, .68, .4, 'gfedv2.aero_num.eta.2002clm', /normal
  xyouts, .68, .35, '"sub-micron" aerosol number !Cconcentration [cm-3]', /normal

  labelarray = ['1','10','20','50','100','200','500','1000','2000','5000','10000']
  makekey, .68, .2, .32, .05, 0, -0.025, color=colorarray, $
   label=labelarray, align=0, charsize=.5

  device, /close

end
