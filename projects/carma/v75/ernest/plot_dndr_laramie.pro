; Make a plot to compare to Kovilakam and Deshler 2015 Figure 5(b)
  set_plot, 'ps'
  device, file='dndlnr_laramie.c90Fc_I10pa3.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[0.01,1], /xlog, yrange=[1.e-4,1.e2], /ylog, $
   xtitle = 'radius [!Mm!Nm]', ytitle='N [cm!E-3!N], dNdlnr [cm!E-3!N]'

; Get the profile for one case
  expid = 'c90Fc_I10pa3_ctrl'
  filename = 'dndr_laramie.'+expid+'.txt'
  get_dndr, filename, r, dr, dndr, alt
  nbin = n_elements(r)
  oplot, r*1e6, dndr[32,*]*r/1e6, thick=6, color=254, lin=2
  n = fltarr(nbin)
  n[nbin-1] = dndr[32,nbin-1]*dr[nbin-1]/1.e6
  for ibin = nbin-2, 0, -1 do begin
   n[ibin] = n[ibin+1]+dndr[32,ibin]*dr[ibin]/1.e6
  endfor
  oplot, r*1e6, n, thick=6, color=254

; Get the profile for one case
  expid = 'c90Fc_I10pa3_anth'
  filename = 'dndr_laramie.'+expid+'.txt'
  get_dndr, filename, r, dr, dndr, alt
  nbin = n_elements(r)
  oplot, r*1e6, dndr[32,*]*r/1e6, thick=6, color=208, lin=2
  n = fltarr(nbin)
  n[nbin-1] = dndr[32,nbin-1]*dr[nbin-1]/1.e6
  for ibin = nbin-2, 0, -1 do begin
   n[ibin] = n[ibin+1]+dndr[32,ibin]*dr[ibin]/1.e6
  endfor
  oplot, r*1e6, n, thick=6, color=208

  device, /close

end

