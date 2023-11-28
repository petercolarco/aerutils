; Colarco
; February 2016
; Four Panel AOD plot of MERRAero Results

; Setup the plot
  plotfile = 'figure06.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=20, xoff=.5, yoff=.5
  !p.font=0


; Panel 1: AOD Plots (June)
  filetemplate = 'monthly.sampled_ext.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200706')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.55,.475,.95]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) MERRAero AOD (June 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, aot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 2: AOD Plots (July)
  filetemplate = 'monthly.sampled_ext.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.55,.975,.95]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) MERRAero AOD (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, aot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 3: AOD Plots (August)
  filetemplate = 'monthly.sampled_ext.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200708')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.075,.475,.475]
  xyouts, .025, .48, /normal, charsize=.75, $
   'c) MERRAero AOD (August 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, aot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3


; Panel 4: AOD Plots (September)
  filetemplate = 'monthly.sampled_ext.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200709')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd_, nhms_, template=template
  filename_omi=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.075,.975,.475]
  xyouts, .525, .48, /normal, charsize=.75, $
   'd) MERRAero AOD (September 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, aot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

  loadct, 0
  map_continents, thick=3
  makekey, .3, .025, .4, .025, 0, -.015, $
   colors=make_array(7,val=255),align=0, charsize=.75,  $
   labels=['0','0.25','0.5','0.75','1','1.25','1.5']
  loadct, 55
  makekey, .3, .025, .4, .025, 0, -.025, $
   labels=make_array(7,val=' '), $
   colors=colors


  device, /close
  

end
