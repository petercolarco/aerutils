  cases = ['dust.land.20060605','dust.ocean.20060605', $
           'smoke.land.20060930','smoke.ocean.20060930', $
           'clean.land.20061113','clean.ocean.20061113', $
           'pollution.land.20060430','pollution.ocean.20060430', $
           'marine.20061223']

  ncases = n_elements(cases)

  for i = 0, ncases-1 do begin

   cdfid = ncdf_open(cases[i]+'.ext.nc')
    id = ncdf_varid(cdfid,'ext')
    ncdf_varget, cdfid, id, ext
    id = ncdf_varid(cdfid,'tau')
    ncdf_varget, cdfid, id, tau
   ncdf_close, cdfid

   cdfid = ncdf_open(cases[i]+'.ext.nc.dust')
    id = ncdf_varid(cdfid,'ext')
    ncdf_varget, cdfid, id, extdu
    id = ncdf_varid(cdfid,'tau')
    ncdf_varget, cdfid, id, taudu
   ncdf_close, cdfid

   cdfid = ncdf_open(cases[i]+'.ext.nc.su')
    id = ncdf_varid(cdfid,'ext')
    ncdf_varget, cdfid, id, extsu
    id = ncdf_varid(cdfid,'tau')
    ncdf_varget, cdfid, id, tausu
   ncdf_close, cdfid

   cdfid = ncdf_open(cases[i]+'.ext.nc.ss')
    id = ncdf_varid(cdfid,'ext')
    ncdf_varget, cdfid, id, extss
    id = ncdf_varid(cdfid,'tau')
    ncdf_varget, cdfid, id, tauss
   ncdf_close, cdfid

   cdfid = ncdf_open(cases[i]+'.ext.nc.oc')
    id = ncdf_varid(cdfid,'ext')
    ncdf_varget, cdfid, id, extoc
    id = ncdf_varid(cdfid,'tau')
    ncdf_varget, cdfid, id, tauoc
   ncdf_close, cdfid

   cdfid = ncdf_open(cases[i]+'.ext.nc.bc')
    id = ncdf_varid(cdfid,'ext')
    ncdf_varget, cdfid, id, extbc
    id = ncdf_varid(cdfid,'tau')
    ncdf_varget, cdfid, id, taubc
   ncdf_close, cdfid

; plot it
  set_plot, 'ps'
  device, file=cases[i]+'.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39

  plot, ext, indgen(72), yrange=[71,0], thick=6, ystyle=1, xrange=[0,1]
  oplot, extdu, indgen(72), color=208, thick=6
  oplot, extss, indgen(72), color=80, thick=6
  oplot, extsu, indgen(72), color=176, thick=6
  oplot, extoc, indgen(72), color=254, thick=6
  oplot, extbc, indgen(72), color=192, thick=6

  xyouts, .6, 5, 'AOD: '+string(total(tau[*,0]), format='(f5.3)')
  xyouts, .6, 10,'DU:  '+string(total(taudu[*,0]), format='(f5.3)'), color=208
  xyouts, .6, 15,'SS:  '+string(total(tauss[*,0]), format='(f5.3)'), color=80
  xyouts, .6, 20,'SU:  '+string(total(tausu[*,0]), format='(f5.3)'), color=176
  xyouts, .6, 25,'OC:  '+string(total(tauoc[*,0]), format='(f5.3)'), color=254
  xyouts, .6, 30,'BC:  '+string(total(taubc[*,0]), format='(f5.3)'), color=192

  device, /close

endfor

end
