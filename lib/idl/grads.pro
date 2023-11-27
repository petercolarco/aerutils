;
;    IDL interface to GrADS based on GA_BASE. This is a non-OO wrapper.
;
;    !REVISION HISTORY:
;
;    12Mar2006  da Silva  First crack.
;
;--------------------------------------------------------------------------
;
;    Copyright (C) 2006 by Arlindo da Silva <dasilva@alum.mit.edu>
;    All Rights Reserved.
;
;    This program is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; using version 2 of the License.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program; if not, please consult  
;              
;              http://www.gnu.org/licenses/licenses.html
;
;    or write to the Free Software Foundation, Inc., 59 Temple Place,
;    Suite 330, Boston, MA 02111-1307 USA
;

;------------------------------------------------------------------------
;
; Starts grads with bi-directional pipes;
;

PRO GRADS, bin=usrprog,  portrait=port, window=wind, options=opts,  $
           rc=rc,        echo=opt_e,    verb=opt_v,  transfer=opt_t

  common grads_private, GA

  if keyword_set(usrprog) then prog = usrprog $
  else                         prog = 'grads'

  if keyword_set(port) then orient = ' -p' $
  else                      orient = ' -l'

  if keyword_set(wind) then batch = ' ' $
  else                        batch = ' -b' 

  if keyword_set(opts) then extras = ' ' + opts $
  else                      extras = ' '

  if keyword_set(opt_e) then echo = 1 $
  else                       echo = 0

  if keyword_set(opt_v) then verb = 1 $
  else                       verb = 0

  if keyword_set(opt_t) then transfer = opt_t $
  else                       transfer = 'idl.dat' 


; If GrADS is running, stop it first
; ----------------------------------
  help,GA,out=txt
  if ~strmatch(txt[1],'*UNDEFINED*') then begin
      if GA.pid gt 0 then begin
         if verb then $
            print,'grads: stopping already running GrADS with pid = ', GA.pid
         rc = ga__end(GA)
      endif
  endif


  cmd_line = prog + ' -u ' + batch + orient + extras

  GA = ga__new(cmd_line,rc=rc,echo=echo,verb=verb,transfer=transfer)

  return

END

;------------------------------------------------------------------------
;
; GrADS wrappers
;
PRO GA_DODS, _REF_EXTRA=e
    grads, bin='gradsdods', _EXTRA=e
END

PRO GA_DAP, _REF_EXTRA=e
    grads, bin='gradsdap', _EXTRA=e
END

PRO GA_HDF, _REF_EXTRA=e
    grads, bin='gradshdf', _EXTRA=e
END

PRO GA_NC, _REF_EXTRA=e
    grads, bin='gradsnc', _EXTRA=e
END

PRO GA_NC4, _REF_EXTRA=e
    grads, bin='gradsnc4', _EXTRA=e
END

;------------------------------------------------------------------------
;
; GA  Main routine to send commands to GrADS.
;

PRO GA, cmd, rc=rc

  common grads_private, GA
  rc = ga__cmd(GA,cmd)

END

;------------------------------------------------------------------------
;
; Quits GrADS and kill process
;

PRO GA_END
  common grads_private, GA
  rc = ga__end(GA)
END

;------------------------------------------------------------------------
;
; var = ga_expr(expr)  Retrieves variable, expressions from GrADS.
;

FUNCTION GA_EXPR, expr, x=x, y=y, rc=rc, no_fix_lon=no_fix
  common grads_private, GA
  return, ga__expr ( GA, expr, x=x, y=y, rc=rc, no_fix_lon=no_fix )
END
   
;------------------------------------------------------------------------
;
; str = GA_RLINE(i)  Retrieves ith line in GrADS output buffer
;

FUNCTION GA_RLINE, iLine, rc=rc
  common grads_private, GA
  return, GA__RLINE ( GA, iLine, rc=rc )
END

;------------------------------------------------------------------------
;
; str = GA_RWORD(i,j)  Retrieves jth word from ith line in GrADS output buffer
;

FUNCTION GA_RWORD, iLine, jWord, rc=rc
  common grads_private, GA
  return, GA__RWORD ( GA, iLine, jWord, rc=rc )
END

;------------------------------------------------------------------------
;
; fh = GA_OPEN - Opens a file, returning a file handle.
;

FUNCTION GA_OPEN, fname, sdf=sdf, xdf=xdf, ctl=ctl, dods=dods, nc4=nc4, rc=rc
  common grads_private, GA

  if strcmp(fname,'http://',7) || $
     strcmp(fname,'HTTP://',7) || $
     keyword_set(dods)         || $
     keyword_set(sdf)          || $
     keyword_set(nc4)          || $
     strmatch(fname,'*.hdf')   || $
     strmatch(fname,'*.nc')          then cmd = 'sdfopen '+fname else $
  if keyword_set(xdf)          || $
     strmatch(fname,'*.ddf')         then cmd = 'xdfopen '+fname else $
                                          cmd = '   open '+fname  
; Define an empty file handle
; ---------------------------
  fh = { GA_FH, fid:-1, title:'', desc:'', bin:'', type:'', $
                nx:0, ny:0, nz:0, nt:0L, $
                nvars:0, vars:'', var_levs:'', vars_long:'' }


; Open the file
; -------------
  rc = GA__CMD ( GA, cmd )
  if rc then return, fh

; Build file handle
; -----------------
  fh.fid = fix(ga_rword(GA.nLines-1,8))
  rc = ga__cmd(GA,'q file '+string(fh.fid))
  if rc then return, fh
  
  fh.title = ga_rline(1)
  fh.desc  = ga_rword(2,2)
  fh.bin   = ga_rword(3,2)
  fh.type  = ga_rword(4,3)
  fh.nx    = ga_rword(5,3)
  fh.ny    = ga_rword(5,6)
  fh.nz    = ga_rword(5,9)
  fh.nt    = ga_rword(5,12)
  fh.nvars = ga_rword(6,5)
  vars  = ga_rword(7,1)
  levs  = ga_rword(7,2)
  vars_long = ga_rline(7)
  for i = 8, 6+fh.nvars do begin
      vars = vars + ' ' + ga_rword(i,1) 
      levs = levs + ' ' + ga_rword(i,2) 
      vars_long = vars_long + '$$$' + ga_rline(i)
  endfor
  fh.vars     = vars
  fh.var_levs = levs
  fh.vars_long = vars_long

  return, fh

END

;------------------------------------------------------------------------
;
; str = GA_TIME(t)   Set time index to 't', returning time string
;

FUNCTION GA_TIME, t, rc=rc
  common grads_private, GA
  time = ''
  rc = ga__cmd(GA,'set t '+string(t))
  if rc then return, time
  xxx = strsplit(ga_rword(1,4),':',/extract)
  year  = xxx[0]
  month = xxx[1]
  if fix(month) lt 10 then month = '0'+month
  day   = xxx[2]
  if fix(day) lt 10 then day = '0'+day
  rc = ga__cmd(GA,'q time')
  xxx = strsplit(ga_rword(1,3),'Z',/extract)
  hhmm = xxx[0]+' Z'
  time = year + '-' + month + '-' + day + ' ' + hhmm
  return,time
END


;------------------------------------------------------------------------
;
; PRC contrib
; str = GA_DATE(date)   Set time index to 'date', returning time string
; date = yyyymm, yyyymmdd, yyyymmddhh string or number

FUNCTION GA_DATE, date, rc=rc
  common grads_private, GA
  time = ''
  monstr = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', $
            'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  date = strcompress(date,/rem)

; Check to see if a text date is passed
  if(strcompress(string(long(date)),/rem) ne $
     strcompress(string(date),/rem) ) then begin
   rc = ga__cmd(GA,'set time '+string(date))
   return, time
  endif

; Otherwise it is a number, so do something with it???
  if(strlen(date) ge 6) then begin
   yyyy = strmid(date,0,4)
   mm   = strmid(date,4,2)
   dd   = '15'
   hh   = '12'
   if(strlen(date)eq 8 or strlen(date)eq 10) then dd = strmid(date,6,2)
   if(strlen(date)eq 10) then hh = strmid(date,8,2)
   datestr = hh+'z'+dd+monstr[fix(mm)-1]+yyyy
   rc = ga__cmd(GA,'set time '+string(datestr))
   if rc then return, time
; else assume a time index is passed
  endif else begin
   rc = ga__cmd(GA,'set t '+string(date))
   if rc then return, time
  endelse
  xxx = strsplit(ga_rword(1,4),':',/extract)
  year  = xxx[0]
  month = xxx[1]
  if fix(month) lt 10 then month = '0'+month
  day   = xxx[2]
  if fix(day) lt 10 then day = '0'+day
  rc = ga__cmd(GA,'q time')
  xxx = strsplit(ga_rword(1,3),'Z',/extract)
  hhmm = xxx[0]+' Z'
  time = year + '-' + month + '-' + day + ' ' + hhmm
  return,time
END


FUNCTION GA_GETT, rc=rc
  common grads_private, GA
  t  = ''
  rc = ga__cmd(GA,'q dims')
  t  = ga_rword(5,9)
  return, t
END



