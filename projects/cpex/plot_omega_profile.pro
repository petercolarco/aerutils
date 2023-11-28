; Make a plot of the flight track over the GEOS FP total AOD field

; Track
  date = '20210821'

  trj = '/misc/prc19/colarco/CPEX/6km.ext_532nm.'+date+'.du.nc'
  cdfid = ncdf_open(trj)
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, trjlon
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, trjlat
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  id = ncdf_varid(cdfid,'time') 
  ncdf_varget, cdfid, id, time_sec
  ncdf_attget, cdfid, id, 'units', unit
  unit=string(unit)
  units = strsplit(unit)
  unit0 = strmid(unit,units[3])
  ncdf_close, cdfid

  trj = '/misc/prc19/colarco/CPEX/6km.'+date+'.nc'
  cdfid = ncdf_open(trj)
  id = ncdf_varid(cdfid,'H')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'OMEGA')
  ncdf_varget, cdfid, id, w
  id = ncdf_varid(cdfid,'PBLH')
  ncdf_varget, cdfid, id, pblh
  id = ncdf_varid(cdfid,'PHIS')
  ncdf_varget, cdfid, id, phis
  id = ncdf_varid(cdfid,'PRECTOT')
  ncdf_varget, cdfid, id, prectot
  ncdf_close, cdfid
  pblh = (pblh+phis/9.81)/1000.

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

; Interpolate to a regular height grid
  z = findgen(100)*100.+50.
  nt = n_elements(h[0,*])
  var = fltarr(nt,100)

  for i = 0, nt-1 do begin
   iy = interpol(findgen(90),h[*,i],z)
   var[i,*] = interpolate(ext[*,i],iy)
  endfor
  ext = var

  for i = 0, nt-1 do begin
   iy = interpol(findgen(90),h[*,i],z)
   var[i,*] = interpolate(w[*,i],iy)
  endfor
  w = var

; Make a plot
  set_plot, 'ps'
  device, file='plot_omega_profile.'+date+'.du.ps', /helvetica, font_size=14, $
   xsize=36, ysize=12, /color
  !p.font=0

  xticks = n_elements(un)-1
  xtickv = un
  xtickn = hh[un]
  a = where(xtickn ge 24)
  if(a[0] ne -1 ) then xtickn[a] = xtickn[a]-24
  xtickn = string(xtickn,format='(i-2)')

  loadct, 0
  plot, indgen(10), /nodata, $
   yrange=[0,10], ytitle='Altitude (km), PBLH', ystyle=9, $
   xrange=[0,nt-1], xstyle=1, $
   xticks=xticks, xtickv=xtickv, xtickn=xtickn, $
   position=[.1,.1,.85,.9]

  levels=-2.+findgen(36)*.05
  levels[0] = -8.
;  loadct, 74
;  colors=255-indgen(36)*7
  loadct, 39
  colors=[0,48+indgen(19)*5,192,200,204+indgen(13)*4,254]

  contour, /over, w, indgen(nt), z/1000., $
   level=[-100.,-1,-.5,-.1,.1,.5,1], /cell, c_colors=[48,84,174,255,196,208,254]
  contour, /over, alog10(ext), indgen(nt), z/1000., $
   levels=[alog10([.02,.05])], c_colors=0

  for i = 0, n_elements(un)-1 do begin
   plots, un[i], [0,10], thick=6, color=0
  endfor

  plot, indgen(10), /nodata, /noerase, $
   yrange=[0,10], ytitle='Altitude (km), PBLH', ystyle=9, $
   xrange=[0,nt-1], xstyle=1, $
   xticks=xticks, xtickv=xtickv, xtickn=xtickn, $
   position=[.1,.1,.85,.9]
  plots, indgen(nt), pblh, thick=12, color=0

  axis, yaxis=1, yrange=[0,50], ytitle='Precipitation [mm day!E-1!N]', $
   color=254, /save
  oplot, indgen(nt), prectot*86400., thick=6, color=254

  loadct, 0
  makekey, /orientation, .9, .1, .03, .8, .05, 0, $
   labels=[' ','-1','-0.5','-0.1','0.1','0.5','1'], $
   colors=make_array(7,val=0), align=.5
;  loadct, 74
  loadct, 39
  makekey, /orientation, .9, .1, .03, .8, .05, 0, $
   labels=make_array(7,val=' '), colors=[48,84,174,255,196,208,254], /noborder
  xyouts, .98, .5, 'Vertical Velocity [Pa s!E-1!N]', orient=90, /normal, align=.5


  device, /close
  end
