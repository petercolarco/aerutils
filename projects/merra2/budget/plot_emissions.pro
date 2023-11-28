; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot

; Get the lifetimes
  expid = ['merra2.d5124_m2_jan79.tavg1_2d_aer_Nx']
;  expid = ['bR_arctas.tavg2d_aer_x']

  nexpid = n_elements(expid)
  colorarray=[0,176,254,0,176,254]
  linarray  =[0,0,0,2,2,2]

  years = strcompress(string(2000 + indgen(15)),/rem)
  draft = 0 ; suppress experiment information on plot
;  draft = 1 ; show experiment information on plot

  nexp = n_elements(expid)
  ny = n_elements(years)

  set_plot, 'ps'
  device, file = './output/plots/plot_emissions.'+expid[0]+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=20, yoff=.5
  !P.font=0
  !P.multi=[0,2,2]
  loadct, 0

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Dust
  read_budget_table, expid[0],'DU', years, $
                     emis, sed, dep, wet, scav, burden, tau, rc=rc
  if(rc eq 0) then begin
   plot, [0,13], [50,200], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Emissions [Tg mon!E-1!N]', title='Dust'
   polymaxmin, indgen(12)+1, emis[0:11,*], color=0, fillcolor=208, lin=linarray[0], thick=12
;   oplot, indgen(12)+1, emis[0:11,0], thick=6
  endif
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    read_budget_table, expid[iexpid],'DU', years, $
                       emis, sed, dep, wet, scav, burden, tau, rc=rc
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, emis[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=12
   endfor
   loadct, 0
  endif
   


; Sea Salt
  read_budget_table, expid[0],'SS', years, $
                     emis, sed, dep, wet, scav, burden, tau, rc=rc
  if(rc eq 0) then begin
   plot, [0,13], [600,1000], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Emissions [Tg mon!E-1!N]', title='Sea Salt'
   polymaxmin, indgen(12)+1, emis[0:11,*], color=0, fillcolor=208, lin=linarray[0], thick=12
;   oplot, indgen(12)+1, emis[0:11,0], thick=6
  endif
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    read_budget_table, expid[iexpid],'SS', years, $
                       emis, sed, dep, wet, scav, burden, tau, rc=rc
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, emis[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=12
   endfor
   loadct, 0
  endif


; Sulfate
  read_budget_table, expid[0], 'SU', years, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                     pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms, rc=rc

  if(rc eq 0) then begin
   emis = (emis + pso4g+pso4liq)/3.   ; SO4 -> S
   plot, [0,13], [3,7], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Emissions [Tg S mon!E-1!N]', title='Sulfate'

   polymaxmin, indgen(12)+1, emis[0:11,*], color=0, fillcolor=208, lin=linarray[0], thick=12
;   oplot, indgen(12)+1, emis[0:11,0], thick=6
   oplot, indgen(12)+1, total(pso4g+pso4liq,2)/ny/3., thick=6, lin=2
   plots, [1,3], 6.5, thick=6, lin=2
   xyouts, 3.35, 6.45, 'Chemical Production', charsize=.75
  endif
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    read_budget_table, expid[iexpid],'SU', years, $
                       emis, sed, dep, wet, scav, burden, tau, $
                       emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                       pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms, rc=rc
    if(rc eq 0) then begin
     emis = (emis + pso4g+pso4liq)/3.   ; SO4 -> S
     polymaxmin, indgen(12)+1, emis[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=12
     oplot, indgen(12)+1, total(pso4g+pso4liq,2)/ny/3., thick=6, lin=2, color=colorarray[iexpid]
    endif
   endfor
   loadct, 0
  endif




; Carbon
  read_budget_table, expid[0], 'POM', years, $
                     emisoc, sed, dep, wet, scav, burden, tau, $
                     embb=emisbboc, rc=rcpom

  read_budget_table, expid[0], 'BC', years, $
                     emisbc, sed, dep, wet, scav, burden, tau, $
                     embb=emisbbbc, rc=rcbc

  if(rcpom eq 0 and rcbc eq 0) then begin
   plot, [0,13], [0,20], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Emissions [Tg mon!E-1!N]', title='Carbon'
   polymaxmin, indgen(12)+1, emisbc[0:11,*]+emisoc[0:11,*], color=0, fillcolor=208, thick=12
;   oplot, indgen(12)+1, emisbc[0:11,0]+emisoc[0:11,0], thick=6
;   polymaxmin, indgen(12)+1, emisbbbc[0:11,*]+emisbboc[0:11,*], color=120, fillcolor=120, thick=12
   polymaxmin, indgen(12)+1, emisbc[0:11,*]+emisoc[0:11,*] $
                           -(emisbbbc[0:11,*]+emisbboc[0:11,*]), $
                            color=120, fillcolor=120, thick=12
;   oplot, indgen(12)+1, total(  emisbc[0:11,*]+emisoc[0:11,*] $
;                              -(emisbbbc[0:11,*]+emisbboc[0:11,*]),2)/ny, thick=12, lin=2
   plots, [1,3], .90*20, thick=6
   plots, [1,3], .85*20, thick=6, color=120
;   plots, [1,3], .80*20, lin=2, thick=6
   xyouts, 3.35, (1.77/2.)*20, 'Total', charsize=.75
   xyouts, 3.35, (1.67/2.)*20, 'Anthropogenic+Biofuel+Biogenic', charsize=.75
;   xyouts, 3.35, (1.57/2.)*20, 'Biomass Burning', charsize=.75
  endif


  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75

  device, /close  

end

