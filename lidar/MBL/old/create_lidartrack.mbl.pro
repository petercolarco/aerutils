; MODIS extract on offset tracks
  track = ['nadir.txt','pos10deg.txt','pos15deg.txt','pos5deg.txt', $
           'neg10deg.txt','neg15deg.txt','neg5deg.txt']

  outdir = '/misc/prc10/colarco/tc4/d5_tc4_01/das/lidar/'

;  for it = 0, 6 do begin
  for it = 1,1 do begin

;  Read the track file to get sampling date, lon, lat
   trackfile = '/misc/prc08/calipso/MBL_STK_Orbit_Tracks_Offset_Jul07/'+track[it]
   read_calipso_track, trackfile, lonInp, latInp, dateInp, mbl = 1

;  Keep only the points >= 20070713 12Z
   a = where(dateInp ge 20070713.375d)
   dateInp = dateInp[a]
   lonInp  = lonInp[a]
   latInp  = latInp[a]
   strdate = strcompress(string(long(dateInp)),/rem)
   yyyy = strmid(strdate,0,4)
   mm   = strmid(strdate,4,2)
   dd   = strmid(strdate,6,2)
   sec  = (dateInp - long(dateInp))*86400.
   hh   = fix(sec/3600)
   nn   = fix((sec-3600.*hh)/60)
   ss   = fix((sec-3600.*hh-60.*nn))


;  Temporary, set longitudes to go 0 to 360.
   a = where(lonInp lt 0.)
   if(a[0] ne -1) then lonInp[a] = lonInp[a]+360.d


;  Now use the gr_circ_rte routine to fill in points between
   lon  = lonInp[0]
   lat  = latInp[0]
   date = dateInp[0]
   nPts = n_elements(lonInp)
   nMidPts = 2L
   lon = dblarr(long((nPts-1)*(nMidPts-1)+1L))
   lat = dblarr(long((nPts-1)*(nMidPts-1)+1L))
   date = dblarr(long((nPts-1)*(nMidPts-1)+1L))
   for iPts = 1L, nPts-1 do begin
    gr_circ_rte, latInp[ipts-1], lonInp[iPts-1], latInp[ipts], lonInp[iPts], nMidPts, $
                 bearing, dist, del, latp, lonp, rd
    lon[(iPts-1)*(nMidPts-1):iPts*(nMidPts-1)] = lonp
    lat[(iPts-1)*(nMidPts-1):iPts*(nMidPts-1)] = latp
;   Higher resolution of time
    delt = (julday(mm[iPts],dd[iPts],yyyy[iPts],hh[iPts],nn[iPts],ss[iPts]) $
          -julday(mm[iPts-1],dd[iPts-1],yyyy[iPts-1],hh[iPts-1],nn[iPts-1],ss[iPts-1]))/(nMidPts-1.d)
    jday =  julday(mm[iPts],dd[iPts],yyyy[iPts],hh[iPts],nn[iPts],ss[iPts])+findgen(nMidPts)*delt
    caldat, jday, mm_, dd_, yyyy_, hh_, nn_, ss_
    fday = (hh_*3600.d + nn_*60.d + ss_)/86400.d
    date[(iPts-1)*(nMidPts-1):iPts*(nMidPts-1)] = yyyy_*10000.d + mm_*100.d + dd_ + fday
   endfor

;  Return the longitudes to -180 to 179.9999
   a = where(lon ge 180.)
   if(a[0] ne -1) then lon[a] = lon[a]-360.d

;  Random seed for the output filename (supports multiple instances in one directory)
   rnum = strcompress(string(abs(randomu(seed,/long))),/rem)

;  Model
   species = ['total','dust','sulfate','seasalt','bc','oc']
   type = ['','.dust','.su','.ss','.bc','.oc']
   for isp = 0, 0 do begin
    varlist = ['extinction','tau', 'backscat', 'ext2back', 'aback_sfc', 'aback_toa', 'ssa','mass']
    ctlFile = 'taufile.aerosol.ctl.'+rnum
    openw, lun, ctlfile, /get_lun
    printf, lun, 'dset /misc/prc10/colarco/tc4/d5_tc4_01/das/tau/Y%y4/M%m2/' + $
                       'd5_tc4_01.inst3d_ext-532nm_v.%y4%m2%d2_%h200z.hdf'+type[isp]
    printf, lun, 'options template'
    printf, lun, 'tdef time 80 linear 12:00z13Jul2007 6hr'
    free_lun, lun
    filetocreate = outdir+'d5_tc4_01.inst3d_ext-532nm_v.'+species[isp]+'.'+track[it]+'.hdf'
    lidartrack_model, date, lon, lat, ctlFile, varlist, filetocreate=filetocreate
   endfor

;   species = ['total','dust','sulfate','seasalt','bc','oc']+'.dry'
;   type = '.dry' + ['','.dust','.su','.ss','.bc','.oc']
;   for isp = 0, 5 do begin
;    varlist = ['extinction','tau', 'backscat', 'ext2back', 'aback_sfc', 'aback_toa', 'ssa','mass']
;    ctlFile = 'taufile.aerosol.ctl.'+rnum
;    openw, lun, ctlfile, /get_lun
;    printf, lun, 'dset /misc/prc10/colarco/tc4/d5_tc4_01/das/tau/Y%y4/M%m2/' + $
;                       'd5_tc4_01.inst3d_ext-532nm_v.%y4%m2%d2_%h200z.hdf'+type[isp]
;    printf, lun, 'options template'
;    printf, lun, 'tdef time 80 linear 12:00z13Jul2007 6hr'
;    free_lun, lun
;    filetocreate = outdir+'d5_tc4_01.inst3d_ext-532nm_v.'+species[isp]+'.'+track[it]+'.hdf'
;    lidartrack_model, date, lon, lat, ctlFile, varlist, filetocreate=filetocreate
;   endfor

;  Do the met track
   ctlFile_eta = 'diag_eta.ctl.'+rnum
   openw, lun, ctlfile_eta, /get_lun
   printf, lun, 'dset /misc/prc10/colarco/tc4/d5_tc4_01/das/diag/Y%y4/M%m2/' + $
                      'd5_tc4_01.tavg3d_dyn_v.%y4%m2%d2_%h200z.hdf'
   printf, lun, 'options template'
   printf, lun, 'tdef time 80 linear 12:00z13Jul2007 6hr'
   free_lun, lun

   ctlFile_edge = 'diag_edge.ctl.'+rnum
   openw, lun, ctlfile_edge, /get_lun
   printf, lun, 'dset /misc/prc10/colarco/tc4/d5_tc4_01/das/diag/Y%y4/M%m2/' + $
                      'd5_tc4_01.tavg3d_met_e.%y4%m2%d2_%h200z.hdf'
   printf, lun, 'options template'
   printf, lun, 'tdef time 80 linear 12:00z13Jul2007 6hr'
   free_lun, lun

   ctlFile_sfc = 'diag_sfc.ctl.'+rnum
   openw, lun, ctlfile_sfc, /get_lun
   printf, lun, 'dset /misc/prc10/colarco/tc4/d5_tc4_01/das/diag/Y%y4/M%m2/' + $
                      'd5_tc4_01.tavg2d_met_x.%y4%m2%d2_%h2%n2z.hdf'
   printf, lun, 'options template'
   printf, lun, 'tdef time 160 linear 10:30z13jul2007 3hr'
   free_lun, lun

   ctlFile_cloud = 'diag_cloud.ctl.'+rnum
   openw, lun, ctlfile_cloud, /get_lun
   printf, lun, 'dset /misc/prc10/colarco/tc4/d5_tc4_01/das/diag/Y%y4/M%m2/' + $
                      'd5_tc4_01.tavg3d_cld_v.%y4%m2%d2_%h200z.hdf'
   printf, lun, 'options template'
   printf, lun, 'tdef time 80 linear 12:00z13Jul2007 6hr'
   free_lun, lun

   filetocreate = outdir+'d5_tc4_01.met.'+track[it]+'.hdf'
   lidartrack_model_met, date, lon, lat, ctlfile_eta, ctlfile_edge, ctlfile_sfc, $
                         ctlfile_cloud, filetocreate=filetocreate

   cmd = '/bin/rm -f *.ctl.'+rnum
   spawn, cmd

  endfor



end
