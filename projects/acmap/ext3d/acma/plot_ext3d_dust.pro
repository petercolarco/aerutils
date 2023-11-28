; Zonal, annual mean extinction profile

; Setup the plot
  set_plot, 'ps'
  device, file='plot_ext3d_dust.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,4)
  position = [ [.1,.62,.5,.95], [.575,.62,.975,.95], $
               [.1,.17,.5,.5], [.575,.17,.975,.5]]

  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=0, charsize=.7, $
           color=make_array(7,val=0), label=['1','2','4','8','16','32','64']
  xyouts, .75, .03, 'Mm!E-1!N', charsize=.7, /normal

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [1,2,4,8,16,32,64]/1000.
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']



; dR_F25b18
  iplot = 0
  datafil = '/misc/prc14/colarco/dR_F25b18/inst3d_ext-532nm_v/dust/dR_F25b18/inst3d_ext-532nm_v/dR_F25b18.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytitle='Pressure [hPa]', $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  title = 'Fortuna!U1/2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1


; c180R_G40b11_merra2
  iplot = 2
  datafil = '/misc/prc14/colarco/c180R_G40b11_merra2/inst3d_ext-532nm_v/dust/c180R_G40b11_merra2/inst3d_ext-532nm_v/c180R_G40b11_merra2.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytitle='Pressure [hPa]', $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6, xtitle='Latitude'
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  title = 'Ganymed!U1/2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1



; F25b18
  iplot = 1
  datafil = '/misc/prc14/colarco/F25b18/inst3d_ext-532nm_v/dust/F25b18/inst3d_ext-532nm_v/F25b18.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  title = 'Fortuna!U2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1


; c48R_G40b11_merra2
  iplot = 3
  datafil = '/misc/prc14/colarco/c48R_G40b11_merra2/inst3d_ext-532nm_v/dust/c48R_G40b11_merra2/inst3d_ext-532nm_v/c48R_G40b11_merra2.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=[1000,850,700,500,300,200,100,25], charsize=.6, xtitle='Latitude'
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,25], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '],$
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  title = 'Ganymed!U2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2

  device, /close

end
