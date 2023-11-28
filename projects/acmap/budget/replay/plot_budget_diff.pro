; Colarco
; Generic call to plot six-panel baseline and difference plots

; Variable desired
  var = 'supso4wet'

; Experiments (first one is baseline)
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

; Colors and levels
  case var of
   'duem': begin
           vars = ['duem001','duem002','duem003','duem004','duem005']
           red   = [255,254,254,253,252,227,177, 152, 0]
           green = [255,217,178,141,78,26,0    , 152, 0]
           blue  = [178,178,76,60,42,28,38     , 152, 0]
           levels = [.01,.02,.05,.1,.2,.3,.5]
           labels = ['0.01','0.02','0.05','0.1','0.2','0.3','0.5']
           dred   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
           dgreen = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
           dblue  = [162,189,16,164,152,255,139,97,67,79,66  ,152,0]
           dlevels = [-2000,-.1,-.05,-0.02,-0.01,-.005,.005,0.01,0.02,.1,.2]
           dlabels = [' ','-0.1','-0.05','-0.02','-0.01','-0.005','0.005','0.01','0.02','0.1','0.2']
           scale = 365.*86400.
           unitstr = 'kg m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(f7.2)'
           varscale = 1.e-9
        end
   'ssem': begin
           vars = ['ssem001','ssem002','ssem003','ssem004','ssem005']
           red   = [255,199,127,65,29,34,12,     152, 0]
           green = [255,233,205,182,145,94,44,   152, 0]
           blue  = [204,180,187,196,192,168,132, 152, 0]
           levels = [.001,.002,.004,.007,.01,.02,.04]
           labels = ['0.001','0.002','0.004','0.007','0.01','0.02','0.04']
           dred   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
           dgreen = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
           dblue  = [162,189,16,164,152,255,139,97,67,79,66  ,152,0]
           dlevels = [-2000,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]/10.
           dlabels = [' ','-0.01','-0.005','-0.003','-0.002','-0.001','0.001','0.002','0.003','0.005','0.01']
           scale = 365.*86400.
           unitstr = 'kg m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(i5)'
           varscale = 1.e-9
        end
   'ocem': begin
           vars = ['ocem001','ocem002']
           red   = [255,254,254,253,252,227,177, 152, 0]
           green = [255,217,178,141,78,26,0    , 152, 0]
           blue  = [178,178,76,60,42,28,38     , 152, 0]
           levels = [.001,.002,.004,.007,.01,.02,.04]
           labels = ['0.001','0.002','0.004','0.007','0.01','0.02','0.04']
           dred   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
           dgreen = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
           dblue  = [162,189,16,164,152,255,139,97,67,79,66  ,152,0]
           dlevels = [-2000,-.1,-.05,-0.03,-0.02,-.01,.01,0.02,0.03,.05,.1]/10.
           dlabels = [' ','-0.01','-0.005','-0.003','-0.002','-0.001','0.001','0.002','0.003','0.005','0.01']
           scale = 365.*86400.
           unitstr = 'kg m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(f7.2)'
           varscale = 1.e-9
        end
   'supd': begin
           vars = ['supso4g','supso4aq','supso4wt']
           red   = [255,199,127,65,29,34,12,     152, 0]
           green = [255,233,205,182,145,94,44,   152, 0]
           blue  = [204,180,187,196,192,168,132, 152, 0]
           levels = [.1,.2,.4,.7,1,2,4]
           labels = ['0.1','0.2','0.4','0.7','1','2','4']
           dred   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
           dgreen = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
           dblue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
           dlevels = [-2000,-1.,-.5,-.2,-.1,-.05,-0.02,-.01,.01,0.02,.05,.1,.2]
           dlabels = [' ','-1','-0.5','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
           scale = 365.*86400.*1000. ; g m-2 yr-1
           unitstr = 'g m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(f6.2)'
           varscale = 1.e-12
        end
   'supso4g': begin
           vars = ['supso4g']
           red   = [255,199,127,65,29,34,12,     152, 0]
           green = [255,233,205,182,145,94,44,   152, 0]
           blue  = [204,180,187,196,192,168,132, 152, 0]
           levels = [.1,.2,.4,.7,1,2,4]
           labels = ['0.1','0.2','0.4','0.7','1','2','4']
           dred   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
           dgreen = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
           dblue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
           dlevels = [-2000,-1.,-.5,-.2,-.1,-.05,-0.02,-.01,.01,0.02,.05,.1,.2]
           dlabels = [' ','-1','-0.5','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
           scale = 365.*86400.*1000. ; g m-2 yr-1
           unitstr = 'g m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(f6.2)'
           varscale = 1.e-12
        end
   'supso4aq': begin
           vars = ['supso4aq']
           red   = [255,199,127,65,29,34,12,     152, 0]
           green = [255,233,205,182,145,94,44,   152, 0]
           blue  = [204,180,187,196,192,168,132, 152, 0]
           levels = [.1,.2,.4,.7,1,2,4]
           labels = ['0.1','0.2','0.4','0.7','1','2','4']
           dred   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
           dgreen = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
           dblue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
           dlevels = [-2000,-1.,-.5,-.2,-.1,-.05,-0.02,-.01,.01,0.02,.05,.1,.2]
           dlabels = [' ','-1','-0.5','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
           scale = 365.*86400.*1000. ; g m-2 yr-1
           unitstr = 'g m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(f6.2)'
           varscale = 1.e-12
        end
   'supso4wet': begin
           vars = ['supso4aq','supso4wt']
           red   = [255,199,127,65,29,34,12,     152, 0]
           green = [255,233,205,182,145,94,44,   152, 0]
           blue  = [204,180,187,196,192,168,132, 152, 0]
           levels = [.1,.2,.4,.7,1,2,4]
           labels = ['0.1','0.2','0.4','0.7','1','2','4']
           dred   = [12,34,29,65,127,199,255,      255,254,253,244,213,158,152,0]
           dgreen = [44,94,145,182,205,233,255,    255,224,174,109,62,1   ,152,0]
           dblue  = [132,168,192,196,187,180,204,  255,139,97,67,79,66    ,152,0]
           dlevels = [-2000,-1.,-.5,-.2,-.1,-.05,-0.02,-.01,.01,0.02,.05,.1,.2]
           dlabels = [' ','-1','-0.5','-0.2','-0.1','-0.05','-0.02','-0.01','0.01','0.02','0.05','0.1','0.2']
           scale = 365.*86400.*1000. ; g m-2 yr-1
           unitstr = 'g m!E-2!N yr!E-1!N'
           unitstrt = ' Tg'
           formatstr = '(f6.2)'
           varscale = 1.e-12
        end
  endcase


; Setup the plot
  set_plot, 'ps'
  device, file='plot_'+var+'_all_diff.ps', /color, /helvetica, font_size=16, $
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
  tvlct, red, green, blue
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

; Baseline
  iplot = 0
  datafil = datafils[iplot]
  nc4readvar, datafil, vars, duem, lon=lon, lat=lat, lev=lev, /sum
  duem = duem*scale
  area, lon, lat, nx, ny, dx, dy, area
  title = titles[iplot]
  plot_map, duem, lon, lat, dx, dy, levels, dcolors, $
            position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
            textcolor=iblack, title=title, format=formatstr, $
            varscale=varscale, /varsum, varunits=unitstrt
  loadct, 0
  polyfill, [.02,.32,.32,.02,.02], [.5,.5,.64,.64,.5], color=255, /normal
  makekey, .02, .6, .3, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), label=labels
  xyouts, .32, .56, unitstr, charsize=.6, /normal
  tvlct, red, green, blue
  makekey, .02, .6, .3, .03, 0, -.02, /noborder, $
     color=dcolors, label=make_array(n_elements(labels)+1,val='')

; DIFFERENCE PLOT
  duem_base = duem
  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(n_elements(dlabels),val=0), label=dlabels
  xyouts, .75, .03, unitstr, charsize=.6, /normal
  tvlct, dred, dgreen, dblue
  dcolors=indgen(n_elements(dlevels))
  igrey  = n_elements(dred)-2
  iblack = n_elements(dred)-1

  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=make_array(n_elements(dlabels)+1,val='')

; Get the b-resolution
  datafil_ = strmid(datafils[0],0,strlen(datafils[0])-4)
  datafil = datafil_+'.b.nc4'
  nc4readvar, datafil, vars, duem_b, lon=lon, lat=lat, lev=lev, /sum
  duem_b = duem_b*scale
  duem_base_b = duem_b

; Get the c-resolution
  datafil = datafil_+'.c.nc4'
  nc4readvar, datafil, vars, duem_c, lon=lon, lat=lat, lev=lev, /sum
  duem_c = duem_c*scale
  duem_base_c = duem_c

  for iplot = 1, 5 do begin

   nc4readvar, datafils[iplot], vars, duem, lon=lon, lat=lat, lev=lev, /sum
   duem = duem*scale
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
   plot_map, duem, lon, lat, dx, dy, dlevels, dcolors, $
             position[*,iplot], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title, format=formatstr, $
             varscale=varscale, /varsum, varunits=unitstrt
  endfor

  loadct, 0
  plots, [.02,.32,.32,.02,.02], [.6,.6,.63,.63,.6], color=0, /normal, thick=2
  plots, [.25,.75,.75,.25,.25], [.07,.07,.1,.1,.07], color=0, /normal, thick=2


  device, /close

end
