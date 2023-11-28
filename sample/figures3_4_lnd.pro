; For some sampled data sets, plot the histogram of AOT

;  satid = 'MOD04'
  satid = 'MYD04'
  weight = ''
  weight = 'num.'
  resolution = 'b'
;  resolution = 'ten'
  tag   = satid+'.mm.'+resolution+'.'+weight+'lnd_2003_2011'
  nymd0 = '20030101'
  nymd1 = '20111231'
  dateexpand, nymd0, nymd1, '000000', '000000', nymd, nhms, /monthly

  ntemplate = 10
  nt = n_elements(nymd)

  aot = fltarr(ntemplate,nt)
  std = fltarr(ntemplate,nt)
  num = fltarr(ntemplate,nt)
  minval = fltarr(ntemplate,nt)
  maxval = fltarr(ntemplate,nt)

; PDF binning for analysis
  nbins = 501
  nseason = 5
  naotbins = lonarr(nbins,ntemplate,nseason)
  ndifbins = lonarr(nbins,ntemplate,nseason)
; 5 seasons: 0 = all year, 1 = DJF, 2 = MAM, 3 = JJA, 4 = SON

; cummulative difference bins
  cumbinmin = -.5
  cumbindel = 0.002  
  difbins = findgen(nbins)*cumbindel+cumbinmin

; Table of cummulative differences
  cumdif = fltarr(9)

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

;; No correction factor
;  corrfact[*,*] = 0.


  spawn, 'echo $MODISDIR', MODISDIR
  fileatemplate =    MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+resolution+'/GRITAS/Y%y4/M%m2' $
                  + ['/'+satid+'_L2_lnd.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.supermisr.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr1.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr2.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr3.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr4.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop1.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop2.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop3.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop4.aero_tc8_051.qast3_qawt.'+weight+'%y4%m2.nc4' ]
  filentemplate =    MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+resolution+'/GRITAS/Y%y4/M%m2' $
                  + ['/'+satid+'_L2_lnd.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.supermisr.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr1.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr2.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr3.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.misr4.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop1.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop2.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop3.aero_tc8_051.qast3_qafl.%y4%m2.nc4', $
                     '/'+satid+'_L2_lnd.caliop4.aero_tc8_051.qast3_qafl.%y4%m2.nc4' ]

  for it = 0, n_elements(nymd)-1 do begin

  mm = strmid(string(nymd[it],format='(i8)'),4,2)

  for itemplate = 0, ntemplate-1 do begin

;  Read the monthly mean files
   filename = strtemplate(fileatemplate[itemplate], nymd[it], nhms[it])
   nc4readvar, filename, 'aot', aot_, lon=lon, lat=lat
   a = where(aot_ ge 1.e15)
   if(a[0] ne -1) then aot_[a] = !values.f_nan
   aot_ = aot_-corrfact[itemplate,1]

   print, filename

;  Global AOT PDF
method = 1
   case method of
;  Method 1
;   PDF of the 10x10 box values
    1 : arr = histogram(aot_,binsize=.01, min=0., nbins=nbins, /nan)

;  Method 2 (weight)
;   PDF of 10x10 box values weighted by number of obs
    2: begin
       filename = strtemplate(filentemplate[itemplate], nymd[it], nhms[it])
       nc4readvar, filename, 'num', num_, lon=lon, lat=lat
       a = where(num_ ge 1.e15)
       if(a[0] ne -1) then num_[a] = !values.f_nan
       arr = histogram(aot_,binsize=.02, min=0., nbins=nbins, reverse_indices=r, /nan)
       for i = 0, nbins-1 do begin
        if(r[i] ne r[i+1]) then arr[i] = total(aot_[r[r[i]:r[i+1]-1]]*num_[r[r[i]:r[i+1]-1]])
       endfor
       end

   endcase

;  By "season"
   naotbins[*,itemplate,0] = naotbins[*,itemplate,0] + arr
   if(mm eq '12' or mm eq '01' or mm eq '02') then naotbins[*,itemplate,1] = naotbins[*,itemplate,1] + arr
   if(mm eq '03' or mm eq '04' or mm eq '05') then naotbins[*,itemplate,2] = naotbins[*,itemplate,2] + arr
   if(mm eq '06' or mm eq '07' or mm eq '08') then naotbins[*,itemplate,3] = naotbins[*,itemplate,3] + arr
   if(mm eq '09' or mm eq '10' or mm eq '11') then naotbins[*,itemplate,4] = naotbins[*,itemplate,4] + arr


;  Maintain the PDF differences in AOT
   if(itemplate eq 0) then begin
    aot = aot_
   endif else begin
    arr = histogram(aot-aot_,binsize=cumbindel, min=cumbinmin, nbins=nbins, /nan, loc=loc)
    ndifbins[*,itemplate,0] = ndifbins[*,itemplate,0] + arr
    if(mm eq '12' or mm eq '01' or mm eq '02') then ndifbins[*,itemplate,1] = ndifbins[*,itemplate,1] + arr
    if(mm eq '03' or mm eq '04' or mm eq '05') then ndifbins[*,itemplate,2] = ndifbins[*,itemplate,2] + arr
    if(mm eq '06' or mm eq '07' or mm eq '08') then ndifbins[*,itemplate,3] = ndifbins[*,itemplate,3] + arr
    if(mm eq '09' or mm eq '10' or mm eq '11') then ndifbins[*,itemplate,4] = ndifbins[*,itemplate,4] + arr
   endelse

  endfor

  endfor

; Normalize
  naotbins = float(naotbins)
print, total(naotbins[*,*,0],1)
  for itemplate = 0, ntemplate-1 do begin
   naotbins[*,itemplate,0] = naotbins[*,itemplate,0] / total(naotbins[*,itemplate,0])
   naotbins[*,itemplate,1] = naotbins[*,itemplate,1] / total(naotbins[*,itemplate,1])
   naotbins[*,itemplate,2] = naotbins[*,itemplate,2] / total(naotbins[*,itemplate,2])
   naotbins[*,itemplate,3] = naotbins[*,itemplate,3] / total(naotbins[*,itemplate,3])
   naotbins[*,itemplate,4] = naotbins[*,itemplate,4] / total(naotbins[*,itemplate,4])
  endfor

; Cumulative
  cumbins = fltarr(nbins,ntemplate,nseason)
  for itemplate = 1, ntemplate-1 do begin
   for ibin = nbins-1, 0, -1 do begin
    cumbins[ibin,itemplate,0] = total(ndifbins[0:ibin,itemplate,0])
    cumbins[ibin,itemplate,1] = total(ndifbins[0:ibin,itemplate,1])
    cumbins[ibin,itemplate,2] = total(ndifbins[0:ibin,itemplate,2])
    cumbins[ibin,itemplate,3] = total(ndifbins[0:ibin,itemplate,3])
    cumbins[ibin,itemplate,4] = total(ndifbins[0:ibin,itemplate,4])
   endfor
   cumbins[*,itemplate,0] = cumbins[*,itemplate,0]/total(ndifbins[*,itemplate,0])
   cumbins[*,itemplate,1] = cumbins[*,itemplate,1]/total(ndifbins[*,itemplate,1])
   cumbins[*,itemplate,2] = cumbins[*,itemplate,2]/total(ndifbins[*,itemplate,2])
   cumbins[*,itemplate,3] = cumbins[*,itemplate,3]/total(ndifbins[*,itemplate,3])
   cumbins[*,itemplate,4] = cumbins[*,itemplate,4]/total(ndifbins[*,itemplate,4])
  endfor
jump:

; Print the annual cummulative difference in range +/- 0.01 AOT

; threshold range = +/0.01 AOT
  jmax = 254
  jmin = 245

; threshold range = +/0.02 AOT
;  jmax = 259
;  jmin = 240

  
  for i = 0, 8 do begin
   cumdif[i] = (cumbins[jmax,i+1,0]-cumbins[jmin,i+1,0])
  endfor

  sample = ['Super-MISR','MISR1','MISR2','MISR3','MISR4','CALIOP1','CALIOP2','CALIOP3','CALIOP4']

  for i = 0, 8 do begin
   print, sample[i], cumdif[i], format='(a12,1(2x,f5.3))'
  endfor

; Plot the PDF
  set_plot, 'ps'
  device, file='aotpdf.'+tag+'.figure3.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0
  loadct, 39
  aotbins = findgen(nbins)*.01
  ymax = .1
  plot, aotbins, naotbins[*,0,0], thick=3, title = 'MODIS Aqua Land', yrange=[0,ymax], $
        ytitle='Frequency', xtitle='AOT', xrange=[0,0.5], /nodata
  oplot, aotbins, naotbins[*,0,0], thick=6
  oplot, aotbins, naotbins[*,1,0], thick=6, color=0, lin=2
  oplot, aotbins, naotbins[*,2,0], thick=6, color=254
  oplot, aotbins, naotbins[*,3,0], thick=6, color=254, lin=2
  oplot, aotbins, naotbins[*,4,0], thick=6, color=254, lin=1
  oplot, aotbins, naotbins[*,5,0], thick=6, color=254, lin=3
  oplot, aotbins, naotbins[*,6,0], thick=6, color=75
  oplot, aotbins, naotbins[*,7,0], thick=6, color=75, lin=2
  oplot, aotbins, naotbins[*,8,0], thick=6, color=75, lin=1
  oplot, aotbins, naotbins[*,9,0], thick=6, color=75, lin=3
  plots, [.25,.35], .94*ymax, thick=6
  plots, [.25,.35], .87*ymax, thick=6, lin=2
  plots, [.25,.35], .80*ymax, thick=6, color=254
  plots, [.25,.35], .73*ymax, thick=6, color=254, lin=2
  plots, [.25,.35], .66*ymax, thick=6, color=254, lin=1
  plots, [.25,.35], .59*ymax, thick=6, color=254, lin=3
  plots, [.25,.35], .52*ymax, thick=6, color=75
  plots, [.25,.35], .45*ymax, thick=6, color=75, lin=2
  plots, [.25,.35], .38*ymax, thick=6, color=75, lin=1
  plots, [.25,.35], .31*ymax, thick=6, color=75, lin=3
  xyouts,.36, .925*ymax, 'Full Swath'
  xyouts,.36, .855*ymax, 'SM'
  xyouts,.36, .785*ymax, 'M1'
  xyouts,.36, .715*ymax, 'M2'
  xyouts,.36, .645*ymax, 'M3'
  xyouts,.36, .575*ymax, 'M4'
  xyouts,.36, .505*ymax, 'C1'
  xyouts,.36, .435*ymax, 'C2'
  xyouts,.36, .375*ymax, 'C3'
  xyouts,.36, .305*ymax, 'C4'

  device, /close



  set_plot, 'ps'
  device, file='cumdiffpdf.'+tag+'.figure4.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0
  loadct, 0
  difbins = findgen(nbins)*cumbindel+cumbinmin
  plot, difbins, cumbins[*,0,0], thick=3, title = 'MODIS Aqua Land', yrange=[0,1], $
        ytitle='Cumulative Fraction', xtitle='Difference in mean AOT', xrange=[-.1,.1], /nodata
  polyfill, [-.01,.01,.01,-.01,-.01], [0,0,1,1,0], color=200
  plot, difbins, cumbins[*,0,0], thick=3, yrange=[0,1], xrange=[-.1,.1], /nodata, /noerase
  loadct, 39
  oplot, difbins, cumbins[*,1,0], thick=6, color=0, lin=2
  oplot, difbins, cumbins[*,2,0], thick=6, color=254
  oplot, difbins, cumbins[*,3,0], thick=6, color=254, lin=2
  oplot, difbins, cumbins[*,4,0], thick=6, color=254, lin=1
  oplot, difbins, cumbins[*,5,0], thick=6, color=254, lin=3
  oplot, difbins, cumbins[*,6,0], thick=6, color=75
  oplot, difbins, cumbins[*,7,0], thick=6, color=75, lin=2
  oplot, difbins, cumbins[*,8,0], thick=6, color=75, lin=1
  oplot, difbins, cumbins[*,9,0], thick=6, color=75, lin=3
  plots, [-.09,-.06], .90, thick=6, lin=2
  plots, [-.09,-.06], .83, thick=6, color=254
  plots, [-.09,-.06], .76, thick=6, color=254, lin=2
  plots, [-.09,-.06], .69, thick=6, color=254, lin=1
  plots, [-.09,-.06], .62, thick=6, color=254, lin=3
  plots, [-.09,-.06], .55, thick=6, color=75
  plots, [-.09,-.06], .48, thick=6, color=75, lin=2
  plots, [-.09,-.06], .41, thick=6, color=75, lin=1
  plots, [-.09,-.06], .34, thick=6, color=75, lin=3
  xyouts, -.05, .885, 'SM'
  xyouts, -.05, .815, 'M1'
  xyouts, -.05, .745, 'M2'
  xyouts, -.05, .675, 'M3'
  xyouts, -.05, .605, 'M4'
  xyouts, -.05, .535, 'C1'
  xyouts, -.05, .465, 'C2'
  xyouts, -.05, .395, 'C3'
  xyouts, -.05, .325, 'C4'

  device, /close

end
