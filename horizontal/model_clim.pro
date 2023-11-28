; Colarco, Feb. 2008
; Plot a climatology of the MODIS AOT over the ocean

; Make use of existing aerosols
; Create a temporary ddf
  openw, lun, 'model.ddf', /get_lun
  printf, lun, 'dset /output/colarco/b32dust/diag/Y%y4/M%m2/'+ $
               'b32dust.chem_diag.sfc.%y4%m2.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 7 linear 12z15jul2000 1yr'
  free_lun, lun



; And get the MODIS data
  ga_getvar, 'model.ddf', 'duexttau', duexttau, wanttime=['200007','200607'], $
   lon=lon, lat=lat
  ga_getvar, 'model.ddf', 'ssexttau', ssexttau, wanttime=['200007','200607'], $
   lon=lon, lat=lat
  ga_getvar, 'model.ddf', 'oro', oro, wanttime=['200007','200607'], $
   lon=lon, lat=lat

  a = where(oro ne 0)
  duexttau[a] = !values.f_nan
  ssexttau[a] = !values.f_nan

; Shift the lons/lat
  a = where(lon ge 180)
  lon[a] = lon[a]-360.
  nx = n_elements(lon)
  ny = n_elements(lat)
  lon = shift(lon,nx/2)
  aodtau = shift(duexttau+ssexttau,nx/2,0,0)
  
; average
  aodtau_ = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    aodtau_[ix,iy] = mean(aodtau[ix,iy,*],/nan)
   endfor
  endfor


  set_plot, 'ps'
  device, file='./output/plots/b32dust.july_clim.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=16, ysize=14
  !p.font=0


   dx = 2.5
   dy = 2.

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, limit=[-20,-120,50,0], position=[.05,.2,.95,.9], /noborder
   plotgrid, aodtau_, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, limit=[-20,240,50,360], /noerase, position = [.05,.2,.95,.9]
   xyouts, .05, .96, 'GEOS-4 July 2000 - 2006 AOD 550nm Climatology', /normal
   map_grid, /box, charsize=.8

   makekey, .05, .1, .9, .025, 0, -.035, color=colorarray, label=labelarray, $
    align=0

   device, /close



end
