; Do this by month
  nday = [31,28,31,30,31,30,31,31,30,31,30,31]
  mon  = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']

; save the monthly mean values
  med = fltarr(17,12)
  men = fltarr(17,12)

  for it = 0, 11 do begin

  if(it eq 0) then begin
   nt0 = 0
   nt1 = nday[it]-1
  endif else begin
   nt0 = nt1+1
   nt1 = nt0+nday[it]-1
  endelse

  get_stat, 'full.ddf', res0, nt0=nt0, nt1=nt1
  get_stat, 'full.ddf', res1, wantlat=[-65,65], nt0=nt0, nt1=nt1
  get_stat, 'c1440_NR.gpm.nodrag.nadir.ddf', res_gpm_0, nt0=nt0, nt1=nt1
  get_stat, 'c1440_NR.gpm.nodrag.100km.ddf', res_gpm_1, nt0=nt0, nt1=nt1
  get_stat, 'c1440_NR.gpm.nodrag.300km.ddf', res_gpm_2, nt0=nt0, nt1=nt1
  get_stat, 'c1440_NR.gpm.nodrag.500km.ddf', res_gpm_3, nt0=nt0, nt1=nt1
  get_stat, 'c1440_NR.gpm.nodrag.1000km.ddf', res_gpm_4, nt0=nt0, nt1=nt1
  get_stat, 'c1440_NR.sunsynch_450km_1330crossing.nodrag.nadir.ddf', res_sun_0, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.sunsynch_450km_1330crossing.nodrag.100km.ddf', res_sun_1, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.sunsynch_450km_1330crossing.nodrag.300km.ddf', res_sun_2, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.sunsynch_450km_1330crossing.nodrag.500km.ddf', res_sun_3, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.sunsynch_450km_1330crossing.nodrag.1000km.ddf', res_sun_4, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.dual450km.nadir.ddf', res_dual_0, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.dual450km.100km.ddf', res_dual_1, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.dual450km.300km.ddf', res_dual_2, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.dual450km.500km.ddf', res_dual_3, nt0=nt0, nt1=nt1, wantlat=[-65,65]
  get_stat, 'c1440_NR.dual450km.1000km.ddf', res_dual_4, nt0=nt0, nt1=nt1, wantlat=[-65,65]

  med[0,it] = res0[2]
  med[1,it] = res1[2]
  med[2,it] = res_gpm_0[2]
  med[3,it] = res_gpm_1[2]
  med[4,it] = res_gpm_2[2]
  med[5,it] = res_gpm_3[2]
  med[6,it] = res_gpm_4[2]
  med[7,it] = res_sun_0[2]
  med[8,it] = res_sun_1[2]
  med[9,it] = res_sun_2[2]
  med[10,it] = res_sun_3[2]
  med[11,it] = res_sun_4[2]
  med[12,it] = res_dual_0[2]
  med[13,it] = res_dual_1[2]
  med[14,it] = res_dual_2[2]
  med[15,it] = res_dual_3[2]
  med[16,it] = res_dual_4[2]

  men[0,it] = res0[5]
  men[1,it] = res1[5]
  men[2,it] = res_gpm_0[5]
  men[3,it] = res_gpm_1[5]
  men[4,it] = res_gpm_2[5]
  men[5,it] = res_gpm_3[5]
  men[6,it] = res_gpm_4[5]
  men[7,it] = res_sun_0[5]
  men[8,it] = res_sun_1[5]
  men[9,it] = res_sun_2[5]
  men[10,it] = res_sun_3[5]
  men[11,it] = res_sun_4[5]
  men[12,it] = res_dual_0[5]
  men[13,it] = res_dual_1[5]
  men[14,it] = res_dual_2[5]
  men[15,it] = res_dual_3[5]
  men[16,it] = res_dual_4[5]


; plot
  set_plot, 'ps'
  device, file='pdf.swt.'+mon[it]+'.65.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=14
  !p.font=0

  dx = .8
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,18], yrange=[-6,4], xstyle=9, ystyle=9, $
   xticks=18, xtickname=make_array(19,val=' ')
  whisker, res0, 1, dx, color=200, thick=3
  whisker, res1, 2, dx, color=140, thick=3
  loadct, 56
  whisker, res_gpm_0, 3, dx, color=240, thick=3, lcolor=255
  whisker, res_gpm_1, 4, dx, color=200, thick=3, lcolor=255
  whisker, res_gpm_2, 5, dx, color=160, thick=3, lcolor=255
  whisker, res_gpm_3, 6, dx, color=120, thick=3, lcolor=255
  whisker, res_gpm_4, 7, dx, color=80, thick=3, lcolor=255

  loadct, 49
  whisker, res_sun_0, 8, dx, color=240, thick=3, lcolor=255
  whisker, res_sun_1, 9, dx, color=200, thick=3, lcolor=255
  whisker, res_sun_2, 10, dx, color=160, thick=3, lcolor=255
  whisker, res_sun_3, 11, dx, color=120, thick=3, lcolor=255
  whisker, res_sun_4, 12, dx, color=80, thick=3, lcolor=255

  loadct, 53
  whisker, res_dual_0, 13, dx, color=240, thick=3, lcolor=255
  whisker, res_dual_1, 14, dx, color=200, thick=3, lcolor=255
  whisker, res_dual_2, 15, dx, color=160, thick=3, lcolor=255
  whisker, res_dual_3, 16, dx, color=120, thick=3, lcolor=255
  whisker, res_dual_4, 17, dx, color=80, thick=3, lcolor=255


  device, /close

  endfor

; Plot the time series median and mean values
  set_plot, 'ps'
  device, file='pdf.swt_month.median.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=14
  !p.font=0
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,13], yrange=[-2,0], xstyle=9, ystyle=9, $
   xticks=13, xtickname=make_array(14,val=' ')
  loadct,56
  oplot, indgen(12)+1, med[2,*], thick=3, color=240
  oplot, indgen(12)+1, med[3,*], thick=3, color=200
  oplot, indgen(12)+1, med[4,*], thick=3, color=160
  oplot, indgen(12)+1, med[5,*], thick=3, color=120
  oplot, indgen(12)+1, med[6,*], thick=3, color=80
  loadct,49
  oplot, indgen(12)+1, med[7,*], thick=3, color=240
  oplot, indgen(12)+1, med[8,*], thick=3, color=200
  oplot, indgen(12)+1, med[9,*], thick=3, color=160
  oplot, indgen(12)+1, med[10,*], thick=3, color=120
  oplot, indgen(12)+1, med[11,*], thick=3, color=80
  loadct,53
  oplot, indgen(12)+1, med[12,*], thick=3, color=240
  oplot, indgen(12)+1, med[13,*], thick=3, color=200
  oplot, indgen(12)+1, med[14,*], thick=3, color=160
  oplot, indgen(12)+1, med[15,*], thick=3, color=120
  oplot, indgen(12)+1, med[16,*], thick=3, color=80
  loadct, 0
  oplot, indgen(12)+1, med[0,*], thick=12, color=0
  oplot, indgen(12)+1, med[1,*], thick=12, color=140
  device, /close


  set_plot, 'ps'
  device, file='pdf.swt_month.mean.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=14
  !p.font=0
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,13], yrange=[-4,0], xstyle=9, ystyle=9, $
   xticks=13, xtickname=make_array(14,val=' ')
  loadct,56
  oplot, indgen(12)+1, men[2,*], thick=3, color=240
  oplot, indgen(12)+1, men[3,*], thick=3, color=200
  oplot, indgen(12)+1, men[4,*], thick=3, color=160
  oplot, indgen(12)+1, men[5,*], thick=3, color=120
  oplot, indgen(12)+1, men[6,*], thick=3, color=80
  loadct,49
  oplot, indgen(12)+1, men[7,*], thick=3, color=240
  oplot, indgen(12)+1, men[8,*], thick=3, color=200
  oplot, indgen(12)+1, men[9,*], thick=3, color=160
  oplot, indgen(12)+1, men[10,*], thick=3, color=120
  oplot, indgen(12)+1, men[11,*], thick=3, color=80
  loadct,53
  oplot, indgen(12)+1, men[12,*], thick=3, color=240
  oplot, indgen(12)+1, men[13,*], thick=3, color=200
  oplot, indgen(12)+1, men[14,*], thick=3, color=160
  oplot, indgen(12)+1, men[15,*], thick=3, color=120
  oplot, indgen(12)+1, men[16,*], thick=3, color=80
  loadct, 0
  oplot, indgen(12)+1, men[0,*], thick=12, color=0
  oplot, indgen(12)+1, men[1,*], thick=12, color=140
  device, /close

end
