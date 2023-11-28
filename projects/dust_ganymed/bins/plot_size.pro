set_plot, 'ps'
device, file='plot_size.ps', /helvetica, font_size=12, /color, $
 xoff=.5, yoff=.5, xsize=24, ysize=8
!p.font=0

!p.multi=[0,5,1]
loadct, 39
for i = 0, 4 do begin
a = where(lon2 gt -50+i*10 and lon2 le -40+i*10 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,*],1)*n_elements(a)*r/dr, $
 xrange=[.1,100], xtitle='radius [um]', yrange=[1.e-5,10], ystyle=9, xstyle=9, /xlog, /ylog, thick=6
oplot, r24, total(du24[a,70,*],1)*n_elements(a)*r24/dr24, lin=2, thick=6
oplot, r, total(du[a,60,*],1)*n_elements(a)*r/dr, thick=6, color=84
oplot, r24, total(du24[a,60,*],1)*n_elements(a)*r24/dr24, color=84, lin=2, thick=6
oplot, r, total(du[a,50,*],1)*n_elements(a)*r/dr, thick=6, color=208
oplot, r24, total(du24[a,50,*],1)*n_elements(a)*r24/dr24, color=208, lin=2, thick=6
oplot, r, total(du[a,40,*],1)*n_elements(a)*r/dr, thick=6, color=254
oplot, r24, total(du24[a,40,*],1)*n_elements(a)*r24/dr24, color=254, lin=2, thick=6
endfor

device, /close
end
