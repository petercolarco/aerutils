  filehead = 'MOD04_regions.d.daily.aot.'
  region   = 'r30_12.x300_310.n30_n40.'

  filename = 'output/tables/'+filehead+region+'modis.'
  read_daily, filename, date, avg0, std0, num0, $
              yyyy=['2000','2001','2002','2003','2004','2005','2006']

  i = 1
  filename = 'output/tables/'+filehead+region+'shift_misr.'
  read_daily, filename, date, avg1, std1, num1, $
              yyyy=['2000','2001','2002','2003','2004','2005','2006']

  i = 2
  filename = 'output/tables/'+filehead+region+'shift_subpoint.'
  read_daily, filename, date, avg2, std2, num2, $
              yyyy=['2000','2001','2002','2003','2004','2005','2006']


; Do a weighting over different periods
  ndays = [1,3,5,9,15,30,60,90,180,360,720,1540]
  weightedaot = fltarr(n_elements(date),3,12)
  weightedaot[*,0,0] = avg0
  weightedaot[*,1,0] = avg1
  weightedaot[*,2,0] = avg2
  for i = 1, 11 do begin
   weightedaot[*,0,i] = smooth_weighted(avg0,ndays[i],weight=num0)
   weightedaot[*,1,i] = smooth_weighted(avg1,ndays[i],weight=num1)
   weightedaot[*,2,i] = smooth_weighted(avg2,ndays[i],weight=num2)
  endfor

  iday = 918
  ymax = 1
  set_plot, 'ps'
  datestr = string(date[iday],format='(i8)')
  device, file='output/plots/'+filehead+region+datestr+'.box_qasum_avg.ps', $
   xoff=.5, yoff=.5, xsize=12, ysize=10, /color, /helvetica, font_size=14
  !p.font=1
  loadct, 39
  plot, ndays, weightedaot[iday,0,*], /xlog, /nodata, $
   xrange=[1,1000], xstyle=9, xthick=3, xtitle='Days of Averaging', $
   yrange=[0,ymax], ystyle=9, ythick=3, ytitle='AOT', $
   title=date[iday]
  oplot, ndays, weightedaot[iday,0,*], thick=6, color=254
  oplot, ndays, weightedaot[iday,1,*], thick=6, color=60
  oplot, ndays, weightedaot[iday,2,*], thick=6, color=140
  xyouts, 100, .94*ymax, 'MODIS', color=254
  xyouts, 100, .88*ymax, 'MISR', color=60
  xyouts, 100, .82*ymax, 'Subpoint', color=140

  device, /close

end

