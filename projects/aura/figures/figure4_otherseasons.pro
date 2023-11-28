; Colarco
; February 2016
; Make a PDF histogram of the of the MERRAero vs. OMAERUV AI for all
; four months based on the PGEO files.  Be sure to sample only where
; PGEO returns an AI.  Other three panels are months of July, August,
; and September monthly difference plot

; Setup the plot
  plotfile = 'figure4_otherseasons.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0


; Panel 1: get the daily gridded AI values and make joint PDF
  filetemplate = 'daily.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  filetemplate = 'daily.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14 or ai gt 1e14)
  ai[a] = !values.f_nan
  ai_omi[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  nt = n_elements(nymd)
  result = hist_2d(ai_omi, ai, min1=-2.,min2=-2.,max1=6,max2=6, $
                   bin1=.1,bin2=.1)

  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.05,.6,.425,.95], $
   xrange=[-2,6], yrange=[-2,6], $
   xtitle='OMAERUV AI', $
   ytitle='MERRAero AI', charsize=.75
  loadct, 74
  level = [1,5,10,50,100,500,1000,5000]
  color = findgen(8)*35
  x = -2.+findgen(81)*.1
  y = -2.+findgen(81)*.1
  dx = .1
  dy = .1
  plotgrid, result, level, color, x, y, dx, dy

  loadct, 0
  xyouts, .05, .955, /normal, charsize=.75, $
   'a) Frequency Distribution of MERRAero versus OMAERUV AI (daily)'
  oplot, indgen(10)-2, indgen(10)-2, thick=2, lin=2
  makekey, .43, .6, .025, .35, 0.03, 0., /orient, $
   labels=['1','5','10','50','100','500','1000','5000'], $
   colors=make_array(8,val=0), charsize=.75, align=0
  loadct, 74
  makekey, .43, .6, .025, .35, 0.03, 0, /orient, $
   labels=make_array(8,val=' '), $
   colors=color

; print some histogram values
  a = where(abs(ai-ai_omi) gt .1)
  print, 'abs(aidiff) > 0.1 ', $
         n_elements(a), n_elements(ai), n_elements(a)*1./n_elements(ai)*100.
  a = where(abs(ai-ai_omi) gt .2)
  print, 'abs(aidiff) > 0.2 ', $
         n_elements(a), n_elements(ai), n_elements(a)*1./n_elements(ai)*100.
  a = where(abs(ai-ai_omi) gt .5)
  print, 'abs(aidiff) > 0.5 ', $
         n_elements(a), n_elements(ai), n_elements(a)*1./n_elements(ai)*100.


; Panel 2: Difference Plots (July)
  filetemplate = 'monthly.aimask.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
; Difference is OMI - MERRAero
  diff = ai_omi - ai

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.6,.975,.95]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV (MERRAero pressure) - MERRAero AI Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-.2,-0.1,-.05,-.02,-.01,.01,.02,.05,.1,.2]
  colors=reverse(findgen(11)*24)
  colors=reverse(colors)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 3: Difference Plots (August)
  filetemplate = 'monthly.aimask.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200708')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
; Difference is OMI - MERRAero
  diff = ai_omi - ai

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.1,.475,.45]
  xyouts, .025, .455, /normal, charsize=.75, $
   'c) OMAERUV (MERRAero pressure) - MERRAero AI Difference (August 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-.2,-0.1,-.05,-.02,-.01,.01,.02,.05,.1,.2]
  colors=reverse(findgen(11)*24)
  colors=reverse(colors)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3


; Panel 4: Difference Plots (September)
  filetemplate = 'monthly.aimask.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200709')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  ai[a] = !values.f_nan
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
; Difference is OMI - MERRAero
  diff = ai_omi - ai

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.1,.975,.45]
  xyouts, .525, .455, /normal, charsize=.75, $
   'd) OMAERUV (MERRAero pressure) - MERRAero AI Difference (September 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-.2,-0.1,-.05,-.02,-.01,.01,.02,.05,.1,.2]
  colors=reverse(findgen(11)*24)
  colors=reverse(colors)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

  loadct, 0
  map_continents, thick=3
  makekey, .3, .05, .4, .025, 0, -.015, $
   colors=make_array(11,val=255), align=.5, charsize=.75, $
   labels=[' ','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
  loadct, 66
  makekey, .3, .05, .4, .025, 0, -.025, $
   labels=make_array(11,val=' '), $
   colors=colors


  device, /close
  

end
