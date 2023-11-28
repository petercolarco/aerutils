; Get the time series of seasonal and regionally averaged AOT for the
; MODIS full swath (i) and the sub-samples exposed only at points
; which were *ever* observed by the sub-samples (ii).

  res = 'd'

  sample = [' ', 'supermisr', 'misr1', 'misr2', 'misr4', $
            'caliop1', 'caliop2', 'caliop4', 'caliop3', 'misr3']
  ;sample = [' ', 'lat1', 'lat2', 'lat3', 'lat4', 'lat5']
  yyyy   = ['2003','2004','2005','2006','2007','2008','2009','2010','2011','2012']
;  yyyy   = ['2005']
  seas   = ['JFM','AMJ','JAS','OND']
;  seas   = ['JAS']

  nseas  = n_elements(seas)
  ny     = n_elements(yyyy)
  nsam   = n_elements(sample)

; regions
  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30, 30, 75, 100,  95, 135]
  lon1 = [-45, 35,-15, 36, 95, 125, 110, 165]
  lat0 = [-20,-20, 10, 22, 20,  25,  10,  30]
  lat1 = [  0,  0, 30, 32, 30,  42,  25,  55]
  nreg = n_elements(lon0)

  reg_aot = fltarr(ny*nseas,nreg,nsam)
  reg_std = fltarr(ny*nseas,nreg,nsam)

  for iy = 0, ny-1 do begin
print, yyyy[iy]
   for iseas = 0, nseas-1 do begin
print, iseas
    for isam = 0, nsam-1 do begin

     exclude = 0
     inverse = 0
     if(sample[isam] eq ' ') then exclude=0
     if(sample[isam] eq ' ') then inverse=0

     read_seasonal, 'MYD04', sample[isam], yyyy[iy], seas[iseas], aotsat, $
                    res=res, exclude=exclude, inverse=inverse, $
                    lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot_, reg_std=reg_std_
     reg_aot[iy*nseas+iseas,*,isam] = reg_aot_
     reg_std[iy*nseas+iseas,*,isam] = reg_std_

    endfor
   endfor
  endfor


  save, /all, filename='time_seasonal.along_track.sample_then_average.sav'

end
