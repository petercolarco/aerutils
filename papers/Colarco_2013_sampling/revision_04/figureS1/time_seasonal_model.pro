; Get the time series of seasonal and regionally averaged AOT for the
; MODIS full swath (i) and the sub-samples exposed only at points
; which were *ever* observed by the sub-samples (ii).

  res = 'd'

;  sample = ['modis_aqua.cloud2', 'misr_aqua.cloud2', 'calipso.cloud2']
  sample = ['modis_aqua', 'misr_aqua', 'calipso','calipso_calipso','misr_calipso'];,'modis_terra','misr_terra','calipso_terra']
  yyyy   = ['2003','2004','2005','2006','2007','2008','2009','2010','2011','2012']
  seas   = ['JFM','AMJ','JAS','OND']

  nm     = n_elements(seas)
  ny     = n_elements(yyyy)
  nsam   = n_elements(sample)

; regions
  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30, 30, 75, 100,  95, 135]
  lon1 = [-45, 35,-15, 36, 95, 125, 110, 165]
  lat0 = [-20,-20, 10, 22, 20,  25,  10,  30]
  lat1 = [  0,  0, 30, 32, 30,  42,  25,  55]
  nreg = n_elements(lon0)

  reg_aot = fltarr(ny*nm,nreg,nsam)
  reg_std = fltarr(ny*nm,nreg,nsam)

  for iy = 0, ny-1 do begin
print, yyyy[iy]
   for im = 0, 3 do begin
print, im, seas[im]
    for isam = 0, nsam-1 do begin

     exclude = 0
     inverse = 0

     read_seasonal_model, 'dR_MERRA-AA-r2', sample[isam], yyyy[iy], seas[im], aotsat, $
                    res=res, exclude=exclude, inverse=inverse, $
                    lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot_, reg_std=reg_std_
     reg_aot[iy*nm+im,*,isam] = reg_aot_
     reg_std[iy*nm+im,*,isam] = reg_std_

    endfor
   endfor
  endfor


;  save, /all, filename='time_monthly_model.cloud2.sav'
  save, /all, filename='time_seasonal_model.dR_MERRA-AA-r2.noTERRA.sav'

end
