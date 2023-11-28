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

; Get the model fields
  expid = ['c90Fc_pI20p1_anth', $
           'c90Fc_pI20p1_pin', $
           'c90Fc_pI20p1_pina10']
  nexpid = n_elements(expid)
  area, lon, lat, nx, ny, dx, dy, area, grid='c'
  for iexpid = 0, nexpid-1 do begin
     print, iexpid+1, '/', nexpid
     filetemplate = expid[iexpid]+'.tavg2d_carma_x.ddf'
     ga_times, filetemplate, nymd, nhms, template=template
     filename=strtemplate(template,nymd,nhms)
     a = where(nymd ge '19910500' and nymd le '19931000')
     nymd = nymd[a]
     filename = filename[a]
     nt = n_elements(a)
     if(iexpid eq 0) then suext = make_array(nt,nexpid,val=0.)
     if(iexpid eq 0) then suang = make_array(nt,nexpid,val=0.)
     if(iexpid eq 0) then sucm  = make_array(nt,nexpid,val=0.)
     if(iexpid eq 0) then sume  = make_array(nt,nexpid,val=0.)
     nc4readvar, filename, 'suexttau', sus, lon=lon, lat=lat
     nc4readvar, filename, 'suangstr', suas, lon=lon, lat=lat
     nc4readvar, filename, 'sucmass', sucs, lon=lon, lat=lat
     suang_ = sus*suas
     suext_ = sus
     sucm_  = sucs
     sume_  = suext_/sucm_/1000.
;    zonal mean and discard where no AVHRR latitudes exist (b_resolution)
     suext__ = total(suext_,1)/288.
     suang__ = total(suang_,1)/288.
     sucm__  = total(sucm_,1)/288.
     sume__  = total(sume_,1)/288.
     for it = 0, nt-1 do begin
      iit = where(xavhrr eq it)
      a = where(finite(avhrr[*,iit[0]]) eq 1)
      suext[it,iexpid] = total(suext__[a,it]*area[0,a])/total(area[0,a])
      suang[it,iexpid] = total(suang__[a,it]/suext__[a,it]*area[0,a])/total(area[0,a])
      sucm[it,iexpid] = total(sucm__[a,it]*area[0,a])
      sume[it,iexpid] = total(sume__[a,it]*area[0,a])/total(area[0,a])
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
  oplot, x, suext[*,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suext[*,2], thick=8, color=84         ; ensemble +cerro
  oplot, x, suext[*,0], thick=8, color=208        ; no cerro
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
  oplot, x, suang[*,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, suang[*,2], thick=8, color=84         ; ensemble +cerro
  oplot, x, suang[*,0], thick=8, color=208        ; no cerro

  plot, x, sucm[*,0,0], /nodata, /noerase, $
   position=[.575,.525,.975,.95], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=1, yrange=[0,20], $
   yticks=4, ytitle = 'Sulfate Column Loading [Tg SO!D4!N]'

; CARMA optics
  loadct, 39
  oplot, x, sucm[*,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sucm[*,2], thick=8, color=84         ; ensemble +cerro
  oplot, x, sucm[*,0], thick=8, color=208        ; no cerro
 
  

  plot, x, sucm[*,0,0], /nodata, /noerase, $
   position=[.575,.1,.975,.525], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=1, yrange=[0,6], $
   yticks=6, ytitle = 'Mass Extinction Efficiency [m!E2!N g!E-1!N]', $
   ytickname=['0','1','2','3','4','5',' ']

; CARMA optics
  loadct, 39
  oplot, x, sume[*,1], thick=8, color=84         ; ensemble +cerro
  oplot, x, sume[*,2], thick=8, color=84         ; ensemble +cerro
  oplot, x, sume[*,0], thick=8, color=208        ; no cerro
  
  device, /close

end
