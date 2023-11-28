; Barbados location
  wantlon = [-59.5,-59.5]
  wantlat = [13.,13.]

; Get the MERRA2 file template (monthly means)
  filetemplate = 'd5124_m2_jan79.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2016)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', duext, wantlon=wantlon, wantlat=wantlat, $
              time=time
  nc4readvar, filename, 'totexttau', totext, wantlon=wantlon, wantlat=wantlat, $
              time=time
  nc4readvar, filename, 'dusmass', dusmass, wantlon=wantlon, wantlat=wantlat, $
              time=time

; Reform these into annual
  ny = n_elements(a)/12
  duext = reform(duext,12,ny)
  totext = reform(totext,12,ny)
  dusmass = reform(dusmass,12,ny)

; Make a plot
  set_plot, 'ps'
  device, file='barbados_duexttau.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=12
  !p.font=0

  tickn = ['Jan','Feb','Mar','Apr','May','Jun', $
           'Jul','Aug','Sep','Oct','Nov','Dec']

  plot, indgen(12), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xmin=1, $
   yrange=[0,.4], ystyle=9, ythick=3, ymin=2, $
   xticks=13, xtickname=make_array(14,val=' '), $
   ytitle='AOT'
  xyouts, indgen(12)+1, -.025, tickn, align=.5

  loadct, 39

  for iy = 0, ny-1 do begin
   oplot, indgen(12)+1, duext[*,iy], thick=6, color=iy*16
  endfor

  device, /close



  device, file='barbados_totexttau.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=12
  !p.font=0

  tickn = ['Jan','Feb','Mar','Apr','May','Jun', $
           'Jul','Aug','Sep','Oct','Nov','Dec']

  plot, indgen(12), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xmin=1, $
   yrange=[0,.4], ystyle=9, ythick=3, ymin=2, $
   xticks=13, xtickname=make_array(14,val=' '), $
   ytitle='AOT'
  xyouts, indgen(12)+1, -.025, tickn, align=.5

  loadct, 39

  for iy = 0, ny-1 do begin
   oplot, indgen(12)+1, totext[*,iy], thick=6, color=iy*16
  endfor

  device, /close



  device, file='barbados_dusmass.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=12
  !p.font=0

  tickn = ['Jan','Feb','Mar','Apr','May','Jun', $
           'Jul','Aug','Sep','Oct','Nov','Dec']

  plot, indgen(12), /nodata, $
   xrange=[0,13], xstyle=9, xthick=3, xmin=1, $
   yrange=[0,50], ystyle=9, ythick=3, ymin=2, $
   xticks=13, xtickname=make_array(14,val=' '), $
   ytitle='Dust Surface Mass Concentration [!Mm!3g m!E-3!N]'
  xyouts, indgen(12)+1, -3, tickn, align=.5

  loadct, 39

  for iy = 0, ny-1 do begin
   oplot, indgen(12)+1, dusmass[*,iy]*1e9, thick=6, color=iy*16
  endfor

  device, /close
end

