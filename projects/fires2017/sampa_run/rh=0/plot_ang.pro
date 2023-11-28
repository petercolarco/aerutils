; Plot the absorbing aerosol optical depth angstrom exponent (AAE) for
; various model run optics versions
  filen = 'c180R_NoT_I32_pyroCB_pt3smoke.dryaer.taod_Nc.20170815_1800z.nc4'
  vars  = ['brcphobic','brcphilic','bcphobic','bcphilic']
  nc4readvar, filen, vars, aod, lon=lon, lat=lat, lev=lev, /sum
; angstrom parameter 520 (3) and 1021 (7)
  a = where(aod[*,*,1] lt 0.5)
  aod = -alog(aod[*,*,3]/aod[*,*,7])/(alog(520./1021.))
  aod[a] = !values.f_nan

  set_plot, 'ps'
  device, file='ang.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 0

  levels = findgen(11)*.04+1
  colors = findgen(11)*25

  map_set, /noborder, /noerase, limit=[50,-120,80,-60], position=[.05,.2,.95,.95]
  loadct, 65
  contour, aod, lon, lat, /over, /cell, lev=levels, c_color=colors
  loadct, 0
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, limit=[50,-120,80,-60], position=[.05,.2,.95,.95], $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=0, colors=colors, $
           labels=string(levels,format='(f4.2)'), /noborder
  loadct, 65
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=colors, $
           labels=[' ',' '], /noborder

  device, /close

end
