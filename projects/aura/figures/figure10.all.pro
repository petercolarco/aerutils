; Colarco
; February 2016
; Four Panel AOD plot of OMAERUV - MERRAero Results

; Setup the plot
  plotfile = 'figure10.all.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=30, xoff=.5, yoff=.5
  !p.font=0


; Get the fields to plot
  filemodel = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'+ $
              'OMI-Aura_L2-OMAERUV_2007m07.vl_rad.geos5_pressure.monthly.sampled_ext.grid.nc4'
  nc4readvar, filemodel, 'aot', aot, lon=lon, lat=lat
  nc4readvar, filemodel, 'ssa', ssa, lon=lon, lat=lat
  fileomi   = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'+$
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

; Plot the MERRAero AOT
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.7,.475,.975]
  xyouts, .025, .98, /normal, charsize=.75, $
   'a) MERRAero AOD (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, aot[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

; Plot the OMAERUV AOT
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.4,.475,.675]
  xyouts, .025, .68, /normal, charsize=.75, $
   'c) OMAERUV AOD (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, aot_omi[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  makekey, .025, .375, .45, .015, 0, -.015, $
   colors=make_array(7,val=255),align=0, charsize=.75,  $
   labels=['0','0.25','0.5','0.75','1','1.25','1.5']
  loadct, 55
  makekey, .025, .375, .45, .015, 0, -.015, $
   labels=make_array(7,val=' '), $
   colors=colors


; Plot the AOT Difference
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.025,.05,.475,.325]
  xyouts, .025, .33, /normal, charsize=.75, $
   'e) OMAERUV - MERRAero AOD Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]
  colors=reverse(20+findgen(9)*30)
  plotgrid, aot_diff[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  makekey, .025, .025, .45, .015, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1']
  loadct, 72
  makekey, .025, .025, .45, .015, 0, -.015, $
   labels=make_array(9,val=' '), $
   colors=colors



  

; Plot the MERRAero SSA
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.7,.975,.975]
  xyouts, .525, .98, /normal, charsize=.75, $
   'b) MERRAero SSA (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[-1.,.76,.8,.84,.88,.92,.96]
  colors=reverse([0,32,80,128,192,208,255])
  plotgrid, ssa[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

; Plot the OMAERUV AOT
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.4,.975,.675]
  xyouts, .525, .68, /normal, charsize=.75, $
   'd) OMAERUV SSA (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 55
  levels=[-1.,.76,.8,.84,.88,.92,.96]
  colors=reverse([0,32,80,128,192,208,255])
  plotgrid, ssa_omi[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  makekey, .525, .375, .45, .015, 0, -.015, $
   colors=make_array(7,val=255),align=.5, charsize=.75,  $
   labels=[' ','0.76','0.8','0.84','0.88','0.92','0.96']
  loadct, 55
  makekey, .525, .375, .45, .015, 0, -.015, $
   labels=make_array(7,val=' '), $
   colors=colors


; Plot the AOT Difference
  loadct, 0
  map_set, /noerase, limit=[-60,-180,60,180], e_horizon={fill:1,color:200}, $
   /noborder, position=[.525,.05,.975,.325]
  xyouts, .525, .33, /normal, charsize=.75, $
   'f) OMAERUV - MERRAero SSA Difference (July 2007)'
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 72
  levels=[-100,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  colors=reverse(20+findgen(9)*30)
  plotgrid, ssa_diff[*,*], levels, colors, lon, lat, dx, dy, /map
  
  loadct, 0
  contour, /overplot, aot, lon, lat, levels=[.5], c_color=[100], c_orient=[45], /cell, /noerase
  map_continents, thick=3

  makekey, .525, .025, .45, .015, 0, -.015, $
   colors=make_array(9,val=255),align=.5, charsize=.75,  $
   labels=[' ','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1']
  loadct, 72
  makekey, .525, .025, .45, .015, 0, -.015, $
   labels=make_array(9,val=' '), $
   colors=colors


device, /close
  
end
