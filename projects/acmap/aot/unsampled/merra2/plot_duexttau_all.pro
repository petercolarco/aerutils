; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_duexttau_all.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,4)
  position = [ [.025,.5,.475,1], [.525,.5,.975,1], $
               [.025,.07,.475,.57], [.525,.07,.975,.57]]

  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=0, charsize=.7, $
           color=make_array(7,val=0), label=['0.01','0.05','0.1','0.2','0.3','0.5','0.7']

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [.01,.05,.1,.2,.3,.5,.7]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']



; dR_F25b18
  iplot = 0
  datafil = '/misc/prc14/colarco/dR_F25b18/tavg2d_aer_x/dR_F25b18.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'duexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Fortuna!U1/2!S!Eo!N'
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title



; c180R_G40b11_merra2
  iplot = 2
  datafil = '/misc/prc14/colarco/c180R_G40b11_merra2/tavg2d_aer_x/c180R_G40b11_merra2.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'duexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U1/2!S!Eo!N'
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title



; F25b18
  iplot = 1
  datafil = '/misc/prc14/colarco/F25b18/tavg2d_aer_x/F25b18.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'duexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Fortuna!U2!S!Eo!N'
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title


; c48R_G40b11_merra2
  iplot = 3
  datafil = '/misc/prc14/colarco/c48R_G40b11_merra2/tavg2d_aer_x/c48R_G40b11_merra2.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'duexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U2!S!Eo!N'
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2

  device, /close

end
