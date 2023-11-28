; Plot dust emission time series and mean climatology

  yyyy = ['1911','1951']
  expid = 'S2S1850nrst'
;  expid = 'S2S1850CO2x4pl'

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
  read_budget_table, expid, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, burden25=burden25
  duem=reform(emis[0:11,*],12*ny)
  plot_time, expid, duem, 'duem', nymd, 'Dust'

  aertype = 'SS'
  read_budget_table, expid, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, burden25=burden25
  ssem=reform(emis[0:11,*],12*ny)
  plot_time, expid, ssem, 'ssem', nymd, 'Sea Salt'

  aertype = 'BC'
  read_budget_table, expid, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  bcem=reform(emis[0:11,*],12*ny)
  plot_time, expid, bcem, 'bcem', nymd, 'Black Carbon';, second=bcem-bcembb

  aertype = 'POM'
  read_budget_table, expid, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  ocem=reform(emis[0:11,*],12*ny)
  plot_time, expid, ocem, 'ocem', nymd, 'Primary Organic Aerosol';, second=oceman

  aertype = 'SU'
  read_budget_table, expid, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                     pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms
  so4em = reform(emis[0:11,*],12*ny)
  so2em = reform(emisso2[0:11,*],12*ny)
  pso4aq = reform(pso4liq[0:11,*],12*ny)
  pso4g  = reform(pso4g[0:11,*],12*ny)
  plot_time, expid, so2em, 'sulf', nymd, 'Sulfur', second=so4em
  plot_time, expid, pso4aq, 'sulfchem', nymd, 'Sulfate Production', second=pso4g

  aertype = 'NI'
  read_budget_table, expid, aertype, yyyy, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                     sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh4
  niht = reform(pno3ht[0:11,*],12*ny)
  nh3em = reform(emis[0:11,*],12*ny)
  nipno3aq = reform(pno3aq[0:11,*],12*ny)
  plot_time, expid, niht, 'niht', nymd, 'Nitrate Heterogeneous Production'
  plot_time, expid, nh3em, 'nh3em', nymd, 'Ammonia Emissions'
  plot_time, expid, nipno3aq, 'nipno3aq', nymd, 'Nitrate Aqueous Production'

end
