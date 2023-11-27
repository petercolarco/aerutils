; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot

; Get the lifetimes
  expid = ['b_F25b9-base-v1.tavg2d_carma_x']
  nexpid = n_elements(expid)
;  colorarray=[0,0,176,254,0,176,254]
;  linarray  =[0,2,0,0,2,2,2]
  colorarray=[0,0,254,84,84,254]
  linarray  =[0,2,0,0,2,2]

  years = strcompress(string(2010 + indgen(16)),/rem)
  draft = 0 ; suppress experiment information on plot
;  draft = 1 ; show experiment information on plot

  nexp = n_elements(expid)
  ny = n_elements(years)

  set_plot, 'ps'
  device, file = './output/plots/plot_burden.'+expid[0]+'.ps', /color, /helvetica, $
   font_size=12, xsize=20, xoff=.5, ysize=10, yoff=.5
  !P.font=0
  !P.multi=[0,2,1]

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Dust
  read_budget_table, expid[0],'DU', years, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     burden25=burden25, rc=rc
  loadct, 0
  if(rc eq 0) then begin
   plot, [0,13], [10,40], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Burden [Tg]', title='Dust'
   polymaxmin, indgen(12)+1, burden[0:11,*], fillcolor=208, lin=linarray[0], thick=12
;   oplot, indgen(12)+1, burden[0:11,0], thick=6
;   polymaxmin, indgen(12)+1, burden25[0:11,*], fillcolor=120
;   oplot, indgen(12)+1, burden25[0:11,0], thick=6
  endif
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    read_budget_table, expid[iexpid],'DU', years, $
                       emis, sed, dep, wet, scav, burden, tau, rc=rc
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, burden[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=12
   endfor
   plots, [1,3], .9*80, thick=6
   plots, [1,3], .85*80, lin=2, thick=6
   plots, [1,3], .8*80, thick=6, color=254
   plots, [1,3], .75*80, thick=6, color=84
   plots, [1,3], .7*80, lin=2, thick=6, color=84
   xyouts, 3.35, .885*80, 'R_gocart', charsize=.75
   xyouts, 3.35, .835*80, 'R_gocart_u10n', charsize=.75
   xyouts, 3.35, .785*80, 'R_qfed21_2_3', charsize=.75
   xyouts, 3.35, .735*80, 'F_control_p2-m16', charsize=.75
   xyouts, 3.35, .685*80, 'Fp_control', charsize=.75
   loadct, 0
  endif

; Sea salt
  read_budget_table, expid[0],'SS', years, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     burden25=burden25, rc=rc
  if(rc eq 0) then begin
   plot, [0,13], [4,8], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Burden [Tg]', title='Sea Salt'
   polymaxmin, indgen(12)+1, burden[0:11,*], fillcolor=208, thick=12
;   oplot, indgen(12)+1, burden[0:11,0], thick=6
;   polymaxmin, indgen(12)+1, burden25[0:11,*], fillcolor=120
;   oplot, indgen(12)+1, burden25[0:11,0], thick=6
  endif
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    read_budget_table, expid[iexpid],'SS', years, $
                       emis, sed, dep, wet, scav, burden, tau, rc=rc
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, burden[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=12
   endfor
   loadct, 0
  endif

  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75

  device, /close

end

