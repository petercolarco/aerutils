  expid = 'c180R_calbucco'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  for i = 0, nf-1 do begin

   datestr = strmid(filename[i],17,14,/rev)
   hstr    = strmid(datestr,9,2)
   print, hstr

   datestr0 = datestr
   datestr1 = datestr
   case hstr of
    '01': begin
          hstr0 = '00'
          hstr1 = '02'
          end
    '04': begin
          hstr0 = '03'
          hstr1 = '05'
          end
    '07': begin
          hstr0 = '06'
          hstr1 = '08'
          end
    '10': begin
          hstr0 = '09'
          hstr1 = '11'
          end
    '13': begin
          hstr0 = '12'
          hstr1 = '14'
          end
    '16': begin
          hstr0 = '15'
          hstr1 = '17'
          end
    '19': begin
          hstr0 = '18'
          hstr1 = '20'
          end
    '22': begin
          hstr0 = '21'
          hstr1 = '23'
          end
   endcase
   strput, datestr0, hstr0, 9
   strput, datestr1, hstr1, 9

   cmd = 'ln -s zonal.'+expid+'.'+datestr+'.png zonal.'+expid+'.'+datestr0+'.png'
   spawn, cmd, /sh
   cmd = 'ln -s zonal.'+expid+'.'+datestr+'.png zonal.'+expid+'.'+datestr1+'.png'
   spawn, cmd, /sh

  endfor

end
