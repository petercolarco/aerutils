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
  nsamples = 8
  samples  = ['', '.supermisr', '.misr1', '.misr2', '.misr3', '.caliop1','.caliop2', '.caliop3']
  globaot  = fltarr(nt,2,nsamples)
  sample   = strarr(nsamples)

  for isample = nsamples-2, nsamples-1 do begin

   for ioro = 0, 1 do begin

    if(ioro eq 0) then oro = 'ocn'
    if(ioro eq 1) then oro = 'lnd'
    qast = 'qast'
    if(oro eq 'lnd') then qast = 'qast3'
    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+satid+'_L2_'+oro+samples[isample] $
                      +'.aero_tc8_051.'+qast+'_qawt'+nums+'.%y4%m2.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, 'aot', aot
stop
    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+satid+'_L2_'+oro+samples[isample] $
                      +'.aero_tc8_051.'+qast+'_qafl.%y4%m2.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, numvar, num
    for it = 0, nt-1 do begin
     globaot[it,ioro,isample] = aave(aot[*,*,it]*num[*,*,it],area,nan=nan)/aave(num[*,*,it],area,nan=nan)
    endfor

   endfor

  endfor

  !p.multi = [0,1,2]
  set_plot, 'ps'
  device, file='modis_aot_monthly.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(nt)+1
  nyrs = 9
  xtickv = [0,indgen(9)*12+6]
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[0.1,.17], $
   xtitle = 'Month', ytitle='AOT', title='MYD04 Ocean AOT', $
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
  plot, x, globaot[*,1,0], /nodata, yrange=[0.1,0.35], $
   xtitle = 'Month', ytitle='AOT', title='MYD04 Land AOT', $
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

  device, /close



end
