; Plot the time series of MODIS AOT for each of the sampling
; strategies (land and ocean)

; Number weight
  nums = '.num'
  numvar = 'num'
; QA-weighted
;  nums = ''
;  numvar = 'qasum'

  res = 'b'

  satid = 'MYD04'

  nan  = 1.e14
  area, lon, lat, nx, ny, dx, dy, area, grid=res

  spawn, 'echo $MODISDIR', MODISDIR


  dateexpand, '20030115', '20111231', '120000', '120000', $
              nymd, nhms, /monthly
  nt = n_elements(nymd)
  nyrs = 9
  nt = nyrs*4
  nsamples = 8
  samples  = ['', '.supermisr', '.misr1', '.misr2', '.misr3', '.caliop1','.caliop2', '.caliop3']
  globaot  = fltarr(nt,2,nsamples)
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
    a = where(aot gt nan)
    aot[a] = !values.f_nan
    num[a] = !values.f_nan
    for it = 0, nt-1 do begin
     numtmp = total(aot[*,*,it*3:it*3+2]*num[*,*,it*3:it*3+2],3)
     dentmp = total(                     num[*,*,it*3:it*3+2],3)
     a = where(finite(numtmp) eq 0)
     numtmp[a] = 1.e15
     dentmp[a] = 1.e15
     globaot[it,ioro,isample] = aave(numtmp,area,nan=nan)/aave(dentmp,area,nan=nan)
    endfor

   endfor

  endfor

  !p.multi = [0,1,2]
  set_plot, 'ps'
  device, file='modis_aot_seasonal.ocn.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(nt)+1
  nyrs = 9
  xtickv = [0,indgen(9)*4+2]
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[0.1,.17], $
   xtitle = 'Season', ytitle='AOT', title='MYD04 Ocean AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,0,0]-.01,globaot[*,0,0]+.01],nt,2)
  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,0,1], thick=6, lin=2
  oplot, x, globaot[*,0,2], thick=6, color=254
  oplot, x, globaot[*,0,3], thick=6, color=254, lin=2
  oplot, x, globaot[*,0,4], thick=6, color=254, lin=1
  oplot, x, globaot[*,0,5], thick=6, color=75
  oplot, x, globaot[*,0,6], thick=6, color=75, lin=2
  oplot, x, globaot[*,0,7], thick=6, color=75, lin=1

  loadct, 0
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[-.03,.03], $
   xtitle = 'Year', ytitle='AOT', title='Difference from Full Swath', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 39
  oplot, x, globaot[*,0,1]-globaot[*,0,0], thick=6, lin=2
  oplot, x, globaot[*,0,2]-globaot[*,0,0], thick=6, color=254
  oplot, x, globaot[*,0,3]-globaot[*,0,0], thick=6, color=254, lin=2
  oplot, x, globaot[*,0,4]-globaot[*,0,0], thick=6, color=254, lin=1
  oplot, x, globaot[*,0,5]-globaot[*,0,0], thick=6, color=75
  oplot, x, globaot[*,0,6]-globaot[*,0,0], thick=6, color=75, lin=2
  oplot, x, globaot[*,0,7]-globaot[*,0,0], thick=6, color=75, lin=1
  axis, 0, 0, xaxis=0, xticks = nyrs+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nyrs+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nyrs+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nyrs+2,val=' '), xminor=1

  device, /close

  set_plot, 'ps'
  device, file='modis_aot_seasonal.lnd.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(nt)+1
  nyrs = 9
  xtickv = [0,indgen(9)*4+2]
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,1,0], /nodata, yrange=[0.1,.28], $
   xtitle = 'Season', ytitle='AOT', title='MYD04 Land AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,1,0]-.01,globaot[*,1,0]+.01],nt,2)
  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,1,1], thick=6, lin=2
  oplot, x, globaot[*,1,2], thick=6, color=254
  oplot, x, globaot[*,1,3], thick=6, color=254, lin=2
  oplot, x, globaot[*,1,4], thick=6, color=254, lin=1
  oplot, x, globaot[*,1,5], thick=6, color=75
  oplot, x, globaot[*,1,6], thick=6, color=75, lin=2
  oplot, x, globaot[*,1,7], thick=6, color=75, lin=1

  loadct, 0
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,1,0], /nodata, yrange=[-.04,.04], $
   xtitle = 'Year', ytitle='AOT', title='Difference from Full Swath', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 39
  oplot, x, globaot[*,1,1]-globaot[*,1,0], thick=6, lin=2
  oplot, x, globaot[*,1,2]-globaot[*,1,0], thick=6, color=254
  oplot, x, globaot[*,1,3]-globaot[*,1,0], thick=6, color=254, lin=2
  oplot, x, globaot[*,1,4]-globaot[*,1,0], thick=6, color=254, lin=1
  oplot, x, globaot[*,1,5]-globaot[*,1,0], thick=6, color=75
  oplot, x, globaot[*,1,6]-globaot[*,1,0], thick=6, color=75, lin=2
  oplot, x, globaot[*,1,7]-globaot[*,1,0], thick=6, color=75, lin=1
  axis, 0, 0, xaxis=0, xticks = nyrs+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nyrs+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nyrs+1, xrange=[0,nt+1], xtickv=xtickv, xtickn = make_array(nyrs+2,val=' '), xminor=1

  device, /close
stop


  loadct, 0
  plot, x, globaot[*,1,0], /nodata, yrange=[0.1,0.28], $
   xtitle = 'Season', ytitle='AOT', title='MYD04 Land AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nt+1], xtickv=xtickv
  y = reform([globaot[*,1,0]-.01,globaot[*,1,0]+.01],nt,2)
  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,1,1], thick=6, color=75
  oplot, x, globaot[*,1,2], thick=6, color=254
  oplot, x, globaot[*,1,3], thick=6, color=75, lin=2
  oplot, x, globaot[*,1,4], thick=6, color=254, lin=2
  oplot, x, globaot[*,1,5], thick=6, lin=2
  oplot, x, globaot[*,1,6], thick=6, color=75
  oplot, x, globaot[*,1,7], thick=6, color=254, lin=1

  device, /close



end
