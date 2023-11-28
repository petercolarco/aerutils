; GEOS table:  read from optics_DU.v15_6 -- merge of OBS + OPAC (capped) (GEOS)
; OPAC table:  read from "miam00" -- official OPAC
; ECMWF table: read from "woodward.txt" -- this was copied out of
;              Table 2 of Woodward 2001 (need to verify with Sam Remy)
; UKMO table:  read from "balkanski_fig4.txt" from Balkanski et al. 2007
;              medium hemative model (provided by Balkanski, need to
;              check with Melissa Brooks)

; Read and output refractive indices in form suitable for
; ingest to Osku's calculator

; GEOS obs+OPAC (Colarco 2014)
  filedir = '/home/colarco/sandbox/radiation/x/'
  filename = 'optics_DU.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  openw, lun, 'ri-du_v15_6.wsv', /get
  printf, lun, '# lambda[um] m_real m_imaginary'
  for ilam = 0, n_elements(lambda)-1 do begin
   printf, lun, lambda[ilam]*1e6, refreal[ilam,0,0], -abs(refimag[ilam,0,0]), $
                format='(E9.3,1x,f5.3,2x,f7.4)'
  endfor
  free_lun, lun

  readref, 'miam00', lambda, refreal, refimag
  openw, lun, 'ri-du_opac.wsv', /get
  printf, lun, '# lambda[um] m_real m_imaginary'
  for ilam = 0, n_elements(lambda)-1 do begin
   printf, lun, lambda[ilam], refreal[ilam], -abs(refimag[ilam]), $
                format='(E9.3,1x,f5.3,2x,f9.6)'
  endfor
  free_lun, lun


  read_woodward, 'woodward.txt', lambda, refreal, refimag
  openw, lun, 'ri-du_woodward.wsv', /get
  printf, lun, '# lambda[um] m_real m_imaginary'
  for ilam = 0, n_elements(lambda)-1 do begin
   printf, lun, lambda[ilam], refreal[ilam], -abs(refimag[ilam]), $
                format='(E9.3,1x,f5.3,2x,f7.4)'
  endfor
  free_lun, lun

  read_balkanski, 'balkanski_fig4.txt', lambda, refreal, refimag
  openw, lun, 'ri-du_balkanski.wsv', /get
  printf, lun, '# lambda[um] m_real m_imaginary'
  for ilam = 0, n_elements(lambda)-1 do begin
   printf, lun, lambda[ilam], refreal[ilam], -abs(refimag[ilam]), $
                format='(E9.3,1x,f5.3,2x,E9.2)'
  endfor
  free_lun, lun

  read_balkanski27, 'balkanski_fig4.txt', lambda, refreal, refimag
  openw, lun, 'ri-du_balkanski27.wsv', /get
  printf, lun, '# lambda[um] m_real m_imaginary'
  for ilam = 0, n_elements(lambda)-1 do begin
   printf, lun, lambda[ilam], refreal[ilam], -abs(refimag[ilam]), $
                format='(E9.3,1x,f5.3,2x,E9.2)'
  endfor
  free_lun, lun

end
