; Colarco, February 2011
; Read a table of entries that define variables to put on file

  pro read_variable_table, filename, nv, varoutname, varname, units, scalefac, $
                                     dimension, vloc, ctlfile, longname

  openr, lun, filename, /get

  str = 'a'

; Now read lines in the file
; Discard line if a "#" is the first character
  definetable = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   if(strmid(str,0,1) eq '#') then continue

;  parse the line
   strparts = strtrim(strsplit(str,'|', /extract),2)

   if(not(definetable)) then begin
    varoutname = strparts[0]
    varname    = strparts[1]
    units      = strparts[2]
    scalefac   = strparts[3]
    dimension  = strparts[4]
    vloc       = strparts[5]
    ctlfile    = strparts[6]
    longname   = strparts[7]
    definetable = 1
   endif else begin
    varoutname = [varoutname,strparts[0]]
    varname    = [varname,strparts[1]]
    units      = [units,strparts[2]]
    scalefac   = [scalefac,strparts[3]]
    dimension  = [dimension,strparts[4]]
    vloc       = [vloc,strparts[5]]
    ctlfile    = [ctlfile,strparts[6]]
    longname   = [longname,strparts[7]]
   endelse

  endwhile
  a = where(scalefac eq '')
  if(a[0] ne -1) then scalefac[a] = '1.'
  scalefac = float(scalefac)

  nv = n_elements(varname)

  free_lun, lun

end
