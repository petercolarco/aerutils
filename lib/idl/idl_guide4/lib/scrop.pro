FUNCTION scrop, str_in, NDECS=ndecs
;Procedure to remove whitespace from a string
;(C) NCAS 2008

str=str_in 

IF (N_ELEMENTS(NDECS) EQ 0) THEN str=STRTRIM(STRING(str),2)
IF (N_ELEMENTS(NDECS) NE 0) THEN BEGIN
 fmt='(f0.'+STRTRIM(STRING(ndecs), 2)+')'
 str=STRTRIM(STRING(str, FORMAT=fmt),2)
ENDIF

RETURN, str

END

