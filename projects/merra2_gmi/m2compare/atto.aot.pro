goto, jump

; Get MERRA2
  filetemplate = 'MERRA2.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 20160000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', tot0, wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'duexttau',  du0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'suexttau',  su0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'ocexttau',  oc0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'bcexttau',  bc0,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'ssexttau',  ss0,  wantlon=[-59.,-59.], wantlat=[2.,2.]

; Get MERRA2_GMI
  filetemplate = 'MERRA2_GMI.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 20160000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', tot1, wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'duexttau',  du1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'suexttau',  su1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'ocexttau',  oc1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'bcexttau',  bc1,  wantlon=[-59.,-59.], wantlat=[2.,2.]
  nc4readvar, filename, 'ssexttau',  ss1,  wantlon=[-59.,-59.], wantlat=[2.,2.]


jump:

; make climatology
  tot0_ = fltarr(12)
  du0_  = fltarr(12)
  su0_  = fltarr(12)
  bc0_  = fltarr(12)
  oc0_  = fltarr(12)
  ss0_  = fltarr(12)
  tot1_ = fltarr(12)
  du1_  = fltarr(12)
  su1_  = fltarr(12)
  bc1_  = fltarr(12)
  oc1_  = fltarr(12)
  ss1_  = fltarr(12)

  nt = n_elements(tot0)
  ny = nt/12
  for i = 0, 11 do begin
   tot0_[i] = total(tot0[i:nt-1:12])/ny
   du0_[i]  = total(du0[i:nt-1:12])/ny
   su0_[i]  = total(su0[i:nt-1:12])/ny
   bc0_[i]  = total(bc0[i:nt-1:12])/ny
   oc0_[i]  = total(oc0[i:nt-1:12])/ny
   ss0_[i]  = total(ss0[i:nt-1:12])/ny
   tot1_[i] = total(tot1[i:nt-1:12])/ny
   du1_[i]  = total(du1[i:nt-1:12])/ny
   su1_[i]  = total(su1[i:nt-1:12])/ny
   bc1_[i]  = total(bc1[i:nt-1:12])/ny
   oc1_[i]  = total(oc1[i:nt-1:12])/ny
   ss1_[i]  = total(ss1[i:nt-1:12])/ny
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='atto.aot.ps', /color, /helvetica, font_size=6, $
   xsize=8, ysize=12
  !p.font=0
  loadct, 39
  !p.multi=[0,1,2]
  plot, indgen(14), /nodata, $
   yrange=[0,.14], xrange=[0,13], $
   xticks=13, xminor=1, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   title='Component AOT'
  x = indgen(12)+1
  xyouts, 1, .135, /data, 'Carbon + Sulfate', color=254
  xyouts, 1, .125,  /data, 'Dust', color=208
  xyouts, 1, .115, /data, 'Sea Salt', color=84
  plots, [1,2.5], .107, thick=6
  plots, [1,2.5], .097, thick=6, lin=2
  xyouts, 2.75, .105, 'MERRA2', /data
  xyouts, 2.75, .095, 'MERRA2-GMI', /data
  oplot, x, bc0_+oc0_+su0_, thick=6, color=254
  oplot, x, du0_, thick=6, color=208
  oplot, x, ss0_, thick=6, color=84
  oplot, x, bc1_+oc1_+su1_, thick=6, color=254, lin=2
  oplot, x, du1_, thick=6, color=208, lin=2
  oplot, x, ss1_, thick=6, color=84, lin=2

  plot, indgen(14), /nodata, $
   yrange=[0,20], xrange=[0,13], $
   xticks=13, xminor=1, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']  
  xyouts, 1, 18, /data, 'Ratio of Carbon+Sulfate / Dust', color=208
  xyouts, 1, 17, /data, 'Ratio of Carbon+Sulfate / Sea Salt', color=84
  oplot, x, (bc0_+oc0_+su0_)/du0_, thick=6, color=208
  oplot, x, (bc1_+oc1_+su1_)/du1_, thick=6, color=208, lin=2
  oplot, x, (bc0_+oc0_+su0_)/ss0_, thick=6, color=84
  oplot, x, (bc1_+oc1_+su1_)/ss1_, thick=6, color=84, lin=2

  device, /close

end
