; Open and read the netcdf file
  filename = '/misc/prc13/c1440_NR/c1440_NR.inst30mn_2d_aer1_Nx.aeronet.TOTEXTTAU.2006.nc4'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'stnName')
          ncdf_varget, cdfid, id, stn
          stn = strcompress(string(stn),/rem)
  id    = ncdf_varid(cdfid,'TOTEXTTAU')
          ncdf_varget, cdfid, id, aot
  id    = ncdf_varid(cdfid,'time')
          ncdf_varget, cdfid, id, time
  id    = ncdf_varid(cdfid,'stnLat')
          ncdf_varget, cdfid, id, lat
  id    = ncdf_varid(cdfid,'stnLon')
          ncdf_varget, cdfid, id, lon
  ncdf_close, cdfid

; Candidate sites from ICAP paper
  sites = ['Alta_Floresta','Amsterdam_Island','Banizoumbou', $
           'Beijing','Capo_Verde','Cart_Site','Chapais',$
           'Chiang_Mai','Gandhi_College','GSFC','Ilorin',$
           'Kanpur','Minsk','Moldova','Monterey','Palma_de_Mallorca',$
           'Ragged_Point','Rio_Branco','Singapore','Mezaira',$
           'Yonsei_University']

  ns = n_elements(sites)
  stnn = intarr(ns)
  for i = 0, ns-1 do begin
   a = where(stn eq sites[i])
   print, i+1, sites[i], a[0]
   stnn[i] = a[0]
  endfor

; Get the aot
  aot = aot[stnn,*]

; Make a diurnal cycle (annual mean)
  aot = mean(reform(aot,ns,48,365),dim=3)

; Now find the daily mean
  aotm = mean(aot,dim=2)

; Compute the percent variance from the daily mean
  aotv = fltarr(ns,48)
  for i = 0, ns-1 do begin
   aotv[i,*] = (aot[i,*]-aotm[i])/aotm[i]*100.
  endfor

; ----------------------------------------------
; Get the MERRA-2 GMI result (note different time frequency)
  filename = '/misc/prc13/MERRA2_GMI/c180/aeronet/MERRA2_GMI.tavg1_2d_aer_Nx.aeronet.2006.nc4'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'stnName')
          ncdf_varget, cdfid, id, stn
          stn = strcompress(string(stn),/rem)
  id    = ncdf_varid(cdfid,'TOTEXTTAU')
          ncdf_varget, cdfid, id, aot
  id    = ncdf_varid(cdfid,'time')
          ncdf_varget, cdfid, id, time
  ncdf_close, cdfid

  stnn = intarr(ns)
  for i = 0, ns-1 do begin
   a = where(stn eq sites[i])
   print, i+1, sites[i], a[0]
   stnn[i] = a[0]
  endfor

; Get the aot
  aot = transpose(aot)
  aot = aot[stnn,*]

; Make a diurnal cycle (annual mean)
  aot = mean(reform(aot,ns,24,365),dim=3)
  
; Now find the daily mean
  aotm2 = mean(aot,dim=2)

; Compute the percent variance from the daily mean
  aotv2 = fltarr(ns,24)
  for i = 0, ns-1 do begin
   aotv2[i,*] = (aot[i,*]-aotm2[i])/aotm2[i]*100.
  endfor

; ----------------------------------------------
; Get the MERRA-2 result (note different time frequency)
  filename = '/misc/prc13/MERRA2/aeronet/MERRA2.tavg1_2d_aer_Nx.aeronet.2006.nc4'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'stnName')
          ncdf_varget, cdfid, id, stn
          stn = strcompress(string(stn),/rem)
  id    = ncdf_varid(cdfid,'TOTEXTTAU')
          ncdf_varget, cdfid, id, aot
  id    = ncdf_varid(cdfid,'time')
          ncdf_varget, cdfid, id, time
  ncdf_close, cdfid

  stnn = intarr(ns)
  for i = 0, ns-1 do begin
   a = where(stn eq sites[i])
   print, i+1, sites[i], a[0]
   stnn[i] = a[0]
  endfor

; Get the aot
  aot = transpose(aot)
  aot = aot[stnn,*]

; Make a diurnal cycle (annual mean)
  aot = mean(reform(aot,ns,24,365),dim=3)
  
; Now find the daily mean
  aotm3 = mean(aot,dim=2)

; Compute the percent variance from the daily mean
  aotv3 = fltarr(ns,24)
  for i = 0, ns-1 do begin
   aotv3[i,*] = (aot[i,*]-aotm3[i])/aotm3[i]*100.
  endfor

; ----------------------------------------------
; Get the AERONET Version 2 from my hourly files
  spawn, 'echo $AERONETDIR', headDir
  aerPath = headDir+'LEV30/'
  lambdabase = '550'
  yyyy = ['2006','2007','2009','2010','2011']
  aotm4 = fltarr(ns)
  aotv4 = fltarr(ns,24)
  for i = 0, ns-1 do begin
   locWant = sites[i]
   print, 'AERONET: ', locWant
   read_aeronet2nc, aerPath, locwant, lambdabase, yyyy, $
                    aotaeronet, dateaeronet, /hourly
;if(i eq 9) then stop
   a = where(aotaeronet lt -9000.)
   aotaeronet[a] = !values.f_nan
   aotaeronet    = reform(aotaeronet,24,365,n_elements(yyyy))
   aotaeronet    = mean(aotaeronet,/nan,dim=3)
   count         = intarr(24)
   for j = 0, 23 do begin
    a            = where(finite(aotaeronet[j,*]) eq 1)
    if(a[0] ne -1) then count[j] = n_elements(a)
    if(count[j] gt 0) then aotm4[i] = aotm4[i]+count[j]*mean(aotaeronet[j,*],/nan,dim=2)
   endfor
   aotm4[i]      = aotm4[i]/total(count)
   aotaeronet    = mean(aotaeronet,/nan,dim=2)
   aotv4[i,*]    = (aotaeronet-aotm4[i])/aotm4[i]*100.
  endfor


; Plot
  set_plot, 'ps'
  device, file='models.ps', /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=24, /color
  !p.font=0
  !p.multi=[0,4,6]

  loadct, 39

  for i = 0, ns-1 do begin
;  Compute longitude adjustment relative to gmt
   hoff = fix((lon[stnn[i]]-7.5)/15.)
   ishift = hoff*2
;   print, lon[stnn[i]], hoff
   aotv_ = shift(reform(aotv[i,*]),ishift)
;  shift the m2gmi results
   aotv2_ = shift(reform(aotv2[i,*]),ishift/2)
;  shift the m2 results
   aotv3_ = shift(reform(aotv3[i,*]),ishift/2)
;  shift the aeronet results
   aotv4_ = shift(reform(aotv4[i,*]),ishift/2)

   plot, indgen(48)*.5, aotv_, $
    xrange=[0,24], xstyle=1, yrange=[-15,30], ystyle=1, $
    xtitle='Local Hour', ytitle='%-variance of daily', $
    title='('+strcompress(string(i+1,format='(i2)'),/rem)+') '+stn[stnn[i]]
   oplot, indgen(48)*.5, aotv_, thick=2, color=254
   oplot, indgen(24), aotv2_, thick=2, color=208
;   oplot, indgen(24), aotv3_, thick=2, color=74
;   oplot, indgen(24), aotv4_, thick=2, color=0
   plots, [0,24],[0,0]
   xyouts, 1, 25, '<!Mt!N> = '+string(aotm[i],format=('(f4.2)')), chars=.6, color=254
   xyouts, 1, 22, '<!Mt!N> = '+string(aotm2[i],format=('(f4.2)')), chars=.6, color=208
;   xyouts, 1, 19, '<!Mt!N> = '+string(aotm3[i],format=('(f4.2)')), chars=.6, color=74
;   xyouts, 13, 25, '<!Mt!N> = '+string(aotm4[i],format=('(f4.2)')), chars=.6, color=0
  endfor

; Put a map
  !p.multi=0
  loadct, 0
  map_set, /cont, position=[.35,.01,1,.17], /noerase, $
   /hammer, /iso, limit=[-85,-180,85,180],/horizon,/noborder, color=150
  for i = 0, ns-1 do begin
;   plots, lon[stnn[i]], lat[stnn[i]], psym=sym(1)
   xyouts, lon[stnn[i]], lat[stnn[i]], $
    strcompress(string(i+1,format='(i2)'),/rem), chars=.5
  endfor


  device, /close







; Plot
  set_plot, 'ps'
  device, file='models_merra2.ps', /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=24, /color
  !p.font=0
  !p.multi=[0,4,6]

  loadct, 39

  for i = 0, ns-1 do begin
;  Compute longitude adjustment relative to gmt
   hoff = fix((lon[stnn[i]]-7.5)/15.)
   ishift = hoff*2
;   print, lon[stnn[i]], hoff
   aotv_ = shift(reform(aotv[i,*]),ishift)
;  shift the m2gmi results
   aotv2_ = shift(reform(aotv2[i,*]),ishift/2)
;  shift the m2 results
   aotv3_ = shift(reform(aotv3[i,*]),ishift/2)
;  shift the aeronet results
   aotv4_ = shift(reform(aotv4[i,*]),ishift/2)

   plot, indgen(48)*.5, aotv_, $
    xrange=[0,24], xstyle=1, yrange=[-15,30], ystyle=1, $
    xtitle='Local Hour', ytitle='%-variance of daily', $
    title='('+strcompress(string(i+1,format='(i2)'),/rem)+') '+stn[stnn[i]]
   oplot, indgen(48)*.5, aotv_, thick=2, color=254
   oplot, indgen(24), aotv2_, thick=2, color=208
   oplot, indgen(24), aotv3_, thick=2, color=74
;   oplot, indgen(24), aotv4_, thick=2, color=0
   plots, [0,24],[0,0]
   xyouts, 1, 25, '<!Mt!N> = '+string(aotm[i],format=('(f4.2)')), chars=.6, color=254
   xyouts, 1, 22, '<!Mt!N> = '+string(aotm2[i],format=('(f4.2)')), chars=.6, color=208
   xyouts, 1, 19, '<!Mt!N> = '+string(aotm3[i],format=('(f4.2)')), chars=.6, color=74
;   xyouts, 13, 25, '<!Mt!N> = '+string(aotm4[i],format=('(f4.2)')), chars=.6, color=0
  endfor

; Put a map
  !p.multi=0
  loadct, 0
  map_set, /cont, position=[.35,.01,1,.17], /noerase, $
   /hammer, /iso, limit=[-85,-180,85,180],/horizon,/noborder, color=150
  for i = 0, ns-1 do begin
;   plots, lon[stnn[i]], lat[stnn[i]], psym=sym(1)
   xyouts, lon[stnn[i]], lat[stnn[i]], $
    strcompress(string(i+1,format='(i2)'),/rem), chars=.5
  endfor


  device, /close



; Plot
  set_plot, 'ps'
  device, file='models_merra2_aeronet.ps', /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=24, /color
  !p.font=0
  !p.multi=[0,4,6]

  loadct, 39

  for i = 0, ns-1 do begin
;  Compute longitude adjustment relative to gmt
   hoff = fix((lon[stnn[i]]-7.5)/15.)
   ishift = hoff*2
;   print, lon[stnn[i]], hoff
   aotv_ = shift(reform(aotv[i,*]),ishift)
;  shift the m2gmi results
   aotv2_ = shift(reform(aotv2[i,*]),ishift/2)
;  shift the m2 results
   aotv3_ = shift(reform(aotv3[i,*]),ishift/2)
;  shift the aeronet results
   aotv4_ = shift(reform(aotv4[i,*]),ishift/2)

   plot, indgen(48)*.5, aotv_, $
    xrange=[0,24], xstyle=1, yrange=[-15,30], ystyle=1, $
    xtitle='Local Hour', ytitle='%-variance of daily', $
    title='('+strcompress(string(i+1,format='(i2)'),/rem)+') '+stn[stnn[i]]
   oplot, indgen(48)*.5, aotv_, thick=2, color=254
   oplot, indgen(24), aotv2_, thick=2, color=208
   oplot, indgen(24), aotv3_, thick=2, color=74
   oplot, indgen(24), aotv4_, thick=2, color=0
   plots, [0,24],[0,0]
   xyouts, 1, 25, '<!Mt!N> = '+string(aotm[i],format=('(f4.2)')), chars=.6, color=254
   xyouts, 1, 22, '<!Mt!N> = '+string(aotm2[i],format=('(f4.2)')), chars=.6, color=208
   xyouts, 1, 19, '<!Mt!N> = '+string(aotm3[i],format=('(f4.2)')), chars=.6, color=74
   xyouts, 13, 25, '<!Mt!N> = '+string(aotm4[i],format=('(f4.2)')), chars=.6, color=0
  endfor

; Put a map
  !p.multi=0
  loadct, 0
  map_set, /cont, position=[.35,.01,1,.17], /noerase, $
   /hammer, /iso, limit=[-85,-180,85,180],/horizon,/noborder, color=150
  for i = 0, ns-1 do begin
;   plots, lon[stnn[i]], lat[stnn[i]], psym=sym(1)
   xyouts, lon[stnn[i]], lat[stnn[i]], $
    strcompress(string(i+1,format='(i2)'),/rem), chars=.5
  endfor


  device, /close



end
