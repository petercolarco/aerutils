; Make a plot of the Pinatubo resulting AOD using Valentina's
; paper as a template

; Pinatubo as separate tracer, and also tropo sulfate to subtract from
; above
  expid = 'c48F_G41-pin'
  filetemplate = expid+'.p.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'suexttau', suexttau_pin, lon=lon, lat=lat
  nc4readvar, filename, 'suexttauvolc', suexttauv_pin, lon=lon, lat=lat
  nc4readvar, filename, 'suangstr', suangstr_pin, lon=lon, lat=lat
  nc4readvar, filename, 'suangstrvolc', suangstrv_pin, lon=lon, lat=lat
  suexttaut_pin = suexttauv_pin+suexttau_pin

  expid = 'c48F_G41-pintc'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'suexttau', suexttau_c_pintc, lon=lon, lat=lat
  nc4readvar, filename, 'suangstr', suangstr_c_pintc, lon=lon, lat=lat


  expid = 'c48F_G41-pinc'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'suexttau', suexttau_c_pinc, lon=lon, lat=lat
  nc4readvar, filename, 'suangstr', suangstr_c_pinc, lon=lon, lat=lat


; Global area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  suangstrt_pin    = suangstr_pin*suexttau_pin + suangstrv_pin*suexttauv_pin
  suangstrv_pin    = suangstrv_pin*suexttauv_pin
  suext_pin   = aave(suexttauv_pin,area)
  suang_pin   = aave(suangstrv_pin,area)/suext_pin
  suext_pint  = aave(suexttaut_pin,area)
  suang_pint  = aave(suangstrt_pin,area)/suext_pint

  suangstr_c_pintc = suangstr_c_pintc*suexttau_c_pintc
  suext_c_pintc    = aave(suexttau_c_pintc,area)
  suang_c_pintc    = aave(suangstr_c_pintc,area)/suext_c_pintc

  suangstr_c_pinc = suangstr_c_pinc*suexttau_c_pinc
  suext_c_pinc    = aave(suexttau_c_pinc,area)
  suang_c_pinc    = aave(suangstr_c_pinc,area)/suext_c_pinc


  set_plot, 'ps'
  device, file='plot_global_pinatubo.angstrom.ps', $
    /helvetica, font_size=12, /color, $
    xsize=18, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']
  plot, x, suext_pin, /nodata, $
   position=[.15,.525,.95,.95], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=1, yrange=[0,0.25], $
   yticks=5, ytitle = 'AOT'

  red   = [0,228,55,77,152]
  green = [0,26,126,175,78]
  blue  = [0,28,184,74,163]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  oplot, x, suext_pint, thick=8, color=1
  oplot, x, suext_pin, thick=8, color=1, lin=2
  oplot, x, suext_c_pintc, thick=8, color=3
  oplot, x, suext_c_pinc, thick=8, color=3, lin=2

  plot, x, suext_pin, /nodata, /noerase, $
   position=[.15,.1,.95,.525], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=1, yrange=[-0.5,2.5], $
   yticks=6, ytitle = 'Angstrom Parameter', ytickname=['-0.5','0.0','0.5','1.0','1.5','2.0',' ']

  oplot, x, suang_pint, thick=8, color=1
  oplot, x, suang_pin, thick=8, color=1, lin=2
  oplot, x, suang_c_pintc, thick=8, color=3
  oplot, x, suang_c_pinc, thick=8, color=3, lin=2

  device, /close

end
