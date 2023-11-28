; Zonal, annual mean extinction profile

; Setup the plot
  set_plot, 'ps'
  device, file='plot_ext3d_su_diff.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,4)
  position = [ [.1,.62,.5,.95], [.575,.62,.975,.95], $
               [.1,.17,.5,.5], [.575,.17,.975,.5]]

  loadct, 0
  makekey, .1, .585, .4, .03, 0, -.025, align=0, charsize=.7, $
           color=make_array(7,val=0), label=['1','2','4','8','16','32','64']
  xyouts, .5, .56, 'Mm!E-1!N', charsize=.7, /normal

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [1,2,4,8,16,32,64]/1000.
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .1, .585, .4, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']



; dR_F25b18
  iplot = 0
  datafil = '/misc/prc14/colarco/dR_F25b18/inst3d_ext-532nm_v/su/dR_F25b18/inst3d_ext-532nm_v/dR_F25b18.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  tau_base = tau
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, $
        xtickn=[' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytitle='Pressure [hPa]', $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, $
        xtickn=[' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytitle='Pressure [hPa]', $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  title = 'Fortuna!U1/2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1

; DIFFERENCE PLOT
  tau_base = tau
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.7, $
           color=make_array(11,val=0), label=[' ','-5','-2','-1','-0.5','-0.1','0.1','0.5','1','2','5']
  xyouts, .75, .03, 'Mm!E-1!N', charsize=.7, /normal
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,255,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-5,-2,-1,-0.5,-.1,.1,0.5,1,2,5]/1000.
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']

; c180R_G40b11_merra2
  iplot = 2
  datafil = '/misc/prc14/colarco/c180R_G40b11_merra2/inst3d_ext-532nm_v/su/c180R_G40b11_merra2/inst3d_ext-532nm_v/c180R_G40b11_merra2.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)-tau_base
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytitle='Pressure [hPa]', $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytitle='Pressure [hPa]', $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6, xtitle='Latitude'
  title = 'Ganymed!U1/2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1



; Get the b-resolution baseine
  datafil = '/misc/prc14/colarco/dR_F25b18/inst3d_ext-532nm_v/su/dR_F25b18/inst3d_ext-532nm_v/dR_F25b18.inst3d_ext-532nm_v.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, 'extinction', tau_base, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau_base = reform(total(tau_base,1)/nx)



; F25b18
  iplot = 1
  datafil = '/misc/prc14/colarco/F25b18/inst3d_ext-532nm_v/su/F25b18/inst3d_ext-532nm_v/F25b18.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)-tau_base
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  title = 'Fortuna!U2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1


; c48R_G40b11_merra2
  iplot = 3
  datafil = '/misc/prc14/colarco/c48R_G40b11_merra2/inst3d_ext-532nm_v/su/c48R_G40b11_merra2/inst3d_ext-532nm_v/c48R_G40b11_merra2.inst3d_ext-532nm_v.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'extinction', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)-tau_base
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], color=iblack, ytickn=[' ',' ',' ',' ',' ',' ',' ',' '],$
        xstyle=1, xticks=6, ystyle=1, yticks=7, $
        ytickv=[1000,850,700,500,300,200,100,25], charsize=.6, xtitle='Latitude'
  title = 'Ganymed!U2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=1

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2

  device, /close

end
