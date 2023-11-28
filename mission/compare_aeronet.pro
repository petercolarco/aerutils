  sites = ['la_parguera', 'capo_verde', 'guadeloup', 'tuxtla_gutierrez']

  nsites = n_elements(sites)
  nt = 176
  time = findgen(nt)*.125+1

  for isite = 0, nsites-1 do begin

   set_plot, 'ps'
   device, file = 'aeronet.'+sites[isite]+'.ps', /helvetica, font_size=14, $
    xoff=.5, yoff=.5, xsize=14, ysize=10, /color
   !p.font=0
   loadct, 39

   plot, findgen(24), /nodata, $
    xthick=3, xtitle='Day of July 2007', xrange=[1,23], xstyle=9, $
    ythick=3, ytitle='AOT', yrange=[0,2], ystyle=9, title=sites[isite]+' Dust'
   ga_getvar, 'geos5.'+sites[isite]+'.nc', 'duexttau', duexttau
   oplot, time, duexttau[0,0,*], color=208, thick=6
   totexttau5 = duexttau
   ga_getvar, 'geos4.'+sites[isite]+'.nc', 'duexttau', duexttau
   oplot, time, duexttau[0,0,*], lin=2, color=208, thick=6
   totexttau4 = duexttau

   plot, findgen(24), /nodata, $
    xthick=3, xtitle='Day of July 2007', xrange=[1,23], xstyle=9, $
    ythick=3, ytitle='AOT', yrange=[0,.05], ystyle=9, title=sites[isite]+' Seasalt'
   ga_getvar, 'geos5.'+sites[isite]+'.nc', 'ssexttau', duexttau
   oplot, time, duexttau[0,0,*], color=60, thick=6
   totexttau5 = totexttau5 + duexttau
   ga_getvar, 'geos4.'+sites[isite]+'.nc', 'ssexttau', duexttau
   oplot, time, duexttau[0,0,*], lin=2, color=60, thick=6
   totexttau4 = totexttau4 + duexttau

   plot, findgen(24), /nodata, $
    xthick=3, xtitle='Day of July 2007', xrange=[1,23], xstyle=9, $
    ythick=3, ytitle='AOT', yrange=[0,.5], ystyle=9, title=sites[isite]+' Sulfate'
   ga_getvar, 'geos5.'+sites[isite]+'.nc', 'suexttau', duexttau
   oplot, time, duexttau[0,0,*], color=176, thick=6
   totexttau5 = totexttau5 + duexttau
   ga_getvar, 'geos4.'+sites[isite]+'.nc', 'suexttau', duexttau
   oplot, time, duexttau[0,0,*], lin=2, color=176, thick=6
   totexttau4 = totexttau4 + duexttau

   plot, findgen(24), /nodata, $
    xthick=3, xtitle='Day of July 2007', xrange=[1,23], xstyle=9, $
    ythick=3, ytitle='AOT', yrange=[0,.1], ystyle=9, title=sites[isite]+' Carbonaceous'
   ga_getvar, 'geos5.'+sites[isite]+'.nc', ['ocexttau','bcexttau'], duexttau
   oplot, time, duexttau[0,0,*], color=254, thick=6
   totexttau5 = totexttau5 + duexttau
   ga_getvar, 'geos4.'+sites[isite]+'.nc', ['ocexttau','bcexttau'], duexttau
   oplot, time, duexttau[0,0,*], lin=2, color=254, thick=6
   totexttau4 = totexttau4 + duexttau

   plot, findgen(24), /nodata, $
    xthick=3, xtitle='Day of July 2007', xrange=[1,23], xstyle=9, $
    ythick=3, ytitle='AOT', yrange=[0,2.5], ystyle=9, title=sites[isite]+' Total AOT'
   oplot, time, totexttau5[0,0,*], color=0, thick=6
   oplot, time, totexttau4[0,0,*], lin=2, color=0, thick=6


   device, /close
  endfor

end

