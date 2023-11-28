; Colarco
; Generate the database table of lifetime quantities and statistics

  print_lifetime, 'ftst', '2000', resolution='b'
  print_lifetime, 'replay', '2000', resolution='b'

; For the "c" run first
  year = string(findgen(7)+2000,format='(i4)')
  ny = n_elements(year)
  expid = ['t003_c32']

  for iexp = 0, n_elements(expid)-1 do begin
   for iy = 0, ny -1 do begin

    print_lifetime, expid[iexp], year[iy], resolution='c'

   endfor
  endfor

; For the "b" runs
  year = string(findgen(7)+2000,format='(i4)')
  ny = n_elements(year)
  expid = ['t002_b55','t005_b32','t006_b32']

  for iexp = 0, n_elements(expid)-1 do begin
   for iy = 0, ny -1 do begin

    print_lifetime, expid[iexp], year[iy], resolution='b'

   endfor
  endfor

end


