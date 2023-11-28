  filehead = 't003_c32.MOD04.daily.'
  sample = ['modis','misr.shift','subpoint.shift']


; Setup the plot
  set_plot, 'ps'
  device, file='output/plots/'+filehead+'correlate_time.ps', $
   /helvetica, font_size=12, /color, $
   xsize=16, ysize=10, xoff=.5, yoff=.5
  !P.font=1


; Filenames
  nxr = 288/8
  nyr = 180/10
  nreg = nxr*nyr
  plottitle = strarr(nxr,nyr)
  lon0want = fltarr(nxr,nyr)
  lon1want = fltarr(nxr,nyr)
  lat0want = fltarr(nxr,nyr)
  lat1want = fltarr(nxr,nyr)
  for ix = 0, nxr-1 do begin
   for iy = 0, nyr-1 do begin
    lon0want[ix,iy] = ix*10.
    lon1want[ix,iy] = lon0want[ix,iy] + 10.
    lat0want[ix,iy] = -90.+iy*10.
    lat1want[ix,iy] = lat0want[ix,iy] + 10.
    xstr = 'x'+strcompress(string(fix(lon0want[ix,iy])),/rem)+'_'+$
               strcompress(string(fix(lon1want[ix,iy])),/rem)+'.'
    latsr = ''
    if(lat0want[ix,iy] lt 0) then latstr = 's'
    if(lat0want[ix,iy] gt 0) then latstr = 'n'
    ystr = latstr+strcompress(string(fix(abs(lat0want[ix,iy]))),/rem)+'_'
    latsr = ''
    if(lat1want[ix,iy] lt 0) then latstr = 's'
    if(lat1want[ix,iy] gt 0) then latstr = 'n'
    ystr = ystr+latstr+strcompress(string(fix(abs(lat1want[ix,iy]))),/rem)+'.'
    ixstr = strcompress(string(ix),/rem)
    if(ix lt 10) then ixstr = '0'+ixstr
    iystr = strcompress(string(iy),/rem)
    if(iy lt 10) then iystr = '0'+iystr
    rstr = 'r'+ixstr+'_'+iystr+'.'
    plottitle[ix,iy] = 'aot.'+rstr+xstr+ystr
   endfor
  endfor  

  for ix = 0, nxr-1 do begin
  for iy = 0, nyr-1 do begin

  i = 0
  filename = 'output/tables/'+filehead+plottitle[ix,iy]+sample[i]+'.txt'
  read_daily, filename, date, avg0, std0, num0

  i = 1
  filename = 'output/tables/'+filehead+plottitle[ix,iy]+sample[i]+'.txt'
  read_daily, filename, date, avg1, std1, num1

  i = 2
  filename = 'output/tables/'+filehead+plottitle[ix,iy]+sample[i]+'.txt'
  read_daily, filename, date, avg2, std2, num2

; Correlate the daily mean

; Loop over averaging periods
  ymin = 0
  w = [1, 5, 10, 30, 180, 360]
  rout = fltarr(6)
  iw = 0
  avg = avg0
  avg_ = avg1
  a = where(finite(avg) eq 1 and finite(avg_) eq 1)
  if(a[0] eq -1) then goto, cycle
  rout[iw] = correlate(avg[a],avg_[a])


  for iw = 1, 5 do begin
   avg = smooth_weighted(avg0,w[iw],weight=num0)
   avg_ = smooth_weighted(avg1,w[iw],weight=num1)
   a = where(finite(avg) eq 1 and finite(avg_) eq 1)
   if(a[0] eq -1) then goto, cycle
   rout[iw] = correlate(avg[a],avg_[a])
  endfor

  plot, indgen(10)+1, /nodata, $
   yrange=[ymin,1], xrange=[.1,1000], /xlog, $
   xtitle='Averaging period in days (running average weighted by obs)', $
   ytitle='Correlation Coefficient, r', $
   title='Correlation of MISR/Subpoint sampling with MODIS (GEOS-4)'
  xyouts, .01, .01, filehead+plottitle[ix,iy], align=0, /normal, charsize=.6

  plots, w, rout, thick=6



; Loop over averaging periods
  w = [1, 5, 10, 30, 180, 360]
  rout = fltarr(6)
  iw = 0
  avg = avg0
  avg_ = avg2
  a = where(finite(avg) eq 1 and finite(avg_) eq 1)
  if(a[0] eq -1) then goto, cycle
  rout[iw] = correlate(avg[a],avg_[a])


  for iw = 1, 5 do begin
   avg = smooth_weighted(avg0,w[iw],weight=num0)
   avg_ = smooth_weighted(avg2,w[iw],weight=num2)
   a = where(finite(avg) eq 1 and finite(avg_) eq 1)
   if(a[0] eq -1) then goto, cycle
   rout[iw] = correlate(avg[a],avg_[a])
  endfor

  plots, w, rout, thick=6, color=160


; Make the plot pretty
  plots, 1, [ymin,1]
  plots, 7, [ymin,1]
  plots, 30, [ymin,1]
  plots, 180, [ymin,1]
  plots, 360, [ymin,1]
  xyouts, 1.1, ymin+(1-ymin)*.05, '1-day'
  xyouts, 7.7, ymin+(1-ymin)*.05, '1-week'
  xyouts, 33, ymin+(1-ymin)*.05, '1-month'
  xyouts, 198, ymin+(1-ymin)*.05, '6-month'
  xyouts, 396, ymin+(1-ymin)*.125, '1-year'

  plots, [.15,.3], 1.-0.15*(1-ymin), thick=6
  plots, [.15,.3], 1.-0.25*(1-ymin), thick=6, color=160
  xyouts, .33, 1.-0.16*(1-ymin), 'MISR'
  xyouts, .33, 1.-0.26*(1-ymin), 'Subpoint'

  map_set, /noerase, position=[.15,.15,.34,.4], /cont
  x0 = lon0want[ix,iy]
  x1 = lon1want[ix,iy]
  y0 = lat0want[ix,iy]
  y1 = lat1want[ix,iy]
  polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0]

cycle:
  endfor
  endfor


  device, /close


end

