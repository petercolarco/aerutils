; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot

; Get the lifetimes
  expid = ['b_F25b9-base-v1.tavg2d_carma_x',$
           'bF_F25b9-base-v1.tavg2d_carma_x', $
           'bF_F25b9-base-v6.tavg2d_carma_x', $
           'bF_F25b9-base-v5.tavg2d_carma_x', $
           'bF_F25b9-base-v8.tavg2d_carma_x', $
           'bF_F25b9-base-v10.tavg2d_carma_x' ]

  nexpid = n_elements(expid)
  colorarray=[0, 254,84,84,208,208]
  linarray  =[0, 0,  0, 2,0,2]

  years = strcompress(string(2011 + indgen(40)),/rem)
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
   plot, [0,13], [0,50], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Burden [Tg]', title='Dust'
   polymaxmin, indgen(12)+1, burden[0:11,*], fillcolor=208, lin=linarray[0], thick=6
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
                 lin=linarray[iexpid], thick=6
   endfor
  endif

; Legend hard wired
  plots, [1,2.5], 47, thick=6
  plots, [1,2.5], 44, thick=6, color=254
  plots, [7,8.5], 47, thick=6, color=84
  plots, [7,8.5], 44, thick=6, color=84, lin=2
  plots, [7,8.5], 41, thick=6, color=208
  plots, [7,8.5], 38, thick=6, color=208, lin=2
  xyouts, 2.8, 46.5, 'No Forcing', charsize=.75
  xyouts, 2.8, 43.5, 'OPAC', charsize=.75
  xyouts, 8.8, 46.5, 'Levoni', charsize=.75
  xyouts, 8.8, 43.5, 'Levoni (Ellipse)', charsize=.75
  xyouts, 8.8, 40.5, 'Colarco', charsize=.75
  xyouts, 8.8, 37.5, 'Colarco (Ellipse)', charsize=.75


; Sea salt
  loadct, 0
  read_budget_table, expid[0],'SS', years, $
                     emis, sed, dep, wet, scav, burden, tau, $
                     burden25=burden25, rc=rc
  if(rc eq 0) then begin
   plot, [0,13], [4,8], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Burden [Tg]', title='Sea Salt'
   polymaxmin, indgen(12)+1, burden[0:11,*], fillcolor=208, thick=6
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
                 lin=linarray[iexpid], thick=6
   endfor
   loadct, 0
  endif

  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75

  device, /close

end

