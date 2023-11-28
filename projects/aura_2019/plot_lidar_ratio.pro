  thresh = 0.05

  expid = 'c360R_v10p22p2_aura_loss_bb3.bcgf_low'
  stnWant = 'Namibe'
  lamWant = '352'
  getmodellidar, expid, stnWant, lamWant, ext2back, rh, ext, h
  lamWant = '532'
  getmodellidar, expid, stnWant, lamWant, ext2back3,rh, ext3, h

  a = where(ext gt thresh)


  set_plot, 'ps'
  device, file='plot_lidar_ratio.'+stnWant+'.'+expid+'.ps', $
   /color, /helvetica, font_size=14
  !p.font=0

  plot, indgen(10), /nodata, $
   yrange=[50,110], ytitle='Lidar ratio, sr', $
   xrange=[0,1], xtitle='RH', $
   title=stnWant

  loadct, 39
  plots, rh[a], ext2back[a], psym=3, color=48
  plots, rh[a], ext2back3[a], psym=3, color=144

  device, /close

end
