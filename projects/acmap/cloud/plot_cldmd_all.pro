; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_cldmd_all.ps', /color, /helvetica, font_size=16, $
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
  levels = [.1,.2,.3,.4,.5,.6,.8]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  datafils = ['/misc/prc18/colarco/c180Rreg_H54p3-acma/geosgcm_surf/c180Rreg_H54p3-acma.geosgcm_surf.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90Rreg_H54p3-acma/geosgcm_surf/c90Rreg_H54p3-acma.geosgcm_surf.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48Rreg_H54p3-acma/geosgcm_surf/c48Rreg_H54p3-acma.geosgcm_surf.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c180F_H54p3-acma/geosgcm_surf/c180F_H54p3-acma.geosgcm_surf.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90F_H54p3-acma/geosgcm_surf/c90F_H54p3-acma.geosgcm_surf.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48F_H54p3-acma/geosgcm_surf/c48F_H54p3-acma.geosgcm_surf.monthly.clim.ANN.nc4' ]


  titles   = ['Rreg!U1/2!S!Eo!N', $
              'Rreg!U1!S!Eo!N', $
              'Rreg!U2!S!Eo!N', $
              'F!U1/2!S!Eo!N', $
              'F!U1!S!Eo!N', $
              'F!U2!S!Eo!N']


  for iplot = 0, 5 do begin

  nc4readvar, datafils[iplot], ['cldmd'], cldmd, lon=lon, lat=lat, lev=lev, /sum
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = titles[iplot]
  plot_map, cldmd, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)'

  endfor

  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=0, charsize=.7, $
           color=make_array(7,val=0), label=['0.1','0.2','0.3','0.4','0.5','0.6','0.8']
  tvlct, red, green, blue
  makekey, .25, .07, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']



  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
