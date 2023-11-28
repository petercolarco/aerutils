; Colarco, October 2006
; Plot lifetime statistics from model run wit tables already generated
; from "generate_lifetime.pro"

; Get the lifetimes
  expid = 'ftst'
  years = ['2000']
  read_lifetime, expid, years, date, var, tau, ksca, kwet, ksed, kdry

  arr = size(tau)
  ny = 1
  if(arr[0] eq 3) then ny = arr[3]

  nvar = n_elements(var)

  set_plot, 'ps'
  device, file = './output/plots/plot_lifetime.'+expid+'.ps', /color, /helvetica, $
   font_size=12, xsize=10, xoff=.5, ysize=10, yoff=.5
  !P.font=0

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

  loadct, 39
  plot, [0,13], [0,15], /nodata, $
   thick=4, xstyle=9, ystyle=9, color=0, $
   position=[.2,.2,.96,.9], $
   xticks=13, xtickname=xtickname, $
   xtitle = 'Month', ytitle='Lifetime [days]'


  for ivar = 0, nvar-1 do begin
   case strupcase(var[ivar]) of
    'DU': color=208
    'SS': color=60
    'BC': color=0
    'OC': color=254
    'SU': color=176
   endcase
   oplot, indgen(12)+1, tau[*,ivar], thick=6, color=color
  endfor

  if(ny gt 1) then begin
   for ivar = 0, nvar-1 do begin
    case strupcase(var[ivar]) of
     'DU': color=208
     'SS': color=60
     'BC': color=0
     'OC': color=254
     'SU': color=176
    endcase
    oplot, indgen(12)+1, total(tau[*,ivar,*],3)/ny, thick=6, color=color, lin=2
   endfor
  endif

;  loadct, 0
;  plots, [1,3], .95*12., thick=6, color=120
;  xyouts, 3.4, .935*12., years[0], charsize=.75
;  if(ny gt 1) then begin
;   plots, [1,3], .91*12., thick=6, color=120, lin=2
;   xyouts, 3.4, .895*12., min(years)+'-'+max(years), charsize=.75
;  endif



  loadct, 39
  plot, [0,13], [0,0.5], /nodata, $
   thick=4, xstyle=9, ystyle=9, color=0, $
   position=[.16,.2,.96,.9], $
   xticks=13, xtickname=xtickname, $
   xtitle = 'Month', ytitle='Loss Rate [1/days]'

  oplot, indgen(12)+1, ksed[*,0]+kdry[*,0], thick=6, color=208
  oplot, indgen(12)+1, kwet[*,0]+ksca[*,0], thick=6, color=84

  if(ny gt 1) then begin
   oplot, indgen(12)+1, total(kdry[*,0,*]+ksed[*,0,*],3)/ny, thick=6, color=208, lin=2
   oplot, indgen(12)+1, total(kwet[*,0,*]+ksca[*,0,*],3)/ny, thick=6, color=84, lin=2
  endif


  loadct, 0
  plots, [1,3], .95*.5, thick=6, color=120
  xyouts, 3.4, .935*.5, years[0], charsize=.75
  if(ny gt 1) then begin
   plots, [1,3], .91*.5, thick=6, color=120, lin=2
   xyouts, 3.4, .895*.5, min(years)+'-'+max(years), charsize=.75
  endif


  device, /close

  species = ['du','su','ss','bc','oc']

  for i = 0, 4 do begin
   print, ''
   print, species[i]
   print, mean(tau[*,i]), mean(tau[*,i,*])
   print, mean(ksca[*,i]+kwet[*,i]), mean(ksca[*,i,*]+kwet[*,i,*])
   print, mean(kdry[*,i]+ksed[*,i]), mean(kdry[*,i,*]+ksed[*,i,*])
  endfor

end

