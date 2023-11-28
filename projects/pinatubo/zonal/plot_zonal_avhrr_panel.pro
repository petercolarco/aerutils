; Colarco
; Make a six-panel plot of the AVHRR optical depths with the volcanic
; simulations I've performed

  set_plot, 'ps'
  device, file='plot_zonal_avhrr_panel.c48F_gocart.ps', $
   /color, /helvetica, font_size=10, $
   xsize=40, ysize=18, xoff=.5, yoff=.5
  !p.font=0

; Model experiments to show
  expid = ['c48F_H43_pinatubo15+sulfate.tavg2d_aer_x', $
           'c48Fc_H43_pinatubo15+sulfate.tavg2d_carma_x', $
           'c48Fc_H43_pinatubo15v2.tavg2d_aer_x', $
           'c48Fc_H43_pinatubo15v2+sulfate.tavg2d_aer_x', $
           'c48Fc_H43_pin15+sulf+cerro.tavg2d_aer_x']

; Set up a six-element array of the positions for individual panels
  position = [ [.05,.6,.325,.95], [.375,.6,.65,.95], [.7,.6,.975,.95], $
               [.05,.15,.325,.5], [.375,.15,.65,.5], [.7,.15,.975,.5] ]

; Get the AVHRR observations and set up the time
; Data is total aerosol loading, monthly (56 months) beginning July
; 1989 as a zonal mean with 141 latitudes from -70 to 70 (so, 1 degree)
  area, lon, lat, nx, ny, dx, dy, area, grid='c'
  openr, lun, 'avhrr_aot_monthly', /get
  inp = fltarr(141,56)
  readu, lun, inp
  free_lun, lun
; Put the data on regular grid and do area weighted average
  avhrr = make_array(ny,56,val=-999.)
  avhrr[20:160,*] = inp
  a = where(avhrr lt 0)
  avhrr[a] = !values.f_nan
; June 90 - May 91
  base_avhrr = avhrr[*,11:22]
; Add in Jul 89 - May 90 and average
  base_avhrr[*,1:11] = (base_avhrr[*,1:11]+avhrr[*,0:10])/2.
  avhrr[*,11:22] = avhrr[*,11:22] - base_avhrr
  avhrr[*,23:34] = avhrr[*,23:34] - base_avhrr
  avhrr[*,35:46] = avhrr[*,35:46] - base_avhrr
  avhrr[*,47:55] = avhrr[*,47:55] - base_avhrr[*,0:9]
  avhrr = transpose(avhrr)
; Give a time coordinate -- May 1991 = 0
  xavhrr = findgen(56)-22.
  x = indgen(29)
  x = xavhrr
  xmax = 28
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']



; Plot the AVHRR observations  loadct, 3
  ipos = 2
  loadct, 3
  levels = [0,3,6,9,12,15,18,21,25,30,40]/100.
  colors = 255-findgen(11)*15
  contour, avhrr, x, lat, /nodata, $
   position=position[*,ipos], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  contour, avhrr, x, lat, /over, $
   levels=levels, c_color=colors, /cell
  contour, avhrr, x, lat, /over, $
   levels=levels

  contour, avhrr, x, lat, /nodata, noerase=1, $
   position=position[*,ipos], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
;  xyouts, .15, .92, 'Sulfate AOT (Pinatubo)', /normal

; Now cycle on model experiments to compare and plot
  ipos = [0,1,3,4,5]
  for iexpid = 0, 4 do begin
   filetemplate = expid[iexpid]+'.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   a = where(nymd ge '19910500' and nymd le '19931000')
   nymd = nymd[a]
   x = indgen(n_elements(nymd))
   filename = filename[a]
   vars = ['suexttau','suexttauvolc']
   if(strpos(filename[0],'tavg2d_carma_x') ne -1) then vars = ['suexttau']
   nc4readvar, filename, vars, su, lon=lon, lat=lat, /sum
   nt = n_elements(a)
;  zonal mean and transpose
   su = transpose(total(su,1)/n_elements(lon))
;  Now mask with AVHRR
   area, lon, lat, nx, ny, dx, dy, area, grid='c'
;  Make model look like c-grid result
   su_ = fltarr(nt,181)
   su_[*,0] = su[*,0]
   for iy = 1, 90 do begin
    su_[*,2*iy-1] = su[*,iy]
    su_[*,2*iy]   = su[*,iy]
   endfor
   for it = 0, nt-1 do begin
    iit = where(xavhrr eq it)
    a = where(finite(avhrr[iit[0],*]) ne 1)
    su_[it,a] = !values.f_nan
   endfor
   su = su_

  contour, su, x, lat, /nodata, /noerase, $
   position=position[*,ipos[iexpid]], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  contour, su, x, lat, /over, $
   levels=levels, c_color=colors, /cell
  contour, su, x, lat, /over, $
   levels=levels

  contour, su, x, lat, /nodata, noerase=1, $
   position=position[*,ipos[iexpid]], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  endfor

  makekey, .3, .06, .4, .03, 0., -0.025, color=colors, chars=1.25, $
           labels=string(levels,format='(f4.2)'), align=0

  device, /close

end
