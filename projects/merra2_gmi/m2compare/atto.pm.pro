goto, jump

; Get MERRA2
  filetemplate = 'MERRA2.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 20160000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'dusmass25',  du0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'so4smass',  su0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'ocsmass',  oc0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'bcsmass',  bc0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'sssmass25',  ss0,  wantlon=[-59.,-59.], wantlat=[2.,2.]

; Get MERRA2_GMI
  filetemplate = 'MERRA2_GMI.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 20160000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'dusmass25',  du1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'so4smass',  su1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'ocsmass',  oc1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'bcsmass',  bc1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'sssmass25',  ss1,  wantlon=[-59.,-59.], wantlat=[2.,2.]


jump:

; make climatology
  du0_  = fltarr(12)
  su0_  = fltarr(12)
  bc0_  = fltarr(12)
  oc0_  = fltarr(12)
  ss0_  = fltarr(12)
  du1_  = fltarr(12)
  su1_  = fltarr(12)
  bc1_  = fltarr(12)
  oc1_  = fltarr(12)
  ss1_  = fltarr(12)

; toss odd negative
  ss1[where(ss1 lt 0)] = 0.

  nt = n_elements(du0)
  ny = nt/12
  for i = 0, 11 do begin
   du0_[i]  = total(du0[i:nt-1:12])/ny*1e9
   su0_[i]  = total(su0[i:nt-1:12])/ny*1e9
   bc0_[i]  = total(bc0[i:nt-1:12])/ny*1e9
   oc0_[i]  = total(oc0[i:nt-1:12])/ny*1e9
   ss0_[i]  = total(ss0[i:nt-1:12])/ny*1e9
   du1_[i]  = total(du1[i:nt-1:12])/ny*1e9
   su1_[i]  = total(su1[i:nt-1:12])/ny*1e9
   bc1_[i]  = total(bc1[i:nt-1:12])/ny*1e9
   oc1_[i]  = total(oc1[i:nt-1:12])/ny*1e9
   ss1_[i]  = total(ss1[i:nt-1:12])/ny*1e9
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='atto.pm.ps', /color, /helvetica, font_size=6, $
   xsize=8, ysize=12
  !p.font=0
  loadct, 39
  !p.multi=[0,1,2]
  plot, indgen(14), /nodata, $
   yrange=[0,15], xrange=[0,13], $
   xticks=13, xminor=1, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   title='Component PM2.5 [!Mm!3g m!E-3!N]'
  x = indgen(12)+1
  xyouts, 1, 13.5, /data, 'Carbon + Sulfate', color=254
  xyouts, 1, 12.5,  /data, 'Dust', color=208
  xyouts, 1, 11.5, /data, 'Sea Salt', color=84
  plots, [1,2.5], 10.7, thick=6
  plots, [1,2.5], 9.7, thick=6, lin=2
  xyouts, 2.75, 10.5, 'MERRA2', /data
  xyouts, 2.75, 9.5, 'MERRA2-GMI', /data
  oplot, x, oc0_+su0_, thick=6, color=254
  oplot, x, du0_, thick=6, color=208
  oplot, x, ss0_, thick=6, color=84
  oplot, x, oc1_+su1_, thick=6, color=254, lin=2
  oplot, x, du1_, thick=6, color=208, lin=2
  oplot, x, ss1_, thick=6, color=84, lin=2

  plot, indgen(14), /nodata, $
   yrange=[0,10], xrange=[0,13], $
   xticks=13, xminor=1, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']  
  xyouts, 1, 9, /data, 'Ratio of Carbon+Sulfate / Dust', color=208
  xyouts, 1, 8.5, /data, 'Ratio of Carbon+Sulfate / Sea Salt', color=84
  oplot, x, (oc0_+su0_)/du0_, thick=6, color=208
  oplot, x, (oc1_+su1_)/du1_, thick=6, color=208, lin=2
  oplot, x, (oc0_+su0_)/ss0_, thick=6, color=84
  oplot, x, (oc1_+su1_)/ss1_, thick=6, color=84, lin=2

  device, /close

end
