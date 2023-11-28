; Plot the time series of MODIS annual AOT for each of the sampling
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
  
  nyrs = 10
  nymd = (indgen(nyrs)+2003)*10000L+0605
  nhms = make_array(nyrs,val=120000L)
  nt = n_elements(nymd)

  nsamples = 35
  samples  = ['', '.supermisr', '.misr1', '.misr2', '.misr3', '.caliop1','.caliop2', '.caliop3','.misr4','.caliop4']
  globaot  = fltarr(nt,2,nsamples)
  sample   = strarr(nsamples)
;goto, jump
; First ten samples are the MODIS along-track sample-then-average
  for isample = 0, 9 do begin

   for ioro = 0, 1 do begin
    if(ioro eq 0) then oro = 'ocn'
    if(ioro eq 1) then oro = 'lnd'
    qast = 'qast'
    if(oro eq 'lnd') then qast = 'qast3'
    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+satid+'_L2_'+oro+samples[isample] $
                      +'.aero_tc8_051.'+qast+'_qawt'+nums+'.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, 'aot', aot

    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+satid+'_L2_'+oro+samples[isample] $
                      +'.aero_tc8_051.'+qast+'_qafl.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, numvar, num
    for it = 0, nt-1 do begin
     globaot[it,ioro,isample] = aave(aot[*,*,it]*num[*,*,it],area,nan=nan)/aave(num[*,*,it],area,nan=nan)
    endfor
   endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]
  endfor

; Next ten samples are the MODIS along-track average-then-mask
  aotmask = fltarr(nx*ny*nyrs*1L,2)
  nummask = fltarr(nx*ny*nyrs*1L,2)
  for isample = 10, 19 do begin

   for ioro = 0, 1 do begin
    if(ioro eq 0) then oro = 'ocn'
    if(ioro eq 1) then oro = 'lnd'
    qast = 'qast'
    if(oro eq 'lnd') then qast = 'qast3'
    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+satid+'_L2_'+oro+samples[isample-10] $
                      +'.aero_tc8_051.'+qast+'_qawt'+nums+'.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, 'aot', aot
    if(isample eq 10 and ioro eq 0) then aotmask[*,0] = aot
    if(isample eq 10 and ioro eq 1) then aotmask[*,1] = aot
    if(isample gt 10) then aot[where(aot lt nan)] = aotmask[where(aot lt nan),ioro]

    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+satid+'_L2_'+oro+samples[isample-10] $
                      +'.aero_tc8_051.'+qast+'_qafl.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, numvar, num
    if(isample eq 10 and ioro eq 0) then nummask[*,0] = num
    if(isample eq 10 and ioro eq 1) then nummask[*,1] = num
    if(isample gt 10) then num[where(num lt nan)] = nummask[where(num lt nan),ioro]

    for it = 0, nt-1 do begin
     globaot[it,ioro,isample] = aave(aot[*,*,it]*num[*,*,it],area,nan=nan)/aave(num[*,*,it],area,nan=nan)
    endfor
   endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]
  endfor

; Next six samples are the MODIS across-track sample-then-average
  samples  = ['', '.lat1', '.lat2', '.lat3', '.lat4', '.lat5']
  aotmask = fltarr(nx*ny*nyrs*1L,2)
  nummask = fltarr(nx*ny*nyrs*1L,2)
  for isample = 20, 25 do begin

   for ioro = 0, 1 do begin
    if(ioro eq 0) then oro = 'ocn'
    if(ioro eq 1) then oro = 'lnd'
    qast = 'qast'
    if(oro eq 'lnd') then qast = 'qast3'
    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+satid+'_L2_'+oro+samples[isample-20] $
                      +'.aero_tc8_051.'+qast+'_qawt'+nums+'.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, 'aot', aot
;   Uncomment here and below to show average-then-mask
;    if(isample eq 20 and ioro eq 0) then aotmask[*,0] = aot
;    if(isample eq 20 and ioro eq 1) then aotmask[*,1] = aot
;    if(isample gt 20) then aot[where(aot lt nan)] = aotmask[where(aot lt nan),ioro]

    dset = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+satid+'_L2_'+oro+samples[isample-20] $
                      +'.aero_tc8_051.'+qast+'_qafl.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, numvar, num
;    if(isample eq 20 and ioro eq 0) then nummask[*,0] = num
;    if(isample eq 20 and ioro eq 1) then nummask[*,1] = num
;    if(isample gt 20) then num[where(num lt nan)] = nummask[where(num lt nan),ioro]

    for it = 0, nt-1 do begin
     globaot[it,ioro,isample] = aave(aot[*,*,it]*num[*,*,it],area,nan=nan)/aave(num[*,*,it],area,nan=nan)
    endfor
   endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]
  endfor

; Next group samples the aerosol model
; Get a mask value
  nc4readvar, '/Users/pcolarco/data/dR_MERRA-AA-r2/dR_MERRA-AA-r2.tavg2d_aer_x.monthly.200301.nc4', $
   'lwi', lwi, lon=lon, lat=lat
  numo = make_array(nx,ny,val=!values.f_nan)
  numl = make_array(nx,ny,val=!values.f_nan)
  a = where(lwi gt .99 and lwi lt 1.01)
  numl[a] = 1.
  a = where(lwi le .99 or lwi ge 1.01)
  numo[a] = 1.
  a = where(lat gt 60 or lat lt -60)
  numo[*,a] = !values.f_nan

  samples  = ['modis_aqua','modis_terra','misr_aqua','misr_terra','calipso','calipso_terra','calipso_calipso','misr_calipso']
  for isample = 26, 30 do begin
    dset = '/Users/pcolarco/data/dR_MERRA-AA-r2/inst2d_hwl_x/dR_MERRA-AA-r2.inst2d_hwl_x.'+samples[isample-26]+'.%y4.nc4'
    filename = strtemplate(dset, nymd, nhms)
    nc4readvar, filename, 'totexttau', aot
    for it = 0, nt-1 do begin
     globaot[it,0,isample] = aave(aot[*,*,it]*numo,area,nan=nan)/aave(numo,area,nan=nan)
     globaot[it,1,isample] = aave(aot[*,*,it]*numl,area,nan=nan)/aave(numl,area,nan=nan)
    endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]
  endfor

jump:
; Finally, get the NNR annual mean
  area, lone, late, nxe, nye, dxe, dye, areae, grid='e'
  dset = '/Volumes/bender/prc10/MODIS/NNR/051.nnr_001/Level3/MYD04/Y%y4/nnr_001.MYD04_L3a.ocean.annual.%y4.nc4'
  filename = strtemplate(dset, nymd, nhms)
  nc4readvar, filename, 'tau_', aoto
  dset = '/Volumes/bender/prc10/MODIS/NNR/051.nnr_001/Level3/MYD04/Y%y4/nnr_001.MYD04_L3a.land.annual.%y4.nc4'
  filename = strtemplate(dset, nymd, nhms)
  nc4readvar, filename, 'tau_', aotl
  a = where(aoto gt 900.)
  aoto[a] = !values.f_nan
  a = where(aotl gt 900.)
  aotl[a] = !values.f_nan
  isample = nsamples-1
  for it = 0, nt-1 do begin
    globaot[it,0,isample] = aave(aoto[*,*,it],areae,nan=nan)
    globaot[it,1,isample] = aave(aotl[*,*,it],areae,nan=nan)
  endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]

  set_plot, 'ps'
  device, file='modis_aot_annual.'+satid+'.'+res+'.eps', /color, /helvetica, font_size=12, $
   xsize=32, ysize=20, xoff=.5, yoff=.5, /encap
  !p.font=0
  loadct, 0
  x = indgen(nyrs)+1
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[0.08,.2], $
   xtitle = 'Year', ytitle='AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, xthick=6, ythick=6, xrange=[0,nyrs+1], $
   position=[.075,.575,.475,.95]
  xyouts, .075, .965, '!4(a)!3 AOT (Ocean)', charsize=1.25, /normal
  y = reform([globaot[*,0,0]-.01,globaot[*,0,0]+.01],nyrs,2)
;  polymaxmin, x, y, thick=8, fill=200
  for isample = 0, 9 do begin
   oplot, x, globaot[*,0,isample], thick=8, color=200
  endfor
  for isample = 26, 33 do begin
   oplot, x, globaot[*,0,isample], thick=8, color=0
  endfor

  loadct, 39
  for isample = 10, 19 do begin
   oplot, x, globaot[*,0,isample], thick=8, color=254
  endfor
  for isample = 20, 25 do begin
   oplot, x, globaot[*,0,isample], thick=8, color=75
  endfor

  oplot, x, globaot[*,0,nsamples-1], thick=8, color=128, lin=2


  ymax = 0.2
  ymin = 0.08
  dy = ymax-ymin
  loadct, 0
  plots, [1,2], .94*dy+ymin, thick=8, color=200
  plots, [6.5,7.5], .80*dy+ymin, thick=8, color=0
  loadct, 39
  plots, [1,2], .80*dy+ymin, thick=8, color=254
  plots, [6.5,7.5], .94*dy+ymin, thick=8, color=75
  loadct, 0
  xyouts, 2.1, .925*dy+ymin, 'MODIS Along-Track!C(sample-then-average)', color=200
  loadct, 39
  xyouts, 2.1, .785*dy+ymin, 'MODIS Along-Track!C(average-then-mask)', color=254
  xyouts, 7.6, .925*dy+ymin, 'MODIS Across-Track!C(sample-then-average)', color=75
  xyouts, 7.6, .785*dy+ymin, 'MERRAero'
  plots, [6.5,7.5], .71*dy+ymin, thick=8, color=128, lin=2
  xyouts, 7.6, .695*dy+ymin, 'MODIS Full Swath (DA)', color=128


  loadct, 0
  plot, x, globaot[*,1,0], /nodata, yrange=[0.08,0.2], /noerase, $
   xtitle = 'Year', ytitle='AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, xthick=6, ythick=6, xrange=[0,nyrs+1], $
   position=[.575,.575,.975,.95]
  xyouts, .575, .965, '!4(b)!3 AOT (Land)', charsize=1.25, /normal
  y = reform([globaot[*,1,0]-.01,globaot[*,1,0]+.01],nyrs,2)
;  polymaxmin, x, y, thick=8, fill=200
  for isample = 26, 33 do begin
   oplot, x, globaot[*,1,isample], thick=8, color=0
  endfor
  for isample = 0, 9 do begin
   oplot, x, globaot[*,1,isample], thick=8, color=200
  endfor

  loadct, 39
  for isample = 10, 19 do begin
   oplot, x, globaot[*,1,isample], thick=8, color=254
  endfor
  for isample = 20, 25 do begin
   oplot, x, globaot[*,1,isample], thick=8, color=75
  endfor

  oplot, x, globaot[*,1,nsamples-1], thick=8, color=128, lin=2


; Ocean difference
  loadct, 0
  x = indgen(nyrs)+1
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[-.04,.04], /noerase, $
   xtitle = 'Year', ytitle='!9D!3AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, xthick=6, ythick=6, xrange=[0,nyrs+1], $
   position=[.075,.075,.475,.45]
  xyouts, .075, .465, '!4(c)!3 Difference from Full Swath (Ocean)', charsize=1.25, /normal
;  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 0
  for isample = 27, 33 do begin
   oplot, x, globaot[*,0,isample]-globaot[*,0,26], thick=8, color=0
  endfor
  for isample = 1, 9 do begin
   oplot, x, globaot[*,0,isample]-globaot[*,0,0], thick=8, color=200
  endfor

  loadct, 39
  for isample = 11, 19 do begin
   oplot, x, globaot[*,0,isample]-globaot[*,0,0], thick=8, color=254
  endfor
  for isample = 21, 25 do begin
   oplot, x, globaot[*,0,isample]-globaot[*,0,0], thick=8, color=75
  endfor

  axis, 0, 0, xaxis=0, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1


; Land difference
  loadct, 0
  x = indgen(nyrs)+1
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,1,0], /nodata, yrange=[-.04,.04], /noerase, $
   xtitle = 'Year', ytitle='!9D!3AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, xthick=6, ythick=6, xrange=[0,nyrs+1], $
   position=[.575,.075,.975,.45]
  xyouts, .575, .465, '!4(d)!3 Difference from Full Swath (Land)', charsize=1.25, /normal
;  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 39
  loadct, 0
  for isample = 27, 33 do begin
   oplot, x, globaot[*,1,isample]-globaot[*,1,26], thick=8, color=0
  endfor
  for isample = 1, 9 do begin
   oplot, x, globaot[*,1,isample]-globaot[*,1,0], thick=8, color=200
  endfor

  loadct, 39
  for isample = 11, 19 do begin
   oplot, x, globaot[*,1,isample]-globaot[*,1,0], thick=8, color=254
  endfor
  for isample = 21, 25 do begin
   oplot, x, globaot[*,1,isample]-globaot[*,1,0], thick=8, color=75
  endfor

  axis, 0, 0, xaxis=0, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1

  device, /close

end
