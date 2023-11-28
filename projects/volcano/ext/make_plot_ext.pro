; Drive the AOT plots

  g5v = ['NHL','NML','SML','SHL','TRO','STR']
  giv = ['NHh','NHm','SHm','SHh','TR0','TRa']

  g5s = ['jan','apr','jul','oct']
  gis = ['Win_anl','Spr_anl','Sum_kt','Fal_kt']

  for i = 0, 5 do begin
   for j = 0, 3 do begin

    print, g5v[i], g5s[j]

    plot_ext, g5v[i], giv[i], g5s[j], gis[j]

   endfor
  endfor

end
