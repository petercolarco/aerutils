; Colarco
; February 2016
; Four Panel AAOD plot of OMAERUV - MERRAero Results

; Setup the plot
  plotfile = 'figure6.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0

  levels=[-100.,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  colors=reverse(20+findgen(9)*30)

; Panel 1: AAOD Plots (June)
  filetemplate = 'monthly.sampled.ctl'
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  aot = aot-ssa*aot
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
  aot_omi = aot_omi-ssa_omi*aot_omi
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.6,.475,.95]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) OMAERUV - MERRAero AAOD Difference (June 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 2: AAOD Plots (July)
  filetemplate = 'monthly.sampled.ctl'
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  aot = aot-ssa*aot
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
  aot_omi = aot_omi-ssa_omi*aot_omi
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.6,.975,.95]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV - MERRAero AAOD Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

; Panel 3: AAOD Plots (August)
  filetemplate = 'monthly.sampled.ctl'
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  aot = aot-ssa*aot
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
  aot_omi = aot_omi-ssa_omi*aot_omi
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.1,.475,.45]
  xyouts, .025, .455, /normal, charsize=.75, $
   'c) OMAERUV - MERRAero AAOD Difference (August 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3


; Panel 4: AAOD Plots (September)
  filetemplate = 'monthly.sampled.ctl'
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  aot = aot-ssa*aot
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
  aot_omi = aot_omi-ssa_omi*aot_omi
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.1,.975,.45]
  xyouts, .525, .455, /normal, charsize=.75, $
   'd) OMAERUV - MERRAero AAOD Difference (September 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3

  loadct, 0
  map_continents, thick=3
  makekey, .3, .05, .4, .025, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1']
  loadct, 72
  makekey, .3, .05, .4, .025, 0, -.025, $
   labels=make_array(9,val=' '), $
   colors=colors


  device, /close
  

end
