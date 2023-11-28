; Colarco, November 28, 2016
; Plot the global mean AOT of volcanic aerosol for all 4 seasons on
; single plot

;  g5v = 'NHL'
;  giv = 'NHh'

; Variant that plots two time series offset in time

  pro plot_aot_4_giss, g5v, giv

; Season titles
  g5s = ['jan','apr','jul','oct']
  gis = ['Win_anl','Spr_anl','Sum_kt','Fal_kt']

  case g5v[0] of
   'NHL': locstr = 'Northern Hemisphere High Latitude'
   'NML': locstr = 'Northern Hemisphere Mid Latitude'
   'TRO': locstr = 'Northern Hemisphere Tropics'
   'STR': locstr = 'Southern Hemisphere Tropics'
   'SML': locstr = 'Southern Hemisphere Mid Latitude'
   'SHL': locstr = 'Southern Hemisphere High Latitude'
  endcase

; Loop cases
  for i = 0, 3 do begin

  g5expid = 'VM'+g5v+g5s[i]+['01','02','03','04','05']+'.tavg2d_carma_x.ddf'

  gidir = '/misc/prc20/colarco/volcano/GISS/'
  gictrl = gidir+'VolK_ctrl/taijVolK_ctrl.2.series.nc'
  giexp  = 'VolK_'+giv+'_'+gis[i]
  gimod  = gidir+giexp+'/taij'+giexp+'.2.series.nc'

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; Get the GISS
  nc4readvar, gictrl, 'aot', ctrl, time=time
  nc4readvar, gimod, 'aot', gmod, time=time
  aot = aave(gmod-ctrl,area)
  aot = aot[0:59]

  color=[84, 178, 208, 254]
  offset = [0,3,6,9]/12.

  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='VM'+g5v+'.giss.ps', $
    /color, /helvetica, font_size=14, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
   !p.font=0
   loadct, 0
   plot, findgen(60)/12., /nodata, yrange=[0,0.15], $
    xmin=12, xrange=[0,5], xtitle='Years', ytitle='AOT', $
    title = 'ModelE2: '+locstr
  endif
  loadct, 39
;  oplot, findgen(60)/12.-offset[i], g5, thick=6, color=color[i]
  oplot, findgen(60)/12.-offset[i], aot, thick=6, color=color[i]

  if(i eq 3) then device, /close

  endfor

end
