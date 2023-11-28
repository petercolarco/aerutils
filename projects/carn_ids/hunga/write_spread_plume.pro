lon0 = -175.380
lat0 = -20.570
mag0 = 631.

npts = 25

; Jan 13
for i = -2,2 do begin
 for j = -2,2 do begin
  print, lat0+i*0.5, lon0+j*0.5, mag0/npts, 150, 20000, 150000, 240000, $
         format='(f7.3,1x,f8.3,1x,e9.3,1x,i3,1x,i5,1x,i06,1x,i06)'
 endfor
endfor

print, ' '
; Jan 14
for i = -2,2 do begin
 for j = -2,2 do begin
  print, lat0+i*0.5, lon0+j*0.5, mag0/npts, 150, 20000, 000000, 020000, $
         format='(f7.3,1x,f8.3,1x,e9.3,1x,i3,1x,i5,1x,i06,1x,i06)'
 endfor
endfor

print, ' '
; Jan 15
mag0 = 8101.
for i = -2,2 do begin
 for j = -2,2 do begin
  print, lat0+i*0.5, lon0+j*0.5, mag0/npts, 150, 30000, 040000, 100000, $
         format='(f7.3,1x,f8.3,1x,e9.3,1x,i3,1x,i5,1x,i06,1x,i06)'
 endfor
endfor

end
