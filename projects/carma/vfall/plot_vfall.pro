  filenames = ['c90_pI10p1_pina10md.tavg3d_carma_e.19910615_2345z.nc4', $
               'c90_pI10p1_pina10.tavg3d_carma_e.19910615_2345z.nc4']

  nf = n_elements(filenames)

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

  for ii = 0, nf-1 do begin
print, ii
  filename = filenames[ii]

  nc4readvar, filename, 'suvf', suvf, /template, lon=lon, lat=lat
  if(ii eq 0) then begin
    nc4readvar, filename, 'mxvf', mxvf, /template, lon=lon, lat=lat
  endif else begin
    nc4readvar, filename, 'duvf', mxvf, /template, lon=lon, lat=lat
  endelse
  check, mxvf

  i = 232
  j = 102

  if(ii eq 0) then begin
  set_plot, 'ps'
  device, file='plot_vfall.ps', /color, /helvetica, font_size=14
   !p.font=0
  plot, suvf[i,j,*,0], ze/1000., /nodata, $
   xrange=[0.00001,10.], /xlog, xtitle='vfall [km day!E-1!N]', $
   yrange=[0,40], ytitle='altitude [km]'
  endif


  loadct, 39
  for ibin = 0, 21 do begin
   oplot, suvf[i,j,*,ibin]/1000.*86400., ze/1000., color=176, lin=ii, thick=(2*ii)+1
   if(ibin eq 16 or ibin eq 18) then oplot, suvf[i,j,*,ibin]/1000.*86400., ze/1000., color=176, lin=ii, thick=12
;   if(ibin eq 16 or ibin eq 18) then oplot, mxvf[i,j,*,ibin]/1000.*86400., ze/1000., color=208, lin=ii, thick=(2*ii)+1
  endfor

  endfor

  device, /close

end
