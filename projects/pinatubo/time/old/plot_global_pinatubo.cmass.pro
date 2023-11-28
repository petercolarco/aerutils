; Make a plot of the Pinatubo resulting AOD using Valentina's
; paper as a template

; Valentina's member plot
  expid = 'Pin45act5d'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'so4cmass', so4cmass_pin45, lon=lon, lat=lat

; Pinatubo as separate tracer, different injection
  expid = 'c48F_G41-pin'
  filetemplate = expid+'.p.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'so4cmassvolc', so4cmassv_pin, lon=lon, lat=lat


; CARMA Pinatubo only
  expid = 'c48F_G41-pinc'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'sucmass', so4cmassv_pinc, lon=lon, lat=lat



; Global total (Tg SO4)
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  nt = n_elements(a)
  suext_pin45 = fltarr(nt)
  suext_pin = fltarr(nt)
  suext_pinc = fltarr(nt)
  for it = 0, nt-1 do begin
   suext_pin45[it] = total(so4cmass_pin45[*,*,it]*area)/1e9
   suext_pin[it] = total(so4cmassv_pin[*,*,it]*area)/1e9
   suext_pinc[it] = total(so4cmassv_pinc[*,*,it]*area)/1e9
  endfor

  set_plot, 'ps'
  device, file='plot_global_pinatubo.cmass.compare.ps', $
    /helvetica, font_size=12, /color, $
    xsize=18, ysize=7.2, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']
  plot, x, suext_pin45, /nodata, $
   position=[.15,.2,.95,.9], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=[xtickname], xticks=14,$
   ystyle=1, yrange=[0,30], $
   yticks=6, ytitle = 'SO4 Loading [Tg]'

  red   = [0,228,55,77,152]
  green = [0,26,126,175,78]
  blue  = [0,28,184,74,163]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  oplot, x, suext_pin45, thick=6, color=0, lin=2

  oplot, x, suext_pin, thick=6, color=1, lin=2
  oplot, x, suext_pinc, thick=6, color=3, lin=2
;  oplot, x, suext_pin, thick=6, color=2
;  oplot, x, suext_pino, thick=6, color=3
;  oplot, x, suext_pinoh, thick=6, color=4
;  oplot, x, suext_pinoh2, thick=6, color=4, lin=2

  device, /close

end
