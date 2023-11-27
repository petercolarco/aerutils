; Colarco, May 2006
; Get the mask file
; Read the resolution dependent mask file and return an array of
; values (by grid box) as indicated below
; 0 = ocean
; 1 = north america
; 2 = south america
; 3 = europe
; 4 = asia
; 5 = africa
; 6 = australia/oceania
; 7 = greenland
; 8 = antarctica

  pro ga_get_mask, var, lon, lat, resolution=resolution

; Check resolution keyword
  spawn, 'echo ${BASEDIRAER}', basedir
  if(keyword_set(resolution)) then begin
   maskfile = $
    basedir+'/data/'+resolution+'/colarco.regions_co.sfc.clm.hdf'
  endif else begin
   maskfile = $
    basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
  endelse


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
  ga, 'sdfopen '+maskfile, rc=rc
  if rc then begin
     print,'cannot read input file, cannot go on'
     return
  endif

; Get the grads variable
; ----------------------
  var = ga_expr('COMASK',x=lon,y=lat,rc=rc)

  if rc then begin
   print, 'Error: getting variable: '+varname
   stop
  endif

; Stop GrADS
; ----------
  ga_end

end
