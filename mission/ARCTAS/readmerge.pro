pro readmerge,fname,DATA,NAMES,UNITS,NCOL,NDAT,VMISS,cols=cols,lines=lines,   $
             delim=delim,skp1=skp1,skp2=skp2,skip=skip,    $
             noheader=noheader,comments=comments,transpose=transpose,  $
             quiet=quiet,max=max,scol=scol,ivar=ivar
;on_error,2     ; return to caller
; set maximum number of allowed lines
  if(keyword_set(lines)) then IMAX = lines else IMAX = 15000
  if(keyword_set(max)) then IMAX = MAX 
; set starting column to read
  if not (keyword_set(scol)) then scol = 0
if keyword_set(ivar) then cols=n_elements(ivar)


     DATA = 0         ; default: return 0 as DATA
     NAMES = ''       ; variable names (will be copied into HEADER)
     COMMENTS = ''    ; comment lines

     NDAT = 0         ; number of data lines actually read

     NCOL = 0         ; number of columns found in the data set, i.e.
                      ; number of variable names in HEADER
                      ; COLS is the variable that is actually used to
                      ; determine the number of variables to read and
                      ; COLS will be set to NCOL if not specified as keyword.

; see if parameters are consistent
  if (N_PARAMS() le 1) then begin
     print,' ERROR in readdata : not enough parameters !'
     use_readdata
     return
     endif

  if (keyword_set(noheader) AND NOT keyword_set(cols)) then begin
     print,' ERROR in readdata : /noheader requires cols=nn !'
     use_readdata
     return
     endif
; set keyword parameters or their default values
  if not keyword_set(delim) then delim=''
  if (not (keyword_set(skp1) OR keyword_set(skip)) ) then skp1 = 0
  if (keyword_set(skip) AND NOT keyword_set(skp1)) then skp1 = skip
  if not keyword_set(skp2) then skp2 = 0

;  on_ioerror,bad
;  !ERROR = 0

; open the data file
  openr,unit1,fname,/get_lun
header1='' & header2='' & header3='' & char=''
;begin to read the information in the file
readf,unit1,ncom
readf,unit1,header1	; reads in Names
readf,unit1,header2	; reads in Institution
readf,unit1,header3     ; name of data set
readf,unit1,char & readf,unit1,char
readf,unit1,char 
print,'Flight date and date of merge:'
print,char
readf,unit1,char & readf,unit1,char 
readf,unit1,NCOL
if (keyword_set(cols)) then begin
 print,fname,' : ',NCOL,' variables found, will read in ',COLS 
 endif else begin
 print,fname,' : ',NCOL,' variables found, will read in ',NCOL 
 COLS=NCOL
 endelse


vscale=fltarr(NCOL) &  vmiss = fltarr(NCOL)
names=strarr(NCOL) & units=strarr(NCOL)
readf,unit1,vscale & readf,unit1,vmiss
readf,unit1,names

   for i=0,NCOL-1 do begin
	char=STR_SEP(names(i),",")
         if n_elements(char) gt 1 then begin
	names(i)=STRCOMPRESS(char(0),/remove_all)
	units(i)=STRCOMPRESS(char(1),/remove_all) 
          endif else begin
	char=STR_SEP(names(i),"(")
	names(i)=STRCOMPRESS(char(0),/remove_all)
	units(i)=STRCOMPRESS(char(1),/remove_all) 
          endelse 
   endfor
if not keyword_set(ivar) then begin
 names=names(scol:scol+cols-1) & units=units(scol:scol+cols-1)
 vscale=vscale(scol:scol+cols-1) & vmiss=vmiss(scol:scol+cols-1) 
endif else begin
  names=names(ivar) & units=units(ivar)
  vscale=vscale(ivar)  & vmiss=vmiss(ivar)
endelse
char=''
readf,unit1,i
if i gt 0 then readf,unit1,char
readf,unit1,ncom
for i=0,ncom-1 do readf,unit1,char
; Qing--changed temporarily for INTEX current merge
;for i=0,ncom-1 do readf,unit1,char
num=0.
data=fltarr(IMAX,COLS+1)
char1=''
char2=''
dum=fltarr(NCOL+1)
   while (not eof(unit1)) do begin
	readf,unit1,dum
        ; Qing --changed temporarily for INTEX current merge
        ;readf,unit1,char1
        ;readf,unit1,char2
        ;dum=float(str_sep(strcompress(strtrim(char1+char2,2)),' '))
        data(num,0)=dum(0)
 	if not keyword_set(ivar) then data(num,1:*)=dum(1+scol:1+scol+cols-1) $
	  else data(num,1:*)=dum(1+ivar)
	num=num+1
	     if num ge IMAX then begin
             print,' SORRY : too much data ! Current limit set to ',IMAX
             print,' Will proceed with what I got ...'
             goto,recover
 	     endif
   endwhile

recover:  
     free_lun,unit1
data=data(0:num-1,*)
;Add to the header the time
names=["UTIME",names]
units=["s",units]

;scale with the appropriate factors:
for i=1,COLS-1 do begin
miss=missdata(data(*,i),vmiss(i))
data(*,i)=data(*,i)*vscale(i)
if miss(0) gt -1 then data(miss,i)=vmiss(i)
endfor
NDAT=num-1	;number of data lines
print,IMAX,' maximum of data lines to read'
print,NDAT,' lines of data read.'
vmiss=[vmiss(0),vmiss]
if keyword_set(transpose) then data=transpose(data)
goto,done

  bad:  print,!ERR_STRING,'  (',!ERROR,')'
        if(!error eq -171) then begin
           print,' File not found.'
           end
        if(!error eq -191) then begin
           use_readdata
           print,' You probably specified a wrong number for skp1 or skp2.'
           end
        if(!error eq 101) then begin
           print,' File was empty.'
           end
  done: if(!error ne -171) then free_lun,unit1
        return


end
