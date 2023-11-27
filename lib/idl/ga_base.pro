;
;    IDL interface to GrADS. Used SPAWN and bi-directional pipes to
;    control GrADS expressions/variables can be exported to IDL.
;    See grads.pro for usage example.
;    
;    Note: This is implemented in a OO manner, although I have not
;          used IDL's object class constructs. No good reason, except 
;          that IDL's syntax looked very cumbersome.
;
;    !REVISION HISTORY:
;
;    13Mar2006  da Silva  First crack.
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
; Parses output, internal.
;

FUNCTION GA__PARSE, self

  line = ''
  WHILE ~STRCMP(line,'<IPC>',5) DO BEGIN
      READF, self.lu, line
  ENDWHILE

  rc = 0
  i = 0
  WHILE ~STRCMP(line,'</IPC>',6) DO BEGIN
      READF, self.lu, line
      IF STRCMP(line,'<RC>',4) THEN BEGIN
         tokens = STRSPLIT(line,/extract)
         rc = fix(tokens[1])
     ENDIF
     IF i le self.mLines THEN BEGIN
        self.result[i] = line
        i = i + 1
        IF self.echo eq 1 THEN print, line 
     ENDIF
  ENDWHILE
  self.nLines = i - 2

  return, rc

END

;------------------------------------------------------------------------
;
; Starts grads with bi-directional pipes;
;

FUNCTION GA__NEW, cmd_line, rc=rc, echo=opt_e, verb=opt_v, transfer=opt_t

; User options
; ------------ 
  if keyword_set(opt_e) then echo = opt_e $
  else                       echo = 0

  if keyword_set(opt_v) then verb = opt_v $
  else                       verb = 0

  if keyword_set(opt_t) then transfer = opt_t $
  else                       transfer = 'idl.dat' 

; Start the GrADS child process
; -----------------------------
  spawn, cmd_line, unit=lu, exit_status=rc, pid=pid, /sh

; GrADS output buffer
; -------------------
  mLines = 512
  result = strarr(mLines)

; Create the object
; ----------------- 
  self = { GRADS, pid:pid, lu:lu, echo:echo, verb:verb, mLines:mLines, $
                  nLines:mLines, transfer:transfer, result:result }

; Parse GrADS output
; ------------------
  rc = ga__parse(self)

  if verb then print, 'Started <', cmd_line, '> with pid = ', pid, $
                      ', rc = ', rc

  return, self

END

;------------------------------------------------------------------------
;
; GA  Main routine to send commands to GrADS.
;

FUNCTION GA__CMD, self, cmd

  rc = 0
  printf, self.lu, cmd
  rc = ga__parse(self)
  if self.verb eq 1 then print, 'rc = ', rc, ' for <', cmd, '>'

  return, rc

END

;------------------------------------------------------------------------
;
; var = ga_expr(expr)  Retrieves variable, expressions from GrADS.
;

FUNCTION GA__EXPR, self, expr, x=x, y=y, rc=rc, no_fix_lon=no_fix

  rc = 0

; Save the GrADS expression
; -------------------------
;  cmd = 'd save(' + expr + ',' + self.transfer + ')' 
  cmd = 'd ipc_save(' + expr + ',' + self.transfer + ')' 
  ga, cmd, rc=rc

  if rc ne 0 then begin
      print,'ga_expr: cannot handle expression <', expr,'>'
      rc = 1
      return, -1.0
  endif

; Retrieve data from transfer file
; --------------------------------
; Here's an unfortunate hack having to do with Mac OS X grads
; The special grads Arlindo provides is compiled so it writes
; output big endian.  This is fine on the powerpc, which is 
; where he compiled it.  On my Intel Mac platform however I
; need to byte swap.  I think this is the only instance where
; this matters.  I should therefore check the OS.  If Darwin,
; then I should check the processor.  If i386 I need to swap
; the endian.

  needswap = 0
; Check the OS
  spawn, 'uname -s', osname, /sh
  if(strlowcase(osname) eq 'darwin') then begin
   spawn, 'uname -p', procname, /sh
   if(strlowcase(procname) eq 'i386') then needswap = 1
  endif 
needswap =0 
  if(needswap eq 1) then begin
   openr, iu, self.transfer, /get_lun, /swap_endian
  endif else begin
   openr, iu, self.transfer, /get_lun
  endelse

  header = fltarr(20)
    grid = fltarr(20)

;  readu, iu, header, grid
  readu, iu, grid

  undef = grid(0)
  ix = grid(1)
  iy = grid(2)
  nx = grid(3)
  ny = grid(4)
  xt = grid(5)
  yt = grid(6)
  x0 = grid(7)
  dx = grid(8)
  y0 = grid(9)
  dy = grid(10)

  nx1 = nx

; Check whether last point is repeated remove it
; Skip this if /no_fix
; ----------------------------------------------
  if (ix eq 0) and ( ~keyword_set(no_fix) )  then begin
      xe = x0 + (nx-1) * dx
      d2r = 4*atan(1.) / 180.
      res = abs(cos(d2r*x0) - cos(d2r*xe))
      if ( res lt 0.00001 ) then begin
          nx1 = nx - 1
      endif
  endif
; PRC
; Fix bug to deal with non-linear longitudes
  if (ix eq 0) and (xt eq 0) then nx1 = nx

; Construct x/y coordinate vectors
; --------------------------------
  x = fltarr(nx)
  y = fltarr(ny)
  if xt ne 0 then begin
      x = x0 + indgen(nx1) * dx
  endif else begin
;      print,'ga_expr: x-coords are non-linear, for now no x'
;      print,'ga_expr: take a look at udf.doc and fix this (Arlindo)'
  endelse
  if yt ne 0 then begin
      y = y0 + indgen(ny) * dy
  endif else begin
;      print,'ga_expr: y-coordinatess are non-linear, for now no y'
;      print,'ga_expr: take a look at udf.doc and fix this (Arlindo)'
  endelse

  rc = 0
  if  (ix eq -1) and (iy eq -1) then begin
       var = 0.0      
       readu, iu, var
       free_lun, iu
   end else if  (ix ge 0) and (iy eq -1) then begin
       var = fltarr(nx)
       readu, iu, var
       var = var(0:nx1-1)
   end else if  (ix ge 0) and (iy ge 0) then begin
       var = fltarr(nx,ny)
       readu, iu, var
       var = var(0:nx1-1,*)
   end else begin
       print,'ga_expr: hmm... internal error for expression <', expr,'>'
       var = undef
       rc = 1
   end

   free_lun, iu

   return, var

END
   
;------------------------------------------------------------------------
;
; str = GA__RLINE(i)  Retrieves ith line in GrADS output buffer
;

FUNCTION GA__RLINE, self, iLine, rc=rc
  i = iLine
  rc = 0
  if i le self.nLines THEN BEGIN
     return,self.result[i-1]
  ENDIF
  rc = 1
  return, ''
END

;------------------------------------------------------------------------
;
; str = GA__RWORD(i,j)  Retrieves jth word from ith line in GrADS output buffer
;

FUNCTION GA__RWORD, self, iLine, jWord, rc=rc
  i = iLine
  j = jWord
  rc = 0
  if i le self.nLines THEN BEGIN
     rline = self.result[i-1]
     tokens = STRSPLIT(rline,/extract)
     if j le N_ELEMENTS(tokens) THEN return,tokens[j-1]
  ENDIF
  rc = 1
  return, ''
END

;------------------------------------------------------------------------
;
; Quits GrADS and kill process
;

FUNCTION GA__END, self
  rc = ga__cmd(self,'quit')
  free_lun, self.lu
  self.pid = -1
  return,rc
END

;------------------------------------------------------------------------
;
; Just to fool IDL.
;

FUNCTION GA_BASE
  return,0
END

   
   

