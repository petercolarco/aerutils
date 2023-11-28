  pro orbits, filename, lon, lat, tau, isotime, ttl


  cdfid = ncdf_open(filename)
   id = ncdf_varid(cdfid,'isotime')
   ncdf_varget, cdfid, id, isotime
   isotime = string(isotime)
   nymd = strmid(isotime,0,4)+strmid(isotime,5,2)+strmid(isotime,8,2)
   hh   = strmid(isotime,11,2)
   mm   = strmid(isotime,14,2)
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau
  ncdf_close, cdfid

; get local time hour
  tt  = hh+mm/60.d
  ttl = tt+lon/15
  ttl[where(ttl ge 24., /null)] = ttl[where(ttl ge 24., /null)]-24.
  ttl[where(ttl lt 0., /null)]  = ttl[where(ttl lt 0.,  /null)]+24.

end

  tle = ['sunsynch_450km_1330crossing', 'sunsynch_450km_1330crossing.nodrag', $
         'aqua', 'aqua.nodrag','pace.nodrag',$
         'sunsynch_500km.nodrag','ins1a.nodrag', 'calipso','calipso.nodrag', $
         'tiantuo2.nodrag','cosmos2503.nodrag','harp_30_may.nodrag', $
         'harp_hi_may.nodrag','iss.nodrag','gpm.nodrag']

  for i = 0, n_elements(tle)-1 do begin

  orbits, 'c180R_pI33p7.'+tle[i]+'.2016.nc', lon, lat, tau, isotime, ttl
; make histogram of equator crossing time
  a = where(lat gt -2 and lat lt 2)
  ttl_hist = lonarr(24)
  for j = 0, 23 do begin
   b = where(ttl[a] ge j and ttl[a] lt j+1)
   if(b[0] ne -1) then ttl_hist[j] = n_elements(b)
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='orbits.'+tle[i]+'.ps', /color, /helvetica, $
   xoff=.5, yoff=.5, xsize=32, ysize=12, font_size=10
  !p.font=0

  plot, indgen(24), /nodata, $
   xrange=[-1,24], xticks=25, xtickn=[' ',string(indgen(24),format='(i2)'),' '], $
   xmin=1, yrange=[0,10000], $
   position=[.62,.1,.98,.95], $
   title='Equator crossing time', xtitle='Local Hour',ytitle='counts'
  oplot, indgen(24), ttl_hist, thick=3

; Plot the first day orbit
  n = 24*60.
  if(tle[i] eq 'sunsynch_500km.nodrag') then begin
   lon_ = lon[0:20*24*60]
   lat_ = lat[0:20*24*60]
   a = where(lat_ gt -2 and lat_ lt 2)
   map_set, /cont, /noerase, position=[.02,.05,.55,.95], $
    title=tle[i]+', day 0 (solid) and day 100 (dashed) orbit'
   plots, lon[0:n], lat[0:n]
;  oplot 100 (110 10-day cycles later)
   x0 = 100*24*60.
   plots, lon[x0:x0+n], lat[x0:x0+n], thick=6, lin=2
  endif else begin
   if(tle[i] eq 'gpm.nodrag') then begin
    lon_ = lon[0:20*24*60]
    lat_ = lat[0:20*24*60]
    a = where(lat_ gt -2 and lat_ lt 2)
    b = where(lon_[a] gt lon_[a[0]]-1 and lon_[a] lt lon_[a[0]]+1.)
    map_set, /cont, /noerase, position=[.02,.05,.55,.95], $
     title=tle[i]+', day 0 (solid) and day 188 (dashed) orbit'
    plots, lon[0:n], lat[0:n]
;   oplot 108 (108 5.43-day cycles later)
    x0 =188*24*60.
    plots, lon[x0:x0+n], lat[x0:x0+n], thick=6, lin=2
   endif else begin
    map_set, /cont, /noerase, position=[.02,.05,.55,.95], $
     title=tle[i]+', day 0 (solid) and day 352 (dashed) orbit'
    plots, lon[0:n], lat[0:n]
;   oplot 352 (22 16-day cycles later)
    x0 = 352*24*60.
    plots, lon[x0:x0+n], lat[x0:x0+n], thick=6, lin=2
   endelse
  endelse




  device, /close


  endfor

end
