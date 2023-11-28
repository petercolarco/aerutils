; Monthly mean AOD plot for May

  ddf1 = 'c1440_NR.sunsynch_450km_1330crossing.nodrag.1000km.ddf'
  ddf2 = 'c1440_NR.gpm.nodrag.1000km.ddf'
  tag  = 'gpm_sun.1000km'

; Do this by month
  nday = [31,28,31,30,31,30,31,31,30,31,30,31]
  mon  = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']


  diffs = fltarr(12)
  for it = 0, 11 do begin

  if(it eq 0) then begin
   nt0 = 0
   nt1 = nday[it]-1
;   nt1 = 1
  endif else begin
   nt0 = nt1+1
   nt1 = nt0+nday[it]-1
;   nt0 = nt0+nday[it-1]
;   nt1 = nt0+1
  endelse
print, nt0, nt1
  get_stat, ddf1, res1, wantlat=[-65,65], nt0=nt0,nt1=nt1,aotm=aot1, aotn=aotn1, cldn80=cldn1, lat=lat,lon=lon
  get_stat, ddf2, res2, wantlat=[-65,65], nt0=nt0,nt1=nt1,aotm=aot2, aotn=aotn2, cldn80=cldn2, lat=lat,lon=lon

  if(it eq 0) then begin
   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]
   ny = n_elements(lat)
   mcf  = fltarr(12,ny,2)
   nn   = lonarr(12,ny,2)
   nn80 = lonarr(12,ny,2)
  endif

  mcf[it,*,0]  = mean(aot1,dim=1,/nan)
  mcf[it,*,1]  = mean(aot2,dim=1,/nan)
  nn[it,*,0]   = total(aotn1,1,/nan)
  nn[it,*,1]   = total(aotn2,1,/nan)
  nn80[it,*,0] = total(cldn1,1,/nan)
  nn80[it,*,1] = total(cldn2,1,/nan)
goto, jump

  set_plot, 'ps'
  device, file='monthly_mean.cldtot.'+tag+'.'+mon[it]+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  xycomp, aot2, aot1, lon, lat, dx, dy, $
   colortable=64, levels=findgen(11)*.1, colors=indgen(11)*25, $
   geolimit=[-65,-180,65,180]
  diffs[it] = mean(aot2,/nan)-mean(aot1,/nan)
  print, diffs[it], res2[5]-res1[5]

  device, /close


  set_plot, 'ps'
  device, file='monthly_mean.num.'+tag+'.'+mon[it]+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  xycomp, aotn2, aotn1, lon, lat, dx, dy, $
   colortable=64, levels=indgen(11)*2, colors=indgen(11)*25, $
   dlevels=[-10,-6,-4,-2,-1,1,2,4,6], dcolors=reverse(indgen(9)*35), $
   geolimit=[-65,-180,65,180]

  device, /close


  set_plot, 'ps'
  device, file='monthly_mean.num80.'+tag+'.'+mon[it]+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  xycomp, aotn2-cldn2, aotn1-cldn1, lon, lat, dx, dy, $
   colortable=64, levels=indgen(11)*2, colors=indgen(11)*25, $
   dlevels=[-10,-6,-4,-2,-1,1,2,4,6], dcolors=reverse(indgen(9)*35), $
   geolimit=[-65,-180,65,180]

  device, /close
jump:
  endfor



  set_plot, 'ps'
  device, file='zonal_mean_cldtot.'+tag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  xycomp, mcf[*,*,1], mcf[*,*,0], indgen(12), lat, 1., dy, $
   colortable=64, levels=findgen(11)*.1, colors=indgen(11)*25, $
   dlevels=[-0.10,-0.06,-0.04,-0.02,-0.01,0.01,0.02,0.04,0.06], $
   dcolors=reverse(indgen(9)*35), $
   geolimit=[-65,-1,65,12], /nomap

  device, /close


  a = where(lat ge -65 and lat le 65)
  nnm = max(nn[*,a,*])*1.

  set_plot, 'ps'
  device, file='zonal_mean_num.'+tag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  xycomp, nn[*,*,1]/nnm, nn[*,*,0]/nnm, indgen(12), lat, 1., dy, $
   colortable=64, levels=findgen(11)*.1, colors=indgen(11)*25, $
   geolimit=[-65,-1,65,12], /nomap

  device, /close


  set_plot, 'ps'
  device, file='zonal_mean_num80.'+tag+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  xycomp, (nn[*,*,1]-nn80[*,*,1])/nnm, (nn[*,*,0]-nn80[*,*,0])/nnm, indgen(12), lat, 1., dy, $
   colortable=64, levels=findgen(11)*.1, colors=indgen(11)*25, $
   geolimit=[-65,-1,65,12], /nomap

  device, /close


  set_plot, 'ps'
  device, file='zonal_mean_num80.summary.jan.'+tag+'.ps', /color, /helvetica, font_size=28, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,15000], xticks=3, xtickn=['0','5000','10000','15000'], $
   yrange=[-65,65], $
   xstyle=9, ystyle=9, xthick=8, ythick=8, $
   position=[.15,.1,.9,.95]
  loadct, 56
  oplot, nn[0,*,1]-nn80[0,*,1], lat, thick=24, color=200
  loadct, 52
  oplot, nn[0,*,0]-nn80[0,*,0], lat, thick=24, color=200
  device, /close


  set_plot, 'ps'
  device, file='zonal_mean_num80.summary.may.'+tag+'.ps', /color, /helvetica, font_size=28, $
   xoff=.5, yoff=.5, xsize=18, ysize=28
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,15000], xticks=3, xtickn=['0','5000','10000','15000'], $
   yrange=[-65,65], $
   xstyle=9, ystyle=9, xthick=8, ythick=8, $
   position=[.15,.1,.9,.95]
  loadct, 56
  oplot, nn[4,*,1]-nn80[4,*,1], lat, thick=24, color=200
  loadct, 52
  oplot, nn[4,*,0]-nn80[4,*,0], lat, thick=24, color=200
  device, /close


end

