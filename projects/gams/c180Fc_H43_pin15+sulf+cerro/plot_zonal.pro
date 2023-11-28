; Colarco, April 2016
; Get vertical extinction profile

  filetemplate = 'c180Fc_H43_pin15+sulf+cerro.tavg3d_carma_p.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 19910901L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  nc4readvar, filename, 'suextcoef', su, lon=lon, lat=lat, lev=lev

  nx = n_elements(lon)
  ny = n_elements(lat)

  a = where(su gt 1e14)
  su[a] = !values.f_nan

; What latitude band to sample
  a = where(lat ge -10 and lat lt 10)
  a = where(lat ge -40 and lat lt -30)

; Get an altitude profile
  presaltnew, lev, z, rhoa, t, 99999.

; Make a plot for different spacings
  deltax = [1,12.,24.,48.]   ; native, 7.5, 15, and 30 degree spacing
  for i = 0, 3 do begin

;  straight zonal mean
   su_zonal = mean(su,dimension=1,/nan)
   su_zonal = transpose(mean(su_zonal[a,*,*], dimension=1,/nan))*1e6

;  sampled zonal mean
   su_zonal_sam = mean(su[0:nx-1:deltax[i],*,*,*],dimension=1,/nan)
   su_zonal_sam = transpose(mean(su_zonal_sam[a,*,*], dimension=1,/nan))*1e6


;  Make a plot
   set_plot, 'ps'
   lab = strpad(deltax[i],10)
   device, file='plot_zonal_'+lab+'.ps', /helvetica, font_size=14, /color, $
    xsize=16, ysize=12, xoff=.5, yoff=.5
   !p.font=0

   levels=[.1,.2,.5,1,2,5,10,20,30]
   levarr=['0.1','0.2','0.5','1','2','5','10','20','30']
   colors=indgen(9)*30


   loadct, 0
   contour, su_zonal_sam, findgen(92), z, /nodata, $
    yrange=[10,40], ytitle='Altitude [km]', $
    xrange=[-1,91], xticks=1, xminor=1, xtickn=[' ', ' '], $
    xstyle=1, ystyle=1, $
    position=[.15,.25,.95,.95], $
    levels=levels, c_colors=colors, /cell
   makekey, .15, .1, .8, .05, 0, -.05, $
    labels=levarr, $
    colors=make_array(n_elements(colors),val=0), align=0
   loadct, 64
   contour, su_zonal_sam, findgen(92), z, /overplot, $
    levels=levels, c_colors=colors, /cell
   makekey, .15, .1, .8, .05, 0, -.05, $
    labels=make_array(n_elements(colors),val=' '), $
    colors=colors
   device, /close


;
;
; Make some difference plots
; Make a plot
   set_plot, 'ps'
   device, file='plot_zonal_'+lab+'.diff.ps', /helvetica, font_size=14, /color, $
    xsize=16, ysize=12, xoff=.5, yoff=.5
   !p.font=0

   loadct, 0
   contour, su_zonal_sam-su_zonal, findgen(92), z, /nodata, $
    yrange=[10,40], ytitle='Altitude [km]', $
    xrange=[-1,91], xticks=1, xminor=1, xtickn=[' ', ' '], $
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
   contour, su_zonal_sam-su_zonal, findgen(92), z, /overplot, $
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
  device, file='plot_zonal_'+lab+'.frac.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, (su_zonal_sam-su_zonal)/su_zonal, findgen(92), z, /nodata, $
   yrange=[10,40], ytitle='Altitude [km]', $
   xrange=[-1,91], xticks=1, xminor=1, xtickn=[' ', ' '], $
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
  contour, (su_zonal_sam-su_zonal)/su_zonal, findgen(92), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .1, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors
  device, /close

  endfor

end
