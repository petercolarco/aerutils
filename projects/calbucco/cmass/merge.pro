; Merge 3 images side by side using imageMagick
  expid = 'c180R_calbucco'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  for i = 0, nf-1 do begin
   datestr = strmid(filename[i],17,14,/rev)

   cmd = '\convert ducmass*'+expid+'*'+datestr+'.png sucmass.'+expid+'*'+datestr+'.png +append out0.png'
   print, cmd
   spawn, cmd, /sh
   cmd = '\convert zonal*'+expid+'*'+datestr+'.png sucmass_diff.'+expid+'*'+datestr+'.png +append out1.png'
   print, cmd
   spawn, cmd, /sh
   cmd = '\convert out0.png out1.png -append merge.'+datestr+'.png'
   print, cmd
   spawn, cmd, /sh

  endfor

end
