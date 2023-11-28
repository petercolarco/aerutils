; For a site, read in a time period of hourly AERONET and model and
; plot an hourly climatology

  site = 'Univ_of_Houston'

  nymd = ['20080101','20081231']
  nhms = ['000000',  '230000']
  lambda = '550'

; Get the AERONET sites
  read_aeronet_locs, sites, lat, lon, elevation
  nsites = n_elements(sites)

  set_plot, 'ps'
  device, file='aeronet_diurnal.ps', /color
  !p.font=0

  xx = indgen(24)

  for i = 0, nsites-1 do begin
;  if(sites[i] ne 'Brussels') then continue

  dx = signum(lon[i])*fix((abs(lon[i])+7.5)/15.)

; Get AERONET
  aeronetPath = '/misc/prc10/AERONET/LEV30/'
  read_aeronet2nc, aeronetPath, sites[i], lambda, '2008', AOT_aeronet, date_aeronet, /hourly
  a = where(date_aeronet ge nymd[0]+'00' and date_aeronet le nymd[1]+'23')
  date_aeronet = date_aeronet[a]
  aot_aeronet = reform(aot_aeronet[a],24,n_elements(a)/24)
  a = where(aot_aeronet lt -9000.)
  aot_aeronet[a] = !values.f_nan
  a = where(finite(aot_aeronet) eq 1)
  if(n_elements(a) lt 1000) then continue
print, sites[i], n_elements(a)
; climatology
  aot_aeronet_clim = make_array(24,value=!values.f_nan)
  for it = 0, 23 do begin
   a = where(finite(aot_aeronet[it,*]) eq 1)
   if(a[0] ne -1) then aot_aeronet_clim[it] = mean(aot_aeronet[it,*],/nan)
  endfor
  a = where(finite(aot_aeronet_clim) eq 1)
  mn = total(aot_aeronet_clim[a])/n_elements(a)
  aot_aeronet_clim = aot_aeronet_clim-mn


; MERRAero
  expid = 'dR_MERRA-AA-r2'
  modeltemplate = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/aeronet/'+$
                  expid+'.inst2d_hwl.aeronet.%ch.%y4.nc4'
  readmodel_aeronet, modeltemplate, sites[i], nymd, nhms, lambda, ['totexttau'], $
                     modeldate, AOT_merraero, tinc = 60.
  ndate = n_elements(modeldate)
  aot_merraero = reform(aot_merraero,24,ndate/24)  ; not sorted by hour
; sample
  a = where(finite(aot_aeronet) eq 0)
  aot_merraero[a] = !values.f_nan
; climatology
  aot_merraero_clim = make_array(24,value=!values.f_nan)
  for it = 0, 23 do begin
   a = where(finite(aot_merraero[it,*]) eq 1)
   if(a[0] ne -1) then aot_merraero_clim[it] = mean(aot_merraero[it,*],/nan)
  endfor
  a = where(finite(aot_merraero_clim) eq 1)
  mn = total(aot_merraero_clim[a])/n_elements(a)
  aot_merraero_clim = aot_merraero_clim-mn

; MERRA-2
  filen = '/misc/prc13/MERRA2/aeronet/MERRA2.tavg1_2d_aer_Nx.aeronet.2008.nc4'
  cdfid = ncdf_open(filen)
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stn
  stn = strcompress(string(stn),/rem)
  a = where(stn eq sites[i])
  if(a[0] eq -1) then begin
   print, 'not in merra2'
   continue
  endif
  id = ncdf_varid(cdfid,'TOTEXTTAU')
  ncdf_varget, cdfid, id, aot_merra2, offset=[0,a[0]], count=[8784,1]
  ncdf_close, cdfid
  aot_merra2 = reform(aot_merra2,24,ndate/24)  ; not sorted by hour
; sample
  a = where(finite(aot_aeronet) eq 0)
  aot_merra2[a] = !values.f_nan
; climatology
  aot_merra2_clim = make_array(24,value=!values.f_nan)
  for it = 0, 23 do begin
   a = where(finite(aot_merra2[it,*]) eq 1)
   if(a[0] ne -1) then aot_merra2_clim[it] = mean(aot_merra2[it,*],/nan)
  endfor
  a = where(finite(aot_merra2_clim) eq 1)
  mn = total(aot_merra2_clim[a])/n_elements(a)
  aot_merra2_clim = aot_merra2_clim-mn



; Replay
  expid = 'c180Rreg_H54p3-acma'
  modeltemplate = '/misc/prc18/colarco/'+expid+'/inst2d_hwl_x/aeronet/'+$
                  expid+'.inst2d_hwl.aeronet.%ch.%y4.nc4'
  readmodel_aeronet, modeltemplate, sites[i], nymd, nhms, lambda, ['totexttau'], $
                     modeldate, AOT_replay, tinc = 60.
  ndate = n_elements(modeldate)
  aot_replay = reform(aot_replay,24,ndate/24)  ; not sorted by hour
; sample
  a = where(finite(aot_aeronet) eq 0)
  aot_replay[a] = !values.f_nan
; climatology
  aot_replay_clim = make_array(24,value=!values.f_nan)
  for it = 0, 23 do begin
   a = where(finite(aot_replay[it,*]) eq 1)
   if(a[0] ne -1) then aot_replay_clim[it] = mean(aot_replay[it,*],/nan)
  endfor
  a = where(finite(aot_replay_clim) eq 1)
  mn = total(aot_replay_clim[a])/n_elements(a)
  aot_replay_clim = aot_replay_clim-mn


; Shift the times to local time
  aot_merra2_clim = shift(aot_merra2_clim,dx)
  aot_merraero_clim = shift(aot_merraero_clim,dx)
  aot_aeronet_clim = shift(aot_aeronet_clim,dx)
  aot_replay_clim = shift(aot_replay_clim,dx)

; Plot
  a = where(finite(aot_aeronet_clim) eq 1)
  yrange = max([max(abs(aot_aeronet_clim[a])), $
                max(abs(aot_merra2_clim[a])), $
                max(abs(aot_replay_clim[a])) ])

  x = findgen(24)

  loadct, 39
  plot, x, aot_merra2_clim[x], thick=6, /nodata, $
   xtitle='Local Hour of Day', ytitle='delta-aot', $
   yrange=[-yrange,yrange], title=sites[i], $
   ystyle=8, xstyle=8, xrange=[4,22], xticks=18, xminor=1, $
   xtickn=[string(indgen(19)+4,format='(i2)')]
  oplot, x, aot_replay_clim[x], thick=10, color=254
  oplot, x, aot_aeronet_clim[x], thick=12, color=0
  plots, [5,6.5], .90*!y.crange[0], thick=10, color=254
  r = correlate(aot_aeronet_clim[a],aot_merra2_clim[a])
  r = string(r, format='(f5.2)')
  xyouts, 7, .83*!y.crange[0], 'MERRA-2 (r='+string(r,format='(f5.2)')+')'
  r = correlate(aot_aeronet_clim[a],aot_replay_clim[a])
  r = string(r, format='(f5.2)')
  xyouts, 7, .93*!y.crange[0], 'Replay (r='+string(r,format='(f5.2)')+')'
  loadct, 67
  oplot, x, aot_merra2_clim[x], thick=10, color=224
  plots, [5,6.5], .80*!y.crange[0], thick=10, color=224
  endfor
  device, /close

end
