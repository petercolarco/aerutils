; Colarco, May 31, 2007
; Sample procedure to illustrate usage of idlgrads interface.
; Assumption is that the grads environment is already set up
; correctly per the README file.

; This example exercises the gradsdods interface by reading something
; off of our dods server.  Visit the dods server at:
; http://opendap.gsfc.nasa.gov:9090/dods/

; -------------------------------------------------------------------------------
; Various datasets are available.  For the top-level URL we focus on the
; GEOS-5 near realtime run.  The front of the URL is:
  URLhead = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/'

; To get the latest aerosol column integrated/surface fields append...
  filename = URLhead + 'assim/tavg2d_aer_x'

; This example shows how to retrieve the variable list and the spatial and
; time grid information on the whole file.
  ga_getvar, filename, '', varvalue, lon=lon, lat=lat, lev=lev, time=time

; This example gets the 2d field of dust optical thickness at the first time index
  ga_getvar, filename, 'duexttau', varvalue, wanttime=[3], lon=lon, lat=lat, lev=lev, time=time, /dods5

; This example gets the 2d field of dust optical thickness at the first three time indices
; The requested wanttime range seems not work in this example.  Check ga_getvar.pro
  ga_getvar, filename, 'duexttau', varvalue, wanttime=[1,3], lon=lon, lat=lat, lev=lev, time=time, /dods5

; NOTE: You could also ask for specific times in the wanttime field.  There's a bug in my code
; at the moment where variable requested returning the time fields don't make a lot of sense, but
; you can get the times again by requesting the '' blank variable field:
  ga_getvar, filename, '', varvalue, lon=lon, lat=lat, lev=lev, time=time, /noprint

; Then check the time variable for one you like:
  ga_getvar, filename, 'duexttau', varvalue, wanttime=['2007-09-23 01:30 Z'], $
   lon=lon, lat=lat, lev=lev, time=time, /dods5

; example to get all the dust emission bins and save to a file called dust_emissions.nc
  wantlon = [-20,60]
  wantlat = [0,40]
  wanttime = [1]
  varwant  = 'duem'
  ga_getvar, filename, varwant, varval, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=wanttime, wantlon=wantlon, wantlat=wantlat, /template, $
             /save, ofile='dust_emissions.nc', /dods5
  du = varval

; Here's an example where we get the pressure value from the 3d eta file.
  URLhead = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/'

; To get the latest aerosol column integrated/surface fields append...
  filename = URLhead + 'inst3d_aer_v'

; Note: the level variable returned is sort of mis-leading.  For the eta files the
; vertical coordinate varies at every grid cell.  What is returned in the variable
; "lev" is a nominal pressure assigned to each vertical grid box, but is not quite
; right.  What you could do to be more precise is the following:
  varwant = 'delp'
  ga_getvar, filename, varwant, varval, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=['1'], wantlon=wantlon, wantlat=wantlat, /dods5
  delp = varval

; delp is the pressure thickness of each level in units of Pa.
; the model has a top pressure which is the air pressure at the top interface of the model
; the "0" index of the column is the surface level
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  if(nz eq 55 or nz eq 72) then ptop = 1.
  if(nz eq 32) then ptop = 40.
  psfc = total(delp,3)+ptop
  p0 = psfc
  pmid = fltarr(nx,ny,nz)
  for iz = 0, nz-1 do begin
   p1 = p0 - delp[*,*,iz]
   pmid[*,*,iz] = exp(0.5*(alog(p0)+alog(p1)))
   p0 = p1
  endfor



end
