; Get and read one of Patricia's files to plot the orbit on a map

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB','*200601*nc4')

  for ii = 0, n_elements(filen)-1 do begin
;  for ii = 0, 2 do begin

  print, filen[ii]

  cdfid = ncdf_open(filen[ii])
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, lon_
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, lat_
  id = ncdf_varid(cdfid,'sza_ss')
  ncdf_varget, cdfid, id, sza_
  id = ncdf_varid(cdfid,'scatAngle_ss')
  ncdf_varget, cdfid, id, scat_
  ncdf_close, cdfid

  nx = n_elements(lon_)
  for ix = 0, nx-1 do begin

   a = where(sza_[*,ix] le 80. and $
             min(scat_[*,ix]) ge 30. and $
             max(scat_[*,ix])-min(scat_[*,ix]) gt 70)
   if(n_elements(a) eq 10) then begin
    if(ii eq 0) then begin
     lon  = lon_[ix]
     lat  = lat_[ix]
    endif else begin
     lon  = [lon,lon_[ix]]
     lat  = [lat,lat_[ix]]
    endelse

   endif

  endfor

  endfor

  a = where(lon gt 180.)
  if(a[0] ne -1) then lon[a] = 360.-lon[a]
  a = where(lon lt -180.)
  if(a[0] ne -1) then lon[a] = 360.+lon[a]

; Make a 1 x 1 grid
  nx = 180
  ny = 91
  dx = 2.
  dy = 2.
  lon_ = -180+dx/2.+findgen(nx)*dx
  lat_ = -90. + findgen(ny)*dy

; Interpolate
  ix = fix(interpol(findgen(nx),lon_,lon)+0.5d)
  iy = fix(interpol(findgen(ny),lat_,lat)+0.5d)
  a = where(ix eq nx)
  if(a[0] ne -1) then ix[a] = nx-1
  a = where(iy eq ny)
  if(a[0] ne -1) then iy[a] = ny-1

  iy = iy[sort(ix)]
  ix = ix[sort(ix)]
  num = lonarr(nx,ny)
  print, systime()
  for i = 0, nx-1 do begin
   a = where(ix eq i)
   if(a[0] ne -1) then begin
    iy_ = iy[a]
    iy_ = iy_[sort(iy_)]
    res = uniq(iy_)
    nres = n_elements(res)
    num[i,iy_[0]] = res[0]+1
    for ires = 1, nres-1 do begin
     num[i,iy_[res[ires]]] = res[ires]-res[ires-1]
    endfor
   endif
;   for j = 0, 180 do begin
;    a = where(ix eq i and iy eq j)
;    if(a[0] ne -1) then num[i,j] = n_elements(a)
;   endfor
  endfor
  print, systime()

; plot the nadir track for the nadir view, and overplot only sunlit
; parts
  set_plot, 'ps'
  device, file='gpm.orbit.freq.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=16, /color
  !p.font=0
  map_set, title='Precessing Platform, January 2006', $
   position=[.05,.15,.95,.9]
  loadct, 0
  map_continents, fill_continents=1, color=200
  loadct, 39
  level = [1000,2000,5000,10000,20000]/100.
  color = [48,84,176,208,254]
  plotgrid, num, level, color, lon_, lat_, dx, dy, /map
  map_continents, thick=2
  makekey, .1,.08,.8,.05,0,-.035,align=0., $
           colors=color, label=string(level,format='(i3)')


  device, /close

end
