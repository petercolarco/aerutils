; Monthly mean AOD plot for May

  ddf1 = 'c1440_NR.sunsynch_450km_1330crossing.nodrag.100km.ddf'
  ddf2 = 'c1440_NR.gpm.nodrag.100km.ddf'
  tag  = 'gpm_sun.100km'

; Do this by month
  nday = [31,28,31,30,31,30,31,31,30,31,30,31]
  mon  = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']


  diffs = fltarr(12)
  for it = 0, 11 do begin

  if(it eq 0) then begin
   nt0 = 0
   nt1 = nday[it]-1
  endif else begin
   nt0 = nt1+1
   nt1 = nt0+nday[it]-1
  endelse
print, nt0, nt1
  get_stat, ddf1, res1, wantlat=[-65,65], nt0=nt0,nt1=nt1,aotm=aot1, aotn=aotn1, lat=lat,lon=lon
  get_stat, ddf2, res2, wantlat=[-65,65], nt0=nt0,nt1=nt1,aotm=aot2, aotn=aotn2, lat=lat,lon=lon

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  set_plot, 'ps'
  device, file='monthly_mean.aod.'+tag+'.'+mon[it]+'.ps', /color, /helvetica, font_size=12, $
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

  endfor

end

