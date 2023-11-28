openr, lun, 'altitudes.txt', /get
dat = 'a'
i = 0
while(not(eof(lun))) do begin
readf, lun, dat
alts = strsplit(dat,/extract)
if(i eq 0) then begin
alt = alts
endif else begin
alt = [alt,alts]
endelse
i = i+1
endwhile

free_lun, lun

openw, lun, 'altitudes_out_thule.txt', /get
for i = 71, 0, -1 do begin
printf, lun, i, alt[i], format='(i2,4x,f6.3)'
endfor
free_lun, lun
end
