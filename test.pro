  datewant = ['20070101','20081231']
  dateexpand, datewant[0], datewant[1], '120000','120000', nymd, nhms, /monthly
  yyyy = strmid(nymd,0,4)
  mm   = strmid(nymd,4,2)
  nt = n_elements(nymd)
  nymd = yyyy+mm
  wanttime = [min(nymd),max(nymd)]
  var = ['ssexttau', 'duexttau', 'suexttau', 'bcexttau', 'ocexttau']
  read_modis, aot, lon, lat, yyyy, mm, satid='MOD04', res='d', /model, $
              ctlmodelocean='dR_Fortuna-2-4-b4.MOD04_l3a.ocn.nnr.ctl', $
              ctlmodelland='dR_Fortuna-2-4-b4.MOD04_l3a.lnd.nnr.ctl'
  contour, aot[*,*,0,1], lev=findgen(10)*.01, /cell
end
