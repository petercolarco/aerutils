  site = 'GSFC'
;  site = 'La_Laguna'
;  site = 'Capo_Verde'

  vars = ['duexttau','ssexttau','suexttau','bcexttau','ocexttau']
  dateexpand, '20110701', '20110718', '120000', '120000', nymd, nhms

  filetemplate = '/misc/prc03/validation/candidate_fp/Y%y4/M%m2/D%d2/H00/aeronet.inst2d_hwl_x.'+site+'.%y4%m2%d2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, vars, aot_candidate, /sum
  nt_mod = n_elements(aot_candidate)

  filetemplate = '/misc/prc03/validation/fp/Y%y4/M%m2/D%d2/H00/aeronet.inst2d_hwl_x.'+site+'.%y4%m2%d2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, vars, aot_fp, /sum

  read_aeronet_nrt2nc, site, '550', nymd, aot_aeronet, dates
  nt_aeronet = n_elements(dates)

  set_plot, 'ps'
  device, file=site+'.ps', /color, font_size=14, /helvetica, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, findgen(nt_mod)*.125+1, aot_fp, thick=3, /nodata, $
   xtitle='Day of July 2011', ytitle='AOT [550 nm]', title=site
  oplot, findgen(nt_mod)*.125+1, aot_fp, thick=6
  oplot, findgen(nt_mod)*.125+1, aot_candidate, thick=6, color=254
  usersym, [-1,0,1,0,-1], [0,-1,0,1,0], color=75, /fill
  plots, findgen(nt_aeronet)*1./24.+1, aot_aeronet, psym=8

  device, /close

end
