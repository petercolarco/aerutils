; Drive the AOT plots

  g5v = ['NHL','NML','TRO','STR','SML','SHL']
  giv = ['NHh','NHm','TR0','TRa','SHm','SHh']

  g5s = ['jan','apr','jul','oct']
  gis = ['Win_anl','Spr_anl','Sum_kt','Fal_kt']

  for i = 0, 5 do begin
   for j = 0, 3 do begin

    print, g5v[i], g5s[j]

    plot_aot, g5v[i], giv[i], g5s[j], gis[j]

   endfor
  endfor

end
