PRO read_sg2data, filename, data_struct, bad=bad

bad=0
sg2_indexinfo, index
sg2_specinfo,  spec

test = FILE_SEARCH(filename)
IF (test(0) EQ '') THEN BEGIN
  PRINT, 'File does not exist: '+filename
  bad=9999.
  GOTO, OVER
ENDIF

; Parse the filename
; DIR/SAGE_II_TYPE_YYYYMMDD.VERS#
file = FILE_BASENAME(filename)        ; Remove the directory
len  = STRLEN(file) - 8
file = STRMID(file,8,len)             ; Remove "SAGE_II_"
gap  = STRPOS(file,'_')
type = STRMID(file,0,gap)             ; File type
date = STRMID(file,gap+1,6)           ; File date
dot  = STRPOS(file,'.')
vers = STRMID(file,dot+1,len-dot-1)   ; File version

CASE (type) OF
'INDEX': BEGIN
  temp_struct = index
  END
'SPEC':  BEGIN
  temp_struct = spec
  END
ELSE: BEGIN
  PRINT, "Invalid file: " + filename
  STOP
  END
ENDCASE

IF (type NE 'INDEX') THEN BEGIN
  data_struct = REPLICATE(temp_struct,930)
ENDIF ELSE BEGIN
  data_struct = temp_struct
ENDELSE

OPENR, lun, filename, /GET_LUN
rec = 0
WHILE (NOT EOF(lun)) DO BEGIN
  READU, lun, temp_struct
  data_struct(rec) = temp_struct
  rec = rec + 1
ENDWHILE
CLOSE, lun  &  FREE_LUN, lun

OVER:
END
