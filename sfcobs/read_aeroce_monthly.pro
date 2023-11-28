; Read a year of the AEROCE data from a file and return

  pro read_aeroce_monthly, filename, date, valueOut, stdOut

  openr, lun, filename, /get_lun
  network = 'a'
  station = 'a'
  parameter = 'a'
  unit = 'a'
  year = 'a'
  month = 'a'
  value = 'a'
  std   = 'a'
; read a header line
  readf, lun, network, station, parameter, unit, year, month, value, std, $
   format='(8a15)'
  ifirst = 1
  while(not eof(lun)) do begin
   readf, lun, network, station, parameter, unit, year, month, value, std, $
   format='(8a15)'
   if(ifirst) then begin
    date = long(year)*10000L + long(month)*100L + 15
    valueOut = float(value)
    stdOut = float(std)
   endif else begin
    date = [date, long(year)*10000L + long(month)*100L + 15]
    valueOut = [valueOut, float(value)]
    stdOut = [stdOut, float(std)]
   endelse
   ifirst = 0
  endwhile
  free_lun, lun

end
