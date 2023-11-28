  lon0 = [-75,-15,-30]
  lon1 = [-45,35,-15]
  lat0 = [-20,-20,10]
  lat1 = [0,0,30]

  yyyy = '2010'
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']

  reg = fltarr(12,3,2,5)

  samples = [' ','misr1', 'misr2', 'misr3', 'misr4']

  for isam = 0, 4 do begin

   for im = 0, 11 do begin

    if(isam eq 0) then begin
     read_monthly, 'MYD04', samples[isam], yyyy, mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot
     reg[im,*,0,isam] = reg_aot
     reg[im,*,1,isam] = reg_aot
    endif else begin
     read_monthly, 'MYD04', samples[isam], yyyy, mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude
     reg[im,*,0,isam] = reg_aot
     read_monthly, 'MYD04', samples[isam], yyyy, mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude, /inverse
     reg[im,*,1,isam] = reg_aot
    endelse

   endfor

  endfor

; Plot for the first region (S. Am.)
  loadct, 39
  window, 0
  plot, reg[*,0,0,0], thick=3
; Exclude
  oplot, reg[*,0,0,1], thick=3, color=84
  oplot, reg[*,0,0,2], thick=3, color=84, lin=2
  oplot, reg[*,0,0,3], thick=3, color=84, lin=1
  oplot, reg[*,0,0,4], thick=3, color=84, lin=3
; Inverse
  oplot, reg[*,0,1,1], thick=3, color=254
  oplot, reg[*,0,1,2], thick=3, color=254, lin=2
  oplot, reg[*,0,1,3], thick=3, color=254, lin=1
  oplot, reg[*,0,1,4], thick=3, color=254, lin=3


; Plot for the second region (S. Afr.)
  loadct, 39
  window, 1
  plot, reg[*,1,0,0], thick=3
; Exclude
  oplot, reg[*,1,0,1], thick=3, color=84
  oplot, reg[*,1,0,2], thick=3, color=84, lin=2
  oplot, reg[*,1,0,3], thick=3, color=84, lin=1
  oplot, reg[*,1,0,4], thick=3, color=84, lin=3
; Inverse
  oplot, reg[*,1,1,1], thick=3, color=254
  oplot, reg[*,1,1,2], thick=3, color=254, lin=2
  oplot, reg[*,1,1,3], thick=3, color=254, lin=1
  oplot, reg[*,1,1,4], thick=3, color=254, lin=3


; Plot for the third region (N. Afr.)
  loadct, 39
  window, 2
  plot, reg[*,2,0,0], thick=3
; Exclude
  oplot, reg[*,2,0,1], thick=3, color=84
  oplot, reg[*,2,0,2], thick=3, color=84, lin=2
  oplot, reg[*,2,0,3], thick=3, color=84, lin=1
  oplot, reg[*,2,0,4], thick=3, color=84, lin=3
; Inverse
  oplot, reg[*,2,1,1], thick=3, color=254
  oplot, reg[*,2,1,2], thick=3, color=254, lin=2
  oplot, reg[*,2,1,3], thick=3, color=254, lin=1
  oplot, reg[*,2,1,4], thick=3, color=254, lin=3

end
