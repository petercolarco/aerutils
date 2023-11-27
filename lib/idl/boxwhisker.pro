; Colarco, October 2012
; Idea is to plot a box-whisker plot on an existing plot.
; The "x" coordinate given (and associated "dx") are used to position
; the plot.  This also returns the statistics.

  pro boxwhisker, data, x, dx, color, $
                  medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv, $
                  linecolor=linecolor, linethick=linethick

  ymin = !y.crange[0]
  ymax = !y.crange[1]
  yplt = ymin+0.95*(ymax-ymin)

  if(not(keyword_set(linecolor))) then linecolor=0
  if(not(keyword_set(linethick))) then linethick=2

  minval  = min(data)
  maxval  = max(data)
  medval  = median(data,/even)
  meanval = total(data)/n_elements(data)
  stddv   = stddev(data)

  qtr_25th = median(data[where(data le medval, countlowerhalf)])
  qtr_75th = median(data[where(data gt medval, countupperhalf)])

; plot a box
  xs = x+[-dx,dx,dx,-dx,-dx]/2.
  ys = [qtr_25th,qtr_25th,qtr_75th,qtr_75th,qtr_25th]
  polyfill, xs, ys, color=color
  plots, xs, ys, thick=linethick, color=linecolor, noclip=0
  plots, x+[-dx,dx]/2., medval, thick=linethick, color=linecolor, noclip=0
  plots, x, [qtr_75th,maxval], thick=linethick, color=linecolor, noclip=0
  plots, x+[-dx,dx]/4., maxval, thick=linethick, color=linecolor, noclip=0
  plots, x, [qtr_25th,minval], thick=linethick, color=linecolor, noclip=0
  plots, x+[-dx,dx]/4., minval, thick=linethick, color=linecolor, noclip=0
  if(maxval gt ymax) then xyouts, x-dx, yplt, string(maxval,format='(f3.1)'), charsize=.75, color=linecolor, /data

end
