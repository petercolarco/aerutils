; input is 2-d array (nx,ny)
; lon is nx longitude points
; lat is ny latitude points
; dx is the width of longitude point
; dy is the width of the latitude
; level and color are array of the same number of elements, contour interval
;  and color

  pro plotgrid,  input_, level, color, x_, y_, dx_, dy_, undef=undef, map=map, $
                 psym=psym, symsize=symsize, missing=missing

  if(not(keyword_set(symsize))) then symsize=1.
  if(not(keyword_set(psym))) then psym=0.
  if(not(keyword_set(undef))) then undef = !values.f_nan

; Check the array sizes on input
  vectorinput = 0 
  input = input_
  sizearr = size(input)
  nx = sizearr[1]
  ny = sizearr[2]
  nlev = n_elements(level)
  if(sizearr[0] eq 1) then begin
   x = x_
   y = y_
   ny = 1
   goto, vectorinput
  endif

; Check x
  sizex = size(x_)
  x = x_
  if(sizex[0] eq 1) then begin ;;; x is vector
   x = fltarr(nx,ny)
   for ix = 0, nx-1 do begin
    x[ix,*] = x_[ix]
   endfor
  endif

; Check dx
  sizedx = size(dx_)
  dx = dx_
  dx = fltarr(nx,ny)
  if(sizedx[0] eq 0) then begin ;; dx is a point
   dx[*,*] = dx_
  endif
  if(sizedx[0] eq 1) then begin ;; dx is vector
   for ix = 0, nx-1 do begin
    dx[ix,*] = dx_[ix]
   endfor
  endif

; Check y
  sizey = size(y_)
  y = y_
  if(sizey[0] eq 1) then begin ;;; y is vector
   y = fltarr(nx,ny)
   for iy = 0L, ny-1 do begin
    y[*,iy] = y_[iy]
   endfor
  endif

; Check dy
  sizedy = size(dy_)
  dy = dy_
  dy = fltarr(nx,ny)
  if(sizedy[0] eq 0) then begin ;; dy is a point
   dy[*,*] = dy_
  endif
  if(sizedy[0] eq 1) then begin ;; dy is vector
   for iy = 0L, ny-1 do begin
    dy[*,iy] = dy_[iy]
   endfor
  endif
  if(sizedy[0] eq 2) then begin ;; dy is vector
    dy = dy_
  endif

vectorinput:
  j0 = 0L
  j1 = ny-1
  if(keyword_set(map) and ny ge 3) then begin
   j0 = 1L
   j1 = ny-2
  endif

  for i = 0L, nx-1 do begin
   for j = j0, j1 do begin
    colorUse=-1
    for k = 0, nlev-1 do begin
     if(input[i,j] ge level[k]) then colorUse=color[k]
    endfor
    if(input[i,j] eq undef) then coloruse = -1
    if(keyword_set(missing)) then begin
     if(input[i,j] eq missing or finite(input[i,j]) ne 1) then coloruse = color[0]
    endif
    if(colorUse ne -1) then begin
     if(psym ne 0) then begin
      plots, x[i,j], y[i,j], psym=psym, color=coloruse, noclip=0, symsize=symsize
     endif else begin
      polyfill, x[i,j]+[-dx[i,j],dx[i,j],dx[i,j],-dx[i,j],-dx[i,j]]/2., $
                y[i,j]+[-dy[i,j],-dy[i,j],dy[i,j],dy[i,j],-dy[i,j]]/2., color=coloruse, /fill, noclip=0
     endelse
    endif
   endfor
  endfor

  end
