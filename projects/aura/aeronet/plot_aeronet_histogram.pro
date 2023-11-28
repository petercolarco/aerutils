  restore, 'aeronet_histogram.sav'
a = where(modaot gt 1e14)
modaot[a] = !values.f_nan
  bins = findgen(101)*.01 - .5

  hist = float(hist)

  nbins = 101
  maxv = 0.5
  minv = -0.5
  hist = fltarr(nbins,nexp)
  frac10 = fltarr(nexp)
  npts = n_elements(aeraot)*1.
  for iexp = 0, nexp-1 do begin
   hist[*,iexp] = histogram(modaot[*,iexp]-aeraot,nbins=nbin,max=maxv,min=minv)
   a = where(modaot[*,iexp] ge 0.5*aeraot and modaot[*,iexp] le 1.5*aeraot)
   frac10[iexp] = n_elements(a)/npts
   hist[*,iexp] = float(hist[*,iexp])/total(hist[*,iexp])
  endfor
;  hist = float(hist)/max(hist[*,0])

  set_plot, 'ps'
  device, file='plot_aeronet_histogram.ps', /color, font_size=12, $
   xoff=.5, yoff=.5, xsize=14, ysize=12
  !p.font=0
  loadct, 0

  plot, bins, hist[*,0], /nodata, $
   xtitle='!3Model - AERONET', ytitle = '!3relative frequency', $
   xrange=[-.25,.25], xstyle=9, yrange=[0.,0.1], ystyle=9, thick=3, $
   xticks=10;, $; /ylog, $
   xtickname=['-0.5','-0.4','-0.3','-0.2','-0.1','0','0.1','0.2','0.3','0.4','0.5']
  plots, 0, [0.,1], thick=1, noclip=0
  oplot, bins, hist[*,0], thick=8
  plots, [.08,.12], .095, thick=8
  xyouts, .13, .0935, 'MERRAero'

  if(nexp gt 1) then begin
   loadct, 39
   oplot, bins, hist[*,1], thick=8, color=254
   oplot, bins, hist[*,2], thick=8, color=84, lin=2

   plots, [.08,.12], .087, thick=8,color=254
   plots, [.08,.12], .079, thick=8,color=84, lin=2
   xyouts, .13, .0855, 'R!U1/2!Eo!N'
   xyouts, .13, .0775, 'R!U2!Eo!N'

  endif

  device, /close

  for iexp = 0, nexp-1 do begin
   statistics, aeraot, modaot[*,iexp], mean0, mean1, std0, std1, r, bias, rms, skill, linslope, linoffset
   print, bias, rms, skill, mean0, mean1, frac10[0]
  endfor


; Make a map showing the distributions
  set_plot, 'ps'
  modnum = 1
  device, file='plot_aeronet_histogram.map.c180R_H40_acma.ps', /color, font_size=12, $
   xoff=.5, yoff=.5, xsize=14, ysize=12
  !p.font=0

  red   = [69,145,224,255,254,252,215,152,0]
  green = [117,191,243,255,224,141,48,152,0]
  blue  = [180,219,248,191,144,89,39, 152,0]
  tvlct, red, green, blue
  dcolors = findgen(n_elements(red))

  map_set, position=[.05,.25,.95,.975], /noborder, /robinson, /iso, /grid, glinestyle=0, color=7, glinethick=.5
  map_continents, color=7, thick=1
  map_continents, color=7, thick=1, /countries

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
   if(bias lt -.05) then color=0
   if(bias gt -.05) then color=1
   if(bias gt -.025) then color=2
   if(bias gt -.01) then color=3
   if(bias gt .01) then color=4
   if(bias gt .025) then color=5
   if(bias gt .05) then color=6
;print, nstart, color
   plots, lon[a[i]], lat[a[i]], psym=sym(1), symsize=symsize, color=color
   plots, lon[a[i]], lat[a[i]], psym=sym(6), symsize=symsize
  endfor

; Plot a key
  plots, .08, .19, psym=sym(1), color=0, /normal, symsize=1.5
  plots, .22, .19, psym=sym(1), color=1, /normal, symsize=1.5
  plots, .36, .19, psym=sym(1), color=2, /normal, symsize=1.5
  plots, .5, .19, psym=sym(1), color=3, /normal, symsize=1.5
  plots, .64, .19, psym=sym(1), color=4, /normal, symsize=1.5
  plots, .78, .19, psym=sym(1), color=5, /normal, symsize=1.5
  plots, .92, .19, psym=sym(1), color=6, /normal, symsize=1.5

  plots, .08, .19, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .22, .19, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .36, .19, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .5, .19, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .64, .19, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .78, .19, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .92, .19, psym=sym(6), /normal, symsize=1.5, color=8

  xyouts, .5, .22, /normal, 'Model bias versus AERONET (b)', align=.5, charsize=.75, color=8
  xyouts, .08, .15, /normal, 'b < -0.05', align=.5, charsize=.5, color=8
  xyouts, .22, .15, /normal, '-0.05 < b < -0.025', align=.5, charsize=.5, color=8
  xyouts, .36, .15, /normal, '-0.025 < b < -0.01', align=.5, charsize=.5, color=8
  xyouts, .5, .15, /normal, '-0.01 < b < 0.01', align=.5, charsize=.5, color=8
  xyouts, .64, .15, /normal, '0.01 < b < 0.025', align=.5, charsize=.5, color=8
  xyouts, .78, .15, /normal, '0.025 < b < 0.05', align=.5, charsize=.5, color=8
  xyouts, .92, .15, /normal, 'b > 0.05', align=.5, charsize=.5, color=8

  plots, .12, .07, psym=sym(1), color=7, /normal, symsize=.4
  plots, .27, .07, psym=sym(1), color=7, /normal, symsize=.75
  plots, .42, .07, psym=sym(1), color=7, /normal, symsize=1
  plots, .57, .07, psym=sym(1), color=7, /normal, symsize=1.5
  plots, .72, .07, psym=sym(1), color=7, /normal, symsize=2
  plots, .87, .07, psym=sym(1), color=7, /normal, symsize=2.5

  plots, .12, .07, psym=sym(6), /normal, symsize=.4, color=8
  plots, .27, .07, psym=sym(6), /normal, symsize=.75, color=8
  plots, .42, .07, psym=sym(6), /normal, symsize=1, color=8
  plots, .57, .07, psym=sym(6), /normal, symsize=1.5, color=8
  plots, .72, .07, psym=sym(6), /normal, symsize=2, color=8
  plots, .87, .07, psym=sym(6), /normal, symsize=2.5, color=8

  xyouts, .5, .1, /normal, 'Number of hourly matches (n)', charsize=.75, align=.5, color=8
  xyouts, .12, .02, /normal, 'n < 500', align=.5, charsize=.5, color=8
  xyouts, .27, .02, /normal, '500 < n < 1000', align=.5, charsize=.5, color=8
  xyouts, .42, .02, /normal, '1000 < n < 1500', align=.5, charsize=.5, color=8
  xyouts, .57, .02, /normal, '1500 < n < 2000', align=.5, charsize=.5, color=8
  xyouts, .72, .02, /normal, '2000 < n < 2500', align=.5, charsize=.5, color=8
  xyouts, .87, .02, /normal, 'n> 2500', align=.5, charsize=.5, color=8

  device, /close



end
