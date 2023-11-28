; Colarco
; February 2016
; Four Panel plot of OMAERUV - MERRAero Results

; Setup the plot
  plotfile = 'figure14.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=24, xoff=.5, yoff=.5
  !p.font=0


; Panel 1: AOD Plots (July)
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
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  nc4readvar, filename_omi, 'aot', aot_omi, lon=lon, lat=lat
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = aot_omi - aot

  loadct, 0
  map_set, /noerase, limit=[0,-80,40,40], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.575,.475,.925]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) OMAERUV - MERRAero AOD Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]
  colors=reverse(20+findgen(9)*30)
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  map_grid, /box

  makekey, .05, .525, .4, .025, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1']
  loadct, 72
  makekey, .05, .525, .4, .025, 0, -.025, $
   labels=make_array(9,val=' '), $
   colors=colors


; Panel 2: SSA Plots (July)
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  colors=reverse(20+findgen(9)*30)
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
  nc4readvar, filename, 'ssa', ssa, lon=lon, lat=lat
  a = where(ssa gt 1e14)
  ssa[a] = !values.f_nan
  nc4readvar, filename_omi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(ssa_omi gt 1e14)
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[0,-80,40,40], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.575,.975,.925]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV - MERRAero SSA Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  plotgrid, diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  map_grid, /box

  makekey, .55, .525, .4, .025, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1']
  loadct, 72
  makekey, .55, .525, .4, .025, 0, -.025, $
   labels=make_array(9,val=' '), $
   colors=colors


; Panel 3: AOD Plots (August)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  nc4readvar, filename, 'ndust', ndust, lon=lon, lat=lat
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan
  ntot = ndust/ntot

  loadct, 0
  map_set, /noerase, limit=[0,-80,40,40], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.075,.475,.425]
  xyouts, .025, .455, /normal, charsize=.75, $
   'c) OMAERUV Fraction of AOD Retrievals Returned as Dust (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  levels=[0,.1,.2,.5,.8,.9,.95]
  colors=[0,32,80,128,192,208,255]
  plotgrid, ntot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  map_grid, /box

; Model monthly mean AOT
  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2a/inst2d_hwl_x/Y2007/M07/'+ $
             'dR_MERRA-AA-r2a.inst2d_hwl_x.monthly.200707.nc4'
  nc4readvar, filename, 'totexttau', totext
  nc4readvar, filename, 'duexttau', duext
  contour, /overplot, duext/totext, lon, lat, $
           level=levels, $
           c_thick=make_array(n_elements(levels),val=6), $
           c_line=make_array(n_elements(levels),val=2), $
           c_col=make_array(n_elements(levels),val=0), $
           c_lab=make_array(n_elements(levels),val=1)


  makekey, .05, .025, .4, .025, 0, -.015, $
   colors=make_array(7,val=255),align=0, charsize=.75,  $
   labels=['<0.1','0.1','0.2','0.5','0.8','0.9','0.95']
  loadct, 34
  makekey, .05, .025, .4, .025, 0, -.015, $
   labels=make_array(7,val=' '), $
   colors=colors

; Panel 4: AOD Plots (September)
  filetemplate = 'monthly.pgeo.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(strmid(nymd,0,6) eq '200707')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ndust','nsmok','nsulf'], ntot, lon=lon, lat=lat, /sum
  nc4readvar, filename, 'nsulf', ndust, lon=lon, lat=lat
  a = where(ntot lt 1)
  ntot[a] = !values.f_nan
  ntot = ndust/ntot

  loadct, 0
  map_set, /noerase, limit=[0,-80,40,40], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.075,.975,.425]
  xyouts, .525, .455, /normal, charsize=.75, $
   'd) OMAERUV Fraction of AOD Retrievals Returned as Sulfate (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 34
  levels=[0,.05,.1,.15,.2,.25,.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, ntot[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  map_continents, thick=3
  map_grid, /box

; Model monthly mean AOT
  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2a/inst2d_hwl_x/Y2007/M07/'+ $
             'dR_MERRA-AA-r2a.inst2d_hwl_x.monthly.200707.nc4'
  nc4readvar, filename, 'totexttau', totext
  nc4readvar, filename, ['suexttau'], suext, /sum
  contour, /overplot, suext/totext, lon, lat, $
           level=levels, $
           c_thick=make_array(n_elements(levels),val=6), $
           c_line=make_array(n_elements(levels),val=2), $
           c_col=make_array(n_elements(levels),val=250), $
           c_lab=make_array(n_elements(levels),val=1)


  makekey, .55, .025, .4, .025, 0, -.015, $
   colors=make_array(7,val=255),align=0, charsize=.75,  $
   labels=['<0.05','0.05','0.1','0.15','0.2','0.25','0.5']
  loadct, 34
  makekey, .55, .025, .4, .025, 0, -.015, $
   labels=make_array(7,val=' '), $
   colors=colors

  device, /close

  

end
