; First get the Y2007 histograms
  restore, 'aeronet_histogram.2007.sav'
  bins = findgen(101)*.01 - .5

  hist = float(hist)

  nbins = 101
  maxv = 0.5
  minv = -0.5
  hist = lonarr(nbins,nexp)
  frac10 = fltarr(nexp)
  npts = n_elements(aeraot)*1.
  for iexp = 0, nexp-1 do begin
   hist[*,iexp] = histogram(aeraot-modaot[*,iexp],nbins=nbin,max=maxv,min=minv)
   a = where(modaot[*,iexp] ge 0.5*aeraot and modaot[*,iexp] le 1.5*aeraot)
   frac10[iexp] = n_elements(a)/npts
  endfor
  hist = float(hist)/max(hist[*,0])

  histsav = hist

; Now get the all year MERRAero
  restore, 'aeronet_histogram.sav'
  bins = findgen(101)*.01 - .5

  hist = float(hist)

  nbins = 101
  maxv = 0.5
  minv = -0.5
  hist = lonarr(nbins,nexp)
  frac10 = fltarr(nexp)
  npts = n_elements(aeraot)*1.
  for iexp = 0, nexp-1 do begin
   hist[*,iexp] = histogram(aeraot-modaot[*,iexp],nbins=nbin,max=maxv,min=minv)
   a = where(modaot[*,iexp] ge 0.5*aeraot and modaot[*,iexp] le 1.5*aeraot)
   frac10[iexp] = n_elements(a)/npts
  endfor
  hist = float(hist)/max(hist[*,0])

; concatenate them
  hist = reform([hist,histsav[*,0],histsav[*,1]],nbins,3)

  set_plot, 'ps'
  device, file='output/plots/plot_aeronet_histogram.ps', /color, font_size=12, $
   xoff=.5, yoff=.5, xsize=14, ysize=12
  !p.font=0

  plot, bins, hist[*,0], /nodata, $
   xtitle='!3AERONET - Model', ytitle = '!3relative frequency', $
   xrange=[-.5,.5], xstyle=9, yrange=[0.001,1], ystyle=9, thick=3, $
   xticks=10, /ylog, $
   xtickname=['-0.5','-0.4','-0.3','-0.2','-0.1','0','0.1','0.2','0.3','0.4','0.5']
  plots, 0, [0.001,1], thick=1, noclip=0
  oplot, bins, hist[*,0], thick=8
  oplot, bins, hist[*,1], thick=8, lin=2
loadct, 39
  oplot, bins, hist[*,2], thick=8, lin=2, color=254
  plots, [-.45,-.37], .80, thick=8
  xyouts, -.35, .73, 'MERRAero'
  plots, [-.45,-.37], .60, thick=8, lin=2
  xyouts, -.35, .55, 'MERRAero (2007)'
  plots, [-.45,-.37], .45, thick=8, lin=2, color=254
  xyouts, -.35, .40, 'Replay (2007)'

  if(nexp gt 1) then begin
   loadct, 39
   oplot, bins, hist[*,6], thick=8, color=176, lin=1
   oplot, bins, hist[*,7], thick=8, color=176, lin=2
   oplot, bins, hist[*,6], thick=8, color=84, lin=2
   oplot, bins, hist[*,5], thick=8, color=208, lin=2
   oplot, bins, hist[*,4], thick=8, color=176
   oplot, bins, hist[*,3], thick=8, color=84
   oplot, bins, hist[*,2], thick=8, color=208
   oplot, bins, hist[*,1], thick=8, color=254

   plots, [-.45,-.37], .80, thick=8,color=254
   plots, [-.45,-.37], .60, thick=8,color=208
   plots, [-.45,-.37], .45, thick=8,color=84
   plots, [-.45,-.37], .33, thick=8,color=176
   xyouts, -.35, .73, '0.25!Eo!N'
   xyouts, -.35, .55, '0.5!Eo!N'
   xyouts, -.35, .40, '1!Eo!N'
   xyouts, -.35, .30, '2!Eo!N'

   plots, [-.25,-.17], .60, thick=8,color=208, lin=2
   plots, [-.25,-.17], .45, thick=8,color=84, lin=2
   plots, [-.25,-.17], .33, thick=8,color=176, lin=2
   xyouts, -.15, .55, 'c180'
   xyouts, -.15, .40, 'c90'
   xyouts, -.15, .30, 'c48'
  endif

  device, /close

  for iexp = 0, nexp-1 do begin
   statistics, aeraot, modaot[*,iexp], mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
   print, bias, rms, skill, mean0, mean1, frac10[0]
  endfor


; Make a map showing the distributions
  set_plot, 'ps'
  modnum = 0
  device, file='output/plots/plot_aeronet_histogram.map.ps', /color, font_size=12, $
   xoff=.5, yoff=.5, xsize=14, ysize=12
  !p.font=0
  loadct, 39
  map_set, /cont, position=[.05,.25,.95,.975]
  a = where(useloc eq 1)
; Draw a symbol for each point, where the radius represents the number
; of comparison points and the color the model bias
  nstart = 0
  for i = 0, n_elements(a)-1 do begin
   symsize=.4
   if(numloc[a[i]] gt 500) then symsize=.75
   if(numloc[a[i]] gt 1000) then symsize=1
   if(numloc[a[i]] gt 1500) then symsize=1.5
   if(numloc[a[i]] gt 2000) then symsize=2
   if(numloc[a[i]] gt 2500) then symsize=2.5
;  Find the bias and color code
   nrange = [nstart,nstart+numloc[a[i]]-1]
   statistics, aeraot[nstart:nstart+numloc[a[i]]-1], modaot[nstart:nstart+numloc[a[i]]-1,modnum], $
     mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
;if(location[a[i]] eq "Capo_Verde") then stop
   nstart = nstart + numloc[a[i]]
   if(bias lt -.05) then color=48
   if(bias gt -.05) then color=90
   if(bias gt -.025) then color=176
   if(bias gt -.01) then color=255
   if(bias gt .01) then color=192
   if(bias gt .025) then color=208
   if(bias gt .05) then color=254
;print, nstart, color
   plots, lon[a[i]], lat[a[i]], psym=sym(1), symsize=symsize, color=color
   plots, lon[a[i]], lat[a[i]], psym=sym(6), symsize=symsize
  endfor

; Plot a key
  plots, .08, .19, psym=sym(1), color=48, /normal, symsize=1.5
  plots, .22, .19, psym=sym(1), color=90, /normal, symsize=1.5
  plots, .36, .19, psym=sym(1), color=176, /normal, symsize=1.5
  plots, .5, .19, psym=sym(1), color=255, /normal, symsize=1.5
  plots, .64, .19, psym=sym(1), color=192, /normal, symsize=1.5
  plots, .78, .19, psym=sym(1), color=208, /normal, symsize=1.5
  plots, .92, .19, psym=sym(1), color=254, /normal, symsize=1.5

  plots, .08, .19, psym=sym(6), /normal, symsize=1.5
  plots, .22, .19, psym=sym(6), /normal, symsize=1.5
  plots, .36, .19, psym=sym(6), /normal, symsize=1.5
  plots, .5, .19, psym=sym(6), /normal, symsize=1.5
  plots, .64, .19, psym=sym(6), /normal, symsize=1.5
  plots, .78, .19, psym=sym(6), /normal, symsize=1.5
  plots, .92, .19, psym=sym(6), /normal, symsize=1.5

  xyouts, .5, .22, /normal, 'MERRAero bias versus AERONET (b)', align=.5, charsize=.75
  xyouts, .08, .15, /normal, 'b < -0.05', align=.5, charsize=.5
  xyouts, .22, .15, /normal, '-0.05 < b < -0.025', align=.5, charsize=.5
  xyouts, .36, .15, /normal, '-0.025 < b < -0.01', align=.5, charsize=.5
  xyouts, .5, .15, /normal, '-0.01 < b < 0.01', align=.5, charsize=.5
  xyouts, .64, .15, /normal, '0.01 < b < 0.025', align=.5, charsize=.5
  xyouts, .78, .15, /normal, '0.025 < b < 0.05', align=.5, charsize=.5
  xyouts, .92, .15, /normal, 'b > 0.05', align=.5, charsize=.5

  loadct, 0
  plots, .12, .07, psym=sym(1), color=150, /normal, symsize=.4
  plots, .27, .07, psym=sym(1), color=150, /normal, symsize=.75
  plots, .42, .07, psym=sym(1), color=150, /normal, symsize=1
  plots, .57, .07, psym=sym(1), color=150, /normal, symsize=1.5
  plots, .72, .07, psym=sym(1), color=150, /normal, symsize=2
  plots, .87, .07, psym=sym(1), color=150, /normal, symsize=2.5

  plots, .12, .07, psym=sym(6), /normal, symsize=.4
  plots, .27, .07, psym=sym(6), /normal, symsize=.75
  plots, .42, .07, psym=sym(6), /normal, symsize=1
  plots, .57, .07, psym=sym(6), /normal, symsize=1.5
  plots, .72, .07, psym=sym(6), /normal, symsize=2
  plots, .87, .07, psym=sym(6), /normal, symsize=2.5

  xyouts, .5, .1, /normal, 'Number of hourly matches (n)', charsize=.75, align=.5
  xyouts, .12, .02, /normal, 'n < 500', align=.5, charsize=.5
  xyouts, .27, .02, /normal, '500 < n < 1000', align=.5, charsize=.5
  xyouts, .42, .02, /normal, '1000 < n < 1500', align=.5, charsize=.5
  xyouts, .57, .02, /normal, '1500 < n < 2000', align=.5, charsize=.5
  xyouts, .72, .02, /normal, '2000 < n < 2500', align=.5, charsize=.5
  xyouts, .87, .02, /normal, 'n> 2500', align=.5, charsize=.5

  device, /close



end
