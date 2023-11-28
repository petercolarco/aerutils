; Read in and map the AOD, SSA comparisons

  datewant = '20070715'
  regname = 'nafrica'

  restore, file='getregions.'+datewant+'.sav'

  set_plot, 'ps'
  device, file='plotregions.day.'+datewant+'.'+regname+'.ps', $
          /color, /helvetica, font_size=12, $
          xoff=.5, yoff=.12, xsize=24, ysize=12
  !p.font=0
  !p.multi=[0,3,2]

  aodcol = fltarr(n_elements(aod))
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  for i = 0, n_elements(levels)-1 do begin
   a = where(aod ge levels[i])
   aodcol[a] = colors[i]
  endfor

  aodomicol = fltarr(n_elements(aodomi))
  levels=[0,.25,.5,.75,1,1.25,1.5]
  colors=[0,32,80,128,192,208,255]
  for i = 0, n_elements(levels)-1 do begin
   a = where(aodomi ge levels[i])
   aodomicol[a] = colors[i]
  endfor

  aoddiff = aodomi - aod
  aoddiffcol = fltarr(n_elements(aoddiff))
  lev = [-100,-1,-.5,-.2,-.1,.1,.2,.5,1]
  coldiff = reverse(20+findgen(9)*30)
  for i = 0, n_elements(lev)-1 do begin
   a = where(aoddiff ge lev[i])
   aoddiffcol[a] = coldiff[i]
  endfor

; Plot OMI AOD
  loadct, 55
  map_set, limit=[-10,-30,30,5]
  plots, lon, lat, psym=sym(1), color=aodomicol, noclip=0, syms=.5
  map_continents, thick=3

; Plot the model AOD
  !p.multi=[5,3,2]
  loadct, 55
  map_set, limit=[-10,-30,30,5],/noerase
  plots, lon, lat, psym=sym(1), color=aodcol, noclip=0, syms=.5
  map_continents, thick=3

; Plot the Difference
  !p.multi=[4,3,2]
  loadct, 72
  map_set, limit=[-10,-30,30,5],/noerase
  plots, lon, lat, psym=sym(1), color=aoddiffcol, noclip=0, syms=.5
  map_continents, thick=3


; Plot the SSA
  ssacol = fltarr(n_elements(ssa))
  levels=[-1.,.76,.8,.84,.88,.92,.96]
  colors=reverse([0,32,80,128,192,208,255])
  for i = 0, n_elements(levels)-1 do begin
   a = where(ssa ge levels[i])
   ssacol[a] = colors[i]
  endfor

  ssaomicol = fltarr(n_elements(ssaomi))
  levels=[-1.,.76,.8,.84,.88,.92,.96]
  colors=reverse([0,32,80,128,192,208,255])
  for i = 0, n_elements(levels)-1 do begin
   a = where(ssaomi ge levels[i])
   ssaomicol[a] = colors[i]
  endfor

  ssadiff = ssaomi - ssa
  ssadiffcol = fltarr(n_elements(ssadiff))
  lev = [-100,-1,-.5,-.2,-.1,.1,.2,.5,1]/10.
  coldiff = reverse(20+findgen(9)*30)
  for i = 0, n_elements(lev)-1 do begin
   a = where(ssadiff ge lev[i])
   ssadiffcol[a] = coldiff[i]
  endfor

; Plot OMI SSA
  !p.multi=[3,3,2]
  loadct, 55
  map_set, limit=[-10,-30,30,5], /noerase
  plots, lon, lat, psym=sym(1), color=ssaomicol, noclip=0, syms=.5
  map_continents, thick=3

; Plot the model SSA
  !p.multi=[2,3,2]
  loadct, 55
  map_set, limit=[-10,-30,30,5],/noerase
  plots, lon, lat, psym=sym(1), color=ssacol, noclip=0, syms=.5
  map_continents, thick=3

; Plot the Difference
  !p.multi=[1,3,2]
  loadct, 72
  color = (ssadiff+.1)/.2*255.
  map_set, limit=[-10,-30,30,5],/noerase
  plots, lon, lat, psym=sym(1), color=ssadiffcol, noclip=0, syms=.5
  map_continents, thick=3


  device, /close

end
