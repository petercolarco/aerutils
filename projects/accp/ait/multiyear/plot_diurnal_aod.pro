; Read and shift local time
  filen = 'pm25_annual.full.2014.nc4'
  read_diurnal_annual_nc, filen, 'pm25', nx, ny, nt, lon, lat, aod_, num_

; Aggregate to 10 x 10 boxes
;  aod = fltarr(36,18,24)
;  num = lonarr(36,18,24)
  aod = fltarr(10,5,24)
  num = lonarr(10,5,24)

; Assume 1 degree boxes...
  for it = 0, 23 do begin
print, it
;  for ix = 0, 35 do begin
;   for iy = 0, 17 do begin
;    var = total (aod_[ix*10:ix*10+9,iy*10:iy*10+9,it] $
;                *num_[ix*10:ix*10+9,iy*10:iy*10+9,it])
;    num[ix,iy,it] = total(num_[ix*10:ix*10+9,iy*10:iy*10+9,it])
;    if(num[ix,iy,it] gt 0) then aod[ix,iy,it] = var/num[ix,iy,it]
;   endfor
;  endfor
  for ix = 0, 9 do begin
   for iy = 0, 4 do begin
    var = total (aod_[ix*36:ix*36+35,iy*36:iy*36+35,it] $
                *num_[ix*36:ix*36+35,iy*36:iy*36+35,it])
    num[ix,iy,it] = total(num_[ix*36:ix*36+35,iy*36:iy*36+35,it])
    if(num[ix,iy,it] gt 0) then aod[ix,iy,it] = var/num[ix,iy,it]
   endfor
  endfor
  endfor
  
; Make a plot
  set_plot, 'ps'
  device, file='test.ps', /helvetica, font_size=12, $
   xsize=36, ysize=18
  !p.font=0

  noerase = 0
;  for ix = 0, 35 do begin
;   for iy = 0, 17 do begin
  for ix = 0, 9 do begin
   for iy = 0, 4 do begin
    if(max(num[ix,iy,*]) gt 0) then begin
;     var = aod[ix,iy,*]-min(aod[ix,iy,*])
     var = reform(aod[ix,iy,*])
     var = var/max(var)
    endif
    x = ix/10.+.01
    dx = 1./10.-.02
    y = iy/5.+.01
    dy = 1./5.-0.02
    plot, indgen(24)+1, var, noerase=noerase, /nodata, $
     xrange=[0,25], yrange=[0.5,1], $
     position=[x,y,x+dx,y+dy], xticks=1, yticks=1, $
     xtickn=[' ',' '], ytickn=[' ',' '], xstyle=1, ystyle=1, color=180
    oplot, indgen(24)+1, reform(var), thick=6
;     position=[ix/36.,iy/18.,ix/36.+1/36.,iy/18+1./18]
    noerase = 1
   endfor
  endfor
  map_set, /cont, /noerase, position=[.01,.01,.99,.99], color=110
  device, /close

end
