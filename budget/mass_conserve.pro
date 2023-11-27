; Colarco, February 2010
; Read some instantaneous files and tavg budget files and construct a comparison

  delta = fltarr(11,2)
  PminusL = fltarr(11,2)
  ndays = [31,29,31,30,31,30,31,31,30,31,30]

  modeldir = '/misc/prc10/GEOS5.0/'
  expdir   = 'fortest_02'

  openw, lun, 'inst.ddf', /get_lun
  printf, lun, 'dset '+modeldir+expdir+'/inst3d_aer_v/Y%y4/M%m2/'+expdir+'.inst3d_aer_v.%y4%m2%d2_0000z.nc4'
  printf, lun, 'options template'
  printf, lun, 'tdef time 13 linear 0z1jan2000 1mo'
  free_lun, lun

  openw, lun, 'tavg.ddf', /get_lun
  printf, lun, 'dset '+modeldir+expdir+'/tavg2d_aer_x/Y%y4/M%m2/'+expdir+'.tavg2d_aer_x.monthly.%y4%m2.nc4'
  printf, lun, 'options template'
  printf, lun, 'tdef time 12 linear 0z1jan2000 1mo'
  free_lun, lun

  for it = 0, 10 do begin

  it_ = strcompress(string(it+1),/rem)
  itp1_ = strcompress(string(it+2),/rem)

  ga_getvar, 'inst.ddf', 'bc', du0, wanttime=[it_], lon=lon, lat=lat, lev=lev, /template, /sum
  ga_getvar, 'inst.ddf', 'delp' , dp0, wanttime=[it_], lon=lon, lat=lat, lev=lev
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  du0 = total(du0*dp0/9.80616,3)
  du0_load = total(du0*area)/1.e9

  ga_getvar, 'inst.ddf', 'bc', du1, wanttime=[itp1_], lon=lon, lat=lat, lev=lev, /template, /sum
  ga_getvar, 'inst.ddf', 'delp' , dp1, wanttime=[itp1_], lon=lon, lat=lat, lev=lev
  du1 = total(du1*dp1/9.80616,3)
  du1_load = total(du1*area)/1.e9

  fileinp = 'tavg.ddf'
  ga_getvar, fileinp, ['bcem001','bcem002'], bcem, wanttime=[it_], /template, /sum, /noprint
  ga_getvar, fileinp, ['bcdp001','bcdp002'], bcdp, wanttime=[it_], /template, /sum, /noprint
  ga_getvar, fileinp, 'bcwt002', bcwt, wanttime=[it_], /template, /sum, /noprint
  ga_getvar, fileinp, 'bcsv', bcsv, wanttime=[it_], /noprint

  delta[it,0] = du1_load-du0_load
  PminusL[it,0] = total( (bcem-bcdp-bcwt-bcsv)*area)/1.e9 * ndays[it] * 86400.

  print, 'du1 [Tg]:   ', du1_load
  print, 'du0 [Tg]:   ', du0_load
  print, 'delta [Tg]: ', delta[it,0]
  print, '%:          ', (delta[it,0])/du0_load*100.
  print, 'P-L [Tg]:   ', PminusL[it,0]
  print, '(P-L)/delta:', PminusL[it,0]/delta[it,0]

  endfor




  modeldir = '/misc/prc10/GEOS5.0/'
  expdir   = 'b530_eos_02'

  openw, lun, 'inst.ddf', /get_lun
  printf, lun, 'dset '+modeldir+expdir+'/inst3d_aer_v/Y%y4/M%m2/'+expdir+'.inst3d_aer_v.%y4%m2%d2_0000z.nc4'
  printf, lun, 'options template'
  printf, lun, 'tdef time 13 linear 0z1jan2000 1mo'
  free_lun, lun

  openw, lun, 'tavg.ddf', /get_lun
  printf, lun, 'dset '+modeldir+expdir+'/tavg2d_aer_x/Y%y4/M%m2/'+expdir+'.tavg2d_aer_x.monthly.%y4%m2.nc4'
  printf, lun, 'options template'
  printf, lun, 'tdef time 12 linear 0z1jan2000 1mo'
  free_lun, lun

  for it = 0, 10 do begin

  it_ = strcompress(string(it+1),/rem)
  itp1_ = strcompress(string(it+2),/rem)

  ga_getvar, 'inst.ddf', 'bc', du0, wanttime=[it_], lon=lon, lat=lat, lev=lev, /template, /sum
  ga_getvar, 'inst.ddf', 'delp' , dp0, wanttime=[it_], lon=lon, lat=lat, lev=lev
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  du0 = total(du0*dp0/9.80616,3)
  du0_load = total(du0*area)/1.e9

  ga_getvar, 'inst.ddf', 'bc', du1, wanttime=[itp1_], lon=lon, lat=lat, lev=lev, /template, /sum
  ga_getvar, 'inst.ddf', 'delp' , dp1, wanttime=[itp1_], lon=lon, lat=lat, lev=lev
  du1 = total(du1*dp1/9.80616,3)
  du1_load = total(du1*area)/1.e9

  fileinp = 'tavg.ddf'
  ga_getvar, fileinp, ['bcem001','bcem002'], bcem, wanttime=[it_], /template, /sum, /noprint
  ga_getvar, fileinp, ['bcdp001','bcdp002'], bcdp, wanttime=[it_], /template, /sum, /noprint
  ga_getvar, fileinp, 'bcwt002', bcwt, wanttime=[it_], /template, /sum, /noprint
  ga_getvar, fileinp, 'bcsv', bcsv, wanttime=[it_], /noprint

  delta[it,1] = du1_load-du0_load
  PminusL[it,1] = total( (bcem-bcdp-bcwt-bcsv)*area)/1.e9 * ndays[it] * 86400.

  print, 'du1 [Tg]:   ', du1_load
  print, 'du0 [Tg]:   ', du0_load
  print, 'delta [Tg]: ', delta[it,1]
  print, '%:          ', (delta[it,1])/du0_load*100.
  print, 'P-L [Tg]:   ', PminusL[it,1]
  print, '(P-L)/delta:', PminusL[it,1]/delta[it,1]

  endfor


end
