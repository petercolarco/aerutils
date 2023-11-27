; Colarco, May 2006
; Given a grads control file and time index as input, retrieve the
; requested variable.

  pro ga_get_diag_xdf, ddf, tindex, varname, var, lon, lat, z=zinp

; Compile dependencies
; --------------------
  COMPILE_OPT      StrictArr
  RESOLVE_ROUTINE, 'ga_base', /either, /compile_full_file, /no_recompile
  RESOLVE_ROUTINE, 'grads'  , /either, /compile_full_file, /no_recompile

; Start GrADS; see code for the many options
; ------------------------------------------
  grads, rc=rc
  if rc then return

; Open a sample data file
; -----------------------
  ga, 'xdfopen '+ddf, rc=rc
  if rc then begin
     print,'cannot read input file, cannot go on'
     return
  endif

; Set the file time
; -----------------
  ga, 'set t '+string(tindex)

  z = 1
  if(keyword_set(zinp)) then begin
   z = zinp
   ga, 'set z '+string(z)
  endif

; Get the grads variable
; ----------------------
  var = ga_expr(varname,x=lon,y=lat,rc=rc)

  if rc then begin
   print, 'Error: getting variable: '+varname
   stop
  endif

; Stop GrADS
; ----------
  ga_end

end
