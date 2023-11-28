; Zonal, annual mean extinction profile

; Setup the plot
  set_plot, 'ps'
  device, file='plot_rh_all.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,6)
  for iplot = 0, 2 do begin
   position[*,iplot] = [.05+iplot*.3,.65,.05+iplot*.3+.25,.95]
  endfor
  for iplot = 3, 5 do begin
   position[*,iplot] = [.05+(iplot-3)*.3,0.22,.05+(iplot-3)*.3+.25,.52]
  endfor
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  loadct, 0
  makekey, .25, .1, .5, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), label=['0.3','0.4','0.5','0.6','0.7','0.8','0.9']

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = findgen(7)*.1+.3
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .1, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']



; c180R_G40b11
  iplot = 0
  datafil = '/misc/prc14/colarco/c180R_G40b11/inst3d_ext-532nm_v/c180R_G40b11.inst3d_ext-532nm_v.monthly.clim.JJA.nc4'
  nc4readvar, datafil, 'rh', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  title = 'Ganymed!U1/2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6


; dR_F25b18
  iplot = 3
  datafil = '/misc/prc14/colarco/dR_F25b18/inst3d_ext-532nm_v/dR_F25b18.inst3d_ext-532nm_v.monthly.clim.JJA.nc4'
  nc4readvar, datafil, 'rh', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  title = 'Fortuna!U1/2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6


; Get the c-resolution baseine
  datafil = '/misc/prc14/colarco/c180R_G40b11/inst3d_ext-532nm_v/c180R_G40b11.inst3d_ext-532nm_v.monthly.clim.JJA.c.nc4'
  nc4readvar, datafil, 'rh', tau_base, lon=lon, lat=lat, lev=lev



; c90R_G40b11
  iplot = 1
  datafil = '/misc/prc14/colarco/c90R_G40b11/inst3d_ext-532nm_v/c90R_G40b11.inst3d_ext-532nm_v.monthly.clim.JJA.nc4'
  nc4readvar, datafil, 'rh', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  title = 'Ganymed!U1!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6


; cR_F25b18
  iplot = 4
  datafil = '/misc/prc14/colarco/cR_F25b18/inst3d_ext-532nm_v/cR_F25b18.inst3d_ext-532nm_v.monthly.clim.JJA.nc4'
  nc4readvar, datafil, 'rh', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  title = 'Fortuna!U1!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6



; Get the c-resolution baseine
  datafil = '/misc/prc14/colarco/c180R_G40b11/inst3d_ext-532nm_v/c180R_G40b11.inst3d_ext-532nm_v.monthly.clim.JJA.b.nc4'
  nc4readvar, datafil, 'rh', tau_base, lon=lon, lat=lat, lev=lev



; c48R_G40b11
  iplot = 2
  datafil = '/misc/prc14/colarco/c48R_G40b11/inst3d_ext-532nm_v/c48R_G40b11.inst3d_ext-532nm_v.monthly.clim.JJA.nc4'
  nc4readvar, datafil, 'rh', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  title = 'Ganymed!U2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6


; F25b18
  iplot = 5
  datafil = '/misc/prc14/colarco/F25b18/inst3d_ext-532nm_v/F25b18.inst3d_ext-532nm_v.monthly.clim.JJA.nc4'
  nc4readvar, datafil, 'rh', tau, lon=lon, lat=lat, lev=lev
; Zonal mean
  nx = n_elements(lon)
  tau = reform(total(tau,1)/nx)
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  contour, tau, lat, lev, /over, levels=levels, /fill, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=[1000,500], /ylog, color=iblack, ytickn=[' ',' ',' ',' ',' ',' '],$
        xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=[1000,900,800,700,600,500], charsize=.8
  title = 'Fortuna!U2!S!Eo!N'
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.1,.1,.13,.13,.1], color=0, /normal, thick=2

  device, /close

end
