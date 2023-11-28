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
  
; Correction factor based on LAR analysis to correct for actual view
; angle dependency relative to full swath (subtract from number calculated)
  corrfact = [ [0,-0.0058,-0.0050,-0.0093,0.0163,-0.0045,-0.0019,0.0133], $ ; ocean
               [0,-0.0205,-0.0274,-0.0145,0.0079,-0.0111,-0.0072,0.0191]]   ; land
; New as of 3/2
  corrfact = [ [0.0044,-0.0027,-0.0006,-0.0049,0.0208,-0.0001,0.0026,0.0177], $ ; ocean
               [-0.0023,-0.0229,-0.0298,-0.0168,0.0056,-0.0268,-0.0095,0.0168]]   ; land

; New as of 6/5 - updates 3/2 but for M4 and C4
  corrfact = [ [0.0044,-0.0027,-0.0006,-0.0049,0.0208,-0.0001,0.0026,0.0177,0.,0.], $           ; ocean   ; Ocean M4 and C4 not corrected
               [-0.0023,-0.0229,-0.0298,-0.0168,0.0056,-0.0268,-0.0095,0.0168,0.0003,0.0124]]   ; land

  nyrs = 9
  nymd = (indgen(nyrs)+2003)*10000L+0605
  nhms = make_array(nyrs,val=120000L)
  nt = n_elements(nymd)
  nsamples = 10
  samples  = ['', '.supermisr', '.misr1', '.misr2', '.misr3', '.caliop1','.caliop2', '.caliop3','.misr4','.caliop4']
  globaot  = fltarr(nt,2,nsamples)
  sample   = strarr(nsamples)

  for isample = 0, nsamples-1 do begin

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
     globaot[it,ioro,isample] = aave(aot[*,*,it]*num[*,*,it],area,nan=nan)/aave(num[*,*,it],area,nan=nan)-corrfact[isample,ioro]
    endfor
   endfor
print, isample, globaot[*,0,isample]
print, isample, globaot[*,1,isample]
  endfor

  !p.multi = [0,1,2]
  set_plot, 'ps'
  device, file='modis_aot_annual_corrected.ocn.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  x = indgen(nyrs)+1
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[0.11,.16], $
   xtitle = 'Year', ytitle='AOT', title='MYD04 Ocean AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nyrs+1]
  y = reform([globaot[*,0,0]-.01,globaot[*,0,0]+.01],nyrs,2)
  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,0,1], thick=6, lin=2
  oplot, x, globaot[*,0,2], thick=6, color=254
  oplot, x, globaot[*,0,3], thick=6, color=254, lin=2
  oplot, x, globaot[*,0,4], thick=6, color=254, lin=1
  oplot, x, globaot[*,0,5], thick=6, color=75
  oplot, x, globaot[*,0,6], thick=6, color=75, lin=2
  oplot, x, globaot[*,0,7], thick=6, color=75, lin=1

  ymax = 0.16
  ymin = 0.11
  dy = ymax-ymin
  plots, [1,2], .94*dy+ymin, thick=6
  plots, [1,2], .87*dy+ymin, thick=6, lin=2
  plots, [4,5], .94*dy+ymin, thick=6, color=254
  plots, [4,5], .87*dy+ymin, thick=6, color=254, lin=2
  plots, [4,5], .80*dy+ymin, thick=6, color=254, lin=1
  plots, [7,8], .94*dy+ymin, thick=6, color=75
  plots, [7,8], .87*dy+ymin, thick=6, color=75, lin=2
  plots, [7,8], .80*dy+ymin, thick=6, color=75, lin=1
  xyouts, 2.1, .925*dy+ymin, 'Full Swath'
  xyouts, 2.1, .855*dy+ymin, 'SM'
  xyouts, 5.1, .925*dy+ymin, 'M1'
  xyouts, 5.1, .855*dy+ymin, 'M2'
  xyouts, 5.1, .785*dy+ymin, 'M3'
  xyouts, 8.1, .925*dy+ymin, 'C1'
  xyouts, 8.1, .855*dy+ymin, 'C2'
  xyouts, 8.1, .785*dy+ymin, 'C3'

  loadct, 0
  x = indgen(nyrs)+1
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,0,0], /nodata, yrange=[-.02,.02], $
   xtitle = 'Year', ytitle='AOT', title='Difference from Full Swath', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nyrs+1]
  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
  loadct, 39
  oplot, x, globaot[*,0,1]-globaot[*,0,0], thick=6, lin=2
  oplot, x, globaot[*,0,2]-globaot[*,0,0], thick=6, color=254
  oplot, x, globaot[*,0,3]-globaot[*,0,0], thick=6, color=254, lin=2
  oplot, x, globaot[*,0,4]-globaot[*,0,0], thick=6, color=254, lin=1
  oplot, x, globaot[*,0,5]-globaot[*,0,0], thick=6, color=75
  oplot, x, globaot[*,0,6]-globaot[*,0,0], thick=6, color=75, lin=2
  oplot, x, globaot[*,0,7]-globaot[*,0,0], thick=6, color=75, lin=1
  axis, 0, 0, xaxis=0, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1

  device, /close



  !p.multi = [0,1,2]
  set_plot, 'ps'
  device, file='modis_aot_annual_corrected.lnd.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=20, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  plot, x, globaot[*,1,0], /nodata, yrange=[0.14,0.24], $
   xtitle = 'Month', ytitle='AOT', title='MYD04 Land AOT', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nyrs+1]
  y = reform([globaot[*,1,0]-.01,globaot[*,1,0]+.01],nyrs,2)
  polymaxmin, x, y, thick=6, fill=200
  loadct, 39
  oplot, x, globaot[*,1,1], thick=6, lin=2
  oplot, x, globaot[*,1,2], thick=6, color=254
  oplot, x, globaot[*,1,3], thick=6, color=254, lin=2
  oplot, x, globaot[*,1,4], thick=6, color=254, lin=1
  oplot, x, globaot[*,1,5], thick=6, color=75
  oplot, x, globaot[*,1,6], thick=6, color=75, lin=2
  oplot, x, globaot[*,1,7], thick=6, color=75, lin=1
  oplot, x, globaot[*,1,8], thick=6, color=254, lin=3
  oplot, x, globaot[*,1,9], thick=6, color=75, lin=3

  ymax = 0.24
  ymin = 0.14
  dy = ymax-ymin
  plots, [1,2], .94*dy+ymin, thick=6
  plots, [1,2], .87*dy+ymin, thick=6, lin=2
  plots, [4,5], .94*dy+ymin, thick=6, color=254
  plots, [4,5], .87*dy+ymin, thick=6, color=254, lin=2
  plots, [4,5], .80*dy+ymin, thick=6, color=254, lin=1
  plots, [4,5], .73*dy+ymin, thick=6, color=254, lin=3
  plots, [7,8], .94*dy+ymin, thick=6, color=75
  plots, [7,8], .87*dy+ymin, thick=6, color=75, lin=2
  plots, [7,8], .80*dy+ymin, thick=6, color=75, lin=1
  plots, [7,8], .73*dy+ymin, thick=6, color=75, lin=3
  xyouts, 2.1, .925*dy+ymin, 'Full Swath'
  xyouts, 2.1, .855*dy+ymin, 'SM'
  xyouts, 5.1, .925*dy+ymin, 'M1'
  xyouts, 5.1, .855*dy+ymin, 'M2'
  xyouts, 5.1, .785*dy+ymin, 'M3'
  xyouts, 5.1, .715*dy+ymin, 'M4'
  xyouts, 8.1, .925*dy+ymin, 'C1'
  xyouts, 8.1, .855*dy+ymin, 'C2'
  xyouts, 8.1, .785*dy+ymin, 'C3'
  xyouts, 8.1, .715*dy+ymin, 'C4'


  loadct, 0
  x = indgen(nyrs)+1
  xticklabels = [' ',strpad(indgen(nyrs)+2003,1000),' ']
  plot, x, globaot[*,1,0], /nodata, yrange=[-.04,.04], $
   xtitle = 'Year', ytitle='AOT', title='Difference from Full Swath', $
   xticks = nyrs+1, xtickn = xticklabels, xminor=1, yminor=2, $
   xstyle=9, ystyle=9, thick=3, xrange=[0,nyrs+1]
  polyfill, [0,max(x)+1,max(x)+1,0,0], [-.01,-.01,.01,.01,-.01], color=200
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
  axis, 0, 0, xaxis=0, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1
  axis, 0, 0, xaxis=1, xticks = nyrs+1, xtickn = make_array(nyrs+2,val=' '), xminor=1

  device, /close

end
