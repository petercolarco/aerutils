; Colarco, July 2006
; Demonstrate the IDL to Grads interface using gradsdods interface
; Note: undefined (=1e+25) is returned for requested values outside 
; the range of times in the file.  

; 25 yr simulation of dust (2-d surface and column integrated fields)
  inpfile = 'http://calculon.gsfc.nasa.gov:8080/dods/g4dust/sfc.monthly_means.1979-2005'
  ga_getvar, inpfile, '', novalue, lon=lonb, lat=latb, lev=lev, time=time
  ga_getvar, inpfile, 'duexttau', aot, wanttime=['197901','197912'], time=time
  print, time


; 25 yr simulation of dust (3-d eta fields)
; Note: the levels returned are the "nominal" pressure levels, but the data is
; not on a pressure surface
  inpfile = 'http://calculon.gsfc.nasa.gov:8080/dods/g4dust/eta.monthly_means.1979-2005'
  ga_getvar, inpfile, '', novalue, lon=lonb, lat=latb, lev=lev , wantlev=[1000,-100], time=time
  print, lev
  ga_getvar, inpfile, 'dumass', dumass, wantlev=[1000.,500.], wanttime=['197901','197912'], time=time

; 2 yr simulation of CO from 200301 to 200412
  inpfile = 'http://calculon.gsfc.nasa.gov:8080/dods/terra_gfedv2/chem_diag.eta.monthly'
  ga_getvar, inpfile, '', novalue, lon=lonc, lat=latc, lev=lev, wantlev=[992.,500.], time=time
  print, lev
  ga_getvar, inpfile, 'co', co, wantlev=[992.,500.], wanttime=['200301'], time=time
  ga_getvar, inpfile, 'coxxx', co, wantlev=[992.,500.], wanttime=['200301'], time=time


end
