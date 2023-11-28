  fnoff = 0
  nts = 2208

  wantlon = [115,117] & wantlat = [39,41] & filetag = 'beijing.01deg.jun1-aug31'
; Get "TOMCAT1" - equivalent to ISS1 (450km) -- but only AOD > 0.2 and CLDTOT < 0.8
  get_sample, 'iss1day.450km', fnoff, nts, tom1, tom1hr, tom1hrn, tom1hrhst, tom1hrs, tom1hrmn, tom1hrmx, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, unionorbit='iss1'
;                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, /taod, /tcld, unionorbit='iss1'

; Get "TOMCAT1" - equivalent to ISS1 (450km) -- but only AOD > 0.2 and CLDTOT < 0.8
  get_sample, 'iss1day.450km', fnoff, nts, tom1_, tom1hr_, tom1hrn_, tom1hrhst_, tom1hrs_, tom1hrmn_, tom1hrmx_, $
                  wantlat=wantlat, wantlon=wantlon, lat=lat, lon=lon, /taod, /tcld, unionorbit='iss1'


end

