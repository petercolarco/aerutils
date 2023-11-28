  filed = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_u10m/'
  file  = file_search(filed,'*2007m06*.geos5_pressure.he5')

  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for ifile = 0, n_elements(file)-1 do begin

;  Get the information write a grads template
   x = strpos(file[ifile],'2007m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   hh = strmid(file[ifile],x+5,2)
   nn = strmid(file[ifile],x+7,2)
   tdef = 'tdef time 1 linear '+hh+':'+nn+'z'+dd+mon[fix(mm)-1]+'2007 1hr'
print, file[ifile]
   u10m = 1.
   read_retrieval, file(ifile), lon, lat, $
                   ler388, aod, ssa, $
                   residue, ai, prs, prso, $
                   rad354, rad388, u10m=u10m

   grid_retrieval, file(ifile), tdef, lon, lat, $
                   ler388, aod, ssa, $
                   residue, ai, prs, prso, $
                   rad354, rad388, $
                   u10m = u10m, $
                   resolution=resolution

   endfor

  end
