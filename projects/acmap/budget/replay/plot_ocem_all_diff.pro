; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_ocem_all_diff.ps', /color, /helvetica, font_size=16, $
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
  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [.001,.002,.004,.007,.01,.02,.04]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  datafils = ['/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90Rreg_H54p3-acma/tavg2d_aer_x/c90Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48Rreg_H54p3-acma/tavg2d_aer_x/c48Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c180R_H54p3-acma/tavg2d_aer_x/c180R_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90R_H54p3-acma/tavg2d_aer_x/c90R_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48R_H54p3-acma/tavg2d_aer_x/c48R_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4' ]


  titles   = ['Rreg!U1/2!S!Eo!N', $
              'Rreg!U1!S!Eo!N', $
              'Rreg!U2!S!Eo!N', $
              'R!U1/2!S!Eo!N', $
              'R!U1!S!Eo!N', $
              'R!U2!S!Eo!N']


; Baseline
  iplot = 0
  datafil = datafils[iplot]
  nc4readvar, datafil, ['ocem001','ocem002'], ocem, lon=lon, lat=lat, lev=lev, /sum
  ocem = ocem*365.*86400.   ; kg m-2 yr-1
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, ocem, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f7.2)', $
            varscale=1.e-9, /varsum, varunits=' Tg'
  loadct, 0
  polyfill, [.02,.32,.32,.02,.02], [.5,.5,.64,.64,.5], color=255, /normal
  makekey, .02, .6, .3, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), label=['0.001','0.002','0.004','0.007','0.01','0.02','0.04']
  xyouts, .32, .56, 'kg m!E-2!N yr!E-1!N', charsize=.6, /normal
  tvlct, red, green, blue
  makekey, .02, .6, .3, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

; DIFFERENCE PLOT
  ocem_base = ocem
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(11,val=0), label=[' ','-0.01','-0.005','-0.003','-0.002','-0.001','0.001','0.002','0.003','0.005','0.01']
  xyouts, .75, .03, 'kg m!E-2!N yr!E-1!N', charsize=.6, /normal
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,16,164,152,255,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]/10.
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']

; Get the b-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, ['ocem001','ocem002'], ocem_b, lon=lon, lat=lat, lev=lev, /sum
  ocem_b = ocem_b*365.*86400.
  ocem_base_b = ocem_b

; Get the b-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.c.nc4'
  nc4readvar, datafil, ['ocem001','ocem002'], ocem_c, lon=lon, lat=lat, lev=lev, /sum
  ocem_c = ocem_c*365.*86400.
  ocem_base_c = ocem_c

  for iplot = 1, 5 do begin

   nc4readvar, datafils[iplot], ['ocem001','ocem002'], ocem, lon=lon, lat=lat, lev=lev, /sum
   ocem = ocem*365.*86400.   ; kg m-2 yr-1
   area, lon, lat, nx, ny, dx, dy, area
   if(nx eq 576) then begin
    ocem = ocem-ocem_base
   endif else begin
    if(nx eq 288) then begin
     ocem = ocem-ocem_base_c
    endif else begin
     ocem = ocem-ocem_base_b
    endelse
   endelse
   title = titles[iplot]
   plot_map, ocem, lon, lat, dx, dy, levels, dcolors, $
             position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title, format='(f6.2)', $
             varscale=1.e-9, /varsum, varunits=' Tg'
  endfor

  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.6,.6,.63,.63,.6], color=0, /normal, thick=2
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end