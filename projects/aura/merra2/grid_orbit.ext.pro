  filed = '/home/colarco/sandbox/GAAS/src/Components/scat/dR_MERRA-AA-r2-v1621f_Full/'
  filed = '/home/colarco/sandbox/GAAS/src/Components/scat/MERRA2_300-v1731f_Full/v3_5/'
;  filed = '/home/colarco/sandbox/GAAS/src/Components/scat/MERRA2_300-v1731f_Full/v1_5/'
;  filed = '/home/colarco/sandbox/GAAS/src/Components/scat/MERRA2_300-v1731f_Full/v5_5/'
  file  = file_search(filed,'*2007m0*.geos5_pressure.ext.he5')
stop
  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for ifile = 0, n_elements(file)-1 do begin

;  Get the information write a grads template
   x = strpos(file[ifile],'2007m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   hh = strmid(file[ifile],x+5,2)
   nn = strmid(file[ifile],x+7,2)
   tdef = 'tdef time 1 linear '+hh+':'+nn+'z'+dd+mon[fix(mm)-1]+'2007 1hr'

   read_retrieval_ext, file(ifile), lon, lat, $
                   ler388, aod, ssa, $
                   duext, ssext, suext, ocext, bcext, $
                   residue, ai, prs, prso, $
                   rad354, rad388

   grid_retrieval_ext, file(ifile), tdef, lon, lat, $
                   ler388, aod, ssa, $
                   duext, ssext, suext, ocext, bcext, $
                   residue, ai, prs, prso, $
                   rad354, rad388, $
                   resolution=resolution
   endfor

  end
