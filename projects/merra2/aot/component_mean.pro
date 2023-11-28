; Make a plot of the 2010 - 2019 climatology of component aod
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off a date range
  a = where(long(nymd) gt 20100000L and long(nymd) lt 20200000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)

  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; By component
  comp = ['duexttau','suexttau','ocexttau','bcexttau','ssexttau']
  cct  = [65, 63, 61, 0, 49]
  name = ['DUST','SULFATE','ORGANIC CARBON','BLACK CARBON','SEA SALT']

  for icomp = 0, 4 do begin

; Get AOT
  print, comp[icomp]
  nc4readvar, filename, comp[icomp], ext, lon=lon, lat=lat

; Now make a global mean
  tau = aave(ext,area,/nan)
  a = where(tau eq 0)
  if(a[0] ne -1) then tau[a] = !values.f_nan
  tau = reform(tau,12,n_elements(tau)/12)

; Make a nice plot!
  set_plot, 'ps'
  device, file='component_mean.'+comp[icomp]+'.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=10, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  ymax = 0.08
  if(cct[icomp] eq 0) then ymax=0.01
  plot, findgen(14), /nodata, color=0, $
    xrange=[0,13], yrange=[0,ymax], xstyle=9, ystyle=9, thick=3, $
    ytitle=name[icomp]+' AOT', xticks=13, $
    xtickname=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  loadct, cct[icomp]
  if(cct[icomp] ne 0) then begin
   polymaxmin, indgen(12)+1, tau, fillcolor=120, color=255, edgecolor=200
  endif else begin
   polymaxmin, indgen(12)+1, tau, fillcolor=120, color=0, edgecolor=50
  endelse
  device, /close

  endfor

end
