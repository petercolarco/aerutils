; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_ni_all_diff.ps', /color, /helvetica, font_size=16, $
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
  levels = [.01,.02,.04,.07,.1,.2,.4]/10.
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
  nc4readvar, datafil, 'niexttau', duem, lon=lon, lat=lat, lev=lev, /sum
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f8.5)'
  loadct, 0
  polyfill, [.02,.32,.32,.02,.02], [.5,.5,.64,.64,.5], color=255, /normal
  makekey, .02, .6, .3, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), label=['0.001','0.002','0.004','0.007','0.01','0.02','0.04']
  tvlct, red, green, blue
  makekey, .02, .6, .3, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

; DIFFERENCE PLOT
  duem_base = duem
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(11,val=0), label=[' ','-0.01','-0.005','-0.003','-0.002','-0.001','0.001','0.002','0.003','0.005','0.01']
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,191,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]/10.
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','','','']

; Get the b-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, 'niexttau', duem_b, lon=lon, lat=lat, lev=lev, /sum
  duem_base_b = duem_b

; Get the c-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.c.nc4'
  nc4readvar, datafil, 'niexttau', duem_c, lon=lon, lat=lat, lev=lev, /sum, /tem
  duem_base_c = duem_c

  for iplot = 1, 5 do begin

   nc4readvar, datafils[iplot], 'niexttau', duem, lon=lon, lat=lat, lev=lev, /sum
   area, lon, lat, nx, ny, dx, dy, area
   if(nx eq 576) then begin
    duem = duem-duem_base
   endif else begin
    if(nx eq 288) then begin
     duem = duem-duem_base_c
    endif else begin
     duem = duem-duem_base_b
    endelse
   endelse
   title = titles[iplot]
   plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
             position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title, format='(f8.5)'
  endfor

  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.6,.6,.63,.63,.6], color=0, /normal, thick=2
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
