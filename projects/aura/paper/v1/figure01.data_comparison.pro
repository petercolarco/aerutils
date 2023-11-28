; Colarco
; Make a plot of OMI AI/AAOD vs. MERRAero AI/AAOD for actual
; observations
; This is based on model runs performed for the QA = 0 OMI
; sampling as from:
; /discover/nobackup/pcolarco/GAAS/src/Components/scat/dR_MERRA-AA-r2-v1621f
; The resulting NPZ and regridding scripts are here:
; bender:/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v7_5

; Pick a month
  datewant = '200707'

; Get the OMI and model AI
  filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v1_5/dR_MERRA-AA-r2-v1621.ai.'+datewant+'.nc4'
  nc4readvar, filename, 'ai_omi', ai_omi, lon=lon, lat=lat
  nc4readvar, filename, 'ai', ai_mod
  a = where(ai_mod gt 1e14 or ai_omi gt 1e15)
  ai_mod[a] = !values.f_nan
  ai_omi[a] = !values.f_nan
  ai_dif    = ai_omi - ai_mod

; Get the OMI and model AAOD
  filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v1_5/dR_MERRA-AA-r2-v1621.aot_omi388.'+datewant+'.nc4'
  nc4readvar, filename, 'aaot', aaot_omi, lon=lon, lat=lat
  filename = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f/v1_5/dR_MERRA-AA-r2-v1621.aot388.'+datewant+'.nc4'
  nc4readvar, filename, 'aaot', aaot_mod, lon=lon, lat=lat
  aaot_mod[a] = !values.f_nan
  aaot_omi[a] = !values.f_nan
  aaot_dif    = aaot_omi - aaot_mod

; Now make a plot
  set_plot, 'ps'
  device, file='figure01.data_comparison.'+datewant+'.ps', /color, $
          /helvetica, font_size=12, $
          xoff=.5, yoff=.5, xsize=32, ysize=24
  !p.font=0

  position = [ [.05,.7,.4,.95], [.525,.7,.875,.95], $
               [.05,.4,.4,.65], [.525,.4,.875,.65], $
               [.05,.1,.4,.35], [.525,.1,.875,.35] ]

; AI
  loadct, 0
  title = 'OMI Aerosol Index ('+datewant+')' 
  map_set, limit=[-60,-180,75,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,0], title=title
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 55
  levels=[-.5,0,.5,1,1.5,2.0,2.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, ai_omi, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3

  loadct, 0
  title = 'MERRAero Aerosol Index ('+datewant+')' 
  map_set, limit=[-60,-180,75,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,2], title=title, /noerase
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 55
  levels=[-.5,0,.5,1,1.5,2.0,2.5]
  colors=[0,32,80,128,192,208,255]
  plotgrid, ai_mod, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3

  makekey, .41, .5, .03, .35, .04, 0, orient=1, align=0, $
           colors=make_array(7,val=0), $
           labels=['-0.5','0','0.5','1','1.5','2','2.5']
  loadct, 55
  makekey, .41, .5, .03, .35, .04, 0, orient=1, /noborder, $
           colors=colors, $
           labels=make_array(7,val=' ')

  loadct, 0
  title = '!9D!3AI!DOMI - MERRAero!N ('+datewant+')' 
  map_set, limit=[-60,-180,75,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,4], title=title, /noerase
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 4
  loadct, 72
  levels=[-100,-1.5,-1,-.5,-.1,.1,.5,1,1.5]
  colors=reverse(20+findgen(9)*30)
  plotgrid, ai_dif, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3

  makekey, .41, .1, .03, .25, .04, 0, orient=1, align=0, $
           colors=make_array(9,val=0), $
           labels=[' ','-1.5','-1','-0.5','-0.1','0.1','0.5','1','1.5']
  loadct, 72
  makekey, .41, .1, .03, .25, .04, 0, orient=1, /noborder, $
           colors=colors, $
           labels=make_array(9,val=' ')




  ; AAOD
  loadct, 0
  title = 'OMI AAOD!D388 nm!N ('+datewant+')' 
  map_set, limit=[-60,-180,75,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,1], title=title, /noerase
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 55
  levels=findgen(11)*.02
  colors=indgen(11)*20+25
  plotgrid, aaot_omi, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3

  loadct, 0
  title = 'MERRAero AAOD!D388 nm!N ('+datewant+')' 
  map_set, limit=[-60,-180,75,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,3], title=title, /noerase
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 55
  plotgrid, aaot_mod, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3

  makekey, .885, .5, .03, .35, .04, 0, orient=1, align=0, $
           colors=make_array(11,val=0), $
           labels=string(levels,format='(F4.2)')
  loadct, 55
  makekey, .885, .5, .03, .35, .04, 0, orient=1, /noborder, $
           colors=colors, $
           labels=make_array(11,val=' ')

  loadct, 0
  title = '!9D!3AAOD!DOMI - MERRAero!N ('+datewant+')' 
  map_set, limit=[-60,-180,75,180], e_horizon={fill:1,color:200}, $
   /noborder, position=position[*,5], title=title, /noerase
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  loadct, 4
  loadct, 72
  levels=-.1+findgen(11)*.02
  colors=reverse(20+findgen(11)*23)
  plotgrid, aaot_dif, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=3

  makekey, .885, .1, .03, .25, .04, 0, orient=1, align=0, $
           colors=make_array(11,val=0), $
           labels=string(levels,format='(f5.2)')
  loadct, 72
  makekey, .885, .1, .03, .25, .04, 0, orient=1, /noborder, $
           colors=colors, $
           labels=make_array(11,val=' ')

  device, /close

  
end
