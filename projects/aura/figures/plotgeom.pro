; Read the aggregate files from getgeom.pro and make a plot
; that illustrates relevant behavior

  datewant = '200706'

  restore, file='getgeom.'+datewant+'.sav'

; Region of interest
  a = where(lon gt -125 and lon lt -80 and lat gt 35 and lat lt 40)
  regname = 'namerica'
stop
  xrange = [-125,-80]

; Plot some regional stuff
  set_plot, 'ps'
  device, file='plotgeom.'+datewant+'_'+regname+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=26
  !p.font=0
  !p.multi = [0,2,5]

; PRS
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,4], $
   xtitle='longitude', ytitle='AOD', $
   title='AOD: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], aod[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], aodomi[a], psym=sym(1), color=84, symsize=.5

; AOD difference
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[-1,2], $
   xtitle='longitude', ytitle='AOD Difference', $
   title='OMAERUV - MERRAero AOD Difference'
  loadct, 39
  plots, lon[a], aodomi[a]-aod[a], psym=sym(1), color=84, symsize=.5


; SSA
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[.7,1], $
   xtitle='longitude', ytitle='SSA', $
   title='SSA: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], ssa[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], ssaomi[a], psym=sym(1), color=84, symsize=.5

; SSA difference
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[-.2,.2], $
   xtitle='longitude', ytitle='SSA Difference', $
   title='OMAERUV - MERRAero SSA difference'
  loadct, 39
  plots, lon[a], ssaomi[a]-ssa[a], psym=sym(1), color=84, symsize=.5

; AI
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,5], $
   xtitle='longitude', ytitle='AI', $
   title='AI: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], ai[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], aiomi[a], psym=sym(1), color=84, symsize=.5

; LER
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='LER', $
   title='LER388: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], ler[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], leromi[a], psym=sym(1), color=84, symsize=.5

; AERH
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,4], $
   xtitle='longitude', ytitle='Aerosol Height [km]', $
   title='OMAERUV aerosol retrieval height'
  loadct, 39
  plots, lon[a], aerh[a], psym=sym(1), color=84, symsize=.5

; AERT
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,3.2], ystyle=1, $
   yticks=3, ytickv=[0,1,2,3], ytickn=[' ','1','2','3'], $
   xtitle='longitude', ytitle='Aerosol Type Flag', $
   title='OMAERUV aerosol type flag'
  loadct, 39
  plots, lon[a], aert[a], psym=sym(1), color=84, symsize=.5
  x = min(xrange)+.02*(max(xrange)-min(xrange))
  n = n_elements(where(aert[a] eq 1))
  xyouts, x, .6, 'n = '+string(n)
  n = n_elements(where(aert[a] eq 2))
  xyouts, x, 1.6, 'n = '+string(n)
  n = n_elements(where(aert[a] eq 3))
  xyouts, x, 2.6, 'n = '+string(n)

; REF
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Surface Reflectance @ 388', $
   title='OMAERUV Surface Reflectance @ 388 nm'
  loadct, 39
  plots, lon[a], refomi[a], psym=sym(1), color=84, symsize=.5

; RAD
  plot, findgen(2), /nodata, $
   xrange=xrange, yrange=[0,.2], $
   xtitle='longitude', ytitle='Radiance @ 388'
   title='Radiance @ 388 nm: MERRAero = red, OMAERUV = blue'
  loadct, 39
  plots, lon[a], rad[a], psym=sym(1), color=254, symsize=.5
  plots, lon[a], radomi[a], psym=sym(1), color=84, symsize=.5

device, /close

end
