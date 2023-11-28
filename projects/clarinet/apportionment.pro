; Read Adriana dust apportionment results and construct
; DU AOT at Barbados
  wantlon = [-59.5,-59.5]
  wantlat = [13.,13.]

; srcA
  filetemplate = 'srcA.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcA, wantlon=wantlon, wantlat=wantlat

; srcB
  filetemplate = 'srcB.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcB, wantlon=wantlon, wantlat=wantlat

; srcC
  filetemplate = 'srcC.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcC, wantlon=wantlon, wantlat=wantlat

; srcD
  filetemplate = 'srcD.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcD, wantlon=wantlon, wantlat=wantlat

; srcE
  filetemplate = 'srcE.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcE, wantlon=wantlon, wantlat=wantlat

; srcF
  filetemplate = 'srcF.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcF, wantlon=wantlon, wantlat=wantlat

; srcO
  filetemplate = 'srcO.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', srcO, wantlon=wantlon, wantlat=wantlat


; Make a plot
  set_plot, 'ps'
  device, file='apportionment_barbados.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=12
  !p.font=0

  plot, indgen(12), /nodata, $
   xrange=[0,31], xstyle=9, xthick=3, xmin=1, $
   yrange=[0,.4], ystyle=9, ythick=3, ymin=2, $
   xticks=31, xtickname=make_array(32,val=' '), $
   ytitle='AOT'
  xyouts, indgen(30)+1, -.025, string(indgen(30)+1,format='(i2)'), align=.5

  loadct, 39
  oplot, indgen(30)+1, srcA, thick=6, color=0
  oplot, indgen(30)+1, srcB, thick=6, color=40
  oplot, indgen(30)+1, srcC, thick=6, color=80
  oplot, indgen(30)+1, srcD, thick=6, color=120
  oplot, indgen(30)+1, srcE, thick=6, color=160
  oplot, indgen(30)+1, srcF, thick=6, color=200
  oplot, indgen(30)+1, srcO, thick=6, color=240

  device, /close


end
