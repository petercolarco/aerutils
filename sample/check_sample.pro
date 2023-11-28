  nymd0 = '20090601'
  nymd1 = '20090831'
  dateexpand, nymd0, nymd1, '000000', '000000', nymd, nhms, /daily

; pick a point
; c
;  ix = 120  ; 30 W
;  iy = 100  ; 10 N
; b
;  ix = 60
;  iy = 50
; a
  ix = 30
  iy = 25

  ntemplate = 5
  nt = n_elements(nymd)
  nbin = 11

  aot = fltarr(ntemplate,nt)
  std = fltarr(ntemplate,nt)
  num = fltarr(ntemplate,nt)
  minval = fltarr(ntemplate,nt)
  maxval = fltarr(ntemplate,nt)
  aotpdf = fltarr(ntemplate,nt,nbin)


  filetemplate =    '/misc/prc10/MODIS/Level3/MOD04/a/GRITAS/Y%y4/M%m2' $
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
   aot[itemplate,it] = aot_[ix,iy]
   std[itemplate,it] = std_[ix,iy]
   num[itemplate,it] = num_[ix,iy]
   minval[itemplate,it] = minval_[ix,iy]
   maxval[itemplate,it] = maxval_[ix,iy]
   aotpdf[itemplate,it,*] = aotpdf_[ix,iy,*]

   print, filename
  endfor

  endfor

  set_plot, 'ps'
  device, file='sample.a.ps', /helvetica, font_size=12, $
   xsize=16, ysize=20, /color, xoff=.5, yoff=.5
  !P.font=0
  !P.multi=[0,2,5]

  ntimes = [1,9,19,29,39,49,59,69,79,89]

  for it = 0, n_elements(ntimes)-1 do begin

  aveper = string(ntimes[it]+1)
  n = ntimes[it]

  aot_ = mean(aot[*,0:n],dimension=2,/nan)
  std_ = mean(std[*,0:n],dimension=2,/nan)
  min_ = mean(minval[*,0:n],dimension=2,/nan)
  max_ = mean(maxval[*,0:n],dimension=2,/nan)
  num_ = total(num[*,0:n],2,/nan)
  aotpdf_ = total(aotpdf[*,0:n,*],2,/nan)
  loadct, 39
  plot, aotpdf_[0,*]/num_[0], thick=3, yrange=[0,1], $
   ytitle = 'power', xtitle='aotbin', title=aveper+' days averaging'
  oplot, aotpdf_[1,*]/num_[1], thick=3, color=254
  oplot, aotpdf_[2,*]/num_[2], thick=3, color=254, lin=2
  oplot, aotpdf_[3,*]/num_[3], thick=3, color=80
  oplot, aotpdf_[4,*]/num_[4], thick=3, color=80, lin=2

  str = string(aot_[0],format='(f5.3)')+$
   ' ('+string(std_[0],format='(f5.3)')+$
   ', '+string(num_[0],format='(i6)')+')'
  xyouts, 5, .95, 'MODIS '+str, align=0, charsize=.4
  str = string(aot_[1],format='(f5.3)')+$
   ' ('+string(std_[1],format='(f5.3)')+$
   ', '+string(num_[1],format='(i6)')+')'
  xyouts, 5, .90, 'CALIOP1 '+str, align=0, color=254, charsize=.4
  str = string(aot_[2],format='(f5.3)')+$
   ' ('+string(std_[2],format='(f5.3)')+$
   ', '+string(num_[2],format='(i6)')+')'
  xyouts, 5, .85, 'CALIOP2 (dashed) '+str, align=0, color=254, charsize=.4
  str = string(aot_[3],format='(f5.3)')+$
   ' ('+string(std_[3],format='(f5.3)')+$
   ', '+string(num_[3],format='(i6)')+')'
  xyouts, 5, .80, 'MISR1 '+str, align=0, color=80, charsize=.4
  str = string(aot_[4],format='(f5.3)')+$
   ' ('+string(std_[4],format='(f5.3)')+$
   ', '+string(num_[4],format='(i6)')+')'
  xyouts, 5, .75, 'MISR2 (dashed) '+str, align=0, color=80, charsize=.4

endfor

device, /close

end
