; Colarco, May 2007
; Write the time stamps into the kml file

  pro kml_time, lun, it, time, dirmake, sattrack=sattrack, $
                                        timesat=timesat, lonsat=lonsat, latsat=latsat, $
                                        hourly=hourly

;  hourly is a hook for more sophisticated (in the future) time handling
   if(not(keyword_set(hourly))) then hourly=0

   mm = strmid(time,5,2)
   mmp1 = strcompress(string(fix(mm)+1),/rem)
   yyyyp1 = strmid(time,0,4)
   if(fix(mmp1) lt 10) then mmp1 = '0'+mmp1
   if(fix(mmp1) eq 13) then begin
    mmp1 = '01'
    yyyyp1 = strcompress(string(fix(yyyyp1)+1),/rem)
   endif


;  Assume three hour output

;  Parse the y/m/d of rht file
   yyyy = strmid(time,0,4)
   mm   = strmid(time,5,2)
   dd   = strmid(time,8,2)
   daysmax = ['31','28','31','30','31','30','31','31','30','31','30','31']
   dmax = daysmax[fix(mm)-1]
   if(mm eq '02') then begin
    if(strmid(time,0,4) eq '2000' or strmid(time,0,4) eq '2004' or $
       strmid(time,0,4) eq '2008' or strmid(time,0,4) eq '2012') then dmax='29'
   endif
;  Now parse the hour string (may be different for different files)
   result = strsplit(time,/extract)
   hhstr = result[1]
   if(strlen(hhstr) eq 2) then begin
    hh = hhstr
    nn = '00'
   endif else begin
    hh = strmid(hhstr,0,2)
    nn = strmid(hhstr,3,2)
   endelse
   tm = float(hh)+float(nn)/60.
   tm0 = tm-1.5
   tm1 = tm+1.5

   if(tm0 lt 0) then begin
    tm0 = tm0+24.
    jday0 = julday(mm,dd,yyyy)-1
    caldat, jday0, mm0, dd0, yyyy0
    dd0 = strcompress(string(dd0),/rem)
    if(dd0 lt 10) then dd0 = '0'+dd0
    mm0 = strcompress(string(mm0),/rem)
    if(mm0 lt 10) then mm0 = '0'+mm0
    yyyy0 = strcompress(string(yyyy0),/rem)
    ddstr0 = yyyy0+'-'+mm0+'-'+dd0
   endif else begin
    ddstr0 = strmid(time,0,10)
   endelse
   hh_ = strcompress(string(fix(tm0)),/rem)
   if(hh_ lt 10) then hh_ = '0'+hh_
   nn_ = strcompress(string((tm0-fix(tm0))*60,format='(i2)'),/rem)
   if(nn_ lt 10) then nn_ = '0'+nn_
   hhstr0 = hh_+':'+nn_+':00'
   begintime = ddstr0 + 'T' + hhstr0 + 'Z'

   if(tm1 ge 24) then begin
    tm1 = tm1-24
    jday1 = julday(mm,dd,yyyy)+1
    caldat, jday1, mm1, dd1, yyyy1
    dd1 = strcompress(string(dd1),/rem)
    if(dd1 lt 10) then dd1 = '0'+dd1
    mm1 = strcompress(string(mm1),/rem)
    if(mm1 lt 10) then mm1 = '0'+mm1
    yyyy1 = strcompress(string(yyyy1),/rem)
    ddstr1 = yyyy1+'-'+mm1+'-'+dd1
   endif else begin
    ddstr1 = strmid(time,0,10)
   endelse
   hh_ = strcompress(string(fix(tm1)),/rem)
   if(hh_ lt 10) then hh_ = '0'+hh_
   nn_ = strcompress(string((tm1-fix(tm1))*60,format='(i2)'),/rem)
   if(nn_ lt 10) then nn_ = '0'+nn_
   hhstr1 = hh_+':'+nn_+':00'
   endtime = ddstr1 + 'T' + hhstr1 + 'Z'

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
