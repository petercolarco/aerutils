; Make a plot of the Pinatubo resulting AOD using Valentina's
; paper as a template

; Get AVHRR data
; Data is total aerosol loading, monthly (56 months) beginning July
; 1989 as a zonal mean with 141 latitudes from -70 to 70 (so, 1 degree)
  area, lon, lat, nx, ny, dx, dy, area, grid='c'
  openr, lun, 'avhrr_aot_monthly', /get
  inp = fltarr(141,56)
  readu, lun, inp
  free_lun, lun
; Put the data on regular grid and do area weighted average
  avhrr = make_array(ny,56,val=-999.)
  avhrr[20:160,*] = inp
  a = where(avhrr lt 0)
  avhrr[a] = !values.f_nan
  avhrr_time = fltarr(56)
  for iz = 0, 55 do begin
   a = where(finite(avhrr[*,iz]) eq 1)
   avhrr_time[iz] = total(avhrr[a,iz]*area[0,a])/total(area[0,a])
  endfor
; Give a time coordinate -- May 1991 = 0
  xavhrr = findgen(56)-22.

; Get from Valentina member run
  expid = 'Pin45act5d'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'suexttau', suexttau_pin45, lon=lon, lat=lat


; Pinatubo as separate tracer
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

; Total aerosol 
  expid = 'c48F_G41-pin'
  filetemplate = expid+'.p.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'totexttau', suexttau_pin, lon=lon, lat=lat
  nc4readvar, filename, 'suexttauvolc', suexttauv_pin, lon=lon, lat=lat
  totexttaut_pin = suexttauv_pin+suexttau_pin


; Pinatubo as separate tracer, trop has no other volcanoes
  expid = 'c48F_G41-pinnov'
  filetemplate = expid+'.p.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'suexttau', suexttau_pinnov, lon=lon, lat=lat
  nc4readvar, filename, 'suexttauvolc', suexttauv_pinnov, lon=lon, lat=lat
  nc4readvar, filename, 'suangstr', suangstr_pinnov, lon=lon, lat=lat
  nc4readvar, filename, 'suangstrvolc', suangstrv_pinnov, lon=lon, lat=lat
  suexttaut_pinnov = suexttauv_pinnov+suexttau_pinnov

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

  suext_pin45 = aave(suexttau_pin45,area)

  suangstrt_pin    = suangstr_pin*suexttau_pin + suangstrv_pin*suexttauv_pin
  suangstrv_pin    = suangstrv_pin*suexttauv_pin
  totext_pint  = aave(totexttaut_pin,area)
  suext_pin   = aave(suexttauv_pin,area)
  suang_pin   = aave(suangstrv_pin,area)/suext_pin
  suext_pint  = aave(suexttaut_pin,area)
  suang_pint  = aave(suangstrt_pin,area)/suext_pint

  suangstrt_pinnov    = suangstr_pinnov*suexttau_pinnov + suangstrv_pinnov*suexttauv_pinnov
  suangstrv_pinnov    = suangstrv_pinnov*suexttauv_pinnov
  suext_pinnov   = aave(suexttauv_pinnov,area)
  suang_pinnov   = aave(suangstrv_pinnov,area)/suext_pinnov
  suext_pinnovt  = aave(suexttaut_pinnov,area)
  suang_pinnovt  = aave(suangstrt_pinnov,area)/suext_pinnovt

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
   ystyle=1, yrange=[0,0.3], $
   yticks=6, ytitle = 'AOT'

  red   = [0,228,55,77,152]
  green = [0,26,126,175,78]
  blue  = [0,28,184,74,163]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  oplot, xavhrr, avhrr_time, thick=8, color=0
  oplot, x, suext_pin45, thick=8, color=0, lin=2
  oplot, x, totext_pint, thick=8, color=2
  oplot, x, suext_pint, thick=8, color=1
  oplot, x, suext_pinnovt, thick=8, color=1, lin=1
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
  oplot, x, suang_pinnovt, thick=8, color=1, lin=1
  oplot, x, suang_pin, thick=8, color=1, lin=2
  oplot, x, suang_c_pintc, thick=8, color=3
  oplot, x, suang_c_pinc, thick=8, color=3, lin=2

  device, /close

end
