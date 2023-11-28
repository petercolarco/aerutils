  restore, 'compute_reff_zonal.sav'

; Get the RGB that Kostas provides
  openr, lun, 'rgb.txt', /get
  str   = 'a'
  red   = intarr(24)
  green = intarr(24)
  blue  = intarr(24)
  for i = 0, 23 do begin
   readf, lun, str
   str_ = strsplit(str,' ',/extract)
   red[i]   = str_[1]
   green[i] = str_[2]
   blue[i]  = str_[3]
  endfor
  red   = [red,0]
  green = [green,0]
  blue  = [blue,0]
  tvlct, red, green, blue
  iblack = n_elements(red)-1
  dcolors = indgen(24)

; Now I'm only going to pick off levels with p < 100 hPa (1.e4 Pa)
; Create a simple tropopause
;  lat = findgen(ny)*2.-90.
;  pmax = 30000.-cos(lat*!pi/180.)*20000.  ; Pa
;  tdelp = fltarr(ny,nt,nf)
;  treff = fltarr(ny,nt,nf)
;  for iy = 0, ny-1 do begin
;   a = where(p[iy,*,0,0] lt pmax[iy])
;print, iy, max(a)
;   tdelp[iy,*,*] = total(reform(delp[iy,a,*,*]),1)
;   treff[iy,*,*] = total(reform(delp[iy,a,*,*]*reff[iy,a,*,*]),1)
;  endfor
;  reff = treff/tdelp


  a = where(p[0,*,0,0] lt 1.e4)  ; coordinate is pressure following strat
; Choose 30 hPa altitude (approx)
  a = 31
  suext = suext[*,a,*,*]
  reff  = reff[*,a,*,*]
  p     = p[*,a,*,*]
  delp  = delp[*,a,*,*]


; Now do simple pressure weighting
  tdelp = total(delp,2)
  treff = total(reff*delp,2)
  reff  = treff/tdelp

; And now make global mean
  reff  = total(reff,1)/91.

; And now reorder as Kostas did, by season and N-S
; based on ddflist
  a = [1,5,21,17,13,9]
  ifile = [a,a-1,a+1,a+2]
  reff = reff[*,ifile]
  xoff = [make_array(6,val=0),make_array(6,val=-3),$
          make_array(6,val=-6),make_array(6,val=-9)]/12.

; Plot
  set_plot, 'ps'
  device, file='plot_compute_reff_zonal.ps', $
    /color, /helvetica, font_size=10, xsize=10, ysize=6, xoff=.5, yoff=.5
  !p.font=0
  plot, findgen(60)/12., /nodata, $
   xrange=[0,5], xstyle=9, xtitle = 'Years after eruption', $
   yrange=[0,0.8], ystyle=9, ytitle = 'Effective radius [!Mm!Nm]', $
   title='GEOS-5: Sulfate aerosol effective radius', $
   thick=3, color=iblack
;  for i = 0, 23 do begin
  for i = 1, 23, 6 do begin
   oplot, findgen(60)/12.+xoff[i], reff[*,i]*1e6, thick=6, color=dcolors[i]
  endfor
  device, /close


end

