; Colarco
; September 2, 2008
; Read the HSRL track files provided by Rich Ferrare/Chris Hostetler

  pro read_hsrl, trackfile, gps_lon, gps_lat, gps_alt, date, altitude, ext532, depol532, ext1064

  cdfid = hdf_sd_start(trackfile)
   idx = hdf_sd_nametoindex(cdfid,'gps_time')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, gps_time
   idx = hdf_sd_nametoindex(cdfid,'gps_alt')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, gps_alt
   idx = hdf_sd_nametoindex(cdfid,'gps_date')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, gps_date
   idx = hdf_sd_nametoindex(cdfid,'gps_lon')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, gps_lon
   idx = hdf_sd_nametoindex(cdfid,'gps_lat')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, gps_lat
   idx = hdf_sd_nametoindex(cdfid,'Altitude')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, altitude
   idx = hdf_sd_nametoindex(cdfid,'532_ext')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, ext532
   idx = hdf_sd_nametoindex(cdfid,'532_dep')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, depol532
   idx = hdf_sd_nametoindex(cdfid,'1064_ext')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, ext1064
  hdf_sd_end, cdfid

  yyyy = strmid(gps_date,6,4)
  mm = strmid(gps_date,0,2)
  dd = strmid(gps_date,3,2)

; hack on the time
; If the gps_date rolls over to another day, the gps_time does not
; rather, it keeps accumulating from the start time at the beginning
; Let's assume that if dd ne dd[0] then we've rolled over to a new
; day (UTC-wise) and then subtract 24 hours from the gps_time for those
; points.  Won't work if there really are multi-day flights or some such.
  a = where(dd ne dd[0])
  if(a[0] ne -1) then gps_time[a] = gps_time[a]-24.

  date  = yyyy*10000.d + mm*100.d + dd*1.d + (gps_time*3600.d)/86400.d

end

