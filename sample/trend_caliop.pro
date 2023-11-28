  res = 'd'
  regtitle = ['South America', 'Southern Africa', 'African Dust', 'Nile Valley', $
              'Indogangetic Plain', 'China', 'Southeast Asia', 'Asian Outflow']
  ymax   = [1,.6,.8,.8,.8,1,.8,.5]
  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30,30,75,100,95,135]
  lon1 = [-45,35,-15,36,95,125,110,165]
  lat0 = [-20,-20,10,22,20,25,10,30]
  lat1 = [0,0,30,32,30,42,25,55]
  nreg = n_elements(lon0)

  yyyy = strpad(indgen(9)+2003,1000L)
;  yyyy = ['2010']
  ny   = n_elements(yyyy)
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nm   = 12

  reg = fltarr(ny*nm,nreg,5)

  samples = [' ','caliop1', 'caliop2', 'caliop3', 'caliop4']

  for isam = 0, 4 do begin
print, isam
   for iy = 0, ny-1 do begin
   for im = 0, nm-1 do begin

     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude, /inverse, res=res
     reg[iy*12+im,*,isam] = reg_aot

   endfor
   endfor

  endfor


end
