  set_plot, 'ps'
  device, file='./output/plots/frequency.MOD04.d.shift.ps', $
   /color, font_size=8, xsize=16, ysize=12, /helvetica
  !P.font=0

  color  = [254,176,80]
  filehead = './output/tables/MOD04_regions.d.freq.daily.aot.'
;  filehead = './output/tables/t003_c32.MOD04.freq.aot.'
  sample = ['modis','shift_misr','shift_subpoint']
  regstr = ['r01.x180_270.n30_70', $
            'r02.x270_360.n30_70', $
            'r03.x0_90.n30_70', $
            'r04.x90_180.n30_70', $
            'r05.x180_270.n0_30', $
            'r06.x270_360.n0_30', $
            'r07.x0_90.n0_30', $
            'r08.x90_180.n0_30', $
            'r09.x180_270.s30_0', $
            'r10.x270_360.s30_0', $
            'r11.x0_90.s30_0', $
            'r12.x90_180.s30_0', $
            'r13.x270_360.s70_30']+'.'


; Total
  loadct, 39
  map_set, limit=[-70,-180,70,180], /noborder
  map_continents, thick=2
  xyouts, -170, -40, '2000 - 2006 Average'
  plots, [-170,-160], -45, thick=3, color=254
  plots, [-170,-160], -50, thick=3, color=176
  plots, [-170,-160], -55, thick=3, color=84
  xyouts, -155, -45.5, 'MODIS'
  xyouts, -155, -50.5, 'MISR'
  xyouts, -155, -55.5, 'Nadir'

  for ireg = 0, n_elements(regstr)-1 do begin

; tokenize the region to get the plot limits
  token = strsplit(regstr[ireg],'.',/extract)
  lpos = strpos(token[1],'_')
  lon0 = strmid(token[1],1,lpos-1)
  lon1 = strmid(token[1],lpos+1,strlen(token[1])-lpos)
  if(lon0 ge 180) then lon0 = lon0-360.
  if(lon1 gt 180) then lon1 = lon1-360.
  lpos = strpos(token[2],'_')
  lat0 = strmid(token[2],1,lpos-1)
  lat1 = strmid(token[2],lpos+1,strlen(token[2])-lpos)
  if(strmid(token[2],0,1) eq 's') then begin
   lat0 = -lat0
   lat1 = -lat1
  endif

; position of plot
  position = [.05 + (lon0-(-180.))/360., $
              .025 + (lat0-(-70.))/140., $
              -0.025+(lon1-(-180.))/360., $
              -0.025+(lat1-(-70.))/140.]

  plot, indgen(10), position=position, /noerase, /nodata, $
   yrange=[.001,1], ylog=1, ytitle='freq', ystyle=9, ythick=3, $
   xrange=[0,1], xtitle='AOT', xstyle=9, xthick=3

  for is = 0, n_elements(sample)-1 do begin
   filename = filehead+regstr[ireg]+sample[is]+'.txt'
   read_frequency_histogram, filename, $
     date, histnorm, num, histmin, histmax, nbin
   nt = n_elements(date)
   dx = (histmax-histmin)/nbin
   x = histmin+dx/2. + findgen(nbin)*dx
   y = fltarr(nbin)
   for i = 0, nbin-1 do begin
    y[i] = mean(histnorm[i,*],/nan)
   endfor
   oplot, x, y, thick=3, color=color[is]
;  Find average/std of histogram
;  Expand
   y_ = fix(y*1000)
   x_ = fltarr(total(y_))
   x_[0:y_[0]-1] = x[0]
   i0 = y_[0]
   for i = 1, nbin-1 do begin
    i1 = i0+y_[i]-1
    if(i1 ge i0) then x_[i0:i1] = x[i]
    i0=i1+1
   endfor
   avg = strcompress(string(mean(x_),format='(f5.3)'),/rem)
   std = strcompress(string(stddev(x_),format='(f5.3)'),/rem)
   xyouts, .5, 10^(alog10(.5)-.25*float(is)), '!Mt!3='+avg+'; !Ms!3='+std, color=color[is], chars=.7
  endfor

  endfor


; JFM
  loadct, 39
  map_set, limit=[-70,-180,70,180], /noborder
  map_continents, thick=2
  xyouts, -170, -40, 'JFM 2000 - 2006 Average'
  plots, [-170,-160], -45, thick=3, color=254
  plots, [-170,-160], -50, thick=3, color=176
  plots, [-170,-160], -55, thick=3, color=84
  xyouts, -155, -45.5, 'MODIS'
  xyouts, -155, -50.5, 'MISR'
  xyouts, -155, -55.5, 'Nadir'

  for ireg = 0, n_elements(regstr)-1 do begin

; tokenize the region to get the plot limits
  token = strsplit(regstr[ireg],'.',/extract)
  lpos = strpos(token[1],'_')
  lon0 = strmid(token[1],1,lpos-1)
  lon1 = strmid(token[1],lpos+1,strlen(token[1])-lpos)
  if(lon0 ge 180) then lon0 = lon0-360.
  if(lon1 gt 180) then lon1 = lon1-360.
  lpos = strpos(token[2],'_')
  lat0 = strmid(token[2],1,lpos-1)
  lat1 = strmid(token[2],lpos+1,strlen(token[2])-lpos)
  if(strmid(token[2],0,1) eq 's') then begin
   lat0 = -lat0
   lat1 = -lat1
  endif

; position of plot
  position = [.05 + (lon0-(-180.))/360., $
              .025 + (lat0-(-70.))/140., $
              -0.025+(lon1-(-180.))/360., $
              -0.025+(lat1-(-70.))/140.]

  plot, indgen(10), position=position, /noerase, /nodata, $
   yrange=[.001,1], ylog=1, ytitle='freq', ystyle=9, ythick=3, $
   xrange=[0,1], xtitle='AOT', xstyle=9, xthick=3

  for is = 0, n_elements(sample)-1 do begin
   filename = filehead+regstr[ireg]+sample[is]+'.txt'
   read_frequency_histogram, filename, $
     date, histnorm, num, histmin, histmax, nbin
   date = strcompress(string(date),/rem)
   a = where(strmid(date,4,2) le '03')
   nt = n_elements(date)
   dx = (histmax-histmin)/nbin
   x = histmin+dx/2. + findgen(nbin)*dx
   y = fltarr(nbin)
   for i = 0, nbin-1 do begin
    y[i] = mean(histnorm[i,a],/nan)
   endfor
   oplot, x, y, thick=3, color=color[is]
;  Find average/std of histogram
;  Expand
   y_ = fix(y*1000)
   x_ = fltarr(total(y_))
   x_[0:y_[0]-1] = x[0]
   i0 = y_[0]
   for i = 1, nbin-1 do begin
    i1 = i0+y_[i]-1
    if(i1 ge i0) then x_[i0:i1] = x[i]
    i0=i1+1
   endfor
   avg = strcompress(string(mean(x_),format='(f5.3)'),/rem)
   std = strcompress(string(stddev(x_),format='(f5.3)'),/rem)
   xyouts, .5, 10^(alog10(.5)-.25*float(is)), '!Mt!3='+avg+'; !Ms!3='+std, color=color[is], chars=.7
  endfor

  endfor

; AMJ
  loadct, 39
  map_set, limit=[-70,-180,70,180], /noborder
  map_continents, thick=2
  xyouts, -170, -40, 'AMJ 2000 - 2006 Average'
  plots, [-170,-160], -45, thick=3, color=254
  plots, [-170,-160], -50, thick=3, color=176
  plots, [-170,-160], -55, thick=3, color=84
  xyouts, -155, -45.5, 'MODIS'
  xyouts, -155, -50.5, 'MISR'
  xyouts, -155, -55.5, 'Nadir'

  for ireg = 0, n_elements(regstr)-1 do begin

; tokenize the region to get the plot limits
  token = strsplit(regstr[ireg],'.',/extract)
  lpos = strpos(token[1],'_')
  lon0 = strmid(token[1],1,lpos-1)
  lon1 = strmid(token[1],lpos+1,strlen(token[1])-lpos)
  if(lon0 ge 180) then lon0 = lon0-360.
  if(lon1 gt 180) then lon1 = lon1-360.
  lpos = strpos(token[2],'_')
  lat0 = strmid(token[2],1,lpos-1)
  lat1 = strmid(token[2],lpos+1,strlen(token[2])-lpos)
  if(strmid(token[2],0,1) eq 's') then begin
   lat0 = -lat0
   lat1 = -lat1
  endif

; position of plot
  position = [.05 + (lon0-(-180.))/360., $
              .025 + (lat0-(-70.))/140., $
              -0.025+(lon1-(-180.))/360., $
              -0.025+(lat1-(-70.))/140.]

  plot, indgen(10), position=position, /noerase, /nodata, $
   yrange=[.001,1], ylog=1, ytitle='freq', ystyle=9, ythick=3, $
   xrange=[0,1], xtitle='AOT', xstyle=9, xthick=3

  for is = 0, n_elements(sample)-1 do begin
   filename = filehead+regstr[ireg]+sample[is]+'.txt'
   read_frequency_histogram, filename, $
     date, histnorm, num, histmin, histmax, nbin
   date = strcompress(string(date),/rem)
   a = where(strmid(date,4,2) gt '03' and strmid(date,4,2) le '06')
   nt = n_elements(date)
   dx = (histmax-histmin)/nbin
   x = histmin+dx/2. + findgen(nbin)*dx
   y = fltarr(nbin)
   for i = 0, nbin-1 do begin
    y[i] = mean(histnorm[i,a],/nan)
   endfor
   oplot, x, y, thick=3, color=color[is]
;  Find average/std of histogram
;  Expand
   y_ = fix(y*1000)
   x_ = fltarr(total(y_))
   x_[0:y_[0]-1] = x[0]
   i0 = y_[0]
   for i = 1, nbin-1 do begin
    i1 = i0+y_[i]-1
    if(i1 ge i0) then x_[i0:i1] = x[i]
    i0=i1+1
   endfor
   avg = strcompress(string(mean(x_),format='(f5.3)'),/rem)
   std = strcompress(string(stddev(x_),format='(f5.3)'),/rem)
   xyouts, .5, 10^(alog10(.5)-.25*float(is)), '!Mt!3='+avg+'; !Ms!3='+std, color=color[is], chars=.7
  endfor

  endfor

; JAS
  loadct, 39
  map_set, limit=[-70,-180,70,180], /noborder
  map_continents, thick=2
  xyouts, -170, -40, 'JAS 2000 - 2006 Average'
  plots, [-170,-160], -45, thick=3, color=254
  plots, [-170,-160], -50, thick=3, color=176
  plots, [-170,-160], -55, thick=3, color=84
  xyouts, -155, -45.5, 'MODIS'
  xyouts, -155, -50.5, 'MISR'
  xyouts, -155, -55.5, 'Nadir'

  for ireg = 0, n_elements(regstr)-1 do begin

; tokenize the region to get the plot limits
  token = strsplit(regstr[ireg],'.',/extract)
  lpos = strpos(token[1],'_')
  lon0 = strmid(token[1],1,lpos-1)
  lon1 = strmid(token[1],lpos+1,strlen(token[1])-lpos)
  if(lon0 ge 180) then lon0 = lon0-360.
  if(lon1 gt 180) then lon1 = lon1-360.
  lpos = strpos(token[2],'_')
  lat0 = strmid(token[2],1,lpos-1)
  lat1 = strmid(token[2],lpos+1,strlen(token[2])-lpos)
  if(strmid(token[2],0,1) eq 's') then begin
   lat0 = -lat0
   lat1 = -lat1
  endif

; position of plot
  position = [.05 + (lon0-(-180.))/360., $
              .025 + (lat0-(-70.))/140., $
              -0.025+(lon1-(-180.))/360., $
              -0.025+(lat1-(-70.))/140.]

  plot, indgen(10), position=position, /noerase, /nodata, $
   yrange=[.001,1], ylog=1, ytitle='freq', ystyle=9, ythick=3, $
   xrange=[0,1], xtitle='AOT', xstyle=9, xthick=3

  for is = 0, n_elements(sample)-1 do begin
   filename = filehead+regstr[ireg]+sample[is]+'.txt'
   read_frequency_histogram, filename, $
     date, histnorm, num, histmin, histmax, nbin
   date = strcompress(string(date),/rem)
   a = where(strmid(date,4,2) gt '06' and strmid(date,4,2) le '09')
   nt = n_elements(date)
   dx = (histmax-histmin)/nbin
   x = histmin+dx/2. + findgen(nbin)*dx
   y = fltarr(nbin)
   for i = 0, nbin-1 do begin
    y[i] = mean(histnorm[i,a],/nan)
   endfor
   oplot, x, y, thick=3, color=color[is]
;  Find average/std of histogram
;  Expand
   y_ = fix(y*1000)
   x_ = fltarr(total(y_))
   x_[0:y_[0]-1] = x[0]
   i0 = y_[0]
   for i = 1, nbin-1 do begin
    i1 = i0+y_[i]-1
    if(i1 ge i0) then x_[i0:i1] = x[i]
    i0=i1+1
   endfor
   avg = strcompress(string(mean(x_),format='(f5.3)'),/rem)
   std = strcompress(string(stddev(x_),format='(f5.3)'),/rem)
   xyouts, .5, 10^(alog10(.5)-.25*float(is)), '!Mt!3='+avg+'; !Ms!3='+std, color=color[is], chars=.7
  endfor

  endfor

; OND
  loadct, 39
  map_set, limit=[-70,-180,70,180], /noborder
  map_continents, thick=2
  xyouts, -170, -40, 'OND 2000 - 2006 Average'
  plots, [-170,-160], -45, thick=3, color=254
  plots, [-170,-160], -50, thick=3, color=176
  plots, [-170,-160], -55, thick=3, color=84
  xyouts, -155, -45.5, 'MODIS'
  xyouts, -155, -50.5, 'MISR'
  xyouts, -155, -55.5, 'Nadir'

  for ireg = 0, n_elements(regstr)-1 do begin

; tokenize the region to get the plot limits
  token = strsplit(regstr[ireg],'.',/extract)
  lpos = strpos(token[1],'_')
  lon0 = strmid(token[1],1,lpos-1)
  lon1 = strmid(token[1],lpos+1,strlen(token[1])-lpos)
  if(lon0 ge 180) then lon0 = lon0-360.
  if(lon1 gt 180) then lon1 = lon1-360.
  lpos = strpos(token[2],'_')
  lat0 = strmid(token[2],1,lpos-1)
  lat1 = strmid(token[2],lpos+1,strlen(token[2])-lpos)
  if(strmid(token[2],0,1) eq 's') then begin
   lat0 = -lat0
   lat1 = -lat1
  endif

; position of plot
  position = [.05 + (lon0-(-180.))/360., $
              .025 + (lat0-(-70.))/140., $
              -0.025+(lon1-(-180.))/360., $
              -0.025+(lat1-(-70.))/140.]

  plot, indgen(10), position=position, /noerase, /nodata, $
   yrange=[.001,1], ylog=1, ytitle='freq', ystyle=9, ythick=3, $
   xrange=[0,1], xtitle='AOT', xstyle=9, xthick=3

  for is = 0, n_elements(sample)-1 do begin
   filename = filehead+regstr[ireg]+sample[is]+'.txt'
   read_frequency_histogram, filename, $
     date, histnorm, num, histmin, histmax, nbin
   date = strcompress(string(date),/rem)
   a = where(strmid(date,4,2) gt '09')
   nt = n_elements(date)
   dx = (histmax-histmin)/nbin
   x = histmin+dx/2. + findgen(nbin)*dx
   y = fltarr(nbin)
   for i = 0, nbin-1 do begin
    y[i] = mean(histnorm[i,a],/nan)
   endfor
   oplot, x, y, thick=3, color=color[is]
;  Find average/std of histogram
;  Expand
   y_ = fix(y*1000)
   x_ = fltarr(total(y_))
   x_[0:y_[0]-1] = x[0]
   i0 = y_[0]
   for i = 1, nbin-1 do begin
    i1 = i0+y_[i]-1
    if(i1 ge i0) then x_[i0:i1] = x[i]
    i0=i1+1
   endfor
   avg = strcompress(string(mean(x_),format='(f5.3)'),/rem)
   std = strcompress(string(stddev(x_),format='(f5.3)'),/rem)
   xyouts, .5, 10^(alog10(.5)-.25*float(is)), '!Mt!3='+avg+'; !Ms!3='+std, color=color[is], chars=.7
  endfor

  endfor


; May 2003
  loadct, 39
  map_set, limit=[-70,-180,70,180], /noborder
  map_continents, thick=2
  xyouts, -170, -40, 'May 2003'
  plots, [-170,-160], -45, thick=3, color=254
  plots, [-170,-160], -50, thick=3, color=176
  plots, [-170,-160], -55, thick=3, color=84
  xyouts, -155, -45.5, 'MODIS'
  xyouts, -155, -50.5, 'MISR'
  xyouts, -155, -55.5, 'Nadir'

  for ireg = 0, n_elements(regstr)-1 do begin

; tokenize the region to get the plot limits
  token = strsplit(regstr[ireg],'.',/extract)
  lpos = strpos(token[1],'_')
  lon0 = strmid(token[1],1,lpos-1)
  lon1 = strmid(token[1],lpos+1,strlen(token[1])-lpos)
  if(lon0 ge 180) then lon0 = lon0-360.
  if(lon1 gt 180) then lon1 = lon1-360.
  lpos = strpos(token[2],'_')
  lat0 = strmid(token[2],1,lpos-1)
  lat1 = strmid(token[2],lpos+1,strlen(token[2])-lpos)
  if(strmid(token[2],0,1) eq 's') then begin
   lat0 = -lat0
   lat1 = -lat1
  endif

; position of plot
  position = [.05 + (lon0-(-180.))/360., $
              .025 + (lat0-(-70.))/140., $
              -0.025+(lon1-(-180.))/360., $
              -0.025+(lat1-(-70.))/140.]

  plot, indgen(10), position=position, /noerase, /nodata, $
   yrange=[.001,1], ylog=1, ytitle='freq', ystyle=9, ythick=3, $
   xrange=[0,1], xtitle='AOT', xstyle=9, xthick=3

  for is = 0, n_elements(sample)-1 do begin
   filename = filehead+regstr[ireg]+sample[is]+'.txt'
   read_frequency_histogram, filename, $
     date, histnorm, num, histmin, histmax, nbin
   date = strcompress(string(date),/rem)
   a = where(strmid(date,0,6) gt '200305')
   nt = n_elements(date)
   dx = (histmax-histmin)/nbin
   x = histmin+dx/2. + findgen(nbin)*dx
   y = fltarr(nbin)
   for i = 0, nbin-1 do begin
    y[i] = mean(histnorm[i,a],/nan)
   endfor
   oplot, x, y, thick=3, color=color[is]
;  Find average/std of histogram
;  Expand
   y_ = fix(y*1000)
   x_ = fltarr(total(y_))
   x_[0:y_[0]-1] = x[0]
   i0 = y_[0]
   for i = 1, nbin-1 do begin
    i1 = i0+y_[i]-1
    if(i1 ge i0) then x_[i0:i1] = x[i]
    i0=i1+1
   endfor
   avg = strcompress(string(mean(x_),format='(f5.3)'),/rem)
   std = strcompress(string(stddev(x_),format='(f5.3)'),/rem)
   xyouts, .5, 10^(alog10(.5)-.25*float(is)), '!Mt!3='+avg+'; !Ms!3='+std, color=color[is], chars=.7
  endfor

  endfor

  device, /close

end

