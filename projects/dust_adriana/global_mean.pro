; Make a plot of the time series of global mean AOT
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  a = where(nymd gt 20031231L and nymd lt 20070101L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, 'totexttau', totexttau, lon=lon, lat=lat
  nc4readvar, filename, 'duexttau',  duexttau, lon=lon, lat=lat
  nc4readvar, filename, 'ssexttau',  ssexttau, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau',  suexttau, lon=lon, lat=lat
  nc4readvar, filename, 'ocexttau',  ocexttau, lon=lon, lat=lat

; Now make a global mean
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  taum2 = aave(totexttau,area,/nan)
  dum2  = aave(duexttau,area,/nan)
  ssm2  = aave(ssexttau,area,/nan)
  sum2  = aave(suexttau,area,/nan)
  ocm2  = aave(ocexttau,area,/nan)
  a = where(taum2 eq 0)
  if(a[0] ne -1) then taum2[a] = !values.f_nan
  if(a[0] ne -1) then dum2[a] = !values.f_nan
  if(a[0] ne -1) then sum2[a] = !values.f_nan
  if(a[0] ne -1) then ssm2[a] = !values.f_nan
  if(a[0] ne -1) then ocm2[a] = !values.f_nan

; Get Adriana model run
  expctl = 'c90R_du_Jasper_run1.tavg2d_aer_x.ctl'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, 'totexttau', totexttau, lon=lon, lat=lat
  nc4readvar, filename, 'duexttau',  duexttau, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau',  suexttau, lon=lon, lat=lat
  nc4readvar, filename, 'ssexttau',  ssexttau, lon=lon, lat=lat
  nc4readvar, filename, 'niexttau',  niexttau, lon=lon, lat=lat
  nc4readvar, filename, 'bcexttau',  bcexttau, lon=lon, lat=lat
  nc4readvar, filename, 'ocexttau',  ocexttau, lon=lon, lat=lat
  nc4readvar, filename, 'brcexttau',  brcexttau, lon=lon, lat=lat

; Now make a global mean
  area, lon, lat, nx, ny, dx, dy, area, grid='c'
  tau = aave(totexttau,area,/nan)
  du  = aave(duexttau,area,/nan)
  su  = aave(suexttau,area,/nan)
  ss  = aave(ssexttau,area,/nan)
  ni  = aave(niexttau,area,/nan)
  bc  = aave(bcexttau,area,/nan)
  oc  = aave(ocexttau,area,/nan)
  brc = aave(brcexttau,area,/nan)

; Make a plot
  set_plot, 'ps'
  device, file='global_mean.ps', /color, /helvetica, font_size=12
  !p.font=0

  xtickn = [' ',strmid(strcompress(string(nymd),/rem),0,6),' ']
  xtickn[1:*:3] = ' '
  xtickn[2:*:3] = ' '

  plot, indgen(38), /nodata, $
   xrange = [0,37], chars=.5, $
   xtickn = xtickn, xticks=37, xminor=1, $
   yrange=[0.,0.16], ytitle='global mean AOT'
  loadct, 39
  oplot, indgen(36)+1, taum2, lin=2, thick=6
  oplot, indgen(36)+1, dum2, lin=2, thick=6, color=208
  oplot, indgen(36)+1, sum2, lin=2, thick=6, color=176
  oplot, indgen(36)+1, ssm2, lin=2, thick=6, color=84
  oplot, indgen(36)+1, ocm2, lin=2, thick=6, color=254

  oplot, indgen(36)+1, tau, thick=6
  oplot, indgen(36)+1, du, thick=6, color=208
  oplot, indgen(36)+1, su, thick=6, color=176
  oplot, indgen(36)+1, ss, thick=6, color=84
  oplot, indgen(36)+1, ni, thick=6, color=42
  oplot, indgen(36)+1, bc+brc+oc, thick=6, color=254
  xyouts, 1, .19, 'Total AOD'
  xyouts, 1, .18, 'Dust AOD', color=208
  xyouts, 1, .17, 'Sea Salt AOD', color=84
  xyouts, 8, .19, 'Sulfate AOD', color=176
  xyouts, 8, .18, 'Nitrate AOD', color=42
  xyouts, 8, .17, 'Carbonaceous AOD', color=254
  plots, [18,20], .192, thick=6
  plots, [18,20], .182, thick=6, lin=2
  xyouts, 20.5, .19, 'Dust Model Run'
  xyouts, 20.5, .18, 'MERRA-2'


  device, /close
end

