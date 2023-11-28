  filetemplate = 'H40Fc48aura2.tavg3d_carma_p.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  nc4readvar, filename, 'suextcoef', su, lon=lon, lat=lat, lev=lev

  a = where(su gt 1e14)
  su[a] = !values.f_nan

; What latitude band to sample
  a = where(lat ge -20 and lat lt 0)

; straight zonal mean
  su_zonal = mean(su,dimension=1,/nan)
  su_zonal = transpose(mean(su_zonal[a,*,*], dimension=1,/nan))*1e6

; zonal mean sampled every 20 pts
  su_zonal_20 = mean(su[0:143:20,*,*,*],dimension=1,/nan)
  su_zonal_20 = transpose(mean(su_zonal_20[a,*,*], dimension=1,/nan))*1e6

; zonal mean sampled every 10 pts
  su_zonal_10 = mean(su[0:143:10,*,*,*],dimension=1,/nan)
  su_zonal_10 = transpose(mean(su_zonal_10[a,*,*], dimension=1,/nan))*1e6

; zonal mean sampled every 5 pts
  su_zonal_5 = mean(su[0:143:5,*,*,*],dimension=1,/nan)
  su_zonal_5 = transpose(mean(su_zonal_5[a,*,*], dimension=1,/nan))*1e6

; Get an altitude profile
  presaltnew, lev, z, rhoa, t, 99999.

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=['0.05','0.1','0.2','0.5','1','1.5','2'], $
   colors=make_array(7,val=0), align=0
  loadct, 64
  levels=[.05,.1,.2,.5,1,1.5,2]
  colors=indgen(7)*40
  contour, su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_20.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal_20, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=['0.05','0.1','0.2','0.5','1','1.5','2'], $
   colors=make_array(7,val=0), align=0
  loadct, 64
  levels=[.05,.1,.2,.5,1,1.5,2]
  colors=indgen(7)*40
  contour, su_zonal_20, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_10.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal_10, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=['0.05','0.1','0.2','0.5','1','1.5','2'], $
   colors=make_array(7,val=0), align=0
  loadct, 64
  levels=[.05,.1,.2,.5,1,1.5,2]
  colors=indgen(7)*40
  contour, su_zonal_10, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_5.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal_5, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=['0.05','0.1','0.2','0.5','1','1.5','2'], $
   colors=make_array(7,val=0), align=0
  loadct, 64
  levels=[.05,.1,.2,.5,1,1.5,2]
  colors=indgen(7)*40
  contour, su_zonal_5, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(7,val=' '), $
   colors=colors


;
;
; Make some difference plots
; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_20.diff.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal_20-su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.035, $
   labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
           '0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
  colors=indgen(13)*20
  contour, su_zonal_20-su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_10.diff.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal_10-su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.035, $
   labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
           '0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
  colors=indgen(13)*20
  contour, su_zonal_10-su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_5.diff.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, su_zonal_5-su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.035, $
   labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
           '0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
  colors=indgen(13)*20
  contour, su_zonal_5-su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors

  device, /close

;
;
; Make some fractional difference plots
; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_20.frac.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, (su_zonal_20-su_zonal)/su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.035, $
   labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
           '0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
  colors=indgen(13)*20
  contour, (su_zonal_20-su_zonal)/su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_10.frac.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, (su_zonal_10-su_zonal)/su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.035, $
   labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
           '0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
  colors=indgen(13)*20
  contour, (su_zonal_10-su_zonal)/su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors

; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_5.frac.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, (su_zonal_5-su_zonal)/su_zonal, findgen(59), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,60], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.035, $
   labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
           '0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
  colors=indgen(13)*20
  contour, (su_zonal_5-su_zonal)/su_zonal, findgen(59), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors


  device, /close

end
