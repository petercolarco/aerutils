; Make a plot of the time series of global mean AOT
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  a = where(nymd gt 20000000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, 'totexttau', totexttau, lon=lon, lat=lat

; Now make a global mean
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  a = where(lat gt 50)
  tau = aave(totexttau[*,a,*],area[*,a],/nan)
  a = where(tau eq 0)
  if(a[0] ne -1) then tau[a] = !values.f_nan

; Do the same for the CCMI run
  expctl = 'ref_c2_h53.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  a = where(nymd gt 20000000L and nymd lt 20160000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, ['totexttau','suexttauvolc'], totexttau, lon=lon, lat=lat, /sum
; Now make a global mean
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  a = where(lat gt 50)
  tauccmi = aave(totexttau[*,a,*],area[*,a],/nan)
  a = where(tauccmi eq 0)
  if(a[0] ne -1) then tauccmi[a] = !values.f_nan

; Do the same for the MISR data
  expctl = 'misr_monthly.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  a = where(nymd gt 20000000L and nymd lt 20160000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, ['aodtau'], totexttau, lon=lon, lat=lat, wantlev=[558], lev=lev
  a = where(totexttau gt 1e12)
  totexttau[a] = !values.f_nan
; Now make a global mean
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  a = where(lat gt 50)
  taumisr = aave(totexttau[*,a,*],area[*,a],/nan)
  a = where(taumisr eq 0)
  if(a[0] ne -1) then taumisr[a] = !values.f_nan



; Make a nice plot!
  set_plot, 'ps'
  device, file='boreal_mean.2000.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, findgen(192), /nodata, color=84, $
    xrange=[0,192], yrange=[0,.4], xstyle=9, ystyle=9, thick=3, $
    ytitle='AOT', xticks=7, xminor=4, $
    xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' ']
  loadct, 0
  oplot, findgen(192), taumisr, thick=6, color=160
  loadct, 39
  oplot, findgen(192), tau, thick=6, color=84
  oplot, findgen(192), tauccmi, thick=6, color=254
  device, /close

end
