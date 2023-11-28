; Colarco
; February 2016
; Make a plot of the AI, the differences OMAERUV - MERRAero surface
;                                                  pressure, AI (with
;                                                  OMI surface
;                                                  pressure) and AI
;                                                  (with GEOS-5
;                                                  surface pressure)
; Merge as single plot

; Setup the plot
  plotfile = 'figure1.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0


; Panel 1: Model AI value
  filetemplate = 'daily.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd eq '20070605')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  nc4readvar, filename, 'ai', ai, lon=lon, lat=lat
  a = where(ai gt 1e14)
  filetemplate = 'daily.pomi.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai[a] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

  title = 'a) MERRAero Aerosol Index ('+nymd[0]+')'

  loadct, 0
  map_set, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.6,.475,.95]
  xyouts, .025, .955, /normal, title
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  levels=[-100,0,.5,1,1.5,2.0,2.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, ai, levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .05, .55, .4, .025, 0, -.015, $
   colors=make_array(7,val=255), align=0.5, charsize=.75, $
   labels=[' ','0','0.5','1','1.5','2','2.5']
  loadct, 34
  makekey, .05, .55, .4, .025, 0, -.025, $
   labels=make_array(7,val=' '), $
   colors=colors



; Panel 2: Surface pressure difference
  nc4readvar, filename, 'prs', prs, lon=lon, lat=lat
  a = where(prs gt 1e14)
  a = where(ai_omi gt 1e14)
  prs[a] = !values.f_nan
  nc4readvar, filename, 'prso', prso, lon=lon, lat=lat
  a = where(prso gt 1e14)
  a = where(ai_omi gt 1e14)
  prso[a] = !values.f_nan
; Difference is OMI - MERRAero
  diff = prso - prs

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.6,.975,.95]
  xyouts, .525, .955, /normal, $
   'b) Surface Pressure Difference [hPa]: OMAERUV - MERRAero'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-50,-40,-30,-20,-10,-1,1,10,20,30,40,50]
  colors=reverse(findgen(13)*20)
  colors=reverse(colors)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .55, .55, .4, .025, 0, -.015, $
   colors=make_array(13,val=255), align=.5, charsize=.75, $
   labels=[' ','-50','-40','-30','-20','-10','-1','1','10','20','30','40','50']
  loadct, 66
  makekey, .55, .55, .4, .025, 0, -.025, $
   labels=make_array(13,val=' '), $
   colors=colors


; Panel 3: AI difference OMAERUV using own pressure - MERRAero
  filetemplate = 'daily.pomi.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
  diff = ai_omi - ai
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.1,.475,.45]
  xyouts, .025, .455, /normal, $
   'c) AI Difference: OMAERUV (own pressure) - MERRAero'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-1.5,-1,-.5,-.2,-.1,.1,.2,.5,1,1.5]
  colors=reverse(findgen(11)*24)
  colors=reverse(colors)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3



; Panel 4: AI difference OMAERUV using MERRAero pressure - MERRAero
  filetemplate = 'daily.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename_omi, 'ai', ai_omi, lon=lon, lat=lat
  a = where(ai_omi gt 1e14)
  ai_omi[a] = !values.f_nan
  diff = ai_omi - ai
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.1,.975,.45]
  xyouts, .525, .455, /normal, $
   'd) AI Difference: OMAERUV (MERRAero pressure) - MERRAero'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 66
  levels=[-1000,-1.5,-1,-.5,-.2,-.1,.1,.2,.5,1,1.5]
  colors=reverse(findgen(11)*24)
  colors=reverse(colors)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  makekey, .3, .05, .4, .025, 0, -.015, $
   colors=make_array(11,val=255), align=.5, charsize=.75, $
   labels=[' ','-1.5','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1','1.5']
  loadct, 66
  makekey, .3, .05, .4, .025, 0, -.025, $
   labels=make_array(11,val=' '), $
   colors=colors


  device, /close
  

end
