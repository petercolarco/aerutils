; Colarco, Feb. 2008
; Plot a climatology of the MODIS AOT over the ocean

; Make use of existing aerosols
; Create a temporary ddf
  openw, lun, 'qawt.ddf', /get_lun
  printf, lun, 'dset /output/colarco/MODIS/Level3/MOD04/c/GRITAS/Y%y4/M%m2/'+ $
               'MOD04_L2_ocn.aero_005.qawt.%y4%m2.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 7 linear 12z15jul2000 1yr'
  free_lun, lun

  openw, lun, 'qafl.ddf', /get_lun
  printf, lun, 'dset /output/colarco/MODIS/Level3/MOD04/c/GRITAS/Y%y4/M%m2/'+ $
               'MOD04_L2_ocn.aero_005.qafl.%y4%m2.hdf'
  printf, lun, 'options template'
  printf, lun, 'tdef time 7 linear 12z15jul2000 1yr'
  free_lun, lun


; And get the MODIS data
  ga_getvar, 'qawt.ddf', 'aodtau', aodtau, wanttime=['200007','200607'], $
   lon=lon, lat=lat, wantlev='550'
  ga_getvar, 'qafl.ddf', 'finerat', finerat, wanttime=['200007','200607'], $
   lon=lon, lat=lat
  a = where(aodtau gt 1.e14)
  aodtau[a] = !values.f_nan
  a = where(finerat gt 1.e14)
  finerat[a] = !values.f_nan

; Shift the lons/lat
  a = where(lon ge 180)
  lon[a] = lon[a]-360.
  nx = n_elements(lon)
  ny = n_elements(lat)
  lon = shift(lon,nx/2)
;  aodtau = shift(aodtau,nx/2,0,0)
  finerat = shift(finerat,nx/2,0,0)
  
; average
  aodtau_ = fltarr(nx,ny)
  aodtaufn_ = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    aodtau_[ix,iy] = mean(aodtau[ix,iy,*],/nan)
    aodtaufn_[ix,iy] = mean((1.-finerat[ix,iy,*])*aodtau[ix,iy,*],/nan)
   endfor
  endfor


  set_plot, 'ps'
  device, file='./output/plots/mod04.july_clim.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=16, ysize=14
  !p.font=0


   dx = 1.25
   dy = 1.

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, limit=[-20,-120,50,0], position=[.05,.2,.95,.9], /noborder
   plotgrid, aodtau_, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, limit=[-20,240,50,360], /noerase, position = [.05,.2,.95,.9]
   xyouts, .05, .96, 'MODIS July 2000 - 2006 AOD 550nm Climatology', /normal
   map_grid, /box, charsize=.8

   makekey, .05, .1, .9, .025, 0, -.035, color=colorarray, label=labelarray, $
    align=0

   device, /close


  set_plot, 'ps'
  device, file='./output/plots/mod04.finerat.july_clim.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=16, ysize=14
  !p.font=0


   dx = 1.25
   dy = 1.

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, limit=[-20,-120,50,0], position=[.05,.2,.95,.9], /noborder
   plotgrid, aodtaufn_, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, limit=[-20,240,50,360], /noerase, position = [.05,.2,.95,.9]
   xyouts, .05, .96, 'MODIS Coarse July 2000 - 2006 AOD 550nm Climatology', /normal
   map_grid, /box, charsize=.8

   makekey, .05, .1, .9, .025, 0, -.035, color=colorarray, label=labelarray, $
    align=0

   device, /close


end
