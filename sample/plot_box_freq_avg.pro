  filehead = 'MOD04_regions.d.freq.daily.aot.'
  region   = 'r30_12.x300_310.n30_n40.'

  filename = 'output/tables/'+filehead+region+'modis.'
  read_frequency_histogram, filename, $
    date, histnorm, num, histmin, histmax, nbin, yyyy=['2000','2001','2002','2003','2004','2005','2006']
  histnorm0 = histnorm
  num0 = num

  i = 1
  filename = 'output/tables/'+filehead+region+'shift_misr.'
  read_frequency_histogram, filename, $
    date, histnorm, num, histmin, histmax, nbin, yyyy=['2000','2001','2002','2003','2004','2005','2006']
  histnorm1 = histnorm
  num1 = num

  i = 2
  filename = 'output/tables/'+filehead+region+'shift_subpoint.'
  read_frequency_histogram, filename, $
    date, histnorm, num, histmin, histmax, nbin, yyyy=['2000','2001','2002','2003','2004','2005','2006']
  histnorm2 = histnorm
  num2 = num

; Do a weighting over different periods
  ndays = [1,3,5,9,15,30,60,90,180,360,720,1540]
  weightedaot = fltarr(nbin,n_elements(date),3,12)
  weightedaot[*,*,0,0] = histnorm0
  weightedaot[*,*,1,0] = histnorm1
  weightedaot[*,*,2,0] = histnorm2
  for j = 0, nbin-1 do begin
   for i = 1, 11 do begin
    weightedaot[j,*,0,i] = smooth_weighted(reform(histnorm0[j,*]),ndays[i],weight=num0)
    weightedaot[j,*,1,i] = smooth_weighted(reform(histnorm1[j,*]),ndays[i],weight=num1)
    weightedaot[j,*,2,i] = smooth_weighted(reform(histnorm2[j,*]),ndays[i],weight=num2)
   endfor
  endfor

  iday = 918
  ymax = make_array(nbin,val=1.)
  if(  region eq 'r30_12.x300_310.n30_n40.') then $
   ymax[5] = .1

  set_plot, 'ps'
  datestr = string(date[iday],format='(i8)')
  device, file='output/plots/'+filehead+region+datestr+'.box_freq_avg.ps', $
   xoff=.5, yoff=.5, xsize=12, ysize=10, /color, /helvetica, font_size=14
  !p.font=1
  loadct, 39

  for j = 0, nbin-1 do begin

  quant = reform(total(weightedaot[j:nbin-1,iday,*,*],1,/nan))
  a = where(reform(total(weightedaot[0:nbin-1,iday,*,*],1,/nan)) eq 0)
  if(a[0] ne -1) then quant[a] = !values.f_nan

  plot, ndays, quant[0,*], /xlog, /nodata, $
   xrange=[1,1000], xstyle=9, xthick=3, xtitle='Days of Averaging', $
   yrange=[0,ymax[j]], ystyle=9, ythick=3, ytitle='Fraction', $
   title=string(date[iday])+' '+string(j)
  oplot, ndays, quant[0,*], thick=6, color=254
  oplot, ndays, quant[1,*], thick=6, color=60
  oplot, ndays, quant[2,*], thick=6, color=140
  xyouts, 100, .94*ymax[j], 'MODIS', color=254
  xyouts, 100, .88*ymax[j], 'MISR', color=60
  xyouts, 100, .82*ymax[j], 'Subpoint', color=140

  endfor

  device, /close

end
