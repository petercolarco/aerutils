; Plot the time series of MODIS AOT for each of the sampling
; strategies (land and ocean)

; Number weight
  nums = '.num'
  numvar = 'num'
; QA-weighted
;  nums = ''
;  numvar = 'qasum'

  res = 'd'

  satid = 'MYD04'

  nan  = 1.e14
  area, lon, lat, nx, ny, dx, dy, area, grid=res

  spawn, 'echo $MODISDIR', MODISDIR

  dateexpand, '20030115', '20111231', '120000', '120000', $
              nymd, nhms, /monthly
  nt = n_elements(nymd)
  nyrs = 9
  nt = 12
  nsamples = 10
  samples  = ['', '.supermisr', '.misr1', '.misr2', '.misr3', '.caliop1','.caliop2', '.caliop3','.misr4','.caliop4']
  globaot  = fltarr(nt,2,nsamples)
  globnum  = fltarr(nt,2,nsamples)
  sample   = strarr(nsamples)

  for isample = 0, nsamples-1 do begin

   for ioro = 0, 1 do begin

    if(ioro eq 0) then oro = 'ocn'
    if(ioro eq 1) then oro = 'lnd'
    qast = 'qast'
    if(oro eq 'lnd') then qast = 'qast3'
    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+satid+'_L2_'+oro+samples[isample] $
                      +'.aero_tc8_051.'+qast+'_qawt'+nums+'.%y4%m2.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, 'aot', aot

    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+satid+'_L2_'+oro+samples[isample] $
                      +'.aero_tc8_051.'+qast+'_qafl.%y4%m2.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, numvar, num
b = where(aot lt 1e12)
print, isample, ioro
check, aot[b]
check, num[b]
;if(isample eq 6 and ioro eq 0) then stop
    a = where(aot gt nan or num gt nan)
    aot[a] = !values.f_nan
    num[a] = !values.f_nan
    for it = 0, nt-1 do begin
     numtmp = total(aot[*,*,it:nyrs*nt-1:12]*num[*,*,it:nyrs*nt-1:12],3)
     dentmp = total(                         num[*,*,it:nyrs*nt-1:12],3)
     a = where(finite(numtmp) eq 0)
     b = where(finite(numtmp) eq 1)
     numtmp[a] = 1.e15
     dentmp[a] = 1.e15
     globnum[it,ioro,isample] = total(dentmp[b]) ; total number of obs in all months included
     globaot[it,ioro,isample] = aave(numtmp,area,nan=nan)/aave(dentmp,area,nan=nan)
if(globaot[it,ioro,isample] gt 100) then stop
    endfor

   endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]

  endfor

  !p.multi = [0,1,2]
  set_plot, 'ps'
  device, file='modis_aot_monthly_climatology.'+satid+'.'+res+'.ocn.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(nt)+1
  xtickv = [0,indgen(nt)+1]
  xticklabels = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[0.08,.24], $
   xtitle = 'Month', ytitle='AOT', title=satid+' Ocean AOT', $
   xticks = nt+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,0,0]-.01,globaot[*,0,0]+.01],nt,2)
;  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,0,0], thick=6
  oplot, x, globaot[*,0,1], thick=6, lin=2
  oplot, x, globaot[*,0,2], thick=6, color=254
  oplot, x, globaot[*,0,3], thick=6, color=254, lin=2
  oplot, x, globaot[*,0,4], thick=6, color=254, lin=1
  oplot, x, globaot[*,0,5], thick=6, color=75
  oplot, x, globaot[*,0,6], thick=6, color=75, lin=2
  oplot, x, globaot[*,0,7], thick=6, color=75, lin=1
  oplot, x, globaot[*,0,8], thick=6, color=254, lin=3
  oplot, x, globaot[*,0,9], thick=6, color=75, lin=3

  ymax = 0.24
  ymin = 0.08
  dy = ymax-ymin
  plots, [1,2.5], .94*dy+ymin, thick=6
  plots, [1,2.5], .87*dy+ymin, thick=6, lin=2
  plots, [5.5,7], .94*dy+ymin, thick=6, color=254
  plots, [5.5,7], .87*dy+ymin, thick=6, color=254, lin=2
  plots, [5.5,7], .80*dy+ymin, thick=6, color=254, lin=1
  plots, [5.5,7], .73*dy+ymin, thick=6, color=254, lin=3
  plots, [10,11.5], .94*dy+ymin, thick=6, color=75
  plots, [10,11.5], .87*dy+ymin, thick=6, color=75, lin=2
  plots, [10,11.5], .80*dy+ymin, thick=6, color=75, lin=1
  plots, [10,11.5], .73*dy+ymin, thick=6, color=75, lin=3
  xyouts, 2.7, .925*dy+ymin, 'Full Swath'
  xyouts, 2.7, .855*dy+ymin, 'SM'
  xyouts, 7.2, .925*dy+ymin, 'M1'
  xyouts, 7.2, .855*dy+ymin, 'M2'
  xyouts, 7.2, .785*dy+ymin, 'M3'
  xyouts, 7.2, .715*dy+ymin, 'M4'
  xyouts, 11.7, .925*dy+ymin, 'C1'
  xyouts, 11.7, .855*dy+ymin, 'C2'
  xyouts, 11.7, .785*dy+ymin, 'C3'
  xyouts, 11.7, .715*dy+ymin, 'C4'

  loadct, 0
  plot, x, globaot[*,0,0], /nodata, yrange=[-.04,.08], $
   xtitle = 'Month', ytitle='AOT', title='Difference from Full Swath', $
   xticks = nt+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
;  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 39
  oplot, x, globaot[*,0,1]-globaot[*,0,0], thick=6, lin=2
  oplot, x, globaot[*,0,2]-globaot[*,0,0], thick=6, color=254
  oplot, x, globaot[*,0,3]-globaot[*,0,0], thick=6, color=254, lin=2
  oplot, x, globaot[*,0,4]-globaot[*,0,0], thick=6, color=254, lin=1
  oplot, x, globaot[*,0,5]-globaot[*,0,0], thick=6, color=75
  oplot, x, globaot[*,0,6]-globaot[*,0,0], thick=6, color=75, lin=2
  oplot, x, globaot[*,0,7]-globaot[*,0,0], thick=6, color=75, lin=1
  oplot, x, globaot[*,0,8]-globaot[*,0,0], thick=6, color=254, lin=3
  oplot, x, globaot[*,0,9]-globaot[*,0,0], thick=6, color=75, lin=3
  axis, 0, 0, xaxis=0, xticks = nt+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nt+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nt+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nt+2,val=' '), xminor=1

  loadct, 0
  x = indgen(nt)+1
  xtickv = [0,indgen(nt)+1]
  xticklabels = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, x, globnum[*,0,0], /nodata, yrange=[1e3,1e9], /ylog, $
   xtitle = 'Month', ytitle='Number', title=satid+' Ocean Number', $
   xticks = nt+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,0,0]-.01,globaot[*,0,0]+.01],nt,2)
;  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globnum[*,0,0], thick=6
  oplot, x, globnum[*,0,1], thick=6, lin=2
  oplot, x, globnum[*,0,2], thick=6, color=254
  oplot, x, globnum[*,0,3], thick=6, color=254, lin=2
  oplot, x, globnum[*,0,4], thick=6, color=254, lin=1
  oplot, x, globnum[*,0,5], thick=6, color=75
  oplot, x, globnum[*,0,6], thick=6, color=75, lin=2
  oplot, x, globnum[*,0,7], thick=6, color=75, lin=1
  oplot, x, globnum[*,0,8], thick=6, color=254, lin=3
  oplot, x, globnum[*,0,9], thick=6, color=75, lin=3

  device, /close

  !P.multi=[0,1,2]
  set_plot, 'ps'
  device, file='modis_aot_monthly_climatology.'+satid+'.'+res+'.lnd.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(nt)+1
  xtickv = [0,indgen(nt)+1]
  xticklabels = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, x, globaot[*,1,0], /nodata, yrange=[0.1,.4], $
   xtitle = 'Month', ytitle='AOT', title=satid+' Land AOT', $
   xticks = nt+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,1,0]-.01,globaot[*,1,0]+.01],nt,2)
;  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,1,0], thick=6
  oplot, x, globaot[*,1,1], thick=6, lin=2
  oplot, x, globaot[*,1,2], thick=6, color=254
  oplot, x, globaot[*,1,3], thick=6, color=254, lin=2
  oplot, x, globaot[*,1,4], thick=6, color=254, lin=1
  oplot, x, globaot[*,1,5], thick=6, color=75
  oplot, x, globaot[*,1,6], thick=6, color=75, lin=2
  oplot, x, globaot[*,1,7], thick=6, color=75, lin=1
  oplot, x, globaot[*,1,8], thick=6, color=254, lin=3
  oplot, x, globaot[*,1,9], thick=6, color=75, lin=3

  ymax = 0.40
  ymin = 0.10
  dy = ymax-ymin
  plots, [1,2.5], .94*dy+ymin, thick=6
  plots, [1,2.5], .87*dy+ymin, thick=6, lin=2
  plots, [5.5,7], .94*dy+ymin, thick=6, color=254
  plots, [5.5,7], .87*dy+ymin, thick=6, color=254, lin=2
  plots, [5.5,7], .80*dy+ymin, thick=6, color=254, lin=1
  plots, [5.5,7], .73*dy+ymin, thick=6, color=254, lin=3
  plots, [10,11.5], .94*dy+ymin, thick=6, color=75
  plots, [10,11.5], .87*dy+ymin, thick=6, color=75, lin=2
  plots, [10,11.5], .80*dy+ymin, thick=6, color=75, lin=1
  plots, [10,11.5], .73*dy+ymin, thick=6, color=75, lin=3
  xyouts, 2.7, .925*dy+ymin, 'Full Swath'
  xyouts, 2.7, .855*dy+ymin, 'SM'
  xyouts, 7.2, .925*dy+ymin, 'M1'
  xyouts, 7.2, .855*dy+ymin, 'M2'
  xyouts, 7.2, .785*dy+ymin, 'M3'
  xyouts, 7.2, .715*dy+ymin, 'M4'
  xyouts, 11.7, .925*dy+ymin, 'C1'
  xyouts, 11.7, .855*dy+ymin, 'C2'
  xyouts, 11.7, .785*dy+ymin, 'C3'
  xyouts, 11.7, .715*dy+ymin, 'C4'

  loadct, 0
  plot, x, globaot[*,1,0], /nodata, yrange=[-.04,.12], $
   xtitle = 'Month', ytitle='AOT', title='Difference from Full Swath', $
   xticks = nt+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
;  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 39
  oplot, x, globaot[*,1,1]-globaot[*,1,0], thick=6, lin=2
  oplot, x, globaot[*,1,2]-globaot[*,1,0], thick=6, color=254
  oplot, x, globaot[*,1,3]-globaot[*,1,0], thick=6, color=254, lin=2
  oplot, x, globaot[*,1,4]-globaot[*,1,0], thick=6, color=254, lin=1
  oplot, x, globaot[*,1,5]-globaot[*,1,0], thick=6, color=75
  oplot, x, globaot[*,1,6]-globaot[*,1,0], thick=6, color=75, lin=2
  oplot, x, globaot[*,1,7]-globaot[*,1,0], thick=6, color=75, lin=1
  oplot, x, globaot[*,1,8]-globaot[*,1,0], thick=6, color=254, lin=3
  oplot, x, globaot[*,1,9]-globaot[*,1,0], thick=6, color=75, lin=3
  axis, 0, 0, xaxis=0, xticks = nt+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nt+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nt+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nt+2,val=' '), xminor=1

  loadct, 0
  x = indgen(nt)+1
  xtickv = [0,indgen(nt)+1]
  xticklabels = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  plot, x, globnum[*,1,0], /nodata, yrange=[1e3,1e8], /ylog, $
   xtitle = 'Month', ytitle='Number', title=satid+' Land Number', $
   xticks = nt+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,0,0]-.01,globaot[*,0,0]+.01],nt,2)
;  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globnum[*,1,0], thick=6
  oplot, x, globnum[*,1,1], thick=6, lin=2
  oplot, x, globnum[*,1,2], thick=6, color=254
  oplot, x, globnum[*,1,3], thick=6, color=254, lin=2
  oplot, x, globnum[*,1,4], thick=6, color=254, lin=1
  oplot, x, globnum[*,1,5], thick=6, color=75
  oplot, x, globnum[*,1,6], thick=6, color=75, lin=2
  oplot, x, globnum[*,1,7], thick=6, color=75, lin=1
  oplot, x, globnum[*,1,8], thick=6, color=254, lin=3
  oplot, x, globnum[*,1,9], thick=6, color=75, lin=3


  device, /close

end
