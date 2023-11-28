; Colarco, May 2007
; Create a KML file and make the images requested

  pro kml_make, filename, date, varname, wantlev=wantlev, scalefac=scalefac, $
                levelarray=levelarray, title=title, formatstr=formatstr, $
                wantsattrack=wantsattrack, ntimes=ntimes, dods5=dods5

  if(not(keyword_set(wantlev))) then begin
     dirmake = varname+'.'+date
  endif else begin
     dirmake = varname+'_p'+strcompress(string(wantlev[0]),/rem)+'.'+date
  endelse

  docname = dirmake+'.kml'
  spawn, '/bin/mkdir -p '+dirmake
;  ga_getvar, filename, '', time=time, /noprint

  openw, lun, docname, /get_lun
  if(not(keyword_set(title))) then title = dirmake
  kml_header, lun, title, dirmake

; ----------------------------------
; Do the time slices of model fields
  printf, lun, '<Folder>'
  printf, lun, ' <name>Individual time slices</name>'
  printf, lun, ' <description>Individual time slices</description>'
  printf, lun, ' <visibility>1</visibility>'
  printf, lun, ' <open>0</open>'

;  nt = n_elements(time)
nt = 40
if(keyword_set(ntimes) ) then nt = ntimes
  for it = 0, nt-1 do begin
   ga_getvar, filename, '', time=time, /noprint, wanttime=[strcompress(string(it+1),/rem)]
   kml_time, lun, it, time, dirmake
print, time
   plot_hires, filename, varname, name=dirmake+'/'+strcompress(string(it+1),/rem), $
               wanttime=[gradsdate(time)], wantlev=wantlev, $
               scalefac=scalefac, levelarray=levelarray, dir=dirmake, $
               title=title, formatstr=formatstr, dods5=dods5
  endfor

; Close the time slice folder
  printf, lun, '</Folder>'
; ----------------------------------


; Make the satellite folder
; read the satellite data
  if(keyword_set(wantsattrack)) then begin
   ga_getvar, filename, '', time=time, /noprint, wanttime=[strcompress(string(1),/rem)]
   satdate0 = strmid(time,0,4)+strmid(time,5,2)+strmid(time,8,2)

   read_sattrack, 'junk', satdate0[0], timesat, lonsat, latsat, rc=rc
   if(rc eq 0) then begin
    printf, lun, '<Folder>'
    printf, lun, ' <name>Satellite Track</name>'
    printf, lun, ' <open>0</open>'
    printf, lun, ' <description>Description</description>'
    for it = 0, nt-1 do begin
     ga_getvar, filename, '', time=time, /noprint, wanttime=[strcompress(string(it+1),/rem)]
     kml_time, lun, it, time, dirmake, /sattrack, lonsat=lonsat, latsat=latsat, timesat=timesat
    endfor
    printf, lun, '</Folder>'
   endif
  endif


; Close the file
  printf, lun, '</Folder>'
  printf, lun, '</kml>'
  free_lun, lun

  spawn, '/usr/bin/zip '+dirmake+'.kmz '+docname+' '+dirmake+'/*'
  spawn, 'rm -f '+docname
  spawn, 'rm -rf '+dirmake

end

