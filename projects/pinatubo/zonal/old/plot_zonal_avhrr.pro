; Get AVHRR data
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
  su = transpose(avhrr)
; Give a time coordinate -- May 1991 = 0
  xavhrr = findgen(56)-22.

  x = indgen(29)
  x = xavhrr
  xmax = 28
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_avhrr.ps', $
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

