; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_supd_all_diff.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,6)
  for iplot = 0, 2 do begin
   position[*,iplot] = [.02+iplot*.33,.5,.02+iplot*.33+.3,1]
  endfor
  for iplot = 3, 5 do begin
   position[*,iplot] = [.02+(iplot-3)*.33,0.07,.02+(iplot-3)*.33+.3,.57]
  endfor
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  red   = [255,199,127,65,29,34,12,     152, 0]
  green = [255,233,205,182,145,94,44,   152, 0]
  blue  = [204,180,187,196,192,168,132, 152, 0]
  tvlct, red, green, blue
  levels = [.1,.2,.4,.7,1,2,4]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1



; c180R_G40b11
  iplot = 0
  datafil = '/misc/prc14/colarco/c180R_G40b11/tavg2d_aer_x/c180R_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U1/2!S!Eo!N'
  plot_map, supd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.1)', varunits=' Tg', /varsum, varscale=1.e-12


  loadct, 0
  polyfill, [.02,.32,.32,.02,.02], [.5,.5,.64,.64,.5], color=255, /normal
  makekey, .02, .6, .3, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), label=['0.1','0.2','0.4','0.7','1','2','4']
  xyouts, .32, .56, 'g m!E-2!N yr!E-1!N', charsize=.6, /normal
  tvlct, red, green, blue
  makekey, .02, .6, .3, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

; DIFFERENCE PLOT
  supd_base = supd
  loadct, 0
  levels = [-2000,-1.,-.5,-.2,-.1,-.05,-0.02,-.01,.01,0.02,.05,.1,.2]
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(13,val=0), $
           label=[' ','-1','-0.5','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
  xyouts, .75, .03, 'g m!E-2!N yr!E-1!N', charsize=.6, /normal
  red   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
  green = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
  blue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']




; c180F_G40b11
  iplot = 3
  datafil = '/misc/prc14/colarco/c180F_G40b11/tavg2d_aer_x/c180F_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd = supd-supd_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'fGanymed!U1/2!S!Eo!N'
  plot_map, supd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.1)', varunits=' Tg', /varsum, varscale=1.e-12



; Get the c-resolution baseine
  datafil = '/misc/prc14/colarco/c180R_G40b11/tavg2d_aer_x/c180R_G40b11.tavg2d_aer_x.monthly.clim.ANN.c.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd_base = supd
  area, lon, lat, nx, ny, dx, dy, area


; c90R_G40b11
  iplot = 1
  datafil = '/misc/prc14/colarco/c90R_G40b11/tavg2d_aer_x/c90R_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd = supd-supd_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U1!S!Eo!N'
  plot_map, supd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.1)', varunits=' Tg', /varsum, varscale=1.e-12



; c90F_G40b11
  iplot = 4
  datafil = '/misc/prc14/colarco/c90F_G40b11/tavg2d_aer_x/c90F_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd = supd-supd_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'fGanymed!U1!S!Eo!N'
  plot_map, supd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.1)', varunits=' Tg', /varsum, varscale=1.e-12



; Get the b-resolution baseine
  datafil = '/misc/prc14/colarco/c180R_G40b11/tavg2d_aer_x/c180R_G40b11.tavg2d_aer_x.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd_base = supd
  area, lon, lat, nx, ny, dx, dy, area


; c48R_G40b11
  iplot = 2
  datafil = '/misc/prc14/colarco/c48R_G40b11/tavg2d_aer_x/c48R_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd = supd-supd_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Ganymed!U2!S!Eo!N'
  plot_map, supd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.1)', varunits=' Tg', /varsum, varscale=1.e-12


; c48F_G40b11
  iplot = 5
  datafil = '/misc/prc14/colarco/c48F_G40b11/tavg2d_aer_x/c48F_G40b11.tavg2d_aer_x.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['supso4g','supso4aq','supso4wt'], supd, lon=lon, lat=lat, lev=lev, /sum
  supd = supd*365.*86400.*1000.   ; g m-2 yr-1
  supd = supd-supd_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'fGanymed!U2!S!Eo!N'
  plot_map, supd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.1)', varunits=' Tg', /varsum, varscale=1.e-12



  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.6,.6,.63,.63,.6], color=0, /normal, thick=2
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
