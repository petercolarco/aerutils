; Colarco, September 2008
; This is a wrapper to call "mon_mean" and "histogram" to make monthly
; mean aggregates of the (i) AERONET observed AOT, Angstrom parameter, and
; statistics and (ii) the model values of the same.

; What you need from the model:
;  o  you have run GEOS4/5 and saved the 3d, eta level aerosol mass mixing ratio
;  o  you have processed these through the AOD calculator Chem_Aod.x to generate
;     at each time spectral extinction AOT for each species
;  o  you have run the extract_stations.x program against the AOT files to
;     extract at AERONET locations.  It is useful for consistency that the same
;     aeronet_locs.dat database be used for the station extraction as will now
;     be used in this directory

; What you need from AERONET:
;  o  you have already processed the AERONET data from native text files to
;     aggregate nc files (nominally stored in the ./output/aeronet2nc directory)

goto, jump
; Example call
  expidArr   = ['bR_G40b10','bR_G40b10-MERRA2']
  for iexpid = 0,1 do begin
   expid   = expidArr[iexpid]
   exppath = '/misc/prc14/colarco/'+expid+'/inst2d_hwl_x/aeronet/'
   years   = ['2007']
   expid   = expid+'.inst2d_hwl.aeronet'
   scalefac = make_array(5,val=1.)
   nminret = 3
   ny = n_elements(years)
   for i = 0, ny-1 do begin
    mon_mean,  exppath, expid, years[i], nminret=nminret, scalefac=scalefac, /hourly, /sample, /hwl, $
               aeronet_locs_dat='aeronet_locs.dat'
    histogram, exppath, expid, years[i], nminret=nminret, scalefac=scalefac, /hourly, /sample, /hwl, $
               aeronet_locs_dat='aeronet_locs.dat'
   endfor
  endfor
stop
jump:
  expidArr   = ['F25b18','cR_F25b18','dR_F25b18','eR_F25b18','c48R_G40b11','c90R_G40b11','c180R_G40b11']
  expidArr   = ['cR_F25b18']
  for iexpid = 0,0 do begin
   expid   = expidArr[iexpid]
   exppath = '/misc/prc14/colarco/'+expid+'/inst2d_hwl_x/aeronet/'
   years   = ['2007']
   expid   = expid+'.inst2d_hwl.aeronet'
   scalefac = make_array(5,val=1.)
;   scalefac[0] = 2.
   nminret = 3
   ny = n_elements(years)
   for i = 0, ny-1 do begin
    mon_mean,  exppath, expid, years[i], nminret=nminret, scalefac=scalefac, /hourly, /sample, /hwl
    histogram, exppath, expid, years[i], nminret=nminret, scalefac=scalefac, /hourly, /sample, /hwl
   endfor
  endfor

end

