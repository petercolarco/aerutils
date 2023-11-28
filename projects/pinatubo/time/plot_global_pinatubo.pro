; Make a plot of the Pinatubo resulting AOD using Valentina's
; paper as a template

; Get AVHRR data
; Data is total aerosol loading, monthly (56 months) beginning July
; 1989 as a zonal mean with 141 latitudes from -70 to 70 (so, 1 degree)
  area, lon, lat, nx, ny, dx, dy, area, grid='c'
  openr, lun, 'avhrr_aot_monthly', /get
  inp = fltarr(141,56)
  readu, lun, inp
  free_lun, lun
; Put the data on regular grid and do area weighted average
  avhrr = make_array(ny,56,val=-999.)
  avhrr[20:160,*] = inp
; Give a time coordinate -- May 1991 = 0
  xavhrr = findgen(56)-22.
; subtract from post-Pinatubo months the corresponding monthly values
; pre-Pinatubo
  a = where(avhrr lt 0)
  avhrr[a] = !values.f_nan
  avhrr_time = fltarr(56)
; June 90 - May 91
  base_avhrr = avhrr[*,11:22]
; Add in Jul 89 - May 90 and average
  base_avhrr[*,1:11] = (base_avhrr[*,1:11]+avhrr[*,0:10])/2.
  avhrr[*,11:22] = avhrr[*,11:22] - base_avhrr
  avhrr[*,23:34] = avhrr[*,23:34] - base_avhrr
  avhrr[*,35:46] = avhrr[*,35:46] - base_avhrr
  avhrr[*,47:55] = avhrr[*,47:55] - base_avhrr[*,0:9]
  for iz = 0, 55 do begin
   a = where(finite(avhrr[*,iz]) eq 1)
   avhrr_time[iz] = total(avhrr[a,iz]*area[0,a])/total(area[0,a])
  endfor

;; Get from Valentina member run
;  expid = 'Pin45act5d'
;  filetemplate = expid+'.tavg2d_aer_x.ddf'
;  ga_times, filetemplate, nymd, nhms, template=template
;  filename=strtemplate(template,nymd,nhms)
;  a = where(nymd ge '19910500' and nymd le '19931000')
;  nymd = nymd[a]
;  filename = filename[a]
;  nc4readvar, filename, 'suexttau', suexttau_pin45, lon=lon, lat=lat

; Get the model fields
  expid = ['c48Fc_H43_pin15v2+sulf', $
           'c48Fc_H43_pin15v2+sulf+cerro', $
           'c48Fc_H43_pin15v2+sulf+cerro_2', $
           'c48Fc_H43_pin15v2+sulf+cerro_3', $
           'c48Fc_H43_pinatubo15', $
           'c48Fc_H43_pinatubo15+sulfate', $
           'c48Fc_H43_pinatubo15v2', $
           'c48Fc_H43_pinatubo15v2+sulfate', $
           'c48Fc_H43_pin15+sulf+cerro']
  nexpid = n_elements(expid)
; gocart optics
  icase = 0
  area, lon, lat, nx, ny, dx, dy, area, grid='c'
;  for iexpid = 0, nexpid-1 do begin
  for iexpid = 0, 3 do begin
     print, iexpid+1, '/', nexpid
     filetemplate = expid[iexpid]+'.tavg2d_aer_x.ddf'
     ga_times, filetemplate, nymd, nhms, template=template
     filename=strtemplate(template,nymd,nhms)
     a = where(nymd ge '19910500' and nymd le '19931000')
     nymd = nymd[a]
     filename = filename[a]
     nt = n_elements(a)
     if(iexpid eq 0) then suext = make_array(nt,nexpid,2,val=0.)
     if(iexpid eq 0) then suang = make_array(nt,nexpid,2,val=0.)
     if(iexpid eq 0) then sucm  = make_array(nt,nexpid,2,val=0.)
     if(iexpid eq 0) then sume  = make_array(nt,nexpid,2,val=0.)
     nc4readvar, filename, 'suexttau', sus, lon=lon, lat=lat
     nc4readvar, filename, 'suexttauvolc', suv, lon=lon, lat=lat
     nc4readvar, filename, 'suangstr', suas, lon=lon, lat=lat
     nc4readvar, filename, 'suangstrvolc', suav, lon=lon, lat=lat
     nc4readvar, filename, 'so4cmass', sucs, lon=lon, lat=lat
     nc4readvar, filename, 'so4cmassvolc', sucv, lon=lon, lat=lat
     suang_ = sus*suas + suv*suav
     suext_ = sus + suv
     sucm_  = sucs + sucv
     sume_  = suext_/sucm_/1000.
;    zonal mean and discard where no AVHRR latitudes exist (b_resolution)
     suext_ = total(suext_,1)/144.
     suang_ = total(suang_,1)/144.
     sucm_  = total(sucm_,1)
     sume_  = total(sume_,1)/144.
;    fake double resolution of suext and suang
     suext__ = fltarr(181,nt)
     suang__ = fltarr(181,nt)
     sucm__  = fltarr(181,nt)
     sume__  = fltarr(181,nt)
     suext__[0,*] = suext_[0,*]
     suang__[0,*] = suang_[0,*]
     sucm__[0,*]  = sucm_[0,*]
     sume__[0,*]  = sume_[0,*]
     for iy = 1,90 do begin
      suext__[2*iy-1,*] = suext_[iy,*]
      suext__[2*iy,*]   = suext_[iy,*]
      suang__[2*iy-1,*] = suang_[iy,*]
      suang__[2*iy,*]   = suang_[iy,*]
      sucm__[2*iy-1,*]  = sucm_[iy,*]
      sucm__[2*iy,*]    = sucm_[iy,*]
      sume__[2*iy-1,*]  = sume_[iy,*]
      sume__[2*iy,*]    = sume_[iy,*]
     endfor
     for it = 0, nt-1 do begin
      iit = where(xavhrr eq it)
      a = where(finite(avhrr[*,iit[0]]) eq 1)
      suext[it,iexpid,icase] = total(suext__[a,it]*area[0,a])/total(area[0,a])
      suang[it,iexpid,icase] = total(suang__[a,it]/suext__[a,it]*area[0,a])/total(area[0,a])
      sucm[it,iexpid,icase] = total(sucm__[a,it]*area[0,a])
      sume[it,iexpid,icase] = total(sume__[a,it]*area[0,a])/total(area[0,a])
     endfor
  endfor

  ; carma optics
  icase = 1
;  for iexpid = 0, nexpid-1 do begin
  for iexpid = 0, 3 do begin
     print, iexpid+1, '/', nexpid
     filetemplate = expid[iexpid]+'.tavg2d_carma_x.ddf'
     ga_times, filetemplate, nymd, nhms, template=template
     filename=strtemplate(template,nymd,nhms)
     a = where(nymd ge '19910500' and nymd le '19931000')
     nymd = nymd[a]
     filename = filename[a]
     nt = n_elements(a)
     nc4readvar, filename, 'suexttau', sus, lon=lon, lat=lat
     nc4readvar, filename, 'suangstr', suas, lon=lon, lat=lat
     nc4readvar, filename, 'sucmass', sucs, lon=lon, lat=lat
     suang_ = sus*suas
     suext_ = sus
     sucm_  = sucs
     sume_  = suext_/sucm_/1000.
;    zonal mean and discard where no AVHRR latitudes exist (b_resolution)
     suext_ = total(suext_,1)/144.
     suang_ = total(suang_,1)/144.
     sucm_  = total(sucm_,1)
     sume_  = total(sume_,1)/144.
;    fake double resolution of suext and suang
     suext__ = fltarr(181,nt)
     suang__ = fltarr(181,nt)
     sucm__  = fltarr(181,nt)
     sume__  = fltarr(181,nt)
     suext__[0,*] = suext_[0,*]
     suang__[0,*] = suang_[0,*]
     sucm__[0,*]  = sucm_[0,*]
     sume__[0,*]  = sume_[0,*]
     for iy = 1,90 do begin
      suext__[2*iy-1,*] = suext_[iy,*]
      suext__[2*iy,*]   = suext_[iy,*]
      suang__[2*iy-1,*] = suang_[iy,*]
      suang__[2*iy,*]   = suang_[iy,*]
      sucm__[2*iy-1,*]  = sucm_[iy,*]
      sucm__[2*iy,*]    = sucm_[iy,*]
      sume__[2*iy-1,*]  = sume_[iy,*]
      sume__[2*iy,*]    = sume_[iy,*]
     endfor
     for it = 0, nt-1 do begin
      iit = where(xavhrr eq it)
      a = where(finite(avhrr[*,iit[0]]) eq 1)
      suext[it,iexpid,icase] = total(suext__[a,it]*area[0,a])/total(area[0,a])
      suang[it,iexpid,icase] = total(suang__[a,it]/suext__[a,it]*area[0,a])/total(area[0,a])
      sucm[it,iexpid,icase] = total(sucm__[a,it]*area[0,a])
      sume[it,iexpid,icase] = total(sume__[a,it]*area[0,a])/total(area[0,a])
     endfor
  endfor

  sucm = sucm/1.e9   ; Tg

  set_plot, 'ps'
  device, file='plot_global_pinatubo.ps', $
    /helvetica, font_size=12, /color, $
    xsize=36, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']
  plot, x, suext[*,0,0], /nodata, $
   position=[.075,.525,.475,.95], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=1, yrange=[0,0.25], $
   yticks=5, ytitle = 'AOT'

; CARMA optics
  loadct, 39
  oplot, x, suext[*,1,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suext[*,2,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suext[*,3,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suext[*,0,1], thick=8, color=208        ; no cerro
;  loadct, 39
;  oplot, x, suext[*,4,1], thick=8, color=208         ; broad
;  oplot, x, suext[*,5,1], thick=8, color=208         ; broad
;  oplot, x, suext[*,6,1], thick=8, color=84          ; narrow
;  oplot, x, suext[*,7,1], thick=8, color=84          ; narrow
;  oplot, x, suext[*,8,1], thick=8, color=84          ; narrow
; GOCART optics
  loadct, 39
  oplot, x, suext[*,1,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, suext[*,2,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, suext[*,3,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, suext[*,0,0], thick=4, color=208, lin=2  ; no cerro
;  loadct, 39
;  oplot, x, suext[*,4,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, suext[*,5,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, suext[*,6,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, suext[*,7,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, suext[*,8,0], thick=8, color=84, lin=2   ; narrow
; AVHRR
  loadct, 0
  oplot, xavhrr, avhrr_time, thick=8, color=0


  plot, x, suang[*,0,0], /nodata, /noerase, $
   position=[.075,.1,.475,.525], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=1, yrange=[-0.5,2.5], $
   yticks=6, ytitle = 'Angstrom Parameter', ytickname=['-0.5','0.0','0.5','1.0','1.5','2.0',' ']

; CARMA optics
  loadct, 39
  oplot, x, suang[*,1,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suang[*,2,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suang[*,3,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suang[*,0,1], thick=8, color=208        ; no cerro
;  loadct, 39
;  oplot, x, suang[*,4,1], thick=8, color=208         ; broad
;  oplot, x, suang[*,5,1], thick=8, color=208         ; broad
;  oplot, x, suang[*,6,1], thick=8, color=84          ; narrow
;  oplot, x, suang[*,7,1], thick=8, color=84          ; narrow
;  oplot, x, suang[*,8,1], thick=8, color=84          ; narrow
; GOCART optics
  loadct, 39
  oplot, x, suang[*,1,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, suang[*,2,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, suang[*,3,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, suang[*,0,0], thick=4, color=208, lin=2  ; no cerro
;  loadct, 39
;  oplot, x, suang[*,4,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, suang[*,5,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, suang[*,6,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, suang[*,7,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, suang[*,8,0], thick=8, color=84, lin=2   ; narrow


  plot, x, sucm[*,0,0], /nodata, /noerase, $
   position=[.575,.525,.975,.95], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=1, yrange=[0,20], $
   yticks=4, ytitle = 'Sulfate Column Loading [Tg SO!D4!N]'

; CARMA optics
  loadct, 39
  oplot, x, sucm[*,1,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sucm[*,2,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sucm[*,3,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sucm[*,0,1], thick=8, color=208        ; no cerro
;  loadct, 39
;  oplot, x, sucm[*,4,1], thick=8, color=208         ; broad
;  oplot, x, sucm[*,5,1], thick=8, color=208         ; broad
;  oplot, x, sucm[*,6,1], thick=8, color=84          ; narrow
;  oplot, x, sucm[*,7,1], thick=8, color=84          ; narrow
;  oplot, x, sucm[*,8,1], thick=8, color=84          ; narrow
; GOCART optics
  loadct, 39
  oplot, x, sucm[*,1,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, sucm[*,2,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, sucm[*,3,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, sucm[*,0,0], thick=4, color=208, lin=2  ; no cerro
;  loadct, 39
;  oplot, x, sucm[*,4,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, sucm[*,5,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, sucm[*,6,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, sucm[*,7,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, sucm[*,8,0], thick=8, color=84, lin=2   ; narrow
 
  

  plot, x, sucm[*,0,0], /nodata, /noerase, $
   position=[.575,.1,.975,.525], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=1, yrange=[0,6], $
   yticks=6, ytitle = 'Mass Extinction Efficiency [m!E2!N g!E-1!N]', $
   ytickname=['0','1','2','3','4','5',' ']

; CARMA optics
  loadct, 39
  oplot, x, sume[*,1,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sume[*,2,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sume[*,3,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sume[*,0,1], thick=8, color=208        ; no cerro
;  loadct, 39
;  oplot, x, sume[*,4,1], thick=8, color=208         ; broad
;  oplot, x, sume[*,5,1], thick=8, color=208         ; broad
;  oplot, x, sume[*,6,1], thick=8, color=84          ; narrow
;  oplot, x, sume[*,7,1], thick=8, color=84          ; narrow
;  oplot, x, sume[*,8,1], thick=8, color=84          ; narrow
; GOCART optics
  loadct, 39
  oplot, x, sume[*,1,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, sume[*,2,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, sume[*,3,0], thick=4, color=84, lin=2  ; ensemble +cerro
  oplot, x, sume[*,0,0], thick=4, color=208, lin=2  ; no cerro
;  loadct, 39
;  oplot, x, sume[*,4,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, sume[*,5,0], thick=8, color=208, lin=2  ; broad
;  oplot, x, sume[*,6,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, sume[*,7,0], thick=8, color=84, lin=2   ; narrow
;  oplot, x, sume[*,8,0], thick=8, color=84, lin=2   ; narrow
  
  device, /close

end
