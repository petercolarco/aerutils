  nymd0 = '20091001'
  nymd1 = '20091230'
  dateexpand, nymd0, nymd1, '000000', '000000', nymd, nhms, /daily

; pick a point
; 10 degree
;  xx = findgen(8)-4+120   ; centered at 30 W
;  yy = findgen(10)-5+100  ; centered at 10 N
; 2deg
;  xx = findgen(2)-1+120   ; centered at 30 W
;  yy = findgen(2)-1+100  ; centered at 10 N
; 5deg
  xx = findgen(3)-1+30   ; centered at 30 W
  yy = findgen(3)-1+25  ; centered at 10 N
; 10deg
  xx = 15
  yy = 10

  ntemplate = 5
  nt = n_elements(nymd)
  nbin = 11

  aot = fltarr(ntemplate,nt)
  std = fltarr(ntemplate,nt)
  num = fltarr(ntemplate,nt)
  minval = fltarr(ntemplate,nt)
  maxval = fltarr(ntemplate,nt)
  aotpdf = fltarr(ntemplate,nt,nbin)

  filetemplate =    '/Users/colarco/data/MODIS/Level3/MOD04/ten/GRITAS/Y%y4/M%m2' $
                 + ['/MOD04_L2_ocn.aero_tc8_051.qast.%y4%m2%d2.nc4', $
                    '/MOD04_L2_ocn.caliop1.aero_tc8_051.qast.%y4%m2%d2.nc4', $
                    '/MOD04_L2_ocn.caliop2.aero_tc8_051.qast.%y4%m2%d2.nc4', $
                    '/MOD04_L2_ocn.misr1.aero_tc8_051.qast.%y4%m2%d2.nc4', $
                    '/MOD04_L2_ocn.misr2.aero_tc8_051.qast.%y4%m2%d2.nc4' ]

  for itemplate = 0, ntemplate-1 do begin

  for it = 0, n_elements(nymd)-1 do begin
   filename = strtemplate(filetemplate[itemplate], nymd[it], nhms[it])
   read_sample, filename, nbin, lon, lat, $
                aot_, aotpdf_, num_, std_, minval_, maxval_

   if(it eq 0) then begin
    nx=n_elements(lon)
    ny=n_elements(lat)
    lon_ = fltarr(nx,ny)
    for iy = 0, ny-1 do begin
     lon_[*,iy] = lon
    endfor
    lat_ = fltarr(nx,ny)
    for ix = 0, nx-1 do begin
     lat_[ix,*] = lat
    endfor
    a = where(lon_ ge min(lon[xx]) and lon_ le max(lon[xx]) and $
              lat_ ge min(lat[yy]) and lat_ le max(lat[yy]))
   endif

   aot[itemplate,it] = mean(aot_[a],/nan)
;print, filename, aot_[a], aot[itemplate,it]
   std[itemplate,it] = mean(std_[a],/nan)
   num[itemplate,it] = total(num_[a],/nan)
   minval[itemplate,it] = mean(minval_[a],/nan)
   maxval[itemplate,it] = mean(maxval_[a],/nan)
   aotpdf_ = reform(aotpdf_,nx*ny,nbin)
   aotpdf[itemplate,it,*] = total(aotpdf_[a,*],1,/nan)

   print, filename
  endfor

  endfor

  set_plot, 'ps'
  device, file='sample_region_tendeg.ps', /helvetica, font_size=12, $
   xsize=16, ysize=20, /color, xoff=.5, yoff=.5
  !P.font=0
  !P.multi=[0,2,5]

  ntimes = [1,9,19,29,39,49,59,69,79,89]
  ntimes = [2,10,20,30,40,50,60,70,80,90]

aotnt = fltarr(ntemplate,nt)
stdnt = fltarr(ntemplate,nt)
aotnt[*,0] = !values.f_nan

  for n = 1, nt-1 do begin

  aveper = string(n+1)

  aot_ = mean(aot[*,0:n],dimension=2,/nan)
  std_ = mean(std[*,0:n],dimension=2,/nan)
  aotnt[*,n] = aot_
  stdnt[*,n] = std_
  min_ = mean(minval[*,0:n],dimension=2,/nan)
  max_ = mean(maxval[*,0:n],dimension=2,/nan)
  num_ = total(num[*,0:n],2,/nan)
  aotpdf_ = total(aotpdf[*,0:n,*],2,/nan)
  i = where(aveper eq ntimes)
  if(i[0] ne -1) then begin
   loadct, 39
   plot, findgen(11)*.1+.05, aotpdf_[0,*]/num_[0], thick=3, yrange=[0,1.5], $
    ytitle = 'power', xtitle='AOT', title=aveper+' days averaging'
   oplot, findgen(11)*.1+.05, aotpdf_[1,*]/num_[1], thick=3, color=254
   oplot, findgen(11)*.1+.05, aotpdf_[2,*]/num_[2], thick=3, color=254, lin=2
   oplot, findgen(11)*.1+.05, aotpdf_[3,*]/num_[3], thick=3, color=80
   oplot, findgen(11)*.1+.05, aotpdf_[4,*]/num_[4], thick=3, color=80, lin=2

   str = string(aot_[0],format='(f5.3)')+$
    ' ('+string(std_[0],format='(f5.3)')+$
    ', '+string(num_[0],format='(i6)')+')'
   xyouts, 0.05, 1.4-.01, 'MODIS '+str, align=0, charsize=.6

   x = aotpdf_[0,*]/num_[0]
   y = aotpdf_[1,*]/num_[1]
   statistics, x, y, xm, ym, xs, ys, r, b, rms, sk, linslope, linoffset  
   str = string(aot_[1],format='(f5.3)')+$
    ' ('+string(std_[1],format='(f5.3)')+$
    ', '+string(num_[1],format='(i6)')  +$
    ', '+string(r*r, format='(f6.3)')     +$
    ', '+string(sk, format='(f5.3)')+')'
   xyouts, 0.05, 1.3-.02, 'CALIOP1 '+str, align=0, color=254, charsize=.6

   x = aotpdf_[0,*]/num_[0]
   y = aotpdf_[2,*]/num_[2]
   statistics, x, y, xm, ym, xs, ys, r, b, rms, sk, linslope, linoffset  
   str = string(aot_[2],format='(f5.3)')+$
    ' ('+string(std_[2],format='(f5.3)')+$
    ', '+string(num_[2],format='(i6)')  +$
    ', '+string(r*r, format='(f6.3)')     +$
    ', '+string(sk, format='(f5.3)')+')'
   xyouts, 0.05, 1.2-.03, 'CALIOP2 (dashed) '+str, align=0, color=254, charsize=.6

   x = aotpdf_[0,*]/num_[0]
   y = aotpdf_[3,*]/num_[3]
   statistics, x, y, xm, ym, xs, ys, r, b, rms, sk, linslope, linoffset  
   str = string(aot_[3],format='(f5.3)')+$
    ' ('+string(std_[3],format='(f5.3)')+$
    ', '+string(num_[3],format='(i6)')  +$
    ', '+string(r*r, format='(f6.3)')     +$
    ', '+string(sk, format='(f5.3)')+')'
   xyouts, 0.05, 1.1-.04, 'MISR1 '+str, align=0, color=80, charsize=.6

   x = aotpdf_[0,*]/num_[0]
   y = aotpdf_[4,*]/num_[4]
   statistics, x, y, xm, ym, xs, ys, r, b, rms, sk, linslope, linoffset  
   str = string(aot_[4],format='(f5.3)')+$
    ' ('+string(std_[4],format='(f5.3)')+$
    ', '+string(num_[4],format='(i6)')  +$
    ', '+string(r*r, format='(f6.3)')     +$
    ', '+string(sk, format='(f5.3)')+')'
   xyouts, 0.05, 1.-.05, 'MISR2 (dashed) '+str, align=0, color=80, charsize=.6

  endif

endfor

aotdiff = fltarr(ntemplate,nt)
for i = 0, ntemplate-1 do begin & aotdiff[i,*] = abs(aotnt[i,*]-aotnt[0,*]) & endfor

ymax = fix(max(aotdiff,/nan)*100+1)/100.

!P.multi=[0,1,2]
plot, indgen(nt)+1, indgen(nt)+1, /nodata, thick=2, $
xtitle='days averaging', ytitle='abs(full_swath - sampled_swath)', $
xrange=[0,90], yrange=[0,ymax], xstyle=9, ystyle=9

oplot, indgen(nt)+1, aotdiff[1,*], thick=6, color=254
oplot, indgen(nt)+1, aotdiff[2,*], thick=6, color=254, lin=2
oplot, indgen(nt)+1, aotdiff[3,*], thick=6, color=80
oplot, indgen(nt)+1, aotdiff[4,*], thick=6, color=80, lin=2
oplot, indgen(nt)+1, make_array(n_elements(nt),val=0.02), thick=6


device, /close

end
