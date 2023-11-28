; For some sampled data sets, plot the histogram of AOT

  tag   = 'model.mm.ocn_2009'
  nymd0 = '20090101'
  nymd1 = '20091231'
  dateexpand, nymd0, nymd1, '000000', '000000', nymd, nhms, /monthly

  ntemplate = 5
  nt = n_elements(nymd)

  aot = fltarr(ntemplate,nt)
  std = fltarr(ntemplate,nt)
  num = fltarr(ntemplate,nt)
  minval = fltarr(ntemplate,nt)
  maxval = fltarr(ntemplate,nt)

; PDF binning for analysis
  nbins = 51
  nseason = 5
  naotbins = lonarr(nbins,ntemplate,nseason)
  ndifbins = lonarr(nbins,ntemplate,nseason)
; 5 seasons: 0 = all year, 1 = DJF, 2 = MAM, 3 = JJA, 4 = SON




  filetemplate =    '/misc/prc15/colarco/dR_Fortuna-2-4-b4/inst2d_hwl_x/Y%y4/M%m2'+ $
                    '/dR_Fortuna-2-4-b4.inst2d_hwl_x.'  $
                 + ['MOD04_L2_ocn.aero_tc8_051.qast.mm.10deg.%y4%m2.nc4', $
                    'MOD04_L2_ocn.caliop1.aero_tc8_051.qast.mm.10deg.%y4%m2.nc4', $
                    'MOD04_L2_ocn.caliop2.aero_tc8_051.qast.mm.10deg.%y4%m2.nc4', $
                    'MOD04_L2_ocn.misr1.aero_tc8_051.qast.mm.10deg.%y4%m2.nc4', $
                    'MOD04_L2_ocn.misr2.aero_tc8_051.qast.mm.10deg.%y4%m2.nc4' ]

  for it = 0, n_elements(nymd)-1 do begin

  mm = strmid(string(nymd[it],format='(i8)'),4,2)

  for itemplate = 0, ntemplate-1 do begin

   filename = strtemplate(filetemplate[itemplate], nymd[it], nhms[it])
   print, filename
   read_sample, filename, nbin, lon, lat, $
                aot_, aotpdf_, num_, std_, minval_, maxval_

;  Maintain the PDF of AOT
;  PDF of the 10x10 box values
   arr = histogram(aot_,binsize=.02, min=0., nbins=nbins, /nan)
;  Average of the saved PDF
;   arr = fltarr(nbins)
;   for i = 0, nbins-1 do begin
;    arr[i] = total(aotpdf_[*,*,i],/nan)
;   endfor

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
    arr = histogram(aot-aot_,binsize=.008, min=-.2, nbins=nbins, /nan, loc=loc)
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

; Plot the PDF
  set_plot, 'ps'
  device, file='aotpdf.'+tag+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=18
  !p.font=0
  !p.multi=[0,2,3]
  loadct, 39
  aotbins = findgen(nbins)*.02
  plot, aotbins, naotbins[*,0,1], thick=3, title = 'DJF ('+tag+')', yrange=[0,0.3], $
        ytitle='Frequency', xtitle='AOT', xrange=[0,0.5]
  oplot, aotbins, naotbins[*,1,1], thick=3, color=254
  oplot, aotbins, naotbins[*,2,1], thick=3, color=254, lin=2
  oplot, aotbins, naotbins[*,3,1], thick=3, color=75
  oplot, aotbins, naotbins[*,4,1], thick=3, color=75, lin=2

  plot, aotbins, naotbins[*,0,2], thick=3, title = 'MAM ('+tag+')', yrange=[0,0.3], $
        ytitle='Frequency', xtitle='AOT', xrange=[0,0.5]
  oplot, aotbins, naotbins[*,1,2], thick=3, color=254
  oplot, aotbins, naotbins[*,2,2], thick=3, color=254, lin=2
  oplot, aotbins, naotbins[*,3,2], thick=3, color=75
  oplot, aotbins, naotbins[*,4,2], thick=3, color=75, lin=2

  plot, aotbins, naotbins[*,0,3], thick=3, title = 'JJA ('+tag+')', yrange=[0,0.3], $
        ytitle='Frequency', xtitle='AOT', xrange=[0,0.5]
  oplot, aotbins, naotbins[*,1,3], thick=3, color=254
  oplot, aotbins, naotbins[*,2,3], thick=3, color=254, lin=2
  oplot, aotbins, naotbins[*,3,3], thick=3, color=75
  oplot, aotbins, naotbins[*,4,3], thick=3, color=75, lin=2

  plot, aotbins, naotbins[*,0,4], thick=3, title = 'SON ('+tag+')', yrange=[0,0.3], $
        ytitle='Frequency', xtitle='AOT', xrange=[0,0.5]
  oplot, aotbins, naotbins[*,1,4], thick=3, color=254
  oplot, aotbins, naotbins[*,2,4], thick=3, color=254, lin=2
  oplot, aotbins, naotbins[*,3,4], thick=3, color=75
  oplot, aotbins, naotbins[*,4,4], thick=3, color=75, lin=2

  plot, aotbins, naotbins[*,0,0], thick=3, title = 'ALL ('+tag+')', yrange=[0,0.3], $
        ytitle='Frequency', xtitle='AOT', xrange=[0,0.5]
  oplot, aotbins, naotbins[*,1,0], thick=3, color=254
  oplot, aotbins, naotbins[*,2,0], thick=3, color=254, lin=2
  oplot, aotbins, naotbins[*,3,0], thick=3, color=75
  oplot, aotbins, naotbins[*,4,0], thick=3, color=75, lin=2

  device, /close



  set_plot, 'ps'
  device, file='cumdiffpdf.'+tag+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=18
  !p.font=0
  !p.multi=[0,2,3]
  loadct, 39
  difbins = findgen(nbins)*.008-0.2
  a = 10
  b = 15
  plot, difbins, cumbins[*,0,1], thick=3, title = 'DJF ('+tag+')', yrange=[0,1], $
        ytitle='Cumulative Fraction', xtitle='Difference in mean AOT', xrange=[-.1,.1]
  oplot, difbins, cumbins[*,1,1], thick=3, color=254
  oplot, difbins, cumbins[*,2,1], thick=3, color=254, lin=2
  oplot, difbins, cumbins[*,3,1], thick=3, color=75
  oplot, difbins, cumbins[*,4,1], thick=3, color=75, lin=2
;  plots, [-.1,-.02], cumbins[a,1,1]
;  plots, -.02, [0,cumbins[a,1,1]]
;  plots, [.1,.02], cumbins[b,1,1]
;  plots, .02, [1,cumbins[b,1,1]]
  
  plot, difbins, cumbins[*,0,2], thick=3, title = 'MAM ('+tag+')', yrange=[0,1], $
        ytitle='Cumulative Fraction', xtitle='Difference in mean AOT', xrange=[-.1,.1]
  oplot, difbins, cumbins[*,1,2], thick=3, color=254
  oplot, difbins, cumbins[*,2,2], thick=3, color=254, lin=2
  oplot, difbins, cumbins[*,3,2], thick=3, color=75
  oplot, difbins, cumbins[*,4,2], thick=3, color=75, lin=2
;  plots, [-.1,-.02], cumbins[a,1,2]
;  plots, -.02, [0,cumbins[a,1,2]]
;  plots, [.1,.02], cumbins[b,1,2]
;  plots, .02, [1,cumbins[b,1,2]]

  plot, difbins, cumbins[*,0,3], thick=3, title = 'JJA ('+tag+')', yrange=[0,1], $
        ytitle='Cumulative Fraction', xtitle='Difference in mean AOT', xrange=[-.1,.1]
  oplot, difbins, cumbins[*,1,3], thick=3, color=254
  oplot, difbins, cumbins[*,2,3], thick=3, color=254, lin=2
  oplot, difbins, cumbins[*,3,3], thick=3, color=75
  oplot, difbins, cumbins[*,4,3], thick=3, color=75, lin=2
;  plots, [-.1,-.02], cumbins[a,1,3]
;  plots, -.02, [0,cumbins[a,1,3]]
;  plots, [.1,.02], cumbins[b,1,3]
;  plots, .02, [1,cumbins[b,1,3]]

  plot, difbins, cumbins[*,0,4], thick=3, title = 'SON ('+tag+')', yrange=[0,1], $
        ytitle='Cumulative Fraction', xtitle='Difference in mean AOT', xrange=[-.1,.1]
  oplot, difbins, cumbins[*,1,4], thick=3, color=254
  oplot, difbins, cumbins[*,2,4], thick=3, color=254, lin=2
  oplot, difbins, cumbins[*,3,4], thick=3, color=75
  oplot, difbins, cumbins[*,4,4], thick=3, color=75, lin=2
;  plots, [-.1,-.02], cumbins[a,1,4]
;  plots, -.02, [0,cumbins[a,1,4]]
;  plots, [.1,.02], cumbins[b,1,4]
;  plots, .02, [1,cumbins[b,1,4]]

  plot, difbins, cumbins[*,0,0], thick=3, title = 'ALL ('+tag+')', yrange=[0,1], $
        ytitle='Cumulative Fraction', xtitle='Difference in mean AOT', xrange=[-.1,.1]
  oplot, difbins, cumbins[*,1,0], thick=3, color=254
  oplot, difbins, cumbins[*,2,0], thick=3, color=254, lin=2
  oplot, difbins, cumbins[*,3,0], thick=3, color=75
  oplot, difbins, cumbins[*,4,0], thick=3, color=75, lin=2
;  plots, [-.1,-.02], cumbins[a,1,0]
;  plots, -.02, [0,cumbins[a,1,0]]
;  plots, [.1,.02], cumbins[b,1,0]
;  plots, .02, [1,cumbins[b,1,0]]

  device, /close

end
