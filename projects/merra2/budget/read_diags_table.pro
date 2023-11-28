  pro read_diags_table, expid, yyyy, $
                        precipls, precipcu, precipsno, preciptot, t2m, $
                        cldtt, cldlo, cldmd, cldhi

  rc = 0
  ny = n_elements(yyyy)

  vars = ['precipls','precipcu','precipsno','preciptot','t2m', $
          'cldtt','cldlo','cldmd','cldhi']

  nvars = n_elements(vars)

; setup the arrays to read
; 12 months + 1 annual average/total = 13
  input = fltarr(13,ny,nvars)
  for iy = 0, ny-1 do begin
   openr, lun, 'output/tables/budget.'+expid+'.DIAG.'+yyyy[iy]+'.txt', /get, error=rc
   if(rc ne 0) then return
   strline = 'a'
   data = fltarr(2,13)
   for ivar = 0, nvars-1 do begin
    readf, lun, data
    readf, lun, strline
    input[*,iy,ivar] = data[1,*]
   endfor
   free_lun, lun
  endfor


  precipls  = input[*,*,0]
  precipcu  = input[*,*,1]
  precipsno = input[*,*,2]
  preciptot = input[*,*,3]
  t2m       = input[*,*,4]
  cldtt     = input[*,*,5]
  cldlo     = input[*,*,6]
  cldmd     = input[*,*,7]
  cldhi     = input[*,*,8]

end
