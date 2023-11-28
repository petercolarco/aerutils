; Plot dust emission time series and mean climatology

  yyyy = ['1911','1951']
  expid1 = 'S2S1850nrst'
  expid2 = 'S2S1850CO2x4pl'
  ylabel = 'AOD'
  plotf = 'plot_aod_time'

  expid = expid1+'_'+expid2

  ny = n_elements(yyyy)
  ndaysmon = [31,28,31,30,31,30,31,31,30,31,30,31]
  if(ny eq 2) then begin
   if(yyyy[0] ne yyyy[1]) then begin
    ny = fix(yyyy[1])-fix(yyyy[0]) + 1
    yyyy = strpad(fix(yyyy[0])+indgen(ny),1000L)
   endif
  endif
  if(ny eq 1) then begin
   yyyy = [yyyy[0],yyyy[0]]
   ny = 2
  endif
  ndaysmon_ = intarr(13,ny)
  for iy = 0, ny-1 do begin
   ndaysmon_[0:11,iy] = ndaysmon
   if( fix(yyyy[iy]/4) eq (yyyy[iy]/4.)) then ndaysmon_[1,iy] = 29.
   ndaysmon_[12,iy] = total(ndaysmon_[0:11,iy])
  endfor
  nymd = strarr(ny*12)
  for j = 0, ny-1 do begin
  for i = 0, 11 do begin
   nymd[j*12+i] = string(fix(yyyy[j])*10000L+(i+1)*100L+15,format='(i8)')
  endfor
  endfor

  aertype = 'DU'
  read_budget_table, expid1, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, burden25=burden25
  duem1=reform(tau[0:11,*],12*ny)
  read_budget_table, expid2, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, burden25=burden25
  duem2=reform(tau[0:11,*],12*ny)
  plot_time, expid, duem1, 'duem', nymd, 'Dust', ylabel, plotf, second=duem2

  aertype = 'SS'
  read_budget_table, expid1, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, burden25=burden25
  ssem1=reform(tau[0:11,*],12*ny)
  read_budget_table, expid2, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, burden25=burden25
  ssem2=reform(tau[0:11,*],12*ny)
  plot_time, expid, ssem1, 'ssem', nymd, 'Sea Salt', ylabel, plotf, second=ssem2

  aertype = 'BC'
  read_budget_table, expid1, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  bcem1=reform(tau[0:11,*],12*ny)
  read_budget_table, expid2, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  bcem2=reform(tau[0:11,*],12*ny)
  plot_time, expid, bcem1, 'bcem', nymd, 'Black Carbon', ylabel, plotf, second=bcem2

  aertype = 'POM'
  read_budget_table, expid1, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  ocem1=reform(tau[0:11,*],12*ny)
  read_budget_table, expid2, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  ocem2=reform(tau[0:11,*],12*ny)
  plot_time, expid, ocem1, 'ocem', nymd, 'Primary Organic Aerosol', ylabel, plotf, second=ocem2

  aertype = 'SU'
  read_budget_table, expid1, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                     pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms
  so4em1 = reform(tau[0:11,*],12*ny)
  read_budget_table, expid2, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                     pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms
  so4em2 = reform(tau[0:11,*],12*ny)
  plot_time, expid, so4em1, 'sulf', nymd, 'Sulfate', ylabel, plotf, second=so4em2

  aertype = 'NI'
  read_budget_table, expid1, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                     sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh4
  nh3em1 = reform(tau[0:11,*],12*ny)
  read_budget_table, expid2, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                     sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh4
  nh3em2 = reform(tau[0:11,*],12*ny)
  plot_time, expid, nh3em1, 'nh3em', nymd, 'Nitrate', ylabel, plotf, second=nh3em2

end
