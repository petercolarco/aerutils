; Make a plot of the flight track over the GEOS FP total AOD field

; Track
  date = '20210821'

  trj = '/misc/prc19/colarco/CPEX/GEOS.fp.trj.'+date+'.nc'
  cdfid = ncdf_open(trj)
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, trjlon
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, trjlat
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time_sec
  ncdf_attget, cdfid, id, 'units', unit
  unit=string(unit)
  units = strsplit(unit)
  unit0 = strmid(unit,units[3])
  ncdf_close, cdfid

  jday0 = julday(strmid(date,4,2),strmid(date,6,2),strmid(date,0,4), $
                 strmid(unit0,0,2),strmid(unit0,3,2),strmid(unit0,6,2))
  jday = jday0+time_sec/86400.
  caldat, jday, mm, dd, yy, hh, nn, ss
  a = where(hh lt 12)
  if(a[0] ne -1) then begin
   hh[where(hh lt 12)] =  hh[where(hh lt 12)]+24
  endif
; find indices of first instances of each hour
  un = uniq(hh)
  un = un[0:n_elements(un)-2]+1

; Get the FP total AOD
  datef = strmid(incstrdate(date+'00',24),0,8)
  fp = '/misc/prc19/colarco/CPEX/f5271_fp.inst1_2d_hwl_Nx.'+datef+'_0000z.nc4'
print, fp
  nc4readvar, fp, 'duexttau', aod, lon=lon, lat=lat


  xrange=[min(trjlon),max(trjlon)]
  yrange=[min(trjlat),max(trjlat)]

; Set some nice plotting ranges
  lon_ = -100+indgen(21)*5
  lat_ = indgen(9)*5

  a = where(abs(xrange[0]-lon_) eq min(abs(xrange[0]-lon_)) )
  xrange[0] = lon_[a[0]-1]

  a = where(abs(xrange[1]-lon_) eq min(abs(xrange[1]-lon_)) )
  xrange[1] = lon_[a[0]+1]

  a = where(abs(yrange[0]-lat_) eq min(abs(yrange[0]-lat_)) )
  yrange[0] = lat_[a[0]-1]

  a = where(abs(yrange[1]-lat_) eq min(abs(yrange[1]-lat_)) )
  yrange[1] = lat_[a[0]+1]

; Make a plot
  set_plot, 'ps'
  device, file='plot_track.'+date+'.ps', /helvetica, font_size=14, $
   xsize=20, ysize=20, /color
  !p.font=0

  map_set, limit=[yrange[0],xrange[0],yrange[1],xrange[1]], $
   position=[.1,.2,.9,.95]

  loadct, 56
  levels = findgen(10)*.05+.05
  colors = indgen(10)*25+25
  contour, /over, aod, lon, lat, /cell, levels=levels, c_colors=colors

  loadct, 0
  map_set, limit=[yrange[0],xrange[0],yrange[1],xrange[1]], $
   position=[.1,.2,.9,.95], /noerase
  map_continents, /hires, thick=2, /coasts
  map_grid, /box
  plots, trjlon, trjlat, thick=6

  plots, trjlon[0], trjlat[0], psym=sym(4), symsize=2.2, color=255
  plots, trjlon[0], trjlat[0], psym=sym(4), symsize=2
  plots, trjlon[0], trjlat[0], psym=sym(4), symsize=1.3, color=255

  for i = 0, n_elements(un)-1 do begin
   plots, trjlon[un[i]], trjlat[un[i]], psym=sym(1), symsize=2
   if(hh[un[i]] ge 24) then begin
     xyouts, trjlon[un[i]], trjlat[un[i]]-.2, string(hh[un[i]]-24,format='(i-2)'), $
      color=255, align=.5, chars=.7
   endif else begin
     xyouts, trjlon[un[i]], trjlat[un[i]]-.2, string(hh[un[i]],format='(i2)'), $
      color=255, align=.5, chars=.7
   endelse
  endfor

  xyouts, .1, .025, date, /normal
  makekey, .1, .1, .8, .05, 0, -.035,align=0,  $
   labels=string(levels,format='(f4.2)'), colors=make_array(10,val=0)
  loadct, 56
  makekey, .1, .1, .8, .05, 0, -0.035, $
   labels=make_array(10,val=' '), colors=colors


  device, /close

end
