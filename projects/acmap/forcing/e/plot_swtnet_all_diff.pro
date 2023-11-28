; Make a plot of the SWTNET forcing difference relative to standard, 6 panel

; Setup the plot
  set_plot, 'ps'
  device, file='plot_swtnet_all_diff.ps', /color, /helvetica, font_size=16, $
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
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,191,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-10,-5,-2,-1,-.1,.1,1,2,5,10]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

; datafiles
  datafils = ['/misc/prc14/colarco/c360R_H53-acma/geosgcm_surf/c360R_H53-acma.geosgcm_surf.monthly.clim.JJA.nc4', $
              '/misc/prc14/colarco/c180R_H53-acma/geosgcm_surf/c180R_H53-acma.geosgcm_surf.monthly.clim.JJA.c.nc4', $
              '/misc/prc14/colarco/c90R_H53-acma/geosgcm_surf/c90R_H53-acma.geosgcm_surf.monthly.clim.JJA.nc4', $
              '/misc/prc14/colarco/c360F_H53-acma/geosgcm_surf/c360F_H53-acma.geosgcm_surf.monthly.clim.JJA.c.nc4', $
              '/misc/prc14/colarco/c180F_H53-acma/geosgcm_surf/c180F_H53-acma.geosgcm_surf.monthly.clim.JJA.c.nc4', $
              '/misc/prc14/colarco/c90F_H53-acma/geosgcm_surf/c90F_H53-acma.geosgcm_surf.monthly.clim.JJA.nc4' ]


  titles   = ['R!U1/4!S!Eo!N', $
              'R!U1/2!S!Eo!N', $
              'R!U1!S!Eo!N', $
              'F!U1/4!S!Eo!N', $
              'F!U1/2!S!Eo!N', $
              'F!U1!S!Eo!N']

; 
  iplot = 0
  datafil = datafils[iplot]
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  nc4readvar, '/misc/prc14/colarco/c48R_H40_acma/tavg2d_aer_x/c48R_H40_acma.tavg2d_aer_x.monthly.clim.ANN.nc4', 'lwi', lwi
  tau = reform(tau[*,*,0]-tau[*,*,1])
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  diff = position[2,iplot]-position[0,iplot]
  a = where(lwi lt .1)
  oval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[0,iplot]+diff/10., position[1,iplot]+.06, oval, /normal, color=1, charsize=.5
  a = where(lwi gt .9 and lwi lt 1.1)
  lval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[2,iplot]-diff/10, position[1,iplot]+.06, lval, /normal, color=8, charsize=.5, align=1

  loadct, 0
  polyfill, [.02,.32,.32,.02,.02], [.5,.5,.64,.64,.5], color=255, /normal
  makekey, .02, .6, .3, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(11,val=0), $
           label=[' ','-10','-5','-2','-1','-0.1','0.1','1','2','5','10']
  tvlct, red, green, blue
  makekey, .02, .6, .3, .03, 0, -.04, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']

; DIFFERENCE PLOT
  datafil = '/misc/prc14/colarco/c360R_H53-acma/geosgcm_surf/c360R_H53-acma.geosgcm_surf.monthly.clim.JJA.c.nc4'
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  tau = reform(tau[*,*,0]-tau[*,*,1])
  tau_base = tau
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(11,val=0), $
           label=[' ','-2','-1','-0.5','-0.2','-0.1','0.1','0.2','0.5','1','2']
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,191,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-2,-1,-0.5,-.2,-.1,.1,.2,0.5,1,2]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']


; 
  iplot = 1
  datafil = datafils[iplot]
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  tau = reform(tau[*,*,0]-tau[*,*,1])
  tau = tau-tau_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  diff = position[2,iplot]-position[0,iplot]
  a = where(lwi lt .1)
  oval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[0,iplot]+diff/10., position[1,iplot]+.06, oval, /normal, color=1, charsize=.5
  a = where(lwi gt .9 and lwi lt 1.1)
  lval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[2,iplot]-diff/10, position[1,iplot]+.06, lval, /normal, color=8, charsize=.5, align=1



; 
  iplot = 2
  datafil = datafils[iplot]
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  tau = reform(tau[*,*,0]-tau[*,*,1])
  tau = tau-tau_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  diff = position[2,iplot]-position[0,iplot]
  a = where(lwi lt .1)
  oval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[0,iplot]+diff/10., position[1,iplot]+.06, oval, /normal, color=1, charsize=.5
  a = where(lwi gt .9 and lwi lt 1.1)
  lval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[2,iplot]-diff/10, position[1,iplot]+.06, lval, /normal, color=8, charsize=.5, align=1


;
  iplot = 3
  datafil = datafils[iplot]
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  tau = reform(tau[*,*,0]-tau[*,*,1])
  tau = tau-tau_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  diff = position[2,iplot]-position[0,iplot]
  a = where(lwi lt .1)
  oval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[0,iplot]+diff/10., position[1,iplot]+.06, oval, /normal, color=1, charsize=.5
  a = where(lwi gt .9 and lwi lt 1.1)
  lval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[2,iplot]-diff/10, position[1,iplot]+.06, lval, /normal, color=8, charsize=.5, align=1


; 
  iplot = 4
  datafil = datafils[iplot]
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  tau = reform(tau[*,*,0]-tau[*,*,1])
  tau = tau-tau_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  diff = position[2,iplot]-position[0,iplot]
  a = where(lwi lt .1)
  oval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[0,iplot]+diff/10., position[1,iplot]+.06, oval, /normal, color=1, charsize=.5
  a = where(lwi gt .9 and lwi lt 1.1)
  lval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[2,iplot]-diff/10, position[1,iplot]+.06, lval, /normal, color=8, charsize=.5, align=1


; 
  iplot = 5
  datafil = datafils[iplot]
  nc4readvar, datafil, ['swtnet','swtnetna'], tau, lon=lon, lat=lat, lev=lev
  tau = reform(tau[*,*,0]-tau[*,*,1])
  tau=tau-tau_base
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, tau, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  diff = position[2,iplot]-position[0,iplot]
  a = where(lwi lt .1)
  oval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[0,iplot]+diff/10., position[1,iplot]+.06, oval, /normal, color=1, charsize=.5
  a = where(lwi gt .9 and lwi lt 1.1)
  lval  = string(total(area[a]*tau[a])/total(area[a]),format='(f6.3)')+' W m!E-2!N'
  xyouts, position[2,iplot]-diff/10, position[1,iplot]+.06, lval, /normal, color=8, charsize=.5, align=1



  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.6,.6,.63,.63,.6], color=0, /normal, thick=2
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
