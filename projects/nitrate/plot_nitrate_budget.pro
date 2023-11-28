  expid = 'bench_i329_gmi_free_c180'
  expip = 3
  set_plot, 'ps'
  device, file='plot_nitrate_budget.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  x = 2000.+findgen(241)/12.

  plot, x, indgen(241), /nodata, xticks=20, $
   xtickn=string([x[0:240:12]],format='(i4)'), $
   yrange=[0,10], xrange=[2000,2020]

  loadct, 39

   filetemplate = expid+'.tavg2d_aer_x.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   nc4readvar, filename, 'nicmass', nicmass, lon=lon, lat=lat, time=time
   nc4readvar, filename, 'nipno3aq', nipaq
;   nc4readvar, filename, 'nisv', nisv
;   nisv = -nisv
   nc4readvar, filename, 'nisv0', nisv, /sum, /tem
   nc4readvar, filename, 'nisd0', nisd, /sum, /tem
   nc4readvar, filename, 'nidp0', nidp, /sum, /tem
   nc4readvar, filename, 'niwt0', niwt, /sum, /tem
   nc4readvar, filename, 'niht0', niht, /sum, /tem
   area, lon, lat, nx, ny, dx, dy, area
   nim = aave(nicmass,area)*total(area)/1.e9
   nisv = aave(nisv,area)*total(area)/1.e9*30*86400
   nipaq = aave(nipaq,area)*total(area)/1.e9*30*86400
   nisd = aave(nisd,area)*total(area)/1.e9*30*86400
   nidp = aave(nidp,area)*total(area)/1.e9*30*86400
   niwt = aave(niwt,area)*total(area)/1.e9*30*86400
   niht = aave(niht,area)*total(area)/1.e9*30*86400
   x = 2000+expip+findgen(n_elements(time))/12.
   oplot, x, nim, thick=6
   oplot, x, niwt+nisv, thick=6, color=84
   oplot, x, nisd+nidp, thick=6, color=208
   oplot, x, niht+nipaq, thick=6, color=160
   oplot, x, niht+nipaq - (nisd+nidp+niwt+nisv), thick=6, lin=2
; Now plot the assumulated...
  tot = niht+nipaq - (nisd+nidp+niwt+nisv)
  accum = fltarr(n_elements(time))
  accum[0] = tot[0]
  for i = 1, n_elements(time)-1 do begin
   accum[i] = accum[i-1]+tot[i]
  endfor
  oplot, x, accum, thick=6, color=254


  device, /close

end
