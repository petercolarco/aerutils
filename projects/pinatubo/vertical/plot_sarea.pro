; Make a plot of sulfate surface area density
; susarea from model is m2 m-3, conversion to um2 cm-3
  fac = 1.e12/1.e6
  latr = [-90,-60]


; Get the model fields
  expid = ['c48Fc_H43_pinatubo15',  'c48Fc_H43_pinatubo15+sulfate', 'c48Fc_H43_pinatubo15v2', $
           'c48Fc_H43_pinatubo15v2+sulfate', 'c48Fc_H43_pin15+sulf+cerro']
  ipos = [0,1,3,4,5]

  nexpid = n_elements(expid)
  for iexpid = 0, nexpid-1 do begin
   area, lon, lat, nx, ny, dx, dy, area, grid='b'
   filetemplate = expid[iexpid]+'.tavg3d_carma_p.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   a = where(nymd ge '19910500' and nymd le '19931000')
   nymd = nymd[a]
   filename = filename[a]
   nc4readvar, filename, 'susarea', sus_, lon=lon, lat=lat, lev=lev
   nt = n_elements(a)
   nz = n_elements(lev)
   sus = sus_*fac

;  zonal mean
   sus = reform(total(sus,1)/nx)

;  Now average in latitude band
   a    = where(lat le max(latr) and lat ge min(latr))
   sus  = sus[a,*,*]
   area = reform(area[0,a])
   for it = 0, nt-1 do begin
    for iz = 0, nz-1 do begin
     sus[*,iz,it] = sus[*,iz,it]*area
    endfor
   endfor
   sus = reform(total(sus,1))/total(area)
   sus = transpose(sus)
   a = where(sus gt 1e10)
   sus[a] = !values.f_nan

   if(iexpid eq 0) then susarea = fltarr(nt,nz,nexpid)
   susarea[*,*,iexpid] = sus
  endfor

  set_plot, 'ps'
  device, file='plot_sarea_carma.ps', $
    /helvetica, font_size=10, /color, $
    xsize=40, ysize=18, xoff=.5, yoff=.5
  !p.font=0

; Set up a six-element array of the positions for individual panels
  position = [ [.05,.6,.325,.95], [.375,.6,.65,.95], [.7,.6,.975,.95], $
               [.05,.15,.325,.5], [.375,.15,.65,.5], [.7,.15,.975,.5] ]

  loadct, 3
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

  for iexpid = 0, nexpid-1 do begin

  plot, x, sus[*,0], /nodata, /noerase, $
   position=position[*,ipos[iexpid]], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=1, yrange=[1000,10], /ylog, $
   ytitle = 'pressure [hPa]'

  levels = [.1,.2,.5,1,2,5,10,15]
  colors = 240-findgen(8)*30

  contour, /overplot, susarea[*,*,iexpid], x, lev, /cell, $
   levels=levels, c_colors=colors
  
  contour, /overplot, susarea[*,*,iexpid], x, lev, $
   levels=levels
  
  plot, x, sus[*,0], /nodata, /noerase, $
   position=position[*,ipos[iexpid]], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=1, yrange=[1000,10], /ylog, $
   ytitle = 'pressure [hPa]'
  endfor

  makekey, .3, .06, .4, .03, 0., -0.025, color=colors, chars=1.25, $
           labels=string(levels,format='(f4.1)'), align=0

  device, /close

end
