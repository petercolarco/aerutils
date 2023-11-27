; Colarco, 2.17.22
; Given three points (x0,y0), (x1,y1), (x2,y2) and a desired number of
; levels return the levels such that x1 is the middle level by fitting
; an exponential curve to it. Got this suggestion from Stack Exchange:
;  y = a*exp(b*x) + c
; and conditions are x1-x0 = x2-x1
; Enforce off number of levels so x1,y1 is really mid point

  pro exp_levels, nl, y0, x, y

  if(nl/2. eq nl/2) then begin
   nl = nl+1
   print, "passed nl = ", nl-1, "; returning nl = ", nl
  endif

  x = findgen(nl)+1
  x0 = [1.,(nl-1)/2+1,nl]
print, x0
  r = (y0[2]-y0[1])/(y0[1]-y0[0])
  d = x0[2]-x0[1]
  b = alog(r)/d
  a = (y0[2]-y0[1])/(r^(x0[2]/d)-r^(x0[1]/d))
  c = y0[0]-a*exp(b*x0[0])

  y = a*exp(b*x)+c

;  plot, x, y
;  plots, x, y, psym=4

end
