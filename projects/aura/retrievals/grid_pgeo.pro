; Colarco, March 2017
; Modified to screen by surface pressure as written into PGEO files

  filed = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'
  file  = file_search(filed,'2007m0*Outputs.nc4')
; Disregard files in the "hold" sub-directory
  file = file[where(strpos(file,'hold') eq -1)]

  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for ifile = 0, n_elements(file)-1 do begin

;  Get the information write a grads template
   x = strpos(file[ifile],'2007m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   hh = strmid(file[ifile],x+5,2)
   nn = strmid(file[ifile],x+7,2)
   tdef = 'tdef time 1 linear '+hh+':'+nn+'z'+dd+mon[fix(mm)-1]+'2007 1hr'

   read_retrieval, file(ifile), lon, lat, $
                   ler388, ref388, aod, ssa, $
                   aerh, aert, residue, ai, prs

;  Discard points where prs > 1013.25
   a = where(prs gt 1013.25)
   if(a[0] ne -1) then begin
    minv = min(ai)
    ler388[a] = minv
    ref388[a] = minv
    aod[a]    = minv
    ssa[a]    = minv
    aerh[a]   = minv
    aert[a]   = minv
    residue[a]= minv
    ai[a]     = minv
    prs[a]    = minv
   endif

   grid_retrieval, file(ifile), tdef, lon, lat, $
                   ler388, ref388, aod, ssa, $
                   aerh, aert, residue, ai, prs, $
                   resolution=resolution



   endfor

  end
