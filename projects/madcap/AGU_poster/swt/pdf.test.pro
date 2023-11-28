  get_stat, 'c1440_NR.gpm.nodrag.nadir.ddf', res_gpm_0, nt0=0, nt1=0
  get_stat, 'full.ddf', res0, nt0=0, nt1=0
  get_stat, 'full.ddf', res1, wantlat=[-65,65], nt0=0, nt1=0
  get_stat, 'c1440_NR.gpm.nodrag.100km.ddf', res_gpm_1, nt0=0, nt1=0
  get_stat, 'c1440_NR.gpm.nodrag.300km.ddf', res_gpm_2, nt0=0, nt1=0
  get_stat, 'c1440_NR.gpm.nodrag.500km.ddf', res_gpm_3, nt0=0, nt1=0
  get_stat, 'c1440_NR.gpm.nodrag.1000km.ddf', res_gpm_4, nt0=0, nt1=0
  get_stat, 'c1440_NR.sunsynch_500km.nodrag.nadir.ddf', res_sun_0, nt0=0, nt1=0
  get_stat, 'c1440_NR.sunsynch_500km.nodrag.100km.ddf', res_sun_1, nt0=0, nt1=0
  get_stat, 'c1440_NR.sunsynch_500km.nodrag.300km.ddf', res_sun_2, nt0=0, nt1=0
  get_stat, 'c1440_NR.sunsynch_500km.nodrag.500km.ddf', res_sun_3, nt0=0, nt1=0
  get_stat, 'c1440_NR.sunsynch_500km.nodrag.1000km.ddf', res_sun_4, nt0=0, nt1=0
  get_stat, 'c1440_NR.dual.nadir.ddf', res_dual_0, nt0=0, nt1=0
  get_stat, 'c1440_NR.dual.100km.ddf', res_dual_1, nt0=0, nt1=0
  get_stat, 'c1440_NR.dual.300km.ddf', res_dual_2, nt0=0, nt1=0
  get_stat, 'c1440_NR.dual.500km.ddf', res_dual_3, nt0=0, nt1=0
  get_stat, 'c1440_NR.dual.1000km.ddf', res_dual_4, nt0=0, nt1=0


; plot
  set_plot, 'ps'
  device, file='pdf.swt.test.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=14
  !p.font=0

  dx = .8
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,18], yrange=[-8,4], xstyle=9, ystyle=9, $
   xticks=18, xtickname=make_array(19,val=' ')
  whisker, res0, 1, dx, color=200, thick=3
  whisker, res1, 2, dx, color=140, thick=3
  loadct, 56
  whisker, res_gpm_0, 3, dx, color=240, thick=3, lcolor=255
  whisker, res_gpm_1, 4, dx, color=200, thick=3, lcolor=255
  whisker, res_gpm_2, 5, dx, color=160, thick=3, lcolor=255
  whisker, res_gpm_3, 6, dx, color=120, thick=3, lcolor=255
  whisker, res_gpm_4, 7, dx, color=80, thick=3, lcolor=255

  loadct, 52
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

end
