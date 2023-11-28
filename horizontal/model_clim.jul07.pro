; Colarco, Feb. 2008
; Plot a climatology of the MODIS AOT over the ocean

; Make use of existing aerosols
  datafile = '/Volumes/sahara_2/tc4/d5_tc4_01/das/diag/Y2007/M07/d5_tc4_01.tavg2d_aer_x.20070713_20070731.hdf'
  ga_getvar, datafile, 'duexttau', duexttau, options=' -mean', $
   lon=lon, lat=lat
  ga_getvar, datafile, 'ssexttau', ssexttau, options=' -mean', $
   lon=lon, lat=lat
  ga_getvar, 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg2d_aer_x',$
   'lwi', oro, wanttime=['1'], lon=lon, lat=lat

  a = where(oro ne 0)
  duexttau[a] = !values.f_nan
  ssexttau[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  aodtau_ = duexttau+ssexttau

; Scale the dust
  aodtau_ = duexttau/2.2 + ssexttau


  set_plot, 'ps'
  device, file='./output/plots/geos5.july07.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=16, ysize=14
  !p.font=0


   dx = .666
   dy = .5

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, limit=[-20,-120,50,0], position=[.05,.2,.95,.9], /noborder
   plotgrid, aodtau_, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, limit=[-20,240,50,360], /noerase, position = [.05,.2,.95,.9]
   xyouts, .05, .96, 'GEOS-5 July 2007 AOD 550nm', /normal
   map_grid, /box, charsize=.8

   makekey, .05, .1, .9, .025, 0, -.035, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
