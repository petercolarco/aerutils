; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_merraero_all_diff.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,4)
  position = [ [.025,.5,.475,1], [.525,.5,.975,1], $
               [.025,.07,.475,.57], [.525,.07,.975,.57]]
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.



; DIFFERENCE PLOT
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.7, $
           color=make_array(13,val=0), label=[' ','-0.3','-0.2','-0.1','-0.05','-0.03','-0.02','-0.01','0.01','0.02','0.03','0.05','0.1']
  red   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
  green = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
  blue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-0.3,-0.2,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','','','']



; Get a baseline
  datafil = '/misc/prc15/colarco/dR_MERRA-AA-r2/tavg2d_aer_x/dR_MERRA-AA-r2.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'totexttau', tau_base, lon=lon, lat=lat, lev=lev


; c180R_G40b11_merra2
  iplot = 0
  datafil = '/misc/prc14/colarco/c180R_G40b11_merra2/tavg2d_aer_x/c180R_G40b11_merra2.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'totexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U1/2!S!Eo!N'
  plot_map, tau-tau_base, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f7.4)'
  nx = n_elements(lon)
  ny = n_elements(lat)
  statistics, reform(tau,nx*ny*1L), reform(tau_base,nx*ny*1L), $
              xmean, ymean, xstd, ystd, r, bias, rms, skill, $
              linslope, linoffset
print, skill, r*r, rms, bias
  diff = position[2,iplot]-position[0,iplot]
  oval  = 'r!E2!N = '+string(r*r,format='(f5.3)')
  xyouts, position[0,iplot]+diff/20., position[1,iplot]+.06, oval, /normal, color=0, charsize=.7
  lval  = 'rms = '+string(rms,format='(f6.4)')
  xyouts, position[2,iplot]-diff/20, position[1,iplot]+.06, lval, /normal, color=12, charsize=.7, align=1

; c180F_G40b11
  iplot = 2
  datafil = '/misc/prc14/colarco/c180F_G40b11/tavg2d_aer_x/c180F_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'totexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'fGanymed!U1/2!S!Eo!N'
  plot_map, tau-tau_base, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f7.4)'
  nx = n_elements(lon)
  ny = n_elements(lat)
  statistics, reform(tau,nx*ny*1L), reform(tau_base,nx*ny*1L), $
              xmean, ymean, xstd, ystd, r, bias, rms, skill, $
              linslope, linoffset
print, skill, r*r, rms, bias
  diff = position[2,iplot]-position[0,iplot]
  oval  = 'r!E2!N = '+string(r*r,format='(f5.3)')
  xyouts, position[0,iplot]+diff/20., position[1,iplot]+.06, oval, /normal, color=0, charsize=.7
  lval  = 'rms = '+string(rms,format='(f6.4)')
  xyouts, position[2,iplot]-diff/20, position[1,iplot]+.06, lval, /normal, color=12, charsize=.7, align=1



; Get the b-resolution baseine
  datafil = '/misc/prc15/colarco/dR_MERRA-AA-r2/tavg2d_aer_x/dR_MERRA-AA-r2.tavg2d_aer_x.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, 'totexttau', tau_base, lon=lon, lat=lat, lev=lev



; c48R_G40b11_merra2
  iplot = 1
  datafil = '/misc/prc14/colarco/c48R_G40b11_merra2/tavg2d_aer_x/c48R_G40b11_merra2.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'totexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U2!S!Eo!N'
  plot_map, tau-tau_base, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f7.4)'
  nx = n_elements(lon)
  ny = n_elements(lat)
  statistics, reform(tau,nx*ny*1L), reform(tau_base,nx*ny*1L), $
              xmean, ymean, xstd, ystd, r, bias, rms, skill, $
              linslope, linoffset
print, skill, r*r, rms, bias
  diff = position[2,iplot]-position[0,iplot]
  oval  = 'r!E2!N = '+string(r*r,format='(f5.3)')
  xyouts, position[0,iplot]+diff/20., position[1,iplot]+.06, oval, /normal, color=0, charsize=.7
  lval  = 'rms = '+string(rms,format='(f6.4)')
  xyouts, position[2,iplot]-diff/20, position[1,iplot]+.06, lval, /normal, color=12, charsize=.7, align=1



; c48F_G40b11_step
  iplot = 3
  datafil = '/misc/prc14/colarco/c48F_G40b11_step/tavg2d_aer_x/c48F_G40b11_step.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, 'totexttau', tau, lon=lon, lat=lat, lev=lev
  a = where(lat gt 90 or lat lt -90)
  tau[*,a] = !values.f_nan
  tau[where(tau gt 1e14)] = !values.f_nan
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'fGanymed!U2!S!Eo!N'
  plot_map, tau-tau_base, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f7.4)'
  nx = n_elements(lon)
  ny = n_elements(lat)
  statistics, reform(tau,nx*ny*1L), reform(tau_base,nx*ny*1L), $
              xmean, ymean, xstd, ystd, r, bias, rms, skill, $
              linslope, linoffset
print, skill, r*r, rms, bias
  diff = position[2,iplot]-position[0,iplot]
  oval  = 'r!E2!N = '+string(r*r,format='(f5.3)')
  xyouts, position[0,iplot]+diff/20., position[1,iplot]+.06, oval, /normal, color=0, charsize=.7
  lval  = 'rms = '+string(rms,format='(f6.4)')
  xyouts, position[2,iplot]-diff/20, position[1,iplot]+.06, lval, /normal, color=12, charsize=.7, align=1

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2

  device, /close

end
