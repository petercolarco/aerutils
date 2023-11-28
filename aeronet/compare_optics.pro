
  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/'+ $
             [ 'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2003.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2004.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2005.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2006.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2007.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2008.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2009.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2010.nc4', $
               'dR_MERRA-AA-r2.inst2d_hwl_3hr.aeronet.Capo_Verde.2011.nc4' ]

  nc4readvar, filename, 'TOTEXTTAU', ext, nymd=nymd, lev=lev
  nc4readvar, filename, 'TOTSCATAU', sca, nymd=nymd, lev=lev
  a = where(ext gt 100)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  a = where(sca gt 100)
  if(a[0] ne -1) then sca[a] = !values.f_nan

; Form the monthly mean
  taod_v5 = fltarr(12)
  aaod_v5 = fltarr(12)

  for imon = 0, 11 do begin
   a = where(strmid(nymd,4,2) eq strpad(imon+1,10))
   taod_v5[imon] = mean(ext[a],/nan)
   aaod_v5[imon] = taod_v5[imon]-mean(sca[a],/nan)
  endfor

  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/ext_Nc-v1/'+ $
             [ 'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2003.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2004.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2005.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2006.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2007.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2008.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2009.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2010.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v1.aeronet.Capo_Verde.2011.nc4' ]

  nc4readvar, filename, 'taod', taod, nymd=nymd, lev=lev
  nc4readvar, filename, 'aaod', aaod, nymd=nymd, lev=lev
  a = where(taod gt 100)
  if(a[0] ne -1) then taod[a] = !values.f_nan
  a = where(aaod gt 100)
  if(a[0] ne -1) then aaod[a] = !values.f_nan

; Form the monthly mean
  taod_v1 = fltarr(12)
  aaod_v1 = fltarr(12)

  ilam = 5
  for imon = 0, 11 do begin
   a = where(strmid(nymd,4,2) eq strpad(imon+1,10))
   taod_v1[imon] = mean(taod[ilam,a],/nan)
   aaod_v1[imon] = mean(aaod[ilam,a],/nan)
  endfor


  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/ext_Nc-v11/'+ $
             [ 'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2003.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2004.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2005.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2006.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2007.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2008.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2009.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2010.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2011.nc4' ]

  nc4readvar, filename, 'taod', taod, nymd=nymd, lev=lev
  nc4readvar, filename, 'aaod', aaod, nymd=nymd, lev=lev
  a = where(taod gt 100)
  if(a[0] ne -1) then taod[a] = !values.f_nan
  a = where(aaod gt 100)
  if(a[0] ne -1) then aaod[a] = !values.f_nan

; Form the monthly mean
  taod_v11 = fltarr(12)
  aaod_v11 = fltarr(12)

  ilam = 5
  for imon = 0, 11 do begin
   a = where(strmid(nymd,4,2) eq strpad(imon+1,10))
   taod_v11[imon] = mean(taod[ilam,a],/nan)
   aaod_v11[imon] = mean(aaod[ilam,a],/nan)
  endfor


  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/ext_Nc-v10/'+ $
             [ 'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2003.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2004.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2005.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2006.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2007.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2008.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2009.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2010.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v10.aeronet.Capo_Verde.2011.nc4' ]

  nc4readvar, filename, 'taod', taod, nymd=nymd, lev=lev
  nc4readvar, filename, 'aaod', aaod, nymd=nymd, lev=lev
  a = where(taod gt 100)
  if(a[0] ne -1) then taod[a] = !values.f_nan
  a = where(aaod gt 100)
  if(a[0] ne -1) then aaod[a] = !values.f_nan

; Form the monthly mean
  taod_v10 = fltarr(12)
  aaod_v10 = fltarr(12)

  ilam = 5
  for imon = 0, 11 do begin
   a = where(strmid(nymd,4,2) eq strpad(imon+1,10))
   taod_v10[imon] = mean(taod[ilam,a],/nan)
   aaod_v10[imon] = mean(aaod[ilam,a],/nan)
  endfor

  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/ext_Nc-v11/'+ $
             [ 'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2003.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2004.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2005.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2006.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2007.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2008.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2009.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2010.nc4', $
               'dR_MERRA-AA-r2.ext_Nc-v11.aeronet.Capo_Verde.2011.nc4' ]

  nc4readvar, filename, 'taod', taod, nymd=nymd, lev=lev
  nc4readvar, filename, 'aaod', aaod, nymd=nymd, lev=lev
  a = where(taod gt 100)
  if(a[0] ne -1) then taod[a] = !values.f_nan
  a = where(aaod gt 100)
  if(a[0] ne -1) then aaod[a] = !values.f_nan

; Form the monthly mean
  taod_v11 = fltarr(12)
  aaod_v11 = fltarr(12)

  ilam = 5
  for imon = 0, 11 do begin
   a = where(strmid(nymd,4,2) eq strpad(imon+1,10))
   taod_v11[imon] = mean(taod[ilam,a],/nan)
   aaod_v11[imon] = mean(aaod[ilam,a],/nan)
  endfor

  set_plot, 'ps'
  device, file='taod.ps', /helvetica, font_size=12, /color, $
          xoff=.5, yoff=.5, xsize=20, ysize=10
  !p.font=0
  loadct, 39

  plot, indgen(12), /nodata, $
        xrange=[0,13], yrange=[0,.75], ytitle = 'AOT', xtitle='Month', $
        xticks=13, thick=4, xmin=1, xstyle=9, ystyle=9, $
        xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

  oplot, indgen(12)+1, taod_v5, thick=6, color=84, lin=2
  oplot, indgen(12)+1, taod_v10, thick=6, color=208, lin=2
  oplot, indgen(12)+1, taod_v11, thick=6, color=254, lin=2
  oplot, indgen(12)+1, taod_v1, thick=6, color=254

  device, /close

  set_plot, 'ps'
  device, file='aaod.ps', /helvetica, font_size=12, /color, $
          xoff=.5, yoff=.5, xsize=20, ysize=10
  !p.font=0
  loadct, 39

  plot, indgen(12), /nodata, $
        xrange=[0,13], yrange=[0,.075], ytitle = 'AAOT', xtitle='Month', $
        xticks=13, thick=4, xmin=1, xstyle=9, ystyle=9, $
        xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

  oplot, indgen(12)+1, aaod_v5, thick=6, color=84, lin=2
  oplot, indgen(12)+1, aaod_v10, thick=6, color=208, lin=2
  oplot, indgen(12)+1, aaod_v11, thick=6, color=254, lin=2
  oplot, indgen(12)+1, aaod_v1, thick=6, color=254

  device, /close



end
