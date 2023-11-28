  filetemplate = 'daily.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200706')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  filetemplate = 'daily.pomi.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)

  filetemplate = 'daily.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_geo=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename, 'prs', prs, lon=lon, lat=lat
  a = where(prs gt 1e14)
  prs[a] = !values.f_nan
  nc4readvar, filename, 'prso', prso, lon=lon, lat=lat
  a = where(prso gt 1e14)
  prso[a] = !values.f_nan
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
  nc4readvar, filename_geo, 'ai', ai_geo, lon=lon, lat=lat
  a = where(ai_geo gt 1e14)
  ai_geo[a] = !values.f_nan


  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Retain only values with defined AI
  a = where(finite(ai) eq 1 and finite(ai_omi) eq 1 and finite(ai_geo) eq 1)
  ai     = ai[a]
  ai_omi = ai_omi[a]
  ai_geo = ai_geo[a]
  prs    = prs[a]
  prso   = prso[a]
  
; Differences are OMAERUV - MERRAero
  pdiff  = prso - prs
  a = where(pdiff lt -50)
  pdiff[a] = -50.
  a = where(pdiff gt 50.)
  pdiff[a] = 50.
  pdiff = pdiff+50.
  pdiff = pdiff/100.*254
  aidiff = ai_omi - ai
  aigdiff = ai_geo - ai

  plotfile = 'aidiff_scatter.pgeo.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.1,.25,.95,.95], $
   xrange=[-1,5], yrange=[-2,3], $
   xtitle='MERRAero Aerosol Index', $
   ytitle='!9D!3AI (OMAERUV - MERRAero)'

  loadct, 74
  plots, ai, aidiff, psym=3, color=pdiff, noclip=0
a = where(abs(aidiff) gt 0.2)
print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))
a = where(abs(aigdiff) gt 0.2)
print, n_elements(aigdiff), n_elements(a), float(n_elements(a))/float(n_elements(aigdiff))
  labels = ['-50','0','50']
  makekey, .2, .08, .65, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  loadct, 0
  plots, ai, aigdiff, psym=3, color=0, noclip=0
  xyouts, .525, .015, /normal, 'Pressure Difference (OMAERUV - MERRAero) [hPa]', $
   charsize=.75, align=.5

  device, /close
  

end
