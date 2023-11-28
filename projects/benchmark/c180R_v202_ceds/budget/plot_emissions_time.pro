; Plot dust emission time series and mean climatology

  expid = 'c180R_v202_ceds'
;goto, jump
; Get the dust emissions
  ddf = expid+'.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20110000L and nymd lt 20210000L)
  filename = filename[a]
  nymd = nymd[a]
  nymd = nymd[a]
  nt = n_elements(filename)
  emis = fltarr(nt)
  nx = 720
  dx = 0.5
  lon = -180 + findgen(nx)*dx
  ny = 361
  dy = 0.5
  lat = -90 + findgen(ny)*dy
  area, lon, lat, nx, ny, dx, dy, area

; Dust
  get_emission, filename, 'duem', duem, lon=lon, lat=lat, /template, /sum, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  duem = duem*convfac

; Sea Salt
  get_emission, filename, 'ssem', ssem, lon=lon, lat=lat, /template, /sum, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  ssem = ssem*convfac

; Black Carbon
  get_emission, filename, 'bcem0', bcem, lon=lon, lat=lat, /template, /sum, /global
  get_emission, filename, 'bcembb', bcembb, lon=lon, lat=lat, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  bcem   = bcem*convfac
  bcembb = bcembb*convfac

; Organic Carbon
  get_emission, filename, 'ocem0', ocem, lon=lon, lat=lat, /template, /sum, /global
  get_emission, filename, 'oceman', oceman, lon=lon, lat=lat, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  ocem   = ocem*convfac
  oceman = oceman*convfac

; Brown Carbon
  get_emission, filename, 'brcem0', brcem, lon=lon, lat=lat, /template, /sum, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  brcem   = brcem*convfac

; Secondary OA
  get_emission, filename, 'brcpsoa', psoabrc, lon=lon, lat=lat, /global
  get_emission, filename, 'ocpsoa', psoaoc, lon=lon, lat=lat, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  psoabrc   = psoabrc*convfac
  psoaoc    = psoaoc*convfac

; Sulfur Emissions
  get_emission, filename, 'suem002', so2em, lon=lon, lat=lat, /global
  get_emission, filename, 'suem003', so4em, lon=lon, lat=lat, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  so2em   = so2em*convfac
  so4em   = so4em*convfac

; Sulfur Chemistry
  get_emission, filename, 'supso4g', pso4g, lon=lon, lat=lat, /global
  get_emission, filename, ['supso4aq','supso4wt'], pso4aq, lon=lon, lat=lat, /global, /sum
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  pso4g   = pso4g *convfac
  pso4aq  = pso4aq*convfac

; Nitrate Het Production
  get_emission, filename, 'niht', niht, lon=lon, lat=lat, /template, /sum, /global
  get_emission, filename, 'nh3em', nh3em, lon=lon, lat=lat, /global
  get_emission, filename, 'nipno3aq', nipno3aq, lon=lon, lat=lat, /global
  convfac = 86400*30.*total(area)/1.e9  ; convert kg m-2 s-1 to Tg mon-1
  niht   = niht *convfac
  nh3em  = nh3em*convfac
  nipno3aq = nipno3aq*convfac
  save, file='plot_emissions_time.sav', /variables

jump:
  restore, file='plot_emissions_time.sav'


  plot_time, duem, 'duem', nymd, 'Dust'
  plot_time, ssem, 'ssem', nymd, 'Sea Salt'
  plot_time, bcem, 'bcem', nymd, 'Black Carbon', second=bcem-bcembb
  plot_time, ocem, 'ocem', nymd, 'Primary Organic Aerosol', second=oceman
  plot_time, oceman, 'oceman', nymd, 'Anthropogenic POA'
  plot_time, ocem-oceman, 'ocembg', nymd, 'Biogenic SOA'
  plot_time, brcem, 'brcem', nymd, 'Biomass Burning POA'
  plot_time, psoaoc, 'psoa', nymd, 'SOA', second=psoabrc, third=ocem-oceman
  plot_time, so2em, 'sulf', nymd, 'Sulfur', second=so4em
  plot_time, pso4aq, 'sulfchem', nymd, 'Sulfate Production', second=pso4g
  plot_time, niht, 'niht', nymd, 'Nitrate Heterogeneous Production'
  plot_time, nh3em, 'nh3em', nymd, 'Ammonia Emissions'
  plot_time, nipno3aq, 'nipno3aq', nymd, 'Nitrate Aqueous Production'

end
