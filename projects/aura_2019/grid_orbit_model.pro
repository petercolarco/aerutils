; Colarco, October 7, 2016
; Read the OMI files HDF5 files and grid per-orbit averages to NC4
  yyyy = '2016'
  filed = '/misc/prc18/colarco/c360R_v10p22p2_aura/OMAERUV/'
  file  = file_search(filed,'*'+yyyy+'m09*he5')

  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for ifile = 0, n_elements(file)-1 do begin

;  Get the information write a grads template
   x = strpos(file[ifile],yyyy+'m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   hh = strmid(file[ifile],x+5,2)
   nn = strmid(file[ifile],x+7,2)
   tdef = 'tdef time 1 linear '+hh+':'+nn+'z'+dd+mon[fix(mm)-1]+yyyy+' 1hr'

   maod500 = 1.
   mssa500 = 1.
   maod388 = 1.
   mssa388 = 1.
   maod354 = 1.
   mssa354 = 1.
   aod388 = 1.
   ssa388 = 1.
   aod354 = 1.
   ssa354 = 1.
   read_retrieval, file(ifile), lon, lat, $
                   ler388, aod, ssa, $
                   residue, ai, prs, $
                   rad354, rad388, $
                   maod500=maod500, mssa500=mssa500, $
                   maod388=maod388, mssa388=mssa388, maod354=maod354, mssa354=mssa354, $
                   aod388=aod388, ssa388=ssa388, aod354=aod354, ssa354=ssa354

   grid_retrieval, file(ifile), tdef, lon, lat, $
                   ler388, aod, ssa, $
                   residue, ai, prs, $
                   rad354, rad388, $
                   resolution='e', $
                   maod500=maod500, mssa500=mssa500, $
                   maod388=maod388, mssa388=mssa388, maod354=maod354, mssa354=mssa354, $
                   aod388=aod388, ssa388=ssa388, aod354=aod354, ssa354=ssa354
   endfor

  end
