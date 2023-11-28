; Colarco
; February 2016
; Four Panel AOD plot of OMAERUV - MERRAero Results

; Setup the plot
  plotfile = 'figure10.noss.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=10, xoff=.5, yoff=.5
  !p.font=0


; Panel 1: AOD Difference Plot (July)
  filemodel = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'+ $
              'OMI-Aura_L2-OMAERUV_2007m07.vl_rad.geos5_pressure.monthly.sampled_ext.noss.grid.nc4'
  nc4readvar, filemodel, 'aot', aot, lon=lon, lat=lat
  nc4readvar, filemodel, 'ssa', ssa, lon=lon, lat=lat
  fileomi   = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO_noss/'+$
              '2007m07.monthly.grid.nc4'
  nc4readvar, fileomi, 'aot', aot_omi, lon=lon, lat=lat
  nc4readvar, fileomi, 'ssa', ssa_omi, lon=lon, lat=lat
  a = where(aot gt 1e14)
  aot[a] = !values.f_nan
  ssa[a] = !values.f_nan
  a = where(aot_omi gt 1e14)
  aot_omi[a] = !values.f_nan
  ssa_omi[a] = !values.f_nan
; AOD is OMI - MERRAero
  aot_diff = aot_omi - aot
  ssa_diff = ssa_omi - ssa

  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.2,.475,.925]
  xyouts, .025, .955, /normal, charsize=.75, $
   'a) OMAERUV - MERRAero AOD Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]
  colors=reverse(20+findgen(9)*30)
  plotgrid, aot_diff[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  makekey, .025, .1, .45, .05, 0, -.04, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1']
  loadct, 72
  makekey, .025, .1, .45, .05, 0, -.04, $
   labels=make_array(9,val=' '), $
   colors=colors

  
; Panel 2: SSA Difference Plot (July)
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.2,.975,.925]
  xyouts, .525, .955, /normal, charsize=.75, $
   'b) OMAERUV - MERRAero SSA Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  colors=reverse(20+findgen(9)*30)
  plotgrid, ssa_diff[*,*], levels, colors, lon, lat, dx, dy, /map

  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  makekey, .525, .1, .45, .05, 0, -.04, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1']
  loadct, 72
  makekey, .525, .1, .45, .05, 0, -.04, $
   labels=make_array(9,val=' '), $
   colors=colors



  device, /close
  

end
