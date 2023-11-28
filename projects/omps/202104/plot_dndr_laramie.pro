; Make a plot to compare to Kovilakam and Deshler 2015 Figure 5(b)
  set_plot, 'ps'
  device, file='dndlnr_laramie.c90Fc_I10pa3.ps', /helvetica, font_size=14, /color, $
   xsize=16, ysize=24
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[0.01,1], /xlog, yrange=[1.e-6,2], /ylog, ystyle=1, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N/N0'

; Get the profile for one case
  expid = 'c90Fc_I10pa3_anth'
  filename = 'dndr_laramie.'+expid+'.txt'
  get_dndr, filename, r, dr, dndr, alt
  nbin = n_elements(r)
  n = fltarr(nbin)
  n[nbin-1] = dndr[32,nbin-1]*dr[nbin-1]/1.e6
  for ibin = nbin-2, 0, -1 do begin
   n[ibin] = n[ibin+1]+dndr[32,ibin]*dr[ibin]/1.e6
  endfor
  oplot, r*1e6, n/n[0], thick=14, color=0



; Gamma distribution (Ernest)
  alpha = 1.45
  beta  = 18.36
  nbin  = 1000
  dr    = 0.01  ; micron
  r     = findgen(nbin)*dr+0.01

; Gamma distribution
  n = (beta^alpha)*r^(alpha-1.)*exp(-r*beta) / gamma(alpha)
  dndr = n

  ncum = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   ncum[ibin] = total(n[ibin:nbin-1])
  endfor
  ncum = ncum/ncum[0]

  oplot, r, ncum, thick=14, lin=2, color=254





; Gamma distribution (Zhong)
  alpha = 1.8
  beta  = 20.5
  nbin  = 1000
  dr    = 0.01  ; micron
  r     = findgen(nbin)*dr+0.01

; Gamma distribution
  n = (beta^alpha)*r^(alpha-1.)*exp(-r*beta) / gamma(alpha)
  dndr = n

  ncum = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   ncum[ibin] = total(n[ibin:nbin-1])
  endfor
  ncum = ncum/ncum[0]

  oplot, r, ncum, thick=14, lin=2, color=84

  device, /close

end

