; Colarco, December 2015
; Get a time series of AI and scatter against OMI

  plotfile = 'ai_scatter.dust.v5_5.ps'

  ga_times, 'v5_5.ddf', nymd, nhms, template=filetemplate
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  nc4readvar, filename, 'ai_omi', ai_omi
  a = where(lon ge -30 and lon le 20)
  ai = ai[a,*,*]
  ai_omi = ai_omi[a,*,*]
  b = where(lat ge 0 and lat le 45)
  ai = ai[*,b,*]
  ai_omi = ai_omi[*,b,*]

  a = where(ai gt 1e14 or ai_omi gt 1e14)
  ai[a] = !values.f_nan
  ai_omi[a] = !values.f_nan

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=14, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, findgen(5), /nodata, $
   xrange=[-1,5], yrange=[-1,5], $
   xstyle=9, ystyle=9, thick=3, $
   xtitle='OMAERUV', ytitle='MERRAero', $
   position=[.1,.1,.8,.95]

  x = ai_omi[where(finite(ai) eq 1)]
  y = ai[where(finite(ai) eq 1)]
  statistics, x, y, mean0, mean1, std0, std1, $
              r, bias, rms, skill, linslope, linoffset, rc=rc
  print, mean0, mean1, std0, std1, r, bias, rms
  result = hist_2d(x,y,min1=-1,min2=-1,max1=5,max2=5,bin1=.05,bin2=.05)
  nlev = 8
  level = findgen(nlev)+1
  level = [1,2,5,10,20,50,100,200]
  dc = 200./(nlev-1)
  color = reverse(254 - findgen(nlev)*dc)
  xx = findgen(121)*.05-1
  loadct, 39
  plotgrid, result, level, color, xx, xx, .05, .05
  oplot, findgen(7)-1, findgen(7)-1
  oplot, findgen(7)-1, linoffset+linslope*(findgen(7)-1), lin=2

  n = strcompress(string(n_elements(x), format='(i7)'),/rem)
  r2 = strcompress(string(r*r, format='(f6.3)'),/rem)
  bias = strcompress(string(bias, format='(f6.3)'),/rem)
  rms = strcompress(string(rms, format='(f6.3)'),/rem)
  skill = strcompress(string(skill, format='(f5.3)'),/rem)
  polyfill, [2.2,4.9,4.9,2.2,2.2], [-.8,-.8,0,0,-.8], color=255
  xyouts, 2.25, -.2, 'n = '+n, charsize=.65
  xyouts, 2.25, -.5, 'r!E2!N = '+r2, charsize=.65
  xyouts, 2.25, -.8, 'bias = '+bias, charsize=.65
  xyouts, 3.5, -.2, 'rms = '+rms, charsize=.65
  xyouts, 3.5, -.5, 'skill = '+skill, charsize=.65
  m = string(linslope,format='(f5.2)')
  b = string(linoffset,format='(f5.2)')
  xyouts, 3.5, -.8, 'y = '+m+'x + '+b, charsize=.65
  makekey, .825, .15, .05, .75, 0.055, 0., $
   orient=1, colors=color, labels=level, align=0

  device, /close


end
