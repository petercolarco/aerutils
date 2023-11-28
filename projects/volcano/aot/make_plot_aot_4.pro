; Drive the AOT plots
; Do one panel for each latitude band

  g5v = ['NHL','NML','TRO','STR','SML','SHL']
  giv = ['NHh','NHm','TR0','TRa','SHm','SHh']


  for i = 0, 5 do begin

    print, g5v[i]

    plot_aot_4_geos5, g5v[i], giv[i]
    plot_aot_4_giss, g5v[i], giv[i]

  endfor

end
