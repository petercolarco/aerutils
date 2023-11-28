; Drive the AOT plots

  g5v = ['NHL','NML','TRO','STR','SML','SHL']

  g5s = ['jan','apr','jul','oct']

  for i = 0, 5 do begin
   for j = 0, 3 do begin

    print, g5v[i], g5s[j]

    plot_horz_wetdep, g5v[i], g5s[j]
    plot_horz_drydep, g5v[i], g5s[j]

   endfor
  endfor

end
