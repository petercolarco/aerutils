; Make a plot fo the frequency of observation of max scattering angle
; greater than threshold values
  thresh = findgen(5)*10+130

; inclinations and swath
  inc = ['gpm045','gpm050','gpm055','gpm060','gpm065']
  swt = ['50km','500km']

; Setup plotting arrays
  thresh = 130. + findgen(10)*5.
  mxt    = lonarr(5,2,10)  ; inc, swath, thresh
  freq   = fltarr(10,5,2)  ; thresh, inc, swath
  nxt    = lonarr(5,2)

  for i_ = 0, 4 do begin
   for j_ = 0, 1 do begin
    restore, inc[i_]+'.'+swt[j_]+'.sav'
    scatmxo = scatmxo[*,90] ; equator only
    a = where(finite(scatmxo) eq 1)
    nxt[i_,j_] = n_elements(a)
    for k_ = 0, 9 do begin
     a = where(scatmxo ge thresh[k_])
     if(a[0] ne -1) then mxt[i_,j_,k_] = n_elements(a)
     freq[k_,i_,j_] = mxt[i_,j_,k_]*1./nxt[i_,j_]
    endfor
   endfor
  endfor

; Plot it
  set_plot, 'ps'
  device, file='max_freq.ps', /color, /helvetica, font_size=12
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[129,171], xtitle='!4Scattering Angle!3', $
   xticks=8, xminor=1, xtickv=130+findgen(9)*5, $
   yrange=[0,1], ytitle='!4Frequency of Observation!3', $
   yticks=5, yminor=2

  oplot, [155,155], [.02,.98], thick=24, color=180
  xyouts, 161.5, .92, /data, "!4 Inclination!3"
  plots, [132,135], .12, thick=6
  plots, [132,135], .17, thick=6, lin=2
  xyouts, 136, .11, /data, '!457!Eo!N swath width'
  xyouts, 136, .16, /data, '!47!Eo!N swath width'


  loadct, 38
  oplot, thresh[0:8], freq[0:8,0,0], color=48, lin=2, thick=6
  oplot, thresh[0:8], freq[0:8,0,1], color=48, lin=0, thick=6
  oplot, thresh[0:8], freq[0:8,1,0], color=84, lin=2, thick=6
  oplot, thresh[0:8], freq[0:8,1,1], color=84, lin=0, thick=6
  oplot, thresh[0:8], freq[0:8,2,0], color=16, lin=2, thick=6
  oplot, thresh[0:8], freq[0:8,2,1], color=16, lin=0, thick=6
  oplot, thresh[0:8], freq[0:8,3,0], color=208, lin=2, thick=6
  oplot, thresh[0:8], freq[0:8,3,1], color=208, lin=0, thick=6
  oplot, thresh[0:8], freq[0:8,4,0], color=0, lin=2, thick=6
  oplot, thresh[0:8], freq[0:8,4,1], color=0, lin=0, thick=6

  xyouts, 162, .87, /data, "45!Eo!N", color=48
  xyouts, 162, .82, /data, "50!Eo!N", color=84
  xyouts, 162, .77, /data, "55!Eo!N", color=16
  xyouts, 162, .72, /data, "60!Eo!N", color=208
  xyouts, 162, .67, /data, "65!Eo!N", color=0

  device, /close

end
