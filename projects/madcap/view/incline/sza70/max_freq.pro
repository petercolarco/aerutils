; Make a plot fo the frequency of observation of max scattering angle
; greater than threshold values
  thresh = findgen(5)*10+130

; inclinations and swath
  inc = ['gpm045','gpm050','gpm055','gpm060','gpm']
  swt = ['50km','500km']

  freq = fltarr(5,5,2)

  for i = 1,1 do begin
   for j = 0, 1 do begin
    openr, lun, inc[i]+'.'+swt[j]+'.scat.max_freq.txt', /get
    inp = fltarr(5)
    readf, lun, inp
    freq[*,i,j] = inp
    free_lun, lun
   endfor
  endfor

; Plot it
  set_plot, 'ps'
  device, file='max_freq.ps', /color, /helvetica, font_size=12
  !p.font=0

  plot, indgen(10), /nodata, $
   xrange=[130,170], xtitle='Scattering Angle', $
   yrange=[0,1], ytitle='Frequency'

  loadct, 39
  oplot, thresh, freq[*,1,0], color=84, lin=1, thick=12
  oplot, thresh, freq[*,1,1], color=84, lin=0, thick=12

  device, /close

end
