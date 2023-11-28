; Colarco, May 2007
; Create a KML file and make the images requested

  pro kml_make, filename, date, varname, wantlev=wantlev, scalefac=scalefac, $
                levelarray=levelarray, title=title, formatstr=formatstr

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


; loop over time
;  nt = n_elements(time)
nt = 1
  for it = 0, nt-1 do begin
  ga_getvar, filename, '', time=time, /noprint, wanttime=[strcompress(string(it+1),/rem)]
;   kml_time, lun, it, time[it], dirmake
   kml_time, lun, it, time, dirmake
   plot_hires, filename, varname, name=dirmake+'/'+strcompress(string(it+1),/rem), $
               wanttime=[time], wantlev=wantlev, $
               scalefac=scalefac, levelarray=levelarray, dir=dirmake, $
               title=title, formatstr=formatstr
  endfor

; Close the file
  printf, lun, '</Folder>'
  printf, lun, '</Folder>'
  printf, lun, '</kml>'
  free_lun, lun

  spawn, '/usr/bin/zip '+dirmake+'.kmz '+docname+' '+dirmake+'/*'
  spawn, 'rm -f '+docname
  spawn, 'rm -rf '+dirmake

end

