; input is 2-d array (nx,ny)
; lon is nx longitude points
; lat is ny latitude points
; dx is the width of longitude point
; dy is the width of the latitude
; level and color are array of the same number of elements, contour interval
;  and color

  pro plotgrid,  input, level, color, lon, lat, dx_, dy_, undef=undef

; ignore the polar points
  nx = n_elements(lon)
  ny = n_elements(lat)
  nlev = n_elements(level)

  if(n_elements(dx_) eq 1) then begin
   dx = make_array(nx,val=dx_)
  endif else begin
   dx = dx_
  endelse
   
  if(n_elements(dy_) eq 1) then begin
   dy = make_array(ny,val=dy_)
  endif else begin
   dy = dy_
  endelse

  for i = 0, nx-1 do begin
   for j = 1, ny-2 do begin
    colorUse=255
    for k = 0, nlev-1 do begin
     if(input[i,j] ge level[k]) then colorUse=color[k]
    endfor
    if(keyword_set(undef)) then begin
     if(input[i,j] eq undef) then coloruse = 255
    endif
    if(colorUse ne 255) then $
     polyfill, lon[i]+[-dx[i],dx[i],dx[i],-dx[i],-dx[i]]/2., $
               lat[j]+[-dy[j],-dy[j],dy[j],dy[j],-dy[j]]/2., color=coloruse, /fill, noclip=0
   endfor
  endfor

  end
