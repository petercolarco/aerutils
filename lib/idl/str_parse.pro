function str_parse,str,delim,null=null

;+
; NAME:
;   str_parse
; PURPOSE:
;   breaks an input string up into component parts
; CATEGORY:
;   string
; CALLING SEQUENCE:
;   parts = str_parse("this is a test"," ")
; INPUTS:
;   str = the input string to be separated into tokens
;   delim = the single-character string used as a delimiter
; OPTIONAL INPUT PARAMETERS:
; KEYWORD PARAMETERS: 
;  /null if specified, then multiple occurrences of the delimiter in a row
;          result in null strings being returned.  By default, strings of
;          delimiter characters will be considered as one delimiter.  
; OUTPUTS:
;   returns an array of strings, one for each token found in str
; OPTIONAL OUTPUT PARAMETERS:   
; COMMON BLOCKS:   
; SIDE EFFECTS:   
; RESTRICTIONS:  
; PROCEDURE:   
; REQUIRED ROUTINES:  
; MODIFICATION HISTORY: 
;    lrlait 910614
;    $Header: /cvsroot/esma/sandbox/colarco/aerutils/lib/idl/str_parse.pro,v 1.1.1.1 2008/04/30 19:04:12 colarco Exp $
;-

; get a single byte for the delimiter
delm = byte(delim)
delm = delm(0)

; convert the sting to an array of bytes
ss = byte( str )

; find occurences of the delimiter
oyes = where( ss ne delm )
ono = where( ss eq delm )

   if max(ono) lt max(oyes) then  ono = [ono, n_elements(ss) ]
   ostrt = oyes(where( oyes ne (shift(oyes,1)+1) )) 
   oend= ono(where( ono ne (shift(ono,1)+1) )) - 1
   oend = oend( where( oend ge min(ostrt) ) )

if keyword_set(null) then begin
   nn = n_elements(ono)
   if ono(nn-1) eq (n_elements(ss)-1) then begin
      ono = [ ono, n_elements(ss) ]
      nn = nn + 1
   endif

   hh = strarr(nn)

   for i=0,n_elements(ostrt)-1 do begin
        k = where( (oend(i)+1) eq  ono )
        hh(k) = string( ss(ostrt(i):oend(i) ) )
   endfor

endif else begin

   nn = n_elements(ostrt) 

   hh = strarr(nn)

   for i=0, nn-1 do hh(i) = string( ss( ostrt(i) : oend(i) ) )

endelse

return, hh

end

