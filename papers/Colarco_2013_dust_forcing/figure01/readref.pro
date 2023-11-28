; Procedure to read the refractive index from the specified GADS
; file.  Input is the desired filename.  Output is the refractive
; index value as nReal and nImag and the wavelength range.

  pro readref, filename, lambda, nReal, nImag

  gadsDir = './'

  gadsFile = gadsDir+filename


; File format is a 17 line string header
; followed by 61 lines of format like:
; #  2.500E-01 2.821E-03 1.625E-03 1.196E-03 5.760E-01 0.903E+00 9.037E-01  1.530E+00 -3.000E-02
; That is format='(A3,7(e9.3,1x),2(e10.3,1x))'
  openr, lun, gadsFile, /get_lun
  strHead = strarr(17)
  readf, lun, strhead
  str = 'a'
  dataLine = fltarr(9)
  nReal = fltarr(61)
  nImag = fltarr(61)
  lambda = fltarr(61)
  for i = 0, 60 do begin
   readf, lun, str, dataLine, format='(A3,7(e9.3,1x),2(e10.3,1x))'
   lambda[i] = dataLine[0]
   nReal[i] = dataLine[7]
   nImag[i] = dataLine[8]
  endfor
  free_lun, lun

end

