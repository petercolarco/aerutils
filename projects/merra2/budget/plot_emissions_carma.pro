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
           'bF_F25b9-base-v10.tavg2d_carma_x', $
           'bF_F25b9-base-v11.tavg2d_carma_x' ]

  nexpid = n_elements(expid)
  colorarray=[0, 254,84,84,208,208,254]
  linarray  =[0, 0,  0, 2,0,2,2]

  years = strcompress(string(2011 + indgen(40)),/rem)
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
  print, expid[0]
  for iy = 0, ny-1 do begin
   print, years[iy], emis[0:11,iy], format='(i4,12(2x,i4))'
  endfor

  if(rc eq 0) then begin
   plot, [0,13], [0,400], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Emissions [Tg mon!E-1!N]', title='Dust'
   polymaxmin, indgen(12)+1, emis[0:11,*], color=0, fillcolor=208, lin=linarray[0], thick=6
;   oplot, indgen(12)+1, emis[0:11,0], thick=6
  endif
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    read_budget_table, expid[iexpid],'DU', years, $
                       emis, sed, dep, wet, scav, burden, tau, rc=rc
    print, expid[iexpid]
    for iy = 0, ny-1 do begin
     print, years[iy], emis[0:11,iy], format='(i4,12(2x,i4))'
    endfor
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, emis[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=6
   endfor
  endif
   
; Legend hard wired
  plots, [1,2.5], 375, thick=6
  plots, [1,2.5], 350, thick=6, color=254
  plots, [7,8.5], 375, thick=6, color=84
  plots, [7,8.5], 350, thick=6, color=84, lin=2
  plots, [7,8.5], 325, thick=6, color=208
  plots, [7,8.5], 300, thick=6, color=208, lin=2
  xyouts, 2.8, 370, 'No Forcing', charsize=.75
  xyouts, 2.8, 345, 'OPAC', charsize=.75
  xyouts, 8.8, 370, 'Levoni', charsize=.75
  xyouts, 8.8, 345, 'Levoni (Ellipse)', charsize=.75
  xyouts, 8.8, 320, 'Colarco', charsize=.75
  xyouts, 8.8, 295, 'Colarco (Spheroid)', charsize=.75

; Sea Salt
  loadct, 0
  read_budget_table, expid[0],'SS', years, $
                     emis, sed, dep, wet, scav, burden, tau, rc=rc
  if(rc eq 0) then begin
   plot, [0,13], [350,650], /nodata, $
    thick=4, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Emissions [Tg mon!E-1!N]', title='Sea Salt'
   polymaxmin, indgen(12)+1, emis[0:11,*], color=0, fillcolor=208, lin=linarray[0], thick=6
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
                 lin=linarray[iexpid], thick=6
   endfor
   loadct, 0
  endif

  if(draft) then xyouts, .02, .01, expid, /normal, charsize=.75

  device, /close  

end

