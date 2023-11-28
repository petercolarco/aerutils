; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot

; Get the lifetimes
  expid = ['bF_F25b9-base-v1.tavg2d_carma_x',$
           'bF_F25b9-base-v7.tavg2d_carma_x', $
           'bF_F25b9-base-v6.tavg2d_carma_x', $
           'bF_F25b9-base-v5.tavg2d_carma_x', $
           'b_F25b9-base-v1.tavg2d_carma_x' ] + '.sahara'

  nexpid = n_elements(expid)
  colorarray=[0,0,254,254,176,254]
  linarray  =[0,2,0,2,0,2]

  years = strcompress(string(2010 + indgen(16)),/rem)
  draft = 0 ; suppress experiment information on plot
;  draft = 1 ; show experiment information on plot

  nexp = n_elements(expid)
  ny = n_elements(years)

  set_plot, 'ps'
  device, file = './output/plots/plot_emissions.'+expid[0]+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=10, yoff=.5
  !P.font=0
  !P.multi=[0,2,1]
  loadct, 0

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Dust
  read_budget_table, expid[0],'DU', years, $
                     emis, sed, dep, wet, scav, burden, tau, rc=rc
  if(rc eq 0) then begin
   plot, [0,13], [0,250], /nodata, $
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
   plot, [0,13], [0,40], /nodata, $
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

  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75

  device, /close  

end

