; Colarco, April 2016
; Get vertical extinction profile

  filetemplate = 'H43F2010gocart2.tavg3d_carma_p.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 20120601L)
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
;  a = where(lat ge -10 and lat lt 10)
  a = where(lat ge 30 and lat lt 40)

; Get an altitude profile
  presaltnew, lev, z, rhoa, t, 99999.

; Make a plot for different spacings
  deltax = [1,3.,6.,9.,12.]   ; native, 7.5, 15, 22.5, and 30 degree spacing
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
    xsize=24, ysize=12, xoff=.5, yoff=.5
   !p.font=0

   levels=[.1,.2,.5,1,2,5,10,20,30]
   levext = levels
   levarr=['0.1','0.2','0.5','1','2','5','10','20','30']
   colors=indgen(9)*30


   loadct, 0
   contour, su_zonal_sam, findgen(nf), z, /nodata, $
    yrange=[10,25], ytitle='Altitude [km]', $
    xrange=[-1,nf], xticks=1, xminor=1, xtickn=[' ', ' '], $
    xstyle=1, ystyle=1, yticks=3, yminor=5, $
    position=[.15,.25,.95,.95], $
    levels=levels, c_colors=colors, /cell
   makekey, .15, .15, .8, .05, 0, -.05, $
    labels=levarr, $
    colors=make_array(n_elements(colors),val=0), align=0
   loadct, 64
   contour, su_zonal_sam, findgen(nf), z, /overplot, $
    levels=levels, c_colors=colors, /cell
   makekey, .15, .15, .8, .05, 0, -.05, $
    labels=make_array(n_elements(colors),val=' '), $
    colors=colors
   contour, su_zonal_sam, findgen(nf), z, /overplot, $
    levels=levext
   loadct, 0
   xtickv = where(strmid(nymd,6,2) eq '01')
   xticks = n_elements(xtickv)
   contour, su_zonal_sam, findgen(nf), z, /nodata, /noerase, $
    yrange=[10,25], yticks=1, ytickn=[' ',' '], $
    xrange=[-1,nf], xticks=xticks-1, xtickv=xtickv, $
    xtickn=make_array(xticks,val=' '), $
    xstyle=1, ystyle=1, $
    position=[.15,.25,.95,.95], $
    levels=levels, c_colors=colors, /cell
   xyouts, xtickv, 9.5, nymd[xtickv], align=0, charsize=.5
   device, /close


;
;
; Make some difference plots
; Make a plot
   set_plot, 'ps'
   device, file='plot_zonal_'+lab+'.diff.ps', /helvetica, font_size=14, /color, $
    xsize=24, ysize=12, xoff=.5, yoff=.5
   !p.font=0

   loadct, 0
   contour, su_zonal_sam-su_zonal, findgen(nf), z, /nodata, $
    yrange=[10,25], ytitle='Altitude [km]', $
    xrange=[-1,nf], xticks=1, xminor=1, xtickn=[' ', ' '], $
    xstyle=1, ystyle=1, yticks=3, yminor=5, $
    position=[.15,.25,.95,.95], $
    levels=levels, c_colors=colors, /cell
   makekey, .15, .15, .8, .05, 0, -.035, $
    labels=[' ','-0.5','-0.2','-0.1','-0.05','-0.02',$
            '-0.01','0.01','0.02','0.05','0.1','0.2','0.5'], $
    colors=make_array(13,val=0), align=.5, charsize=.65
   loadct, 66
   levels=[-2000.,-.5,-.2,-.1,-.05,-.02,-.01,0.01,0.02,0.05,.1,.2,.5]
   colors=indgen(13)*20
   contour, su_zonal_sam-su_zonal, findgen(nf), z, /overplot, $
    levels=levels, c_colors=colors, /cell
   makekey, .15, .15, .8, .05, 0, -.05, $
    labels=make_array(13,val=' '), $
    colors=colors
   contour, su_zonal_sam, findgen(nf), z, /overplot, $
    levels=levext
   loadct, 0
   contour, su_zonal_sam, findgen(nf), z, /nodata, /noerase, $
    yrange=[10,25], yticks=1, ytickn=[' ',' '], $
    xrange=[-1,nf], xticks=xticks-1, xtickv=xtickv, $
    xtickn=make_array(xticks,val=' '), $
    xstyle=1, ystyle=1, $
    position=[.15,.25,.95,.95], $
    levels=levels, c_colors=colors, /cell
   xyouts, xtickv, 9.5, nymd[xtickv], align=0, charsize=.5
   device, /close

;
;
; Make some fractional difference plots
; Make a plot
  set_plot, 'ps'
  device, file='plot_zonal_'+lab+'.frac.ps', /helvetica, font_size=14, /color, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  contour, (su_zonal_sam-su_zonal)/su_zonal*100, findgen(nf), z, /nodata, $
   yrange=[10,25], ytitle='Altitude [km]', $
   xrange=[-1,nf], xticks=1, xminor=1, xtickn=[' ', ' '], $
   xstyle=1, ystyle=1, yticks=3, yminor=5, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .15, .8, .05, 0, -.035, $
   labels=[' ','-50','-20','-10','-5','-2',$
           '-1','1','2','5','10','20','50'], $
   colors=make_array(13,val=0), align=.5, charsize=.65
  loadct, 66
  levels=[-2000.,-50,-20,-10,-5,-2,-1,1,2,5,10,20,50]
  colors=indgen(13)*20
  contour, (su_zonal_sam-su_zonal)/su_zonal*100, findgen(nf), z, /overplot, $
   levels=levels, c_colors=colors, /cell
  makekey, .15, .15, .8, .05, 0, -.05, $
   labels=make_array(13,val=' '), $
   colors=colors
  contour, su_zonal_sam, findgen(nf), z, /overplot, $
   levels=levext
  loadct, 0
  contour, su_zonal_sam, findgen(nf), z, /nodata, /noerase, $
   yrange=[10,25], yticks=1, ytickn=[' ',' '], $
   xrange=[-1,nf], xticks=xticks-1, xtickv=xtickv, $
   xtickn=make_array(xticks,val=' '), $
   xstyle=1, ystyle=1, $
   position=[.15,.25,.95,.95], $
   levels=levels, c_colors=colors, /cell
  xyouts, xtickv, 9.5, nymd[xtickv], align=0, charsize=.5
  device, /close

  endfor

end
