; Colarco, December 2015
; Get a time series of AI and scatter against OMI

  plotfile = 'aot_scatter.asia.v7_5.ps'

  ga_times, 'v7_5.ddf', nymd, nhms, template=filetemplate
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  ga_times, 'omi.ddf', nymd, nhms, template=filetemplate
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'aot', aot_omi

  a = where(lon ge 70 and lon le 130)
  aot = aot[a,*,*]
  aot_omi = aot_omi[a,*,*]
  b = where(lat ge 0 and lat le 45)
  aot = aot[*,b,*]
  aot_omi = aot_omi[*,b,*]

  a = where(aot gt 1e14 or aot_omi gt 1e14)
  aot[a] = !values.f_nan
  aot_omi[a] = !values.f_nan

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=14, xoff=.5, yoff=.5
  !p.font=0

  tickv = alog10([.01,.03,.1,.3,1,3,10])
  tickn = ['0.01','0.03','0.1','0.3','1','3','10']

  loadct, 0
  plot, findgen(5), /nodata, $
   xrange=[-2,1], yrange=[-2,1], $
   xticks=6, yticks=6, $
   xtickv=tickv, ytickv=tickv, $
   xtickn=tickn, ytickn=tickn, $
   xstyle=9, ystyle=9, thick=3, $
   xtitle='OMAERUV', ytitle='MERRAero', $
   position=[.12,.12,.8,.95]

  x = alog10(aot_omi[where(finite(aot) eq 1)]+.01)
  y =alog10( aot[where(finite(aot) eq 1)]+.01)
  statistics, x, y, mean0, mean1, std0, std1, $
              r, bias, rms, skill, linslope, linoffset, rc=rc
  print, mean0, mean1, std0, std1, r, bias, rms
  result = hist_2d(x,y,min1=-2,min2=-2,max1=1,max2=1,bin1=.05,bin2=.05)
  nlev = 8
  level = findgen(nlev)+1
  level = [1,5,10,20,50,100,200,500]
  dc = 200./(nlev-1)
  color = reverse(254 - findgen(nlev)*dc)
  xx = findgen(61)*.05-2
  loadct, 39
  plotgrid, result, level, color, xx, xx, .05, .05
  oplot, findgen(7)-2, findgen(7)-2
  oplot, findgen(7)-2, linoffset+linslope*(findgen(7)-2), lin=2

  n = strcompress(string(n_elements(x), format='(i7)'),/rem)
  r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
  bias = strcompress(string(bias, format='(f6.3)'),/rem)
  rms = strcompress(string(rms, format='(f6.3)'),/rem)
  skill = strcompress(string(skill, format='(f5.3)'),/rem)
  polyfill, [2.2,4.9,4.9,2.2,2.2], [-.8,-.8,0,0,-.8], color=255
  xyouts, -1.75, .8, 'n = '+n, charsize=.65
  xyouts, -1.75, .7, 'r!E2!N = '+r2, charsize=.65
  xyouts, -1.75, .6, 'bias = '+bias, charsize=.65
  xyouts, -1, .8, 'rms = '+rms, charsize=.65
  xyouts, -1, .7, 'skill = '+skill, charsize=.65
  m = string(linslope,format='(f5.2)')
  b = string(linoffset,format='(f5.2)')
  xyouts, -1, .6, 'y = '+m+'x + '+b, charsize=.65
  makekey, .825, .17, .05, .73, 0.055, 0., $
   orient=1, colors=color, labels=level, align=0
  xyouts, -1.75, .9, 'log!D10!N(AOT+0.01) based statistics', charsize=.65

  device, /close


end
