  pro read_forcing_table, expid, yyyy, $
                          swtoaclr, swsfcclr, swatmclr, $
                          swtoaall, swsfcall, swatmall, $
                          rc=rc

  rc = 0
  ny = n_elements(yyyy)

  vars = ['swtoaclr','swsfcclr','swatmclr', $
          'swtoaall','swsfcall','swatmall']

  nvars = n_elements(vars)

; setup the arrays to read
; 12 months + 1 annual average/total = 13
  input = fltarr(13,ny,nvars)
  for iy = 0, ny-1 do begin
   openr, lun, 'output/tables/forcing.'+expid+'.'+yyyy[iy]+'.txt', /get, error=rc
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

  swtoaclr = input[*,*,0]
  swsfcclr = input[*,*,1]
  swatmclr = input[*,*,2]
  swtoaall = input[*,*,3]
  swsfcall = input[*,*,4]
  swatmall = input[*,*,5]

end
