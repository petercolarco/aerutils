  filetemplate = 'c180R_pI33p9s12_volc.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(long(nymd) ge 20190600L and long(nymd) lt 20190901L)

  for i = 0, n_elements(a) do begin

  nc4readvar, filename[a[i]], 'duexttau', du, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'ssexttau', ss, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'suexttau', su, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'niexttau', ni, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], ['brcexttau','ocexttau'], cc, lon=lon, lat=lat, lev=lev, time=time

; make a series of plots
  set_plot, 'x'
  !p.font=1
  !p.background=255
  !p.color=0
  window, xsize=3840, ysize=2160, xpos=3060, ypos=-1000
  loadct, 0
  map_set, 0, 180, /robinson, /horizon, /iso, /noborder, e_continents={fill:1,color:200}
; SS
  loadct, 49
  levels = findgen(10)*.1 + 0.1
  colors = indgen(10)*25+25
  contour, /overplot, shift(ss[*,*,0],288), lon+180, lat, /cell, levels=levels, c_colors=colors
; DU
  loadct, 56
  levels = findgen(10)*.1 + 0.1
  contour, /overplot, shift(du[*,*,0],288), lon+180, lat, /cell, levels=levels, c_colors=colors
; CC
  loadct, 59
  levels = findgen(10)*.1 + 0.1
  contour, /overplot, shift(cc[*,*,0],288), lon+180, lat, /cell, levels=levels, c_colors=colors
; NI
  loadct, 60
  levels = findgen(10)*.1 + 0.1
  contour, /overplot, shift(ni[*,*,0],288), lon+180, lat, /cell, levels=levels, c_colors=colors
; SU
  loadct, 50
  levels = findgen(10)*.1 + 0.1
  contour, /overplot, shift(su[*,*,0],288), lon+180, lat, /cell, levels=levels, c_colors=colors

  loadct, 0
  map_set, 0, 180, /robinson, /horizon, /iso, /noborder, /cont, /hires, /noerase, color=120

  xyouts, .01, .94, nymd[a[i]]+'   '+strmid(nhms[a[i]],0,2)+'z', /normal, color=120, charsize=12 

  img = tvrd(/true)

  write_png, 'plot_aod.'+nymd[a[i]]+'_'+nhms[a[i]]+'z.png', img

  endfor

end
