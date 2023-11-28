; Colarco, Jan. 2008
; Read in the database of Prospero Barbados measurements and compare with the
; model results

  lon0 = -59.6
  lat0 = 13.15

; Read the model results
  ctlfile = 'b32dust.chem_diag.sfc.ctl'
  ga_getvar, ctlfile, ['dusmass','dusm25'], dusmass, $
    lon=lon, lat=lat, time=time, wantlon=lon0, wantlat=lat0, $
    wanttime=['197901','200612'], rc=rc
  
  nyears = 28
  xtime = indgen(nyears)*12+6
  xtickn = string(indgen(nyears)+1979,format='(i4)')

; Read the Prospero data file
  fileloc = '/output/colarco/Prospero/Barbados_65-03_18Sep06.txt'
  openr, lun, fileloc, /get_lun
  strhead = 'a'
  for i = 0, 6 do begin
   readf, lun, strhead
  endfor
  i = 0
  strlin = 'a'
  while(not eof(lun)) do begin
   readf, lun, strlin
   split = strsplit(strlin,/extract)
   if(i eq 0) then begin
    date = split[0]
    mass = split[1]
   endif else begin
    date = [date,split[0]]
    mass = [mass,split[1]]
   endelse
   i = i+1
  endwhile
  free_lun, lun


; the times are 0 at 197901
  date_ = indgen(i)-168
  a = where(date_ ge 0 and date_ lt 300)
  date_ = date_[a]
  mass  = mass[a]
  date  = date[a]
  mass = float(mass)
  a = where(mass lt 0)
  if(a[0] ne -1) then mass[a] = !values.f_nan

  dusm = reform(dusmass[0,0,*,0])*1e9
  dusm25 = reform(dusmass[0,0,*,1])*1e9
;  dzsm = reform(dzsmass[0,0,0:299,0])*1e9
;  dzsm25 = reform(dzsmass[0,0,0:299,1])*1e9

  a = where(finite(mass) eq 1)
  print, correlate(mass[a],dusm[a])
  print, correlate(mass[a],dusm25[a])
;  print, correlate(mass[a],dzsm[a])
;  print, correlate(mass[a],dzsm25[a])

; Make an anomaly dataset
  barbadosMean = mean(mass,/nan)
  modelmean    = mean(dusm)
  dataAnomaly  = mass - barbadosMean
  modelAnomaly = dusm - modelmean


; Set plot
  set_plot, 'ps'
  device, file='barbados.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=30, ysize=12
  !P.font=0

  loadct, 39
  nt = n_elements(time)
  plot, indgen(nt+1), /nodata, $
   xrange=[0,nt+1], xstyle=9, xthick=3, $
   yrange=[0,80], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   position=[.05, .2, .95, .9], $
   ytitle='dust mass [!Mu!3g m!E-3!N]',  charsize=.65
  xyouts, 0, 82, 'Barbados Surface Dust Concentration Record'

  oplot, date_, mass, thick=4, color=254
  oplot, indgen(nt), dusm, thick=4, color=60
  xyouts, 18, 75, 'Barbados Station Data (Prospero)', color=254
  xyouts, 18, 67.5, 'GEOS-4 Model', color=60



; Plot the anomaly
  plot, indgen(nt+1), /nodata, $
   xrange=[0,nt+1], xstyle=9, xthick=3, $
   yrange=[-40,40], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   position=[.05, .2, .95, .9], $
   ytitle='dust mass [!Mu!3g m!E-3!N]',  charsize=.65
  xyouts, 0, 42, 'Barbados Surface Dust Anomaly'

  oplot, date_, dataanomaly, thick=4, color=254
  oplot, indgen(nt), modelanomaly, thick=4, color=60
  xyouts, 18, -27.5, 'Barbados Station Data (Prospero)', color=254
  xyouts, 18, -35, 'GEOS-4 Model', color=60


; Plot the anomaly -- differently
  plot, indgen(nt+1), /nodata, $
   xrange=[0,nt+1], xstyle=9, xthick=3, $
   yrange=[-40,40], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   position=[.05, .2, .95, .9], $
   ytitle='dust mass [!Mu!3g m!E-3!N]',  charsize=.65
  xyouts, 0, 42, 'Barbados Surface Dust Anomaly'

  oplot, indgen(nt+1), make_array(nt+1,val=0)
  a = where(dataanomaly gt 0 or finite(dataanomaly) ne 1)
  data_ =   dataanomaly
  data_[a] = 0.
  polyfill, [date_,0], [data_,0], color=254
  a = where(dataanomaly le 0 or finite(dataanomaly) ne 1)
  data_ =   dataanomaly
  data_[a] = 0.
  polyfill, [date_,0], [data_,0], color=60
  oplot, indgen(nt), modelanomaly, thick=2, lin=0
  xyouts, 18, -27.5, 'Barbados Station Data (Prospero) -- colored'
  xyouts, 18, -35, 'GEOS-4 Model -- solid trace'



; Make a deseasonalized anomaly dataset
  barbadosMean = fltarr(12)
  modelMean    = fltarr(12)
  for imon = 0, 11 do begin
   nt = n_elements(mass)
   barbadosMean[imon] = mean(mass[imon:nt-1:12],/nan)
   dataAnomaly[imon:nt-1:12] = mass[imon:nt-1:12] - barbadosMean[imon]
   nt = n_elements(dusm)
   modelMean[imon]    = mean(dusm[imon:nt-1:12])
   modelAnomaly[imon:nt-1:12] = dusm[imon:nt-1:12] - modelMean[imon]
  endfor

  plot, indgen(nt+1), /nodata, $
   xrange=[0,nt+1], xstyle=9, xthick=3, $
   yrange=[-40,40], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   position=[.05, .2, .95, .9], $
   ytitle='dust mass [!Mu!3g m!E-3!N]',  charsize=.65
  xyouts, 0, 42, 'Barbados Surface Dust Anomaly'

  oplot, indgen(nt+1), make_array(nt+1,val=0)
  a = where(dataanomaly gt 0 or finite(dataanomaly) ne 1)
  data_ =   dataanomaly
  data_[a] = 0.
  polyfill, [date_,0], [data_,0], color=254
  a = where(dataanomaly le 0 or finite(dataanomaly) ne 1)
  data_ =   dataanomaly
  data_[a] = 0.
  polyfill, [date_,0], [data_,0], color=60
  oplot, indgen(nt), modelanomaly, thick=2, lin=0
  xyouts, 18, -27.5, 'Barbados Station Data (Prospero) -- colored'
  xyouts, 18, -35, 'GEOS-4 Model -- solid trace'






  device, /close

end
