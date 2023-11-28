  filehead = 'MOD04_regions.d.daily.aot.'
  filehead = 't003_c32.MOD04.daily.aot.'
  sample = ['modis','misr.shift','subpoint.shift']
;  regstr = 'r06.x270_360.n0_30.'
;  numrange = 5000
  regstr = 'r33_10.x330_340.n10_n20.'
  numrange = 100


  set_plot, 'ps'
  device, file='./output/plots/'+filehead+regstr+'shift.ps', $
   /color, font_size=8, xsize=16, ysize=12, /helvetica
  !P.font=0

  color  = [254,176,80]

; Daily average
; -----------------------------
; First plot the overall statistic panels of daily stuff
  for i = 0, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avg, std, num
   n = n_elements(date)
   plot, indgen(10), /nodata, $
    yrange=[0,0.8], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.6,0.95,0.95], $
    xtitle = 'Day', ytitle = 'AOT', title = regstr+sample[i]
   for j = 0, n-1 do begin
    if(num[j] gt 3) then plots, j, avg[j]+[std[j],-std[j]], color=160, noclip=0
   endfor
   oplot, avg

   plot, indgen(10), /nodata, /noerase, $
    yrange=[0,numrange], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.1,0.95,0.45], $
    xtitle = 'Day', ytitle = '#', title = regstr+sample[i]
   oplot, num

  endfor

; Next plot a scatter of different strategies against
  colorpoint = [0, 0, 160]
  plot, indgen(2), $
    yrange=[0,1], ystyle=9, ythick=3, $
    xrange=[0,1], xstyle=9, xthick=3, $
    position = [0.175,0.1,0.825,0.95], $
    xtitle = 'MODIS Swath', ytitle = 'MISR/Subpoint SWATH', title = regstr+' (Daily)'
  for i = 1, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[0]+'.txt'
   read_daily, filename, date, avg, std, num
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avgsample, stdsample, numsample
   a = where(num ne 0 and numsample ne 0)
   statistics, avg[a], avgsample[a], $
               mean0, mean1, std0, std1, r, bias, rms, skill, $
               linslope, linoffset, rc=rc
   if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n_elements(a), format='(i4)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     xyouts, .125, .9-(i-1)*0.2-0.05, 'n = '+n
     xyouts, .125, .9-(i-1)*0.2-0.075, 'r = '+r
     xyouts, .125, .9-(i-1)*0.2-0.1, 'bias = '+bias
     xyouts, .25, .9-(i-1)*0.2-0.05, 'rms = '+rms
     xyouts, .25, .9-(i-1)*0.2-0.075, 'skill = '+skill
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .3, 1-i*0.2, 'y = '+m+'x + '+b
   endif

   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=colorpoint[i], /fill
   plots, .1, .9-(i-1)*0.2, psym=8, noclip=0
   xyouts, .125, .9-(i-1)*0.2-0.01, sample[i]+' (# = '+strcompress(string(n_elements(a)),/rem)+')

   for j = 0, n_elements(a)-1 do begin
    plots, avg[a[j]], avgsample[a[j]], psym=8, noclip=0
   endfor
  endfor


; Five Day running mean average
; -----------------------------
; First plot the overall statistic panels of daily stuff
  for i = 0, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,5,weight=num)
   std = smooth_weighted(std,5,weight=num)
   n = n_elements(date)
   plot, indgen(10), /nodata, $
    yrange=[0,0.8], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.6,0.95,0.95], $
    xtitle = 'Day', ytitle = 'AOT', title = regstr+sample[i]
   for j = 0, n-1 do begin
    if(num[j] gt 3) then plots, j, avg[j]+[std[j],-std[j]], color=160, noclip=0
   endfor
   oplot, avg

   plot, indgen(10), /nodata, /noerase, $
    yrange=[0,numrange], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.1,0.95,0.45], $
    xtitle = 'Day', ytitle = '#', title = regstr+sample[i]
   oplot, num

  endfor

; Next plot a scatter of different strategies against
  colorpoint = [0, 0, 160]
  plot, indgen(2), $
    yrange=[0,1], ystyle=9, ythick=3, $
    xrange=[0,1], xstyle=9, xthick=3, $
    position = [0.175,0.1,0.825,0.95], $
    xtitle = 'MODIS Swath', ytitle = 'MISR/Subpoint SWATH', title = regstr+' (5-day)'
  for i = 1, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[0]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,5,weight=num)
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avgsample, stdsample, numsample
   avgsample = smooth_weighted(avgsample,5,weight=num)
   a = where(num ne 0 and numsample ne 0)
   statistics, avg[a], avgsample[a], $
               mean0, mean1, std0, std1, r, bias, rms, skill, $
               linslope, linoffset, rc=rc
   if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n_elements(a), format='(i4)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     xyouts, .125, .9-(i-1)*0.2-0.05, 'n = '+n
     xyouts, .125, .9-(i-1)*0.2-0.075, 'r = '+r
     xyouts, .125, .9-(i-1)*0.2-0.1, 'bias = '+bias
     xyouts, .25, .9-(i-1)*0.2-0.05, 'rms = '+rms
     xyouts, .25, .9-(i-1)*0.2-0.075, 'skill = '+skill
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .3, 1-i*0.2, 'y = '+m+'x + '+b
   endif

   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=colorpoint[i], /fill
   plots, .1, .9-(i-1)*0.2, psym=8, noclip=0
   xyouts, .125, .9-(i-1)*0.2-0.01, sample[i]+' (# = '+strcompress(string(n_elements(a)),/rem)+')

   for j = 0, n_elements(a)-1 do begin
    plots, avg[a[j]], avgsample[a[j]], psym=8, noclip=0
   endfor
  endfor




; Ten Day running mean average
; -----------------------------
; First plot the overall statistic panels of daily stuff
  for i = 0, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,10,weight=num)
   std = smooth_weighted(std,10,weight=num)
   n = n_elements(date)
   plot, indgen(10), /nodata, $
    yrange=[0,0.8], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.6,0.95,0.95], $
    xtitle = 'Day', ytitle = 'AOT', title = regstr+sample[i]
   for j = 0, n-1 do begin
    if(num[j] gt 3) then plots, j, avg[j]+[std[j],-std[j]], color=160, noclip=0
   endfor
   oplot, avg

   plot, indgen(10), /nodata, /noerase, $
    yrange=[0,numrange], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.1,0.95,0.45], $
    xtitle = 'Day', ytitle = '#', title = regstr+sample[i]
   oplot, num

  endfor

; Next plot a scatter of different strategies against
  colorpoint = [0, 0, 160]
  plot, indgen(2), $
    yrange=[0,1], ystyle=9, ythick=3, $
    xrange=[0,1], xstyle=9, xthick=3, $
    position = [0.175,0.1,0.825,0.95], $
    xtitle = 'MODIS Swath', ytitle = 'MISR/Subpoint SWATH', title = regstr+' (10-day)'
  for i = 1, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[0]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,10,weight=num)
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avgsample, stdsample, numsample
   avgsample = smooth_weighted(avgsample,10,weight=num)
   a = where(num ne 0 and numsample ne 0)
   statistics, avg[a], avgsample[a], $
               mean0, mean1, std0, std1, r, bias, rms, skill, $
               linslope, linoffset, rc=rc
   if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n_elements(a), format='(i4)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     xyouts, .125, .9-(i-1)*0.2-0.05, 'n = '+n
     xyouts, .125, .9-(i-1)*0.2-0.075, 'r = '+r
     xyouts, .125, .9-(i-1)*0.2-0.1, 'bias = '+bias
     xyouts, .25, .9-(i-1)*0.2-0.05, 'rms = '+rms
     xyouts, .25, .9-(i-1)*0.2-0.075, 'skill = '+skill
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .3, 1-i*0.2, 'y = '+m+'x + '+b
   endif

   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=colorpoint[i], /fill
   plots, .1, .9-(i-1)*0.2, psym=8, noclip=0
   xyouts, .125, .9-(i-1)*0.2-0.01, sample[i]+' (# = '+strcompress(string(n_elements(a)),/rem)+')

   for j = 0, n_elements(a)-1 do begin
    plots, avg[a[j]], avgsample[a[j]], psym=8, noclip=0
   endfor
  endfor








; Thirty Day running mean average
; -----------------------------
  for i = 0, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,30,weight=num)
   std = smooth_weighted(std,30,weight=num)
   n = n_elements(date)
   plot, indgen(10), /nodata, $
    yrange=[0,0.8], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.6,0.95,0.95], $
    xtitle = 'Day', ytitle = 'AOT', title = regstr+sample[i]
   for j = 0, n-1 do begin
    if(num[j] gt 3) then plots, j, avg[j]+[std[j],-std[j]], color=160, noclip=0
   endfor
   oplot, avg

   plot, indgen(10), /nodata, /noerase, $
    yrange=[0,numrange], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.1,0.95,0.45], $
    xtitle = 'Day', ytitle = '#', title = regstr+sample[i]
   oplot, num

  endfor

; Next plot a scatter of different strategies against
  colorpoint = [0, 0, 160]
  plot, indgen(2), $
    yrange=[0,1], ystyle=9, ythick=3, $
    xrange=[0,1], xstyle=9, xthick=3, $
    position = [0.175,0.1,0.825,0.95], $
    xtitle = 'MODIS Swath', ytitle = 'MISR/Subpoint SWATH', title = regstr+' (Monthly)'
  for i = 1, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[0]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,30,weight=num)
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avgsample, stdsample, numsample
   avgsample = smooth_weighted(avgsample,30,weight=num)
   a = where(num ne 0 and numsample ne 0)
   statistics, avg[a], avgsample[a], $
               mean0, mean1, std0, std1, r, bias, rms, skill, $
               linslope, linoffset, rc=rc
   if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n_elements(a), format='(i4)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     xyouts, .125, .9-(i-1)*0.2-0.05, 'n = '+n
     xyouts, .125, .9-(i-1)*0.2-0.075, 'r = '+r
     xyouts, .125, .9-(i-1)*0.2-0.1, 'bias = '+bias
     xyouts, .25, .9-(i-1)*0.2-0.05, 'rms = '+rms
     xyouts, .25, .9-(i-1)*0.2-0.075, 'skill = '+skill
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .3, 1-i*0.2, 'y = '+m+'x + '+b
   endif

   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=colorpoint[i], /fill
   plots, .1, .9-(i-1)*0.2, psym=8, noclip=0
   xyouts, .125, .9-(i-1)*0.2-0.01, sample[i]+' (# = '+strcompress(string(n_elements(a)),/rem)+')

   for j = 0, n_elements(a)-1 do begin
    plots, avg[a[j]], avgsample[a[j]], psym=8, noclip=0
   endfor
  endfor


; Annual running mean average
; -----------------------------
  for i = 0, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,365,weight=num)
   std = smooth_weighted(std,365,weight=num)
   n = n_elements(date)
   plot, indgen(10), /nodata, $
    yrange=[0,0.8], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.6,0.95,0.95], $
    xtitle = 'Day', ytitle = 'AOT', title = regstr+sample[i]
   for j = 0, n-1 do begin
    if(num[j] gt 3) then plots, j, avg[j]+[std[j],-std[j]], color=160, noclip=0
   endfor
   oplot, avg

   plot, indgen(10), /nodata, /noerase, $
    yrange=[0,numrange], ystyle=9, ythick=3, $
    xrange=[0,n], xstyle=9, xthick=3, $
    position = [0.1,0.1,0.95,0.45], $
    xtitle = 'Day', ytitle = '#', title = regstr+sample[i]
   oplot, num

  endfor

; Next plot a scatter of different strategies against
  colorpoint = [0, 0, 160]
  plot, indgen(2), $
    yrange=[0,1], ystyle=9, ythick=3, $
    xrange=[0,1], xstyle=9, xthick=3, $
    position = [0.175,0.1,0.825,0.95], $
    xtitle = 'MODIS Swath', ytitle = 'MISR/Subpoint SWATH', title = regstr+' (Yearly)'
  for i = 1, n_elements(sample)-1 do begin
   filename = 'output/tables/'+filehead+regstr+sample[0]+'.txt'
   read_daily, filename, date, avg, std, num
   avg = smooth_weighted(avg,365,weight=num)
   filename = 'output/tables/'+filehead+regstr+sample[i]+'.txt'
   read_daily, filename, date, avgsample, stdsample, numsample
   avgsample = smooth_weighted(avgsample,365,weight=num)
   a = where(num ne 0 and numsample ne 0)
   statistics, avg[a], avgsample[a], $
               mean0, mean1, std0, std1, r, bias, rms, skill, $
               linslope, linoffset, rc=rc
   if(rc eq 0) then begin
     plots, findgen(5), linslope*findgen(5)+linoffset, linestyle=2, noclip=0
     n = strcompress(string(n_elements(a), format='(i4)'),/rem)
     r = strcompress(string(r, format='(f6.3)'),/rem)
     bias = strcompress(string(bias, format='(f6.3)'),/rem)
     rms = strcompress(string(rms, format='(f6.3)'),/rem)
     skill = strcompress(string(skill, format='(f5.3)'),/rem)
     scale = !x.crange[1]
     xyouts, .125, .9-(i-1)*0.2-0.05, 'n = '+n
     xyouts, .125, .9-(i-1)*0.2-0.075, 'r = '+r
     xyouts, .125, .9-(i-1)*0.2-0.1, 'bias = '+bias
     xyouts, .25, .9-(i-1)*0.2-0.05, 'rms = '+rms
     xyouts, .25, .9-(i-1)*0.2-0.075, 'skill = '+skill
     m = string(linslope,format='(f5.2)')
     b = string(linoffset,format='(f5.2)')
     xyouts, .3, 1-i*0.2, 'y = '+m+'x + '+b
   endif

   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=colorpoint[i], /fill
   plots, .1, .9-(i-1)*0.2, psym=8, noclip=0
   xyouts, .125, .9-(i-1)*0.2-0.01, sample[i]+' (# = '+strcompress(string(n_elements(a)),/rem)+')

   for j = 0, n_elements(a)-1 do begin
    plots, avg[a[j]], avgsample[a[j]], psym=8, noclip=0
   endfor
  endfor








  device, /close

end

