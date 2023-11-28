; Grab from MERRA-2 3d extinction calculator output the backscatter
; color ratio, 532 nm lidar ratio, and the 532 nm extinction
; Threshold points on 532 nm extinction greater than 0.003 km-1 after
; Nowottnick et al. 2015 and make a composition plot

; Total aerosol
  file532  = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst3d_ext-532nm-v15_v/Y2009/M07/dR_MERRA-AA-r2.inst3d_ext-532nm_v.20090715_1200z.nc4'
  file1064 = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst3d_ext-1064nm-v15_v/Y2009/M07/dR_MERRA-AA-r2.inst3d_ext-1064nm_v.20090715_1200z.nc4'

  nc4readvar, file532, 'extinction', ext, lon=lon, lat=lat
  nc4readvar, file532, 'ext2back', e2b, lon=lon, lat=lat
  nc4readvar, file532, 'backscat', bsc, lon=lon, lat=lat
  nc4readvar, file1064, 'backscat', bsc1064, lon=lon, lat=lat

  col = bsc/bsc1064

  a = where(ext gt 0.003)

; Plot the first image
  set_plot, 'ps'
  device, file='lidar.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=12, ysize=12
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   thick=4, $
   xrange=[0,120], xtitle='lidar ratio [sr!E-1!N]', $
   yrange=[0,6], ytitle = 'color ratio'
  plots, e2b[a], col[a], color=200, psym=3

; Do marine dominated points
  file532_  = file532+'.ss'
  file1064_ = file1064+'.ss'
  nc4readvar, file532_, 'extinction', ext_, lon=lon, lat=lat
  nc4readvar, file532_, 'ext2back', e2b_, lon=lon, lat=lat
  nc4readvar, file532_, 'backscat', bsc_, lon=lon, lat=lat
  nc4readvar, file1064_, 'backscat', bsc1064_, lon=lon, lat=lat
  a = where(ext gt 0.003 and ext_/ext gt .5)
  col_ = bsc_/bsc1064_

  loadct, 39
  plots, e2b[a], col[a], psym=3, color=60

; Do dust dominated points
  file532_  = file532+'.dust'
  file1064_ = file1064+'.dust'
  nc4readvar, file532_, 'extinction', ext_, lon=lon, lat=lat
  nc4readvar, file532_, 'ext2back', e2b_, lon=lon, lat=lat
  nc4readvar, file532_, 'backscat', bsc_, lon=lon, lat=lat
  nc4readvar, file1064_, 'backscat', bsc1064_, lon=lon, lat=lat
  a = where(ext gt 0.003 and ext_/ext gt .5)
  col_ = bsc_/bsc1064_

  loadct, 69
  plots, e2b[a], col[a], psym=3, color=60


; Do carbon dominated points
  file532_  = file532+'.cc'
  file1064_ = file1064+'.cc'
  nc4readvar, file532_, 'extinction', ext_, lon=lon, lat=lat
  nc4readvar, file532_, 'ext2back', e2b_, lon=lon, lat=lat
  nc4readvar, file532_, 'backscat', bsc_, lon=lon, lat=lat
  nc4readvar, file1064_, 'backscat', bsc1064_, lon=lon, lat=lat
  a = where(ext gt 0.003 and ext_/ext gt .5)
  col_ = bsc_/bsc1064_

  loadct, 73
;  plots, e2b_[a], col_[a], psym=3, color=254
  plots, e2b[a], col[a], psym=3, color=220


; Do sulfate dominated points
  file532_  = file532+'.su'
  file1064_ = file1064+'.su'
  nc4readvar, file532_, 'extinction', ext_, lon=lon, lat=lat
  nc4readvar, file532_, 'ext2back', e2b_, lon=lon, lat=lat
  nc4readvar, file532_, 'backscat', bsc_, lon=lon, lat=lat
  nc4readvar, file1064_, 'backscat', bsc1064_, lon=lon, lat=lat
  a = where(ext gt 0.003 and ext_/ext gt .5)
  col_ = bsc_/bsc1064_

  loadct, 39
  plots, e2b[a], col[a], psym=3


  device, /close

end
