; Colarco, December 2009
; Simple program to compute the area of lat/lon grid boxes
; given the central latitude/longitude

; Input:
;  lonc, latc  --  center longitude, latitude
; Output:
;  nx = number of x points
;  ny = number of y points
;  dx = grid spacing in x-direction
;  dy = grid spacing in y-direction
;  area [m2]
; Optional:
;  grid  = a, b, c, d, e regular grid returned
;  geos4 = with grid option, set longitudes to be GEOS-4 like
; Add 2-dimensional lat/lon output option

  pro area, lon, lat, nx, ny, dx, dy, area, $
            grid=grid, geos4=geos4, lon2=lon2, lat2=lat2

  rearth = 6370000.d   ; m

; If present grid then establish appropriate latitudes and longitudes
  if(keyword_set(grid)) then begin

   case grid of
    'a':      begin
              nx = 72
              ny = 46
              dx = 5.
              dy = 4.
              end
    'b':      begin
              nx = 144
              ny = 91
              dx = 2.5
              dy = 2.
              end
    'c':      begin
              nx = 288
              ny = 181
              dx = 1.25
              dy = 1.
              end
    'd':      begin
              nx = 576
              ny = 361
              dx = 0.625
              dy = 0.5
              end
    'e':      begin
              nx = 1152
              ny = 721
              dx = 0.3125
              dy = 0.25
              end
    'ten':    begin
              nx = 36
              ny = 19
              dx = 10.
              dy = 10.
              end
    'half':   begin
              nx = 720
              ny = 361
              dx = 0.5
              dy = 0.5
              end
    'one':    begin
              nx = 360
              ny = 181
              dx = 1.
              dy = 1.
              end
    'nr':     begin
              nx = 5760
              ny = 2881
              dx = 0.0625
              dy = 0.0625
              end
    else:     begin
              print, 'area: Invalid GRID requested; die'
              stop
              end
    endcase
    
    lon = -180.d + dindgen(nx)*dx
    if(keyword_set(geos4)) then lon = 180.d + lon
    lat = -90.  + dindgen(ny)*dy
  endif

  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = 360.d/nx
  dy = 180.d/(ny-1)

  if(keyword_set(lon2)) then begin
   lon2 = fltarr(nx,ny)
   for iy = 0, ny-1 do begin
    lon2[*,iy] = lon
   endfor
  endif
  if(keyword_set(lat2)) then begin
   lat2 = fltarr(nx,ny)
   for ix = 0, nx-1 do begin
    lat2[ix,*] = lat
   endfor
  endif


; Now compute the area
  area = dblarr(nx,ny)
  area[*,ny-1] = 2.d*!dpi*rearth^2*(1.-sin((lat[ny-1]-dy/2.)*!dpi/180.d))*dx/360.d
  area[*,0] = area[*,ny-1]
  for iy = 1, ny-2 do begin
   area[*,iy] = 2.d*!dpi*rearth^2*dx/360.d $
               * (sin((lat[iy]+dy/2.)*!dpi/180.d)-sin((lat[iy]-dy/2.)*!dpi/180.d))
  endfor

end
