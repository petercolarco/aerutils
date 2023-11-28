  expid = 'bR_F25b25q-lai.inst2d_hwl.aeronet'
  years = '2007'
  read_mon_mean, expid, years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 aotabsaeronet, aotabsmodel, $
                 aotabsaeronetstd, aotabsmodelstd, $
                 elevation=elevation
  amod_b25_lai = aotmodel

  expid = 'bR_F25b25q-newdust.inst2d_hwl.aeronet'
  years = '2007'
  read_mon_mean, expid, years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 aotabsaeronet, aotabsmodel, $
                 aotabsaeronetstd, aotabsmodelstd, $
                 elevation=elevation
  amod_b25_newdust = aotmodel

  expid = 'bR_F25b23q-newdust.inst2d_hwl.aeronet'
  years = '2007'
  read_mon_mean, expid, years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 aotabsaeronet, aotabsmodel, $
                 aotabsaeronetstd, aotabsmodelstd, $
                 elevation=elevation
  amod_b23_newdust = aotmodel

  iloc = where(location eq 'Capo_Verde')
  jloc = where(location eq 'La_Parguera')

  expid = 'bR_F25b23q.inst2d_hwl.aeronet'
  years = '2007'
  read_mon_mean, expid, years, location, latitude, longitude, date, $
                 aotaeronet, angaeronet, aotmodel, angmodel, $
                 aotaeronetstd, angaeronetstd, aotmodelstd, angmodelstd, $
                 aotabsaeronet, aotabsmodel, $
                 aotabsaeronetstd, aotabsmodelstd, $
                 elevation=elevation
  amod_b23 = aotmodel
  iloc0 = where(location eq 'Capo_Verde')
  jloc0 = where(location eq 'La_Parguera')


  loadct, 39
  set_plot, 'ps'
  device, file='capo_verde.ps', /color, /helvetica, font_size=12
  !p.font=0
  plot, findgen(12)+1, amod_b25_lai[*,iloc], /nodata, thick=3, $
        xrange=[0,13], xstyle=9, xticks=13, $
        yrange=[0,1.2], ystyle=9, $
        xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  oplot, findgen(12)+1, amod_b25_lai[*,iloc], thick=6, color=176
  oplot, findgen(12)+1, amod_b25_newdust[*,iloc], thick=6, color=254
  oplot, findgen(12)+1, amod_b23_newdust[*,iloc], thick=6, color=208
  oplot, findgen(12)+1, amod_b23[*,iloc0], thick=6
  oplot, findgen(12)+1, aotaeronet[*,iloc0], thick=6, lin=2
  device, /close


  device, file='la_parguera.ps', /color, /helvetica, font_size=12
  !p.font=0
  plot, findgen(12)+1, amod_b25_lai[*,iloc], /nodata, thick=3, $
        xrange=[0,13], xstyle=9, xticks=13, $
        yrange=[0,.4], ystyle=9, $
        xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']
  oplot, findgen(12)+1, amod_b25_lai[*,jloc], thick=6, color=176
  oplot, findgen(12)+1, amod_b25_newdust[*,jloc], thick=6, color=254
  oplot, findgen(12)+1, amod_b23_newdust[*,jloc], thick=6, color=208
  oplot, findgen(12)+1, amod_b23[*,jloc0], thick=6
  oplot, findgen(12)+1, aotaeronet[*,jloc0], thick=6, lin=2
  device, /close

end
