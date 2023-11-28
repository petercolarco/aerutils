; Plot the regional tag map from Dongchul Kim

  filename = '/misc/prc18/colarco/c48F_pI33p6_reg/tavg2d_dust_x/c48F_pI33p6_reg.tavg2d_dust_x.monthly.201608.nc4'
  nc4readvar, filename, 'duexttau', duext, lon=lon, lat=lat
  nc4readvar, filename, 'duexttaur04', duextr04, lon=lon, lat=lat
  duext = duext-duextr04

; Make a plot
  set_plot, 'ps'
  device, filename = 'plot_aod.r04.ps', /color, /helvetica
  !p.font=0

  loadct, 0
  map_set, /continents, limit=[0,-50,40,30], E_CONTINENTS={FILL:1}, color=180, $
   position=[.05,.15,.95,.95], /hires

  levels = findgen(9)*.2+.2
  loadct, 56
  colors = findgen(9)*30+15
  contour, duext, lon, lat, /over, levels=levels, c_colors=colors, /cell

  loadct, 0
  map_continents, /countries, color=140
  map_continents, thick=3, /hires
  makekey, .05, .075, .9, .05, 0, -.035, align=0, $
   colors=make_array(n_elements(levels),val=0), $
   labels=string(levels,format='(f4.2)')

  loadct, 56
  makekey, .05, .075, .9, .05, 0, -.035, align=0, $
   colors=colors, labels=[' ',' ']

  device, /close
end
