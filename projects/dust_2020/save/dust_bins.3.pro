; Plot the size bins used in the ICAP models

  names = ['GEOS/GEFS/AM4','MODELe', 'IFS','SILAM','MONARCH','MASINGER',$
           'UM','NAAPS']
  nbins = [8,5,3,4,8,10,2,1]

  set_plot, 'ps'
  device, file='dust_bins.3.ps', /color, /helvetica, font_size=14, $
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

  loadct, 39
  axis, yaxis=1, yrange=[.0005,2], /ylog, ystyle=9, /save
  xyouts, .95, .52, 'Normalized Volume Size Distribution dV/d(ln d)', $
                     chars=.8, align=.5, orient=270, /normal
;  oplot, d, dvdlnd, thick=12

; GEOS Ginoux emission psd
  mfrac = [0.0009,0.0081,0.0234,0.0676,0.25,0.25,0.25,0.25]
  dd_    = [.08,.12,.3,.4,.8,1.2,3,4.]*2.
  d_     = [0.1,.18,.3,.6,1,1.8,3,6]*2.
  dvdlnd = mfrac*d_/dd_
  dvdlnd = dvdlnd/max(dvdlnd)
 ; oplot, 1.2*d_, dvdlnd, thick=12, color=90

; Get Kok atmosphere
  read_psd_load, diam, dmdlnd, dmdlndm2, dmdlndp2
  oplot, diam, dmdlnd/max(dmdlnd), thick=12, color=84;, lin=2

; OPAC DESE model
  rmed = [0.27,1.6,11.]*1e-6
  sigma = [1.95,2.0,2.15]
  frac = [7.5,168.7,45.6]
  frac = frac/total(frac)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, /vol, rlow=rlow, rup=rup
  dvdlnd = (dvdr*r)/max(dvdr*r)
  oplot, d, dvdlnd, thick=12,color=148

; GEOS PSD (June 2019, AOD weighted--see geos_mean_psd)
  mfrac0 = 0.258
  mfrac = [0.009*mfrac0,0.081*mfrac0,0.234*mfrac0,0.676*mfrac0,0.8756,1.0,0.610,0.150]
  dvdlnd = mfrac*d_/dd_
  dvdlnd = dvdlnd/max(dvdlnd)
  oplot, 1.2*d_, dvdlnd, thick=12, color=0;, lin=2


goto, jump
loadct, 0
; Get the RS PSDs
; Here is a default set of sizes for a lognormal
  nbin = 1000
  rmrat = (50.d/.01d)^(3.d/(nbin-1))
  rmin = 0.01d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow

; AERONET, Cape Verde, Table 1 in Rob's section
  volume_fraction = [0.094,1.593]
  volume_mean_r   = [0.291,1.797]
  stddev          = [0.481,0.534]
  frac  = volume_fraction/total(volume_fraction)
frac = volume_fraction
  rmed  = volume_mean_r*1e-6
  sigma = exp(stddev)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, $
   /vol, rlow=rlow, rup=rup

  dvdlnd = dvdr*r/(max(dvdr*r))
  oplot, r*1e6*2, dvdlnd, thick=4, color=140

  read_levy, model, rv, sig, vm, nmode
  igood = [0,1,1,1,1,1,1,0,0,1,1,0]
  color = [0,32,96,100,56,56,254,0,0,144,144,0]
  lin   = [0,0,2,3,0,2,0,0,0,0,2,0]
  for imod = 0, n_elements(model)-1 do begin
   if(igood[imod] eq 0) then continue
   rmed  = rv[imod,0:nmode[imod]-1]*1e-6
   sigma = exp(sig[imod,0:nmode[imod]-1])
   frac  = vm[imod,0:nmode[imod]-1]
;   frac  = frac/total(frac)
   lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, $
    /vol, rlow=rlow, rup=rup
   dvdlnd = dvdr*r/(max(dvdr*r))
   oplot, r*1e6*2, dvdlnd, thick=2, color=140
  endfor


jump:

  device, /close

end
