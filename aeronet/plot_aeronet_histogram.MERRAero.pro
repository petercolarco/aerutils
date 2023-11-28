  restore, 'aeronet_histogram.MERRAero.sav'
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

  set_plot, 'ps'
  device, file='plot_aeronet_histogram.MERRAero.ps', /color, font_size=12, $
   xoff=.5, yoff=.5, xsize=28, ysize=12
  !p.font=0

  plot, bins, hist[*,0], /nodata, $
   xtitle='!3AERONET - Model', ytitle = '!3relative frequency', $
   xrange=[-.5,.5], xstyle=9, yrange=[0.001,1], ystyle=9, thick=3, $
   xticks=10, /ylog, position=[.1,.1,.475,.9], $
   xtickname=['-0.5','-0.4','-0.3','-0.2','-0.1','0','0.1','0.2','0.3','0.4','0.5']
  plots, 0, [0.001,1], thick=1, noclip=0
  oplot, bins, hist[*,0], thick=8
  plots, [.05,.1], .85, thick=8
  xyouts, .11, .75, 'MERRAero'
  xyouts, .1, .94, '!4(a)!3 MERRAero versus AERONET bias in Hourly AOT', /normal

  if(nexp gt 1) then begin
   loadct, 39
   oplot, bins, hist[*,2], thick=8, color=208
   oplot, bins, hist[*,3], thick=8, color=84
   oplot, bins, hist[*,1], thick=8, color=254, lin=2

   plots, [.05,.1], .80, thick=8,color=254, lin=2
   plots, [.05,.1], .75, thick=8,color=208
   plots, [.05,.1], .70, thick=8,color=84
   xyouts, .11, .79, 'Hindcast 0.5!Eo!N x 0.625!Eo!N'
   xyouts, .11, .74, 'Hindcast 1!Eo!N x 1.25!Eo!N'
   xyouts, .11, .69, 'Hindcast 2!Eo!N x 2.5!Eo!N'
  endif

  for iexp = 0, nexp-1 do begin
   statistics, aeraot, modaot[*,iexp], mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
   print, bias, rms, skill, mean0, mean1, frac10[0]
  endfor


; Make a map showing the distributions
  loadct, 39
  map_set, /cont, position=[.525,.25,.975,.9], /noerase
  a = where(useloc eq 1)
; Draw a symbol for each point, where the radius represents the number
; of comparison points and the color the model bias
  nstart = 0
  for i = 0, n_elements(a)-1 do begin
   symsize=.4
   if(numloc[a[i]] gt 1000) then symsize=.75
   if(numloc[a[i]] gt 2000) then symsize=1
   if(numloc[a[i]] gt 5000) then symsize=1.5
   if(numloc[a[i]] gt 10000) then symsize=2
   if(numloc[a[i]] gt 20000) then symsize=2.5
;  Find the bias and color code
   nrange = [nstart,nstart+numloc[a[i]]-1]
   statistics, aeraot[nstart:nstart+numloc[a[i]]-1], modaot[nstart:nstart+numloc[a[i]]-1,0], $
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
print, location[a[i]], nstart, color, mean0, mean1
   plots, lon[a[i]], lat[a[i]], psym=sym(1), symsize=symsize, color=color
   plots, lon[a[i]], lat[a[i]], psym=sym(6), symsize=symsize
  endfor

; Plot a key
  plots, .54, .19, psym=sym(1), color=48, /normal, symsize=1.5
  plots, .61, .19, psym=sym(1), color=90, /normal, symsize=1.5
  plots, .68, .19, psym=sym(1), color=176, /normal, symsize=1.5
  plots, .75, .19, psym=sym(1), color=255, /normal, symsize=1.5
  plots, .82, .19, psym=sym(1), color=192, /normal, symsize=1.5
  plots, .89, .19, psym=sym(1), color=208, /normal, symsize=1.5
  plots, .96, .19, psym=sym(1), color=254, /normal, symsize=1.5

  plots, .54, .19, psym=sym(6), /normal, symsize=1.5
  plots, .61, .19, psym=sym(6), /normal, symsize=1.5
  plots, .68, .19, psym=sym(6), /normal, symsize=1.5
  plots, .75, .19, psym=sym(6), /normal, symsize=1.5
  plots, .82, .19, psym=sym(6), /normal, symsize=1.5
  plots, .89, .19, psym=sym(6), /normal, symsize=1.5
  plots, .96, .19, psym=sym(6), /normal, symsize=1.5

  xyouts, .75, .22, /normal, 'MERRAero bias versus AERONET (b)', align=.5, charsize=.75
  xyouts, .54, .15, /normal, 'b < -0.05', align=.5, charsize=.5
  xyouts, .61, .15, /normal, '-0.05 < b < -0.025', align=.5, charsize=.5
  xyouts, .68, .15, /normal, '-0.025 < b < -0.01', align=.5, charsize=.5
  xyouts, .75, .15, /normal, '-0.01 < b < 0.01', align=.5, charsize=.5
  xyouts, .82, .15, /normal, '0.01 < b < 0.025', align=.5, charsize=.5
  xyouts, .89, .15, /normal, '0.025 < b < 0.05', align=.5, charsize=.5
  xyouts, .96, .15, /normal, 'b > 0.05', align=.5, charsize=.5

  loadct, 0
  plots, .575, .07, psym=sym(1), color=150, /normal, symsize=.4
  plots, .645, .07, psym=sym(1), color=150, /normal, symsize=.75
  plots, .715, .07, psym=sym(1), color=150, /normal, symsize=1
  plots, .785, .07, psym=sym(1), color=150, /normal, symsize=1.5
  plots, .855, .07, psym=sym(1), color=150, /normal, symsize=2
  plots, .925, .07, psym=sym(1), color=150, /normal, symsize=2.5

  plots, .575, .07, psym=sym(6), /normal, symsize=.4
  plots, .645, .07, psym=sym(6), /normal, symsize=.75
  plots, .715, .07, psym=sym(6), /normal, symsize=1
  plots, .785, .07, psym=sym(6), /normal, symsize=1.5
  plots, .855, .07, psym=sym(6), /normal, symsize=2
  plots, .925, .07, psym=sym(6), /normal, symsize=2.5

  xyouts, .75, .1, /normal, 'Number of hourly matches (n)', charsize=.75, align=.5
  xyouts, .575, .02, /normal, 'n < 1000', align=.5, charsize=.5
  xyouts, .645, .02, /normal, '1000 < n < 2000', align=.5, charsize=.5
  xyouts, .715, .02, /normal, '2000 < n < 5000', align=.5, charsize=.5
  xyouts, .785, .02, /normal, '5000 < n < 10000', align=.5, charsize=.5
  xyouts, .855, .02, /normal, '10000 < n < 20000', align=.5, charsize=.5
  xyouts, .925, .02, /normal, 'n > 20000', align=.5, charsize=.5

  xyouts, .525, .94, /normal, '!4(b)!3 MERRAero versus AERONET bias in Hourly AOT (by site)'

  device, /close



end
