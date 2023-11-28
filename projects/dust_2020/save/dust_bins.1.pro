; Plot the size bins used in the ICAP models

  names = ['GEOS/GEFS/AM4','MODELe', 'IFS','SILAM','MONARCH','MASINGER',$
           'UM','NAAPS']
  nbins = [8,5,3,4,8,10,2,1]

  set_plot, 'ps'
  device, file='dust_bins.1.ps', /color, /helvetica, font_size=14, $
   xsize=26, ysize=13.5, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0.01,100], /xlog, xstyle=9, xtitle='diameter [!Mm!Nm]', $
   yrange=[0,9], ystyle=9, thick=3, yticks=1, ytickn=[' ',' '], $
   position=[.24,.12,.85,.92]

  loadct, 55

  imod = 0
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 1
  y = 8-imod
  xmin=[0.1,2,4,8,16]
  xmax=32
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 2
  y = 8-imod
  xmin=[.06,1.1,1.8]
  xmax=40
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 3
  y = 8-imod
  xmin=[.0103,1,2.5,10]
  xmax=30
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 4
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 5
  y = 8-imod
  xmin=[0.2,0.32,0.5,0.8,1.3,2,3.2,5,8,13]
  xmax=20
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 6
  y = 8-imod
  xmin=[0.2,4]
  xmax=20
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  imod = 7
  y = 8-imod
;  plots, 5, y, psym=sym(4), color=255, symsize=2
  plots, [0.2,10], y, thick=48, color=colors[0]

  loadct, 0
  for imod = 0, n_elements(names)-1 do begin
   xyouts, 0.0045, 7.9-imod, '!4'+names[imod], align=1
   xyouts, 0.005, 7.9-imod, 'n = '+string(nbins[imod],format='(i2)')+'!3', chars=.6
  endfor
goto, jump
; Plot the Kok PSD at emission over this
; Create a series of size bins
  nbin = 44
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow
  kok_psd, r, rlow, rup, dv, dn

  dvdr = dv/dr
  dndr = dn/dr

; normalize
  dv = dvdr*dr
  dv = dv/total(dv)
  dvdr = dv/dr

  dndlnd = dndr*r
  dvdlnd = dvdr*r
  d  = 2.*r*1e6
  dd = 2.*dr*1e6

  dvdlnd = dvdlnd/max(dvdlnd)

  axis, yaxis=1, yrange=[.0005,2], /ylog, ystyle=9, /save
  xyouts, .95, .52, 'Normalized Volume Size Distribution dV/d(ln d) [Kok 2011]', $
                     chars=.8, align=.5, orient=270, /normal
  oplot, d, dvdlnd, thick=6

; Get the optical table from CARMA run
  filename = '/home/colarco/sandbox/radiation/x/carma_optics_DU.v15.nbin=44.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 5

; normalize to the mass distribution
  y = dv*bext[ilam,0,*]*r/dr
  y = y/max(y)

;  oplot, 2.*r*1e6, y, thick=6, lin=2
jump:
  device, /close

end
