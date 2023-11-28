; $Header: /cvsroot/esma/sandbox/colarco/aerutils/mission/ex_rd2010.pro,v 1.1.1.1 2008/04/30 19:04:12 colarco Exp $
; to run this program simply type in ex_rd2010 and it will compile & run this .pro file
; and the str_parse.pro file.


pro ex_rd2010, filename, xname=xname, xvalues=xvals $
             , yname=yname, yvalues=yvals $
             , vname=vname, data=dat, vmiss=vmiss $
             , aname=aname, auxdat=auxdat, amiss=amiss $
             , n_dimens=n_dimens, nauxv=nauxv, err=err $
             , oname=oname,sname=sname,org=org,mname=mname $
             , date=date, mod_date=mod_date $
             , spec_comments=scom, norm_comments=ncom


;+
; NAME:
;   ex_rd2010
; PURPOSE:
;   reads a format-2010 exchange file
; CATEGORY:
;   exchange
; CALLING SEQUENCE:
;   ex_rd2010, filename, xname=xname, xvalues=xvals $
;             , yname=yname, yvalues=yvals $
;             , vname=vname, data=dat, vmiss=vmiss $
;             , aname=aname, auxdat=auxdat, abad=amiss $
;             , n_dimens=n_dimens, nauxv=nauxv, err=err $
;             , oname=oname,sname=sname,org=org,mname=mname $
;             , date=date, mod_date=mod_date $
;             , spec_comments=scom, norm_comments=ncom
; FUNCTION RETURN VALUE:
; INPUT PARAMETERS:
;    filename = the name of the exchange file to read
; OPTIONAL INPUT PARAMETERS:
; INPUT/OUTPUT PARAMETERS:
; OPTIONAL INPUT/OUTPUT PARAMETERS:
; OUTPUT PARAMETERS:
; OPTIONAL OUTPUT PARAMETERS:
; INPUT KEYWORDS:
; INPUT/OUTPUT KEYWORDS:
; OUTPUT KEYWORDS:
;    err = 0 if the file read read with no problem
;    xname = the name of the 1st independent coordinate (usually time)
;    xvalues = M-element vector of values of the 1st independent coordinate
;    yname = the name of the 2nd independent coordinate (usually altitude)
;    yvalues = N-element vector of values of the 2nd independent coordinate
;    vname = nv-elements array of names of the variables read from the file
;    data = M by N by nv array of data values read from the file
;    vmiss = nv-element vector of bad-or-missing-data flags
;    nauxv = number of auxiliary variables
;    aname = nauxv-elements array of names of the variables read from the file
;    auxdat = M by nauxv array of auxiliary data values read from the file
;    amiss = nauxv-element vector of bad-or-missing-data flags
;    n_dimens = 2 (format 2010 deals only with 2D data)
;    oname = a string holding the name of the data originators
;    sname = a string holding the name of the instrument/experiment
;    org = a string holding the name of the originators' institution
;    mname = a string holding the name of the mission   
;    date = a string holding the date of the flight
;    mod_date = a string holding the date these data were last modified
;    spec_comments = an array of "special" comments applying to this dataset
;    norm_comments = an array of "normal" comments appying to all corresponding
;             exchanges files for other dates.
; COMMON BLOCKS:
; REQUIRED ROUTINES:
; @ FILES:
; RESTRICTIONS:
; SIDE EFFECTS:
; DIAGNOSTIC INFORMATION:
; PROCEDURE:
; EXAMPLES:
; REFERENCE:
; FURTHER INFORMATION:
; RELATED FUNCTIONS AND PROCEDURES:
; MODIFICATION HISTORY:
;   1997-11-05:lrlait: - wrote 
;-




; ok, open the file, letting IDL halt with any error messages
; if there is a problem with the file
;get_lun,lun
;filename = './BT20000123.DC8'
   openr,lun,filename, /get_lun

;#########  uniform header stuff

; get the number of lines in the header and the format type
nlhead = 0
ftype = 0
readf,lun,nlhead,ftype
if ftype ne 2010 then stop,"Wrong file type for 2010:",ftype

; originators' names
oname=''
readf,lun,oname
oname = strtrim(oname,2)
; originators' organization
org=''
readf,lun,org
org = strtrim(org,2)
; data source (i.e., instrument)
sname=''
readf,lun,sname
sname = strtrim(sname,2)
; mission name
mname=''
readf,lun,mname
mname = strtrim(mname,2)


; volumne ivol of nvol
ivol=0L
nvol=0L
readf,lun,ivol,nvol
if (ivol ne 1) or (nvol ne 1) then $
   message,"multi-volume file:"+filename

; date-----note: this must be changed if/when they go to y2K compatibility
datstr=''
readf,lun,datstr
datparts = str_parse(datstr," ")

year = strmid(datparts(0),2,2)
mon = datparts(1)
day = datparts(2)
if strlen(mon) lt 2 then mon = '0'+mon
if strlen(day) lt 2 then day = '0'+day
date =  year+mon+day 

year = strmid(datparts(3),2,2)
mon = datparts(4)
day = datparts(5)
if strlen(mon) lt 2 then mon = '0'+mon
if strlen(day) lt 2 then day = '0'+day
mod_date =  year+mon+day


;      #########  format-dependent header stuff
      
      n_dimens = 2
      
      dx = fltarr(2)
      readf,lun,dx
      nx = 0
      readf,lun,nx
      nxdef = 0
      readf,lun,nxdef
      if nxdef eq 1 then begin
         temp = 0.0
         readf,lun,temp
         yvals = temp + dx(0)*findgen(nx)
      endif else begin
         yvals = fltarr(nx)
         readf,lun,yvals
      endelse
      xname = ''
      temp = ''
      readf,lun,temp
      yname = strtrim(temp,2)
      readf,lun,temp
      xname = strtrim(temp,2)

      nv = 0
      readf,lun,nv
      vscal = fltarr(nv)
      readf,lun,vscal
      vmiss = fltarr(nv)
      readf,lun,vmiss
      vname = strarr(nv)
      for ii=0,nv-1 do begin
          temp = ''
          readf,lun,temp
          vname(ii) = strtrim(temp,2)
      endfor
      
      nauxv = 0
      if n_elements(auxdat) gt 0 then junk = temporary(auxdat)
      if n_elements(aname) gt 0 then junk = temporary(aname)
      if n_elements(amiss) gt 0 then junk = temporary(amiss)
      readf,lun,nauxv
      if nauxv gt 0 then begin
         ascal = fltarr(nauxv)
         readf,lun,ascal
         amiss = fltarr(nauxv)
         readf,lun,amiss
         aname = strarr(nauxv)
         for ii=0,nauxv-1 do begin
             temp = ''
             readf,lun,temp
             aname(ii) = strtrim(temp,2)
         endfor
      endif

; #############################################

; number of special comments
if n_elements(scom) gt 0 then junk = temporary(scom)
nscoml = 0
readf,lun,nscoml
if nscoml gt 0 then begin
   scom = strarr(nscoml)
   for ii=0,nscoml-1 do begin
       temp=''
       readf,lun,temp
       scom(ii) = temp
   endfor
endif

; number of regular comments
if n_elements(ncom) gt 0 then junk = temporary(ncom)
nncoml = 0
readf,lun,nncoml
if nncoml gt 0 then begin
   ncom = strarr(nncoml)
   for ii=0,nncoml-1 do begin
       temp=''
       readf,lun,temp
       ncom(ii) = temp
   endfor
endif

; ##############################################

 
     ; find out how many lines of data there are
     ndata = 0L
     x = 0.0
     indata = fltarr(nx)
     if nauxv gt 0 then a = fltarr(nauxv)
     while not eof(lun) do begin
        if nauxv gt 0 then begin
           readf,lun,x,a
        endif else begin
           readf,lun,x
        endelse
        for ii=1,nv do begin
           readf,lun,indata
        endfor
        ndata = ndata + 1L
     endwhile
     
     ; close the file, reopen it, and skip past the header to the data
     close,lun
     openr,lun,filename
     for ii=1,nlhead do begin
        temp = ''
        readf,lun,temp
     endfor
     
     xvals = fltarr(ndata)
     dat = fltarr(ndata,nx,nv)
     dat0 = fltarr(nx,ndata,nv)
     if nauxv gt 0 then auxdat = fltarr(nauxv,ndata)

     ; now read the data
     indata = fltarr(nx,nv)
     ii = 0L
     while ii lt ndata do begin
         if nauxv gt 0 then begin
            readf,lun,x,a
            auxdat(0,ii) = a
         endif else begin
            readf,lun,x
         endelse
         xvals(ii) = x 
         readf,lun,indata
         for jj=0,nv-1 do begin
            dat0(0,ii,jj) = indata(*,jj)
         endfor
         ii = ii + 1L
     endwhile
     
     for jj=0,nv-1 do begin
        dat(0,0,jj) = transpose(dat0(*,*,jj))
     endfor
     if nauxv gt 0 then auxdat = transpose(auxdat)

; ##############################################


close,lun
free_lun,lun


   ; scale the primary variables
   for pk=0,nv-1 do begin

       case n_dimens of
       1: dd = dat(*,pk)
       2: dd = dat(*,*,pk)
       endcase
       
       ok = where( dd ne vmiss(pk) )
       if ok(0) ne -1 then   dd(ok) = dd(ok) * vscal(pk)
       
       case n_dimens of
       1: dat(0,pk) = dd
       2: dat(0,0,pk) = reform(dd,ndata,nx) 
       endcase
       
   endfor
   
   ;  scale the auxiliary variables
   for ii=0,nauxv-1 do begin

       dd = auxdat(*,ii)

       ok = where( dd ne amiss(ii) )
       if ok(0) ne -1 then  dd(ok) = dd(ok) * ascal(ii)
       
       auxdat(0,ii) = dd
              
   endfor


err = 0
end
