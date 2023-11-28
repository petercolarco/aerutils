; Make a plot of the number/frequency of observations in a 1 degree
; box...

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']

  for im = 0, 11 do begin

; Get SS450
  filen = 'ss450/ss450.random.2006'+mm[im]+'.txt'
  read_random, filen, lon, lat, $
               vza, sza, vaa, saa, scat, $
               date, time

;; Collapse to SZA < 80 and SCAT > 150
;  a = where(sza lt 80. and scat gt 150.)
;  lon = lon[a]
;  lat = lat[a]
;  scat = scat[a]
  a = where(lon gt 180.)
  if(a[0] ne -1) then lon[a] = 360.-lon[a]
  a = where(lon lt -180.)
  if(a[0] ne -1) then lon[a] = 360.+lon[a]

; Make a 1 x 1 grid
  nx = 72
  ny = 37
  dx = 5.
  dy = 5.
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
  endfor

; plot the nadir track for the nadir view, and overplot only sunlit
; parts
  set_plot, 'ps'
  device, file='ss450.random.freq.2006'+mm[im]+'.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=16, /color
  !p.font=0
  map_set, title='Sunsynchronous Platform, 2006'+mm[im], position=[.02,.1,.98,.92]
  loadct, 0
  map_continents, fill_continents=1, color=200
  plotgrid, num, [1], [140], lon_, lat_, dx, dy, /map
  makekey, .2,.05,.1,.035,0,-0.025,align=0,colors=140,labels='1'
  loadct, 39
  level = [2,4,8,12,16]
  color = [48,84,176,208,254]
  plotgrid, num, level, color, lon_, lat_, dx, dy, /map
  map_continents, thick=2

  makekey, .3,.05,.5,.035,0,-0.025,align=0,colors=color,labels=string(level,format='(i4)')
  device, /close

  endfor

end
