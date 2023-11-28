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

  expidArr   = ['dR_MERRA-AA-r2']
  for iexpid = 0,0 do begin
   expid   = expidArr[iexpid]
   exppath = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/aeronet/'
   years   = ['2003','2004','2005','2006','2007','2008',$
              '2009','2010','2011','2012','2013']
   expid   = expid+'.inst2d_hwl.aeronet'
   scalefac = make_array(5,val=1.)
   nminret = 3
   ny = n_elements(years)
   for i = 0, ny-1 do begin
    mon_mean,  exppath, expid, years[i], nminret=nminret, scalefac=scalefac, /hourly, /sample, /hwl
    histogram, exppath, expid, years[i], nminret=nminret, scalefac=scalefac, /hourly, /sample, /hwl
   endfor
  endfor

end

