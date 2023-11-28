; MODIS extract on offset tracks
  track = ['nadir.txt','pos10deg.txt','pos15deg.txt','pos5deg.txt', $
           'neg10deg.txt','neg15deg.txt','neg5deg.txt']

;  outdir = '/misc/prc10/colarco/tc4/d5_tc4_01/das/lidar/'

  for it = 0, 6 do begin

;  Read the track file to get sampling date, lon, lat
   trackfile = '/Volumes/sahara02/CALIPSO/MBL_STK_Orbit_Tracks_Offset_Jul07/'+track[it]
   read_calipso_track, trackfile, lonInp, latInp, dateInp, mbl = 1

;  Keep only the points >= 20070713 12Z
   a = where(dateInp ge 20070713.375d )
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
   nMidPts = 6L
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

; f
   lidartrack_modis, date, lon, lat, 'taufile.modis.f.ctl', wantlev=[550.], $
    filetocreate = './MYD04_L2_ocn.aero_005.noqawt.f.lidartrack_offset.'+track[it]+'.ncdf'

; e
   lidartrack_modis, date, lon, lat, 'taufile.modis.e.ctl', wantlev=[550.], $
    filetocreate = './MYD04_L2_ocn.aero_005.noqawt.e.lidartrack_offset.'+track[it]+'.ncdf'

;  d
   lidartrack_modis, date, lon, lat, 'taufile.modis.d.ctl', wantlev=[550.], $
    filetocreate = './MYD04_L2_ocn.aero_005.noqawt.d.lidartrack_offset.'+track[it]+'.ncdf'


  endfor



end
