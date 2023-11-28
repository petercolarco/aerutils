; Colarco, November 2018
; Adapted from codes provided by Stacey Frith to read and plot the
; SAGE II aerosol extinction

; Give it a level grid from the model fields
  filename = '/misc/prc18/colarco/c90F_pI33p4_ocs/tavg3d_carma_p/c90F_pI33p4_ocs.tavg3d_carma_p.monthly.198001.nc4'
  nc4readvar, filename, 'suextcoef', su, lev=lev
;vertical grid for interpolation in hPa
  hpa = reverse(lev)

mo=[1]
yr=[make_array(12,val=1989),make_array(12,val=1990)]

names=['January','February','March','April','May','June','July','August','September','October','November','December']

ext525=mo*0
ext1020=mo*0
;read in SAGE data
ae525vzm=fltarr(n_elements(mo),n_elements(hPa),180)
for i=0,n_elements(mo)-1 do begin
   sage_read_filter_v7,yr[i],mo[i],nobs,nlev,doy,lat,lon,z,p,t,ozone_ppmv,$
                        ozone_ppmv_err,sgtype, ae525, ae1020, ae525err, ae1020err
                                ;the observations are on a 140
                                ;vertical level non uniform grid.  
                                ;doy, lat, lon, sgtype are arrays with
                                ;dimension = number of data per level
                                ;p,t,ozone, ae*** are arrays with dimensions
                                ;(level, number of data per level)

; Throw out undefs and too-high values (9999?)
   oo=where(ae525 eq -999 or ae525 gt 9990.,c)

   if c gt 0 then ae525(oo)=!Values.F_NaN   
                                ;regrid vertically
   ae525v=fltarr(n_elements(hPa),n_elements(lat))
   for ll=0,n_elements(lat)-1 do begin
      for pp=0,n_elements(hpa)-2 do begin
         oo=where(p[*,ll] le hPa[pp] and p[*,ll] gt hPa[pp+1],c)
         if c gt 1 then ae525v[pp,ll]=avg(ae525[oo,ll],0,/nan)
         if c eq 1 then ae525v[pp,ll]=ae525[oo,ll]
      endfor
   endfor
   print, 'max and min ae525v',max(ae525v,/nan),min(ae525v,/nan)
                                ;do zonal means on a 1 degree grid
   for ll=0,178 do begin
      l=-90+ll
      oo=where(lat ge l and lat lt l+1,c)
      if c gt 1 then ae525vzm[i,*,ll]=avg(ae525v[*,oo],1,/nan)
      if c eq 1 then ae525vzm[i,*,ll]=ae525v[*,oo]
   endfor
endfor
print, 'max and min ext 525',max(ae525vzm,/nan),min(ae525vzm,/nan)

  set_plot, 'ps'
  device, file='sage_check.ps', /color, $
    /helvetica, font_size=12, xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  map_set, /cont
  loadct, 39
  plots, lon, lat, psym=sym(1), color=(1-(p[0,*]-900)/100.)*255

  device, /close


end
