  expid = 'b_F25b9-base-v1'
  filename = '/misc/prc14/colarco/'+expid+'/geosgcm_surf/'+ $
             expid+'.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filename, 'u10m', u10m, lon=lon, lat=lat
  nc4readvar, filename, 'v10m', v10m, lon=lon, lat=lat
  nc4readvar, filename, 'frocean', frocean, lon=lon, lat=lat

  w10m = sqrt(u10m*u10m + v10m*v10m)

  a = where(frocean gt .9)
  w10m[a] = !values.f_nan

  set_plot, 'ps'
  device, file=expid+'.sfc_wind.ps', /helvetica, font_size=12, $
          xs=12, ys=12, xoff=.5, yoff=.5, /color
  !p.font=0

  map_set, limit=[0,-20,45,45], position=[.05,.15,.95,.95]
  loadct, 39
  level = findgen(8)
  color = [20,40,80,120,160,200,220,254]
;  plotgrid, w10m, level, color, lon, lat, 2.5, 2., /map
  contour, /over, w10m, lon, lat, level=level, /cell, c_color=color
  map_continents, /countr
  map_continents, thick=3
  map_grid, /box

  makekey, .05, .05, .9, .05, 0, -.035, align=0, $
           label=string(level,format='(i1)'), color=color

  device, /close  
  w10m_orig = w10m



; Perturbation
  expid = 'bF_F25b9-base-v11'
  filename = '/misc/prc14/colarco/'+expid+'/geosgcm_surf/'+ $
             expid+'.geosgcm_surf.monthly.clim.JJA.nc4'
  nc4readvar, filename, 'u10m', u10m, lon=lon, lat=lat
  nc4readvar, filename, 'v10m', v10m, lon=lon, lat=lat
  nc4readvar, filename, 'frocean', frocean, lon=lon, lat=lat

  w10m = sqrt(u10m*u10m + v10m*v10m)

  a = where(frocean gt .9)
  w10m[a] = !values.f_nan

  set_plot, 'ps'
  device, file=expid+'.sfc_wind.ps', /helvetica, font_size=12, $
          xs=12, ys=12, xoff=.5, yoff=.5, /color
  !p.font=0

  map_set, limit=[0,-20,45,45], position=[.05,.15,.95,.95]
  loadct, 39
  level = findgen(8)
  color = [20,40,80,120,160,200,220,254]
;  plotgrid, w10m, level, color, lon, lat, 2.5, 2., /map
  contour, /over, w10m, lon, lat, level=level, /cell, c_color=color
  map_continents, /countr
  map_continents, thick=3
  map_grid, /box

  makekey, .05, .05, .9, .05, 0, -.035, align=0, $
           label=string(level,format='(i1)'), color=color

  device, /close  


; Difference
  nc4readvar, '/home/colarco/sandbox/Emissions/Dust/b/gocart.dust_source.v5a.x144_y91.nc', $
              'du_src', src
  set_plot, 'ps'
  device, file=expid+'.difference_sfc_wind.ps', /helvetica, font_size=12, $
          xs=12, ys=12, xoff=.5, yoff=.5, /color
  !p.font=0

  map_set, limit=[0,-20,45,45], position=[.05,.15,.95,.95]
  loadct, 39
  level = [-10,-1.5,-1,-.5,-.1,.1,.5,1,1.5]
  color = [40,84,120,176,255,192,208,220,254]
;  plotgrid, w10m, level, color, lon, lat, 2.5, 2., /map
  contour, /over, w10m-w10m_orig, lon, lat, level=level, /cell, c_color=color
  loadct, 0
  contour, /over, src, lon, lat, level=findgen(10)*.1, color=80, c_label=[0,1,0,1,0,1,0,1,0,1]
  map_continents, /countr
  map_continents, thick=3
  map_grid, /box

  loadct, 39
  label = string(level,format='(f4.1)')
  label[0] = ' '
  makekey, .05, .05, .9, .05, 0, -.035, align=.5, $
           label=label, color=color

  device, /close  



end
