; Make a plot of misr annual mean AOT from MISR and sub-sampled model
; results

; Setup the plot
  set_plot, 'ps'
  device, file='plot_supso4aq_all_diff.ps', /color, /helvetica, font_size=16, $
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

  datafils = ['/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90Rreg_H54p3-acma/tavg2d_aer_x/c90Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48Rreg_H54p3-acma/tavg2d_aer_x/c48Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c180F_H54p3-acma/tavg2d_aer_x/c180F_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90F_H54p3-acma/tavg2d_aer_x/c90F_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48F_H54p3-acma/tavg2d_aer_x/c48F_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.nc4' ]


  titles   = ['Rreg!U1/2!S!Eo!N', $
              'Rreg!U1!S!Eo!N', $
              'Rreg!U2!S!Eo!N', $
              'F!U1/2!S!Eo!N', $
              'F!U1!S!Eo!N', $
              'F!U2!S!Eo!N']


; Baseline
  iplot = 0
  datafil = datafils[iplot]
  nc4readvar, datafil, ['supso4aq'], duem, lon=lon, lat=lat, lev=lev
  duem = duem*365.*86400.*1000.   ; g m-2 yr-1
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format='(f6.2)', $
            varscale=1.e-12, /varsum, varunits=' Tg'
  loadct, 0
  polyfill, [.02,.32,.32,.02,.02], [.5,.5,.64,.64,.5], color=255, /normal
  makekey, .02, .6, .3, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), label=['0.1','0.2','0.4','0.7','1','2','4']
  xyouts, .32, .56, 'g m!E-2!N yr!E-1!N', charsize=.6, /normal
  tvlct, red, green, blue
  makekey, .02, .6, .3, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

; DIFFERENCE PLOT
  duem_base = duem
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(13,val=0), label=[' ','-1','-0.5','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
  xyouts, .75, .03, 'g m!E-2!N yr!E-1!N', charsize=.6, /normal
  red   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
  green = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
  blue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-1,-.5,-.2,-.1,-.05,-0.02,-.01,.01,0.02,.05,.1,.2]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','','','']

; Get the b-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, ['supso4aq'], duem_b, lon=lon, lat=lat, lev=lev
  duem_b = duem_b*365.*86400.*1000.
  duem_base_b = duem_b

; Get the c-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg2d_aer_x/c180Rreg_H54p3-acma.tavg2d_aer_x.monthly.clim.ANN.c.nc4'
  nc4readvar, datafil, ['supso4aq'], duem_c, lon=lon, lat=lat, lev=lev
  duem_c = duem_c*365.*86400.*1000.
  duem_base_c = duem_c

  for iplot = 1, 5 do begin

   nc4readvar, datafils[iplot], ['supso4aq'], duem, lon=lon, lat=lat, lev=lev
   duem = duem*365.*86400.*1000.   ; g m-2 yr-1
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
             textcolor=iblack, title=title, format='(f6.2)', $
             varscale=1.e-12, /varsum, varunits=' Tg'
  endfor

  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.6,.6,.63,.63,.6], color=0, /normal, thick=2
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
