  restore, 'compute_dndr.sav'

  lats = ['NHL','NML','TRO','STR','SML','SHL']
  mons = ['jan','apr','jul','oct']

  for i = 0, 5 do begin

    set_plot, 'ps'
    device, file='dndr_'+lats[i]+'.ps', /color, /helvetica, font_size=12, $
     xsize=24, ysize=16, xoff=.5, yoff=.5
    !p.font=0
    !p.multi=[0,2,2]

    loadct, 39


    for j = 0, 3 do begin

     k = where((strpos(ddflist,lats[i]) ne -1) and $
               (strpos(ddflist,mons[j]) ne -1))

     plot, r[*,0,k]*1e6, 4./3.*!pi*r[*,0,k]^3.*dndr[*,0,k]*r[*,0,k], /xlog, /ylog, /nodata, $
      xrange=[.0001,10], xticks=5, $
      xtickn=['0.0001','0.001','0.01','0.1','1','10'], $
      xtitle='radius [!Mm!Nm]', ytitle='dV/d(ln r) [m!E3!N m!E-3!N]', $
      title=lats[i]+': '+mons[j], $
      yrange=[1.e-18,1.e-10]

     oplot, r[*,0,k]*1e6, 4./3.*!pi*r[*,0,k]^3.*dndr[*,0,k]*r[*,0,k], thick=6
     oplot, r[*,1,k]*1e6, 4./3.*!pi*r[*,0,k]^3.*dndr[*,1,k]*r[*,1,k], thick=6, color=176
     oplot, r[*,2,k]*1e6, 4./3.*!pi*r[*,0,k]^3.*dndr[*,2,k]*r[*,2,k], thick=6, color=254

    endfor
    device, /close

  endfor

end
