; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_cnprcp_all.ps', /color, /helvetica, font_size=16, $
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
  levels = [.1,1,2,4,8,12,15]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1



; c180R_H40_acma
  iplot = 0
  datafil = '/misc/prc14/colarco/c180R_H40_acma/geosgcm_surf/c180R_H40_acma.geosgcm_surf.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['cnprcp'], cnprcp, lon=lon, lat=lat, lev=lev, /sum
  cnprcp = cnprcp*86400.   ; mm day-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'R!U1/2!S!Eo!N'
  plot_map, cnprcp, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)', varunits=' mm day!E-1!N'

  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(7,val=0), label=['0.1','1','2','4','8','12','15']
  xyouts, .75, .03, 'mm day!E-1!N', charsize=.6, /normal
  tvlct, red, green, blue
  makekey, .25, .07, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']



; c180Rreg_H40_acma
  iplot = 1
  datafil = '/misc/prc14/colarco/c180Rreg_H40_acma/geosgcm_surf/c180Rreg_H40_acma.geosgcm_surf.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['cnprcp'], cnprcp, lon=lon, lat=lat, lev=lev, /sum
  cnprcp = cnprcp*86400.   ; mm day-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Rreg!U1/2!S!Eo!N'
  plot_map, cnprcp, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)', varunits=' mm day!E-1!N'




; c180F_H40_acma
  iplot = 2
  datafil = '/misc/prc14/colarco/c180F_H40_acma/geosgcm_surf/c180F_H40_acma.geosgcm_surf.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['cnprcp'], cnprcp, lon=lon, lat=lat, lev=lev, /sum
  cnprcp = cnprcp*86400.   ; mm day-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'F!U1/2!S!Eo!N'
  plot_map, cnprcp, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)', varunits=' mm day!E-1!N'


; c48R_H40_acma
  iplot = 3
  datafil = '/misc/prc14/colarco/c48R_H40_acma/geosgcm_surf/c48R_H40_acma.geosgcm_surf.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['cnprcp'], cnprcp, lon=lon, lat=lat, lev=lev, /sum
  cnprcp = cnprcp*86400.   ; mm day-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'R!U2!S!Eo!N'
  plot_map, cnprcp, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)', varunits=' mm day!E-1!N'



; c48Rreg_H40_acma
  iplot = 4
  datafil = '/misc/prc14/colarco/c48Rreg_H40_acma/geosgcm_surf/c48Rreg_H40_acma.geosgcm_surf.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['cnprcp'], cnprcp, lon=lon, lat=lat, lev=lev, /sum
  cnprcp = cnprcp*86400.   ; mm day-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'Rreg!U2!S!Eo!N'
  plot_map, cnprcp, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)', varunits=' mm day!E-1!N'


; c48F_H40_acma
  iplot = 5
  datafil = '/misc/prc14/colarco/c48F_H40_acma/geosgcm_surf/c48F_H40_acma.geosgcm_surf.monthly.clim.ANN.nc4'
  nc4readvar, datafil, ['cnprcp'], cnprcp, lon=lon, lat=lat, lev=lev, /sum
  cnprcp = cnprcp*86400.   ; mm day-1
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  title = 'F!U2!S!Eo!N'
  plot_map, cnprcp, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f4.2)', varunits=' mm day!E-1!N'



  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
