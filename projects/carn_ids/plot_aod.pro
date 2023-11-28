  expid = 'c180R_v202_lasouf'

  filetemplate = expid+'.inst2d_hwl_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(long(nymd) ge 20210408L and long(nymd) lt 20210421L)

  for i = 0, n_elements(a) do begin

  nc4readvar, filename[a[i]], 'duexttau002', du, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'ssexttau002', ss, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'suexttau002', su, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'niexttau002', ni, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], ['brcexttau002','ocexttau002'], cc, lon=lon, lat=lat, lev=lev, time=time

; make a series of plots
  set_plot, 'ps'
  !p.font=1
  !p.background=255
  !p.color=0
  device, file='plot_aod.'+expid+'.'+nymd[a[i]]+'_'+nhms[a[i]]+'z.ps', $
   /helvetica, font_size=12, /color, xsize=24, ysize=16

  loadct, 0
  map_set, 0, 0, /robinson, /horizon, /iso, /noborder, e_continents={fill:1,color:200}

  levels = indgen(10)*.1+0.1
  colors = indgen(10)*25+25


; SS
  loadct, 49
  contour, /overplot, ss[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
; DU
  loadct, 56
  contour, /overplot, du[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
; CC
  loadct, 59
  contour, /overplot, cc[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
; NI
  loadct, 60
  contour, /overplot, ni[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
; SU
  loadct, 50
  contour, /overplot, su[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors

  loadct, 0
  map_set, 0, 0, /robinson, /horizon, /iso, /noborder, /cont, /hires, /noerase, color=120

  xyouts, .01, .94, nymd[a[i]]+'   '+strmid(nhms[a[i]],0,2)+'z', /normal, color=120, charsize=2
  makekey, .1,.05,.8,.05,0,-.025,colors=reverse(colors), align=0, $
   labels=string(levels,format='(f3.1)')

  device, /close
print, nymd[a[i]]+'_'+nhms[a[i]]
  endfor

end
