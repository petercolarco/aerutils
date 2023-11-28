; Colarco, December 2010
; Read in the "aeronet_locs.dat" database and return information
; on sites: location (name), lat, lon, elevation

  pro read_aeronet_locs, location, lat, lon, elevation, database=database, $
                         remove_underscore=remove_underscore

  if(not(keyword_set(database))) then database = 'aeronet_locs.dat'

  openr, lun, database, /get_lun
  a = 'a'
  i = 0 
  while(not eof(lun)) do begin
   readf, lun, a
   strparse = strsplit(a,' ',/extract)
   if(strpos(strparse[0],'#') eq -1) then begin
    location_ = strparse[0]
    lat_ = float(strparse[1]) + float(strparse[2])/60. + float(strparse[3])/3600.
    lon_ = float(strparse[4]) + float(strparse[5])/60. + float(strparse[6])/3600.
    ele_ = float(strparse[7])
    if(keyword_set(remove_underscore)) then begin
     au = 0
     while(au[0] ne -1) do begin
      au = strpos(location_,'_')
      if(au[0] ne -1) then strput, location_,' ',au
     endwhile
    endif
    if(i eq 0) then begin
     location = location_
     lat = lat_
     lon = lon_
     ele = ele_
    endif else begin
     location = [location,location_]
     lat = [lat, lat_]
     lon = [lon, lon_]
     ele = [ele, ele_]
    endelse
    i = i+1
   endif
  endwhile
  free_lun, lun

end
