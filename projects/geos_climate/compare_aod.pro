  expid0 = 'S2S1850nrst'
  expid1 = 'S2S1850CO2x4pl'
  expid2 = 'CO2x4sensSS'
  expid3 = 'CO2x4sensNI'

  set_plot, 'ps'
  device, file='compare_aod.ps', /color
  !p.font=0


  loadct, 39

  plot, indgen(10)+1, /nodata, $
   /ylog, yrange=[0.0001,0.1], ytitle='AOD', $
   xrange=[0,7], xticks=7, xminor=1, $
   xtickname=[' ','DU','SS','SU','OC','BC','NI',' ']

  aers = ['DU','SS','SU','POM','BC','NI']
  color = [208,80,176,255,0,48]

  for i = 0, 5 do begin

  linecolor=0
  if(i eq 4) then linecolor=0

  expand_yyyy, ['1991','2000'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid0, aers[i], yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau
  boxwhisker, tau[0:11,*], i+0.7, 0.15, color[i], $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv, $
    linethick=1, linecolor=linecolor

  expand_yyyy, ['1945','1952'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid1, aers[i], yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau
  boxwhisker, tau[0:11,*], i+.9, 0.15, color[i], $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv, $
    linethick=1, linecolor=linecolor
check, burden


  expand_yyyy, ['1995','2004'], yyyy2, ny, ndaysmonOut
  get_budget_table, expid2, aers[i], yyyy2, $
                    emis, sed, dep, wet, scav, burden, tau
  boxwhisker, tau[0:11,*], i+1.1, 0.15, color[i], $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv, $
    linethick=1, linecolor=linecolor
check, burden

if(i eq 5) then break
  expand_yyyy, ['1995','1999'], yyyy2, ny, ndaysmonOut
  get_budget_table, expid3, aers[i], yyyy2, $
                    emis, sed, dep, wet, scav, burden, tau
  boxwhisker, tau[0:11,*], i+1.3, 0.15, color[i], $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv, $
    linethick=1, linecolor=linecolor
check, burden
  endfor

  device, /close

end
