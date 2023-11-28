; Deseasonalize based on 2001 - 2014 time series
  dupart = duexttau[252:419]
  nd = n_elements(dupart)
  duseas = fltarr(12)
  for i = 0, 11 do begin
   duseas[i] = total(dupart[i:nd-1:12])/n_elements(dupart[i:nd-1:12])
  endfor

  nd = n_elements(duexttau)
  dudeseasonal = fltarr(nd)
  for i = 0, nd-1 do begin
   dudeseasonal[i] = duexttau[i]-duseas[i mod 12]
   print, i, i mod 12
  endfor

end
