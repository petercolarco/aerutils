; Colarco, November 28, 2016
; Plot the global mean AOT of volcanic aerosol

;  g5v = 'NHL'
;  giv = 'NHh'
;  g5s = 'jan'
;  gis = 'Win_anl'

  pro plot_aot, g5v, giv, g5s, gis

  case g5v of
   'NHL': locstr = 'Northern Hemisphere High Latitude'
   'NML': locstr = 'Northern Hemisphere Mid Latitude'
   'TRO': locstr = 'Northern Hemisphere Tropics'
   'STR': locstr = 'Southern Hemisphere Tropics'
   'SML': locstr = 'Southern Hemisphere Mid Latitude'
   'SHL': locstr = 'Southern Hemisphere High Latitude'
  endcase

  case g5s of
   'jan': seasstr = 'January'
   'apr': seasstr = 'April'
   'jul': seasstr = 'July'
   'oct': seasstr = 'October'
  endcase

  g5expid = 'VM'+g5v+g5s+['01','02','03','04','05']+'.tavg2d_carma_x.ddf'

  gidir = '/misc/prc20/colarco/volcano/GISS/'
  gictrl = gidir+'VolK_ctrl/taijVolK_ctrl.series.nc'
  giexp  = 'VolK_'+giv+'_'+gis
  gimod  = gidir+giexp+'/taij'+giexp+'.series.nc'

; Get the g5 aot and save area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  nc4readvar, g5expid[0], 'suexttau', su, time=time

  nt = n_elements(time)
  g5 = fltarr(nt,5)
  g5[*,0] = aave(su,area)

  for i = 1, 4 do begin
   nc4readvar, g5expid[i], 'suexttau', su, time=time
   g5[*,i] = aave(su,area)
  endfor

; Get the GISS
  nc4readvar, gictrl, 'aot', ctrl, time=time
  nc4readvar, gimod, 'aot', gmod, time=time
  aot = aave(gmod-ctrl,area)
  aot = aot[0:59]

  set_plot, 'ps'
  device, file='VM'+g5v+g5s+'.ps', /color, /helvetica, font_size=14, $
   xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  plot, findgen(60)/12., /nodata, yrange=[0,0.15], $
   xmin=12, xrange=[0,5], xtitle='Years', ytitle='AOT', $
   title = locstr+' ('+seasstr+')'
  loadct, 49
  polymaxmin, findgen(60)/12., g5, color=250, fillcolor=80

  loadct, 63
  oplot, findgen(60)/12., aot, thick=6, color=180

  device, /close

end

