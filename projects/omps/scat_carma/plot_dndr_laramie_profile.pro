; Make a plot to compare to Kovilakam and Deshler 2015 Figure 5(b)
  set_plot, 'ps'
  device, file='dndlnr_laramie_profile.c90Fc_I10pa3.ps', /helvetica, font_size=14, /color
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, position=[.2,.1,.9,.9], $
   xrange=[.001,100], /xlog, yrange=[5,30], $
   xtitle = 'N [cm!E-3!N]', ytitle='[km]'

; Get the profile for one case
  expid = 'c90Fc_I10pa3_ctrl'
  filename = 'dndr_laramie.'+expid+'.txt'
  get_dndr, filename, r, dr, dndr, alt
  nbin = n_elements(r)
  nz = n_elements(alt)
  n = fltarr(nz,nbin)
  n[*,nbin-1] = dndr[*,nbin-1]*dr[nbin-1]/1.e6
  for ibin = nbin-2, 0, -1 do begin
   n[*,ibin] = n[*,ibin+1]+dndr[*,ibin]*dr[ibin]/1.e6
  endfor
; Plot for lines of r > some radius
  a = where(r*1e6 gt 0.079)
  oplot, total(n[*,a],2), alt, thick=6, color=254, lin=2
  a = where(r*1e6 gt 0.161)
  oplot, total(n[*,a],2), alt, thick=6, color=84, lin=2
  a = where(r*1e6 gt 0.276)
  oplot, total(n[*,a],2), alt, thick=6, color=32, lin=2


; Get the profile for one case
  expid = 'c90Fc_I10pa3_anth'
  filename = 'dndr_laramie.'+expid+'.txt'
  get_dndr, filename, r, dr, dndr, alt
  nbin = n_elements(r)
  nz = n_elements(alt)
  n = fltarr(nz,nbin)
  n[*,nbin-1] = dndr[*,nbin-1]*dr[nbin-1]/1.e6
  for ibin = nbin-2, 0, -1 do begin
   n[*,ibin] = n[*,ibin+1]+dndr[*,ibin]*dr[ibin]/1.e6
  endfor
; Plot for lines of r > some radius
  a = where(r*1e6 gt 0.079)
  oplot, total(n[*,a],2), alt, thick=6, color=254
  a = where(r*1e6 gt 0.161)
  oplot, total(n[*,a],2), alt, thick=6, color=84
  a = where(r*1e6 gt 0.276)
  oplot, total(n[*,a],2), alt, thick=6, color=32

  device, /close

end

