; Colarco, Dec. 2, 2008
; Goal is to determine an area conservative interpolation method to
; map; e.g., individual satellite retrievals to a grid box.  The method
; is that if the retrievals overlap grid cells they will be distributed
; to all relevant cells, where their final weighting in the cell is the
; fraction of the cell they occupy relative to all other observations
; intruding in the cell.

; Inputs:
;  xx, yy: lon and lat arrays of some grid you want to map to
;  x,  y : lon and lat points of input data you want to map
;          can be a vector or array; I treat like a vector
;  dx, dy: lon and lat extents of the input data

; Assumptions are a regular grid for output (xx, yy) and the dxx and dyy
; spacing of that grid are determined internally.  Other assumption is 
; that the x and y spacing is finer than the xx and yy spacing: that is,
; dxx > dx and dyy > dy.  By enforcing this, I can guarantee that I only
; need to consider nine points on the output grid for each input point.


; On return, the array weightmap is (nPts,3,3) array, where nPts is the
; length of the input vector of x/y points.  The 3x3 dimensions are the
; assumption that the input grid can be distributed on the nearest
; output grid points and the surrounding 8 cells.  So the value of
; weightmap[n,1,1] is the fractional area of the nearest cell on the
; out grid occupied by the measurement.
; It is assumed you know the nearest grid location elsewhere.

  pro weightmap, xx, yy, x, y, dx, dy, weightmap

;  Get the area and spacing of the output grid
   area, xx, yy, xout, yout, dxx, dyy, areaOut

;  ghost the output array to wrap
   xxg = [xx[0]-dxx, xx, xx[xout-1]+dxx]
   yyg = [yy[0]-dyy, yy, yy[yout-1]+dyy]

;  Check the grid of input: enforce that x and y have same # of elements
   if(n_elements(x) ne n_elements(y)) then begin
    print, 'Expecting a vector of lon and lat points; x and y must'
    print, 'have the same number of points; stop'
    stop
   endif
   nPts = n_elements(x)

;  Because we are allowing that x and y are vectors, then need to provide
;  same sized arrays of dx and dy
   if(n_elements(dx) ne nPts or n_elements(dy) ne nPts) then begin
    print, 'Expecting a vector of dx and dy points same size'
    print, 'as x and y; stop'
    stop
   endif

;  Now find the nodal points of the nearest points to input on the out grid
   ixxg = interpol(indgen(xout+2),xxg,x)
   iyyg = interpol(indgen(yout+2),yyg,y)
   ixxg = fix(ixxg+0.5)
   iyyg = fix(iyyg+0.5)
   b = where(ixxg ge xout+1)
   if(b[0] ne -1) then ixxg[b] = 1

;  Now search for the overlaps
   weightmap = fltarr(nPts,3,3)

   for iPts = 0L, nPts-1 do begin

if(dx[iPts] lt dxx) then begin

    xweight = fltarr(3,2)
    yweight = fltarr(3,2)
    ixg = ixxg[iPts]
    iyg = iyyg[iPts]
    dx_xx2 = (dx[iPts]+dxx)/2.
    dy_yy2 = (dy[iPts]+dyy)/2.

;   x-direction
    for ixg_ = ixg-1, ixg+1 do begin
     delta = abs(x[iPts]-xxg[ixg_])
     icol = ixg_ - (ixg-1)
     if( delta lt dx_xx2 ) then begin
       if( delta le (dxx-dx[iPts])/2. ) then weight = dx[iPts]/dxx $
       else                                  weight = (dx_xx2 - delta)/dxx
       xweight[icol,0] = iPts
       xweight[icol,1] = weight
       icol = icol+1
     endif
    endfor

;   y-direction
;   Note the special handling of the ghosting in the y-direction below
    for iyg_ = iyg-1, iyg+1 do begin
     delta = abs(y[iPts]-yyg[iyg_])
     icol = iyg_ - (iyg-1)
     if( delta lt dy_yy2 ) then begin
       if( delta le (dyy-dy[iPts])/2. ) then weight = dy[iPts]/dyy $
       else                                  weight = (dy_yy2 - delta)/dyy
       yweight[icol,0] = iPts
       yweight[icol,1] = weight
       icol = icol+1
     endif
    endfor
;   Now make the total weighting map
    weightmap[iPts,0:2,0] = xweight[0:2,1]*yweight[0,1]
    weightmap[iPts,0:2,1] = xweight[0:2,1]*yweight[1,1]
    weightmap[iPts,0:2,2] = xweight[0:2,1]*yweight[2,1]


endif

   endfor

end
