; Colarco, October 7, 2016
; Read the OMI files HDF5 files and grid per-orbit averages to NC4
  yyyy = '2007'
  filed = '/misc/prc19/colarco/OMAERUV_V1891_DATA/'+yyyy+'/'
filed = '/share/colarco/GAAS/src/Components/scat/dR_MERRA-AA-r2-v1891_Full/'
;filed = '/share/colarco/GAAS/src/Components/scat/test_badpmom/'
  file  = file_search(filed,'*'+yyyy+'m0605*he5')


  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for ifile = 0, n_elements(file)-1 do begin

;  Get the information write a grads template
   x = strpos(file[ifile],yyyy+'m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   hh = strmid(file[ifile],x+5,2)
   nn = strmid(file[ifile],x+7,2)
   tdef = 'tdef time 1 linear '+hh+':'+nn+'z'+dd+mon[fix(mm)-1]+yyyy+' 1hr'

   read_retrieval, file(ifile), lon, lat, $
                   ler388, aod, ssa, $
                   maod, mssa, $
                   residue, ai, prs, $
                   rad354, rad388

   grid_retrieval, file(ifile), tdef, lon, lat, $
                   ler388, aod, ssa, $
                   maod, mssa, $
                   residue, ai, prs, $
                   rad354, rad388, $
                   resolution=resolution

   endfor

  end
