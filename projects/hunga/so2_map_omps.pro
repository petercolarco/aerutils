  file_id = H5F_OPEN('NMSO2-PCA-L2_VOLSO2_gridded_20220122_Tonga.h5')
  var_id = h5d_open(file_id,'OMPS_SO2_Gridded/Latitude_Center')
  lat = h5d_read(var_id)
  var_id = h5d_open(file_id,'OMPS_SO2_Gridded/Longitude_Center')
  lon = h5d_read(var_id)
  var_id = h5d_open(file_id,'OMPS_SO2_Gridded/SO2_STL')
  so2 = h5d_read(var_id)
;  H5F_CLOSE(file_id)

; SO2 kg m-2 to DU
;  so2 = so2/(0.064)*6.022e23/2.687e20

  set_plot, 'ps'
  device, file='so2_map.omps.20220122.ps', $
   /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=24, ysize=10
  !p.font=0

  loadct, 41
  map_set, 0, 80, /horizon, /cont, $
    limit=[-40,-20,0,200], position=[.05,.2,.95,.9], $
    e_horizon={fill:1, color:138}, e_continents={fill:1, color:224}

  loadct, 53
  levels = [1,2,3,5,7,10,15,20,30,50]/10.
  colors = 50+findgen(10)*20
  contour, /over, so2[*,*], lon, lat, levels=levels, c_colors=colors, /cell

  loadct, 0
  map_set, 0, 80, /grid, /horizon, /cont, /noerase, $
    limit=[-40,-20,0,200], position=[.05,.2,.95,.9], color=200
  map_continents, thick=4, /hires
  map_continents, /countries
;  map_grid,/box

  makekey, .15, .1, .7, .05, 0, -0.035, colors=make_array(10, val=120), $
   labels=string(levels,format='(f3.1)'), align=0
  loadct, 53
  makekey, .15, .1, .7, .05, 0, -0.035, colors=colors, $
   labels=make_array(10,val=' '), align=0
  loadct, 0
  xyouts, .5, .025, /normal, align=.5, 'SO!D2!N [DU]'

  device, /close

end

