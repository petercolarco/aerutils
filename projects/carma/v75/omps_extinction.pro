; Colarco, November 2018
; Adapted from reader of files from Ghassan Taha for gridded OMPS LP
; 675 v1.5 algorithm extinction (returned in units of Mm-1)

; Use grads DDF to get the filenames
  filetemplate = 'omps.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  read_omps, filename, ext675, extstd, lon, lat, alt, troph

; Average zonally and temporally
  ext675 = mean(ext675,dim=4,/nan)
  ext675 = mean(ext675,dim=1,/nan)

  set_plot, 'ps'
  device, file='omps_extinction.2016.ps', /color, $
    /helvetica, font_size=12, xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  xrange=[-90,90]
  yrange=[15,35]

  levels = findgen(11)*.08
  dcolors = indgen(11)*25

  latarray = -90+indgen(180)
  loadct, 0
  contour, ext675, lat, alt, /nodata, $
   position=[.1,.2,.9,.9], $
   xrange=xrange, yrange=yrange, xstyle=1, ystyle=9, xticks=6
  loadct, 52
  contour, /over, ext675, lat, alt, levels=levels, c_colors=colors, /cell
  loadct, 0
  contour, ext675, lat, alt, /nodata, /noerase, $
   title = 'OMPS-LP Extinction Coefficient [Mm!E-1!N]', $
   position=[.1,.2,.9,.9], xtitle='latitude (degrees)', ytitle = 'Altitude [km]', $
   xrange=xrange, yrange=yrange, xstyle=1, ystyle=9, xticks=6
  axis, yaxis=1, yrange=[120,5], /ylog, /save, ystyle=1, ytitle='pressure [hPa]'

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(f4.2)')
  loadct, 52
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close


end
