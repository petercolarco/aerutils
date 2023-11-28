; Colarco, November 28, 2016
; Plot the global mean AOT of volcanic aerosol

;  g5v = 'NHL'
;  giv = 'NHh'
;  g5s = 'jan'
;  gis = 'Win_anl'

; Variant that plots two time series offset in time

  pro plot_aot_2, g5v, giv, g5s, gis

  case g5v[0] of
   'NHL': locstr = 'Northern Hemisphere High Latitude'
   'NML': locstr = 'Northern Hemisphere Mid Latitude'
   'TRO': locstr = 'Northern Hemisphere Tropics'
   'STR': locstr = 'Southern Hemisphere Tropics'
   'SML': locstr = 'Southern Hemisphere Mid Latitude'
   'SHL': locstr = 'Southern Hemisphere High Latitude'
  endcase

; Loop cases
  for i = 0, 1 do begin

  case g5s[i] of
   'jan': seasstr = 'January'
   'apr': seasstr = 'April'
   'jul': seasstr = 'July'
   'oct': seasstr = 'October'
  endcase

  g5expid = 'VM'+g5v[i]+g5s[i]+['01','02','03','04','05']+'.tavg2d_carma_x.ddf'

  gidir = '/misc/prc20/colarco/volcano/GISS/'
  gictrl = gidir+'VolK_ctrl/taijVolK_ctrl.2.series.nc'
  giexp  = 'VolK_'+giv[i]+'_'+gis[i]
  gimod  = gidir+giexp+'/taij'+giexp+'.2.series.nc'

; Get the g5 aot and save area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  nc4readvar, g5expid[0], 'suexttau', su, time=time

  nt = n_elements(time)
  g5 = fltarr(nt,5)
  g5[*,0] = aave(su,area)

  for j = 1, 4 do begin
   nc4readvar, g5expid[j], 'suexttau', su, time=time
   g5[*,j] = aave(su,area)
  endfor

; Get the GEOS-5 climatology and remove
  g5clim = 'VMcontrol'+['01','02','03','04','05']+'.tavg2d_carma_x.ddf'
  nc4readvar, g5clim[0], 'suexttau', su, time=time
  nt = n_elements(time)
  g5c = fltarr(nt,5)
  g5c[*,0] = aave(su,area)
  for j = 1, 4 do begin
   nc4readvar, g5clim[j], 'suexttau', su, time=time
   g5c[*,j] = aave(su,area)
  endfor
  g5 = g5-g5c

; Get the GISS
  nc4readvar, gictrl, 'aot', ctrl, time=time
  nc4readvar, gimod, 'aot', gmod, time=time
  aot = aave(gmod-ctrl,area)
  aot = aot[0:59]

  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='VM'+g5v[i]+g5s[i]+'_'+g5s[i+1]+'.ps', $
    /color, /helvetica, font_size=14, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
   !p.font=0
   loadct, 0
   plot, findgen(60)/12., /nodata, yrange=[0,0.15], $
    xmin=12, xrange=[0,5], xtitle='Years', ytitle='AOT', $
    title = locstr
   loadct, 49
   polymaxmin, findgen(60)/12., g5, color=250, fillcolor=80
   loadct, 63
   oplot, findgen(60)/12., aot, thick=6, color=180
  endif else begin
   loadct, 59
   polymaxmin, findgen(60)/12., g5, color=220, fillcolor=80
   loadct, 56
   oplot, findgen(60)/12., aot, thick=6, color=200
   device, /close
  endelse

  endfor

end
