; Colarco, May 2007
; Colarco, Sept 2010
; Create a KML file and make the images requested

; Mods are to do the file reading elsewhere and just
; pass the resultant array to plot in.
; So:
;  array = (nx,ny,nt) array of values
;  lon   = (nx) array of longitudes
;  lat   = (ny) array of longitudes
;  date  = (nt) array of grads-like dates
;  filename = filename.kmz to create



  pro kml_make, array, lon, lat, date, filename, $
                levelarray=levelarray, colorarray=colorarray, $
                formatstr=formatstr,  scalefac=scalefac, $
                wantsattrack=wantsattrack, glopactrack=glopactrack, $
                title=title, hourly=hourly

  docname = filename+'.kml'
  spawn, '/bin/mkdir -p '+filename

  openw, lun, docname, /get_lun
  if(not(keyword_set(title))) then title = filename
  kml_header, lun, title, filename

; ----------------------------------
; Do the time slices of model fields
  printf, lun, '<Folder>'
  printf, lun, ' <name>Individual time slices</name>'
  printf, lun, ' <description>Individual time slices</description>'
  printf, lun, ' <visibility>1</visibility>'
  printf, lun, ' <open>0</open>'

; Handle the times I want
; Default is to assume 3-hourly output and 40 times (5 days)
  nt = n_elements(date)
  for it = 0, nt-1 do begin
   timestr = gradsdate(date[it])
   print, timestr
   kml_time, lun, it, date[it], filename, hourly=hourly

   plot_hires, array[*,*,it], lon, lat, name=filename+'/'+strcompress(string(it+1),/rem), $
               scalefac=scalefac, colorarray=colorarray, $
               levelarray=levelarray, dir=filename, $
               title=title, formatstr=formatstr, dods=dods
  endfor

; Close the time slice folder
  printf, lun, '</Folder>'
; ----------------------------------


; Make the satellite folder
; read the satellite data
  if(keyword_set(wantsattrack)) then begin
   satdate0 = strmid(timeAll[0],0,4)+strmid(timeAll[0],5,2)+strmid(timeAll[0],8,2)
   read_sattrack, 'junk', satdate0[0], timesat, lonsat, latsat, rc=rc
   if(rc eq 0) then begin
    printf, lun, '<Folder>'
    printf, lun, ' <name>Aura Subpoint</name>'
    printf, lun, ' <open>0</open>'
    printf, lun, ' <description>Description</description>'
    for it = 0, nt-1 do begin
     kml_time, lun, it, timeAll[it], dirmake, /sattrack, lonsat=lonsat, latsat=latsat, timesat=timesat
    endfor
    printf, lun, '</Folder>'
   endif
  endif


; Add the GLOPAC tracks
  if(keyword_set(glopactrack)) then begin
   colorstr = ['FFFF00FF','FFFF0000','FF13458B','FF00FF00','FF0000FF','FF228B22']
   for itr = 1, 6 do begin
    track = '0'+strcompress(string(itr),/rem)
    read_glopactrack, track, lonsat, latsat, altkm, rc=rc
    if(rc eq 0) then begin
     printf, lun, '<Folder>'
     printf, lun, ' <name>GLOPAC Track '+track+'</name>'
     printf, lun, ' <open>0</open>'
     printf, lun, ' <description>Description</description>'
     printf, lun, ' <Placemark>'
     printf, lun, ' <name>GLOPAC</name>'
     printf, lun, ' <visibility>0</visibility>'
;     printf, lun, ' <TimeSpan>'
;     printf, lun, '  <begin>'+begintime+'</begin>'
;     printf, lun, '  <end>'+endtime+'</end>'
;     printf, lun, ' </TimeSpan>'
     printf, lun, ' <Style>'
     printf, lun, '  <LineStyle>'
     printf, lun, '   <color>'+colorstr[itr-1]+'</color>'
     printf, lun, '   <width>8</width>'
     printf, lun, '  </LineStyle>'
     printf, lun, ' </Style>'
     printf, lun, ' <LineString>'
     printf, lun, '  <tessellate>1</tessellate>'
     printf, lun, '  <altitudeMode>absolute</altitudeMode>'
     printf, lun, '  <coordinates>'
     nelem = n_elements(lonsat)
     for i = 0, nelem-1 do begin
      printf, lun, '   '+string(lonsat[i])+','+string(latsat[i])+',0'
     endfor
     printf, lun, '  </coordinates>'
     printf, lun, ' </LineString>'
     printf, lun, ' </Placemark>'
     printf, lun, '</Folder>'
    endif
   endfor
  endif

; Close the file
  printf, lun, '</Folder>'
  printf, lun, '</kml>'
  free_lun, lun

  spawn, '/usr/bin/zip '+filename+'.kmz '+docname+' '+filename+'/*'
  spawn, 'rm -f '+docname
  spawn, 'rm -rf '+filename

end

