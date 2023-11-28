; Colarco
; February 2016
; Four Panel SSA plot of OMAERUV - MERRAero Results

; Setup the plot
  plotfile = 'figure09.merraero_ssa.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=20, xoff=.5, yoff=.5
  !p.font=0

  levels=[-1.,.76,.8,.84,.88,.92,.96]
  colors=reverse([0,32,80,128,192,208,255])

; Panel 1: SSA Plots (June)
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(ssa gt 1e14)
  ssa[a] = !values.f_nan
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(ssa_omi gt 1e14)
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.55,.475,.95]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) MERRAero SSA (June 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  plotgrid, ssa[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

; Panel 2: SSA Plots (July)
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(ssa gt 1e14)
  ssa[a] = !values.f_nan
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(ssa_omi gt 1e14)
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.55,.975,.95]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) MERRAero SSA (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  plotgrid, ssa[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

; Panel 3: SSA Plots (August)
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(ssa gt 1e14)
  ssa[a] = !values.f_nan
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(ssa_omi gt 1e14)
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.075,.475,.475]
  xyouts, .025, .48, /normal, charsize=.75, $
   'c) MERRAero SSA (August 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  plotgrid, ssa[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3


; Panel 4: SSA Plots (September)
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(ssa gt 1e14)
  ssa[a] = !values.f_nan
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(ssa_omi gt 1e14)
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.075,.975,.475]
  xyouts, .525, .48, /normal, charsize=.75, $
   'd) MERRAero SSA (September 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  plotgrid, ssa[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  loadct, 0
  map_continents, thick=3
  makekey, .3, .025, .4, .025, 0, -.015, $
   colors=make_array(7,val=255),align=.5, charsize=.75,  $
   labels=[' ','0.76','0.8','0.84','0.88','0.92','0.96']
  loadct, 55
  makekey, .3, .025, .4, .025, 0, -.025, $
   labels=make_array(7,val=' '), $
   colors=colors


  device, /close
  

end
