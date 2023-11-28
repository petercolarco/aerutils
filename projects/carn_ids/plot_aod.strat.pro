  expid = 'c180F_v202_lasouf'

  filetemplate = expid+'.inst2d_hwl_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(long(nymd) ge 20210409L and long(nymd) lt 20210421L)

  for i = 0, n_elements(a) do begin

;  nc4readvar, filename[a[i]], 'dustexttau002', du, lon=lon, lat=lat, lev=lev, time=time
;  nc4readvar, filename[a[i]], 'ssstexttau002', ss, lon=lon, lat=lat, lev=lev, time=time
  nc4readvar, filename[a[i]], 'totstexttau002', su, lon=lon, lat=lat, lev=lev, time=time
;  nc4readvar, filename[a[i]], 'nistexttau002', ni, lon=lon, lat=lat, lev=lev, time=time
;  nc4readvar, filename[a[i]], ['brcstexttau002','ocstexttau002'], cc, lon=lon, lat=lat, lev=lev, time=time

; make a series of plots
  set_plot, 'ps'
  !p.font=1
  !p.background=255
  !p.color=0
  device, file='plot_aod.strat.'+expid+'.'+nymd[a[i]]+'_'+nhms[a[i]]+'z.ps', $
   /helvetica, font_size=12, /color, xsize=24, ysize=16

  loadct, 0
  map_set, 0, 0, /robinson, /horizon, /iso, /noborder, e_continents={fill:1,color:200}
;; SS
;  loadct, 49
;  levels = findgen(10)*.1 + 0.1
;  colors = indgen(10)*25+25
;  contour, /overplot, ss[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
;; DU
;  loadct, 56
;  levels = findgen(10)*.1 + 0.1
;  contour, /overplot, du[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
;; CC
;  loadct, 59
;  levels = findgen(10)*.1 + 0.1
;  contour, /overplot, cc[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
;; NI
;  loadct, 60
;  levels = findgen(10)*.1 + 0.1
;  contour, /overplot, ni[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors
; SU
  loadct, 50
  levels = findgen(10)*.01 + 0.01
  levels = [.001,.002,.005,.01,.02,.05,.1,.2,.5,1]
  colors = indgen(10)*25+25
  contour, /overplot, su[*,*,0], lon, lat, /cell, levels=levels, c_colors=colors

  loadct, 0
  map_set, 0, 0, /robinson, /horizon, /iso, /noborder, /cont, /hires, /noerase, color=120

  xyouts, .01, .94, nymd[a[i]]+'   '+strmid(nhms[a[i]],0,2)+'z', /normal, color=120, charsize=2

  makekey, .1,.05,.8,.05,0,-.025,colors=make_array(10,val=120), align=0, $
   labels=['0.001','0.002','0.005','0.01','0.02','0.05','0.1','0.2','0.5','1']
  loadct, 50
  makekey, .1,.05,.8,.05,0,-.025,colors=colors, labels=make_array(10,val=' ')

  device, /close
print, nymd[a[i]]+'_'+nhms[a[i]]
  endfor

end
