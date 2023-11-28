  expid = 'c90Fc_H54p2v8_pin'
  filetemplate = expid+'.inst2d_hwl_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd gt '19910614')
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)

  for i = 0, n_elements(nymd)-1 do begin
   str = string(nymd[i],format='(i8)')+'_'+$
         strmid(string(nhms[i],format='(a4)'),0,4)+'z'
   plot_aot, filename[i], str
  endfor

end
