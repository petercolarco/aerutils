  expid = 'c90Fc_H54p3_pin'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, ['suexttau'], su, lon=lon, lat=lat, /sum
  nt = n_elements(a)

  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

; zonal mean and transpose
  su = transpose(total(su,1)/n_elements(lon))

; Now mask with the AVHRR
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
  xavhrr = findgen(56)-22.
;; Make model look like c-grid result
;  su_ = fltarr(nt,181)
;  su_[*,0] = su[*,0]
;  for iy = 1, 90 do begin
;   su_[*,2*iy-1] = su[*,iy]
;   su_[*,2*iy]   = su[*,iy]
;  endfor
;  for it = 0, nt-1 do begin
;   iit = where(xavhrr eq it)
;   a = where(finite(avhrr[iit[0],*]) ne 1)
;   su_[it,a] = !values.f_nan
;  endfor
;  su = su_
  for it = 0, nt-1 do begin
   iit = where(xavhrr eq it)
   a = where(finite(avhrr[iit[0],*]) ne 1)
   su[it,a] = !values.f_nan
  endfor


; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_carma.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=18, ysize=7.2, xoff=.5, yoff=.5
  !p.font=0

  loadct, 3
  levels = [0,3,6,9,12,15,18,21,25,30,40]/100.
  colors = 255-findgen(11)*15
  contour, su, x, lat, /nodata, $
   position=[.15,.2,.95,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  contour, su, x, lat, /over, $
   levels=levels, c_color=colors, /cell
  contour, su, x, lat, /over, $
   levels=levels

  contour, su, x, lat, /nodata, noerase=1, $
   position=[.15,.2,.95,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
;  xyouts, .15, .92, 'Sulfate AOT (Pinatubo)', /normal

  makekey, .15, .06, .8, .04, 0., -0.05, color=colors, $
           labels=string(levels,format='(f4.2)'), align=0

  device, /close

end

