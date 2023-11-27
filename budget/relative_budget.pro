; Colarco, December 2010
; Plot the relative budget of emissions, burden, etc. of two
; experiments

  yyyy = '2009'
  expid = ['R_qfed21_2_3.tavg2d_aer_x', $
           'YOTC.tavg2d_aer_x']
  nexpid = n_elements(expid)
  loadct, 39
  colorarray=[176,84]
  q = fltarr(nexpid)
  aertype = ['DU','SS','BC','POM','SU']

  set_plot, 'ps'
  device, file='relative_budget_emis.ps', /color, /helvetica, $
   xsize=14, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  plot, indgen(2), /nodata, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4
  for iaer = 0, 4 do begin

   for iexp = 0, nexpid-1 do begin
    read_budget_table, expid[iexp], aertype[iaer], yyyy, $
                       emis, sed, dep, wet, scav, burden, tau
    q[iexp] = emis[12]
   endfor    
   q = q/q[0]
   for iexp = 0, nexpid-1 do begin
    x = iaer*(nexpid+2)+iexp+1
    polyfill, [x,x+1,x+1,x,x], [0,0,q[iexp],q[iexp],0], $
     color=colorarray[iexp], noclip=0
   endfor
  endfor

  plot, indgen(2), /nodata, /noerase, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4

  device, /close



  set_plot, 'ps'
  device, file='relative_budget_burden.ps', /color, /helvetica, $
   xsize=14, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  plot, indgen(2), /nodata, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4
  for iaer = 0, 4 do begin

   for iexp = 0, nexpid-1 do begin
    read_budget_table, expid[iexp], aertype[iaer], yyyy, $
                       emis, sed, dep, wet, scav, burden, tau
    q[iexp] = burden[12]
   endfor    
   q = q/q[0]
   for iexp = 0, nexpid-1 do begin
    x = iaer*(nexpid+2)+iexp+1
    polyfill, [x,x+1,x+1,x,x], [0,0,q[iexp],q[iexp],0], $
     color=colorarray[iexp], noclip=0
   endfor
  endfor

  plot, indgen(2), /nodata, /noerase, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4

  device, /close




  set_plot, 'ps'
  device, file='relative_budget_aot.ps', /color, /helvetica, $
   xsize=14, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  plot, indgen(2), /nodata, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4
  for iaer = 0, 4 do begin

   for iexp = 0, nexpid-1 do begin
    read_budget_table, expid[iexp], aertype[iaer], yyyy, $
                       emis, sed, dep, wet, scav, burden, tau
    q[iexp] = tau[12]
   endfor    
   q = q/q[0]
   for iexp = 0, nexpid-1 do begin
    x = iaer*(nexpid+2)+iexp+1
    polyfill, [x,x+1,x+1,x,x], [0,0,q[iexp],q[iexp],0], $
     color=colorarray[iexp], noclip=0
   endfor
  endfor

  plot, indgen(2), /nodata, /noerase, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4

  device, /close




  set_plot, 'ps'
  device, file='relative_budget_loss.ps', /color, /helvetica, $
   xsize=14, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  plot, indgen(2), /nodata, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4
  for iaer = 0, 4 do begin

   for iexp = 0, nexpid-1 do begin
    read_budget_table, expid[iexp], aertype[iaer], yyyy, $
                       emis, sed, dep, wet, scav, burden, tau
    q[iexp] = sed[12]+dep[12]+wet[12]+scav[12]
   endfor    
   q = q/q[0]
   for iexp = 0, nexpid-1 do begin
    x = iaer*(nexpid+2)+iexp+1
    polyfill, [x,x+1,x+1,x,x], [0,0,q[iexp],q[iexp],0], $
     color=colorarray[iexp], noclip=0
   endfor
  endfor

  plot, indgen(2), /nodata, /noerase, $
   xrange=[0,5*(nexpid+2)], xstyle=9., xthick=6, $
   yrange=[0,2], ystyle=9, ythick=6, $
   xticks=1, xtickname=[' ',' '], $
   yticks=4

  device, /close


end
