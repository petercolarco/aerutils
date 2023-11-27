; Colarco, Feb. 2006
; Given arrays x and y (same size,shape)
; Compute and return the mean, std deviation, bias, RMS error, and skill score
; Based on K.E. Taylor, JGR, 106 D7 (2001)

; Disregard NAN

  pro statistics, xInp, yInp, xmean, ymean, xstd, ystd, r, bias, rms, skill, $
                  linslope, linoffset, rc=rc

  nx = n_elements(xInp)
  ny = n_elements(yInp)

  rc = 0
  if(nx ne ny) then begin
   print, 'x and y must be same size/shape; exit'
   rc = -1
   return
  endif

  x = xinp[where(finite(xinp) eq 1 and finite(yinp) eq 1)]
  y = yinp[where(finite(xinp) eq 1 and finite(yinp) eq 1)]


  if(n_elements(x) lt 3) then begin
   print, 'Require at least 3 values in x, y; exit'
   rc = -2
   return
  endif

; mean
  x = float(x)
  y = float(y)
  nx = n_elements(x)
  ny = n_elements(y)
  xmean = total(x)/nx
  ymean = total(y)/ny

; std deviation (not quite stddev function, divide by n and not n-1)
  xdev = x - xmean
  ydev = y - ymean
  xstd = sqrt( total(abs(xdev)^2.) / nx)
  ystd = sqrt( total(abs(ydev)^2.) / ny)

; Correlation Coefficient (equivalent to correlate function
  if(nx eq ny) then r = total(xdev*ydev)/ (nx * xstd * ystd) else r = -9999.

; Bias
  bias = ymean - xmean

; RMS
  if(nx eq ny) then rms = sqrt( total( (xdev - ydev)^2. ) / nx ) else rms = -9999.

; Skill Score, assume R0 = 1
  r0 = 1
  if(nx eq ny) then $
   skill = 4.*(1+r) / (1+r0) / (xstd/ystd + ystd/xstd)^2. $
  else $
   skill = -9999.

; Do a linear fit
; y = linslope*x + linoffset
  if(nx eq ny) then begin
   result = linfit(x,y)
   linslope = result[1]
   linoffset = result[0]
  endif else begin
   linslope=-9999.
   linoffset = -9999.
  endelse

; If nx ne ny then print a warning
  if(nx ne ny) then print, "statistics.pro: nx != ny; rms, skill, lonslope, linoffset wrong"

end
