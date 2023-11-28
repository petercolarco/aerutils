; Colarco, May 2007
; Write the time stamps into the kml file

  pro kml_time, lun, it, time, dirmake, sattrack=sattrack, $
                                        timesat=timesat, lonsat=lonsat, latsat=latsat

   mm = strmid(time,5,2)
   mmp1 = strcompress(string(fix(mm)+1),/rem)
   yyyyp1 = strmid(time,0,4)
   if(fix(mmp1) lt 10) then mmp1 = '0'+mmp1
   if(fix(mmp1) eq 13) then begin
    mmp1 = '01'
    yyyyp1 = strcompress(string(fix(yyyyp1)+1),/rem)
   endif


   begintime = strmid(time,0,8)+'01T00:00:00Z'
   endtime   = yyyyp1+'-'+mmp1+'-01T00:00:00Z'

;  suitable for 3 hourly output files
   yyyy = strmid(time,0,4)
   mm   = strmid(time,5,2)
   dd   = strmid(time,8,2)
   daysmax = ['31','28','31','30','31','30','31','31','30','31','30','31']
   dmax = daysmax[fix(mm)-1]
   if(mm eq '02') then begin
    if(strmid(time,0,4) eq '2000' or strmid(time,0,4) eq '2004') then dmax='29'
   endif
   hh = strmid(time,11,2)
   nn = strmid(time,14,2)
   tm = float(hh)+float(nn)/60.
   tm0 = tm-1.5
   tm1 = tm+1.5
   hh0 = strcompress(string(fix(tm0)),/rem)
   if(fix(hh0) lt 10) then hh0 = '0'+hh0
   begintime = strmid(time,0,10)+'T'+hh0+':00:00Z'
   hh1 = strcompress(string(fix(tm1)),/rem)
   if(fix(hh1) lt 10) then hh1 = '0'+hh1
   endtime   = strmid(time,0,10)+'T'+hh1+':00:00Z'
   if(fix(hh1) eq 24) then begin
    hh1 = '00'
    dd1 = strcompress(string(fix(dd)+1),/rem)
    mm1 = strcompress(string(fix(mm)),/rem)
    yyyy1 = strcompress(string(fix(yyyy)),/rem)
    if(fix(dd1) gt dmax) then begin
     mm1 = strcompress(string(fix(mm)+1),/rem)
     dd1 = '1'
    endif
    if(fix(mm1) gt 12) then begin
     mm1 = '1'
     yyyy1 = strcompress(string(fix(yyyy1)+1),/rem)
    endif
    if(fix(dd1) lt 10) then dd1 = '0'+dd1
    if(fix(mm1) lt 10) then mm1 = '0'+mm1
    endtime = yyyy1+'-'+mm1+'-'+dd1+'T'+hh1+':00:00Z'
   endif

;  If this isn't a satellite track, then make the groundoverlay
   if(not keyword_set(sattrack)) then begin

    printf, lun, '<GroundOverlay>'
    printf, lun, ' <name>'+string(it+1)+'</name>'
    printf, lun, ' <color>88ffffff</color>'
    printf, lun, ' <TimeSpan>'
    printf, lun, '  <begin>'+begintime+'</begin>'
    printf, lun, '  <end>'+endtime+'</end>'
    printf, lun, ' </TimeSpan>'
    printf, lun, ' <Icon>'
    printf, lun, '  <href>'+dirmake+'/'+strcompress(string(it+1),/rem)+'.png</href>'
    printf, lun, ' </Icon>'
    printf, lun, ' <LatLonBox>'
    printf, lun, '  <north>90</north>'
    printf, lun, '  <south>-90</south>'
    printf, lun, '  <east>180</east>'
    printf, lun, '  <west>-180</west>'
    printf, lun, ' </LatLonBox>'
    printf, lun, '</GroundOverlay>'

   endif

   if(keyword_set(sattrack)) then begin

    begintimecomp = strmid(begintime,0,4) +strmid(begintime,5,2) +strmid(begintime,8,2) $
              + 'T'+strmid(begintime,11,2)+strmid(begintime,14,2)+strmid(begintime,17,2)
    endtimecomp   = strmid(endtime,0,4) +strmid(endtime,5,2) +strmid(endtime,8,2) $
              + 'T'+strmid(endtime,11,2)+strmid(endtime,14,2)+strmid(endtime,17,2)

    yyyymmdd = yyyy[0]+mm[0]+dd[0]
    a = where(strmid(timesat,0,8) eq yyyymmdd)
    b = where(timesat ge begintimecomp[0] and timesat le endtimecomp[0])
    nelem = n_elements(a)
    if(a[0] ne -1) then begin
     printf, lun, ' <Placemark>'
     printf, lun, ' <name>Aqua</name>'
     printf, lun, ' <TimeSpan>'
     printf, lun, '  <begin>'+begintime+'</begin>'
     printf, lun, '  <end>'+endtime+'</end>'
     printf, lun, ' </TimeSpan>'
     printf, lun, ' <Style>'
     printf, lun, '  <LineStyle>'
     printf, lun, '   <color>ff0000ff</color>'
     printf, lun, '   <width>2</width>'
     printf, lun, '  </LineStyle>'
     printf, lun, ' </Style>'
     printf, lun, ' <LineString>'
     printf, lun, '  <tessellate>1</tessellate>'
     printf, lun, '  <altitudeMode>absolute</altitudeMode>'
     printf, lun, '  <coordinates>'
     for i = 0, nelem-1 do begin
      printf, lun, '   '+string(lonsat[a[i]])+','+string(latsat[a[i]])+',0'
     endfor
     printf, lun, '  </coordinates>'
     printf, lun, ' </LineString>'
     printf, lun, ' </Placemark>'

;    highlight time portion of track
     if(b[0] ne -1) then begin
     printf, lun, ' <Placemark>'
     printf, lun, ' <name>Aqua</name>'
     printf, lun, ' <TimeSpan>'
     printf, lun, '  <begin>'+begintime+'</begin>'
     printf, lun, '  <end>'+endtime+'</end>'
     printf, lun, ' </TimeSpan>'
     printf, lun, ' <Style>'
     printf, lun, '  <LineStyle>'
     printf, lun, '   <color>ff0000ff</color>'
     printf, lun, '   <width>8</width>'
     printf, lun, '  </LineStyle>'
     printf, lun, ' </Style>'
     printf, lun, ' <LineString>'
     printf, lun, '  <tessellate>1</tessellate>'
     printf, lun, '  <altitudeMode>absolute</altitudeMode>'
     printf, lun, '  <coordinates>'
     for i = 0, n_elements(b)-1 do begin
      printf, lun, '   '+string(lonsat[b[i]])+','+string(latsat[b[i]])+',0'
     endfor
     printf, lun, '  </coordinates>'
     printf, lun, ' </LineString>'
     printf, lun, ' </Placemark>'
    endif


    endif
   endif

end
