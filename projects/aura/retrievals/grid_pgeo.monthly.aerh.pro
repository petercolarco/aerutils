  filed = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'
  file  = file_search(filed,'2007m09*Outputs.nc4')

; Find indices of files with uniq dates
  a = strpos(file[0],'2007m')
  fileday = strmid(file,0,a+7)
  unq = uniq(fileday)
  nd = n_elements(uniq(fileday))

  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for id = 0, nd-1 do begin
   if(id eq 0) then sd = 0 else sd = unq[id-1]+1
   ed = unq[id]
   for ifile = sd, ed do begin

      
;  Get the information write a grads template
   x = strpos(file[ifile],'2007m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   fileout = strmid(file[ifile],0,x+2)+'.aerh.monthly.nc4'

   tdef = 'tdef time 1 linear 12z15'+mon[fix(mm)-1]+'2007 24hr'

   if(ifile eq sd) then begin
    print, file[ifile]
    read_retrieval, file[ifile], lon, lat, $
                    ler388, ref388, aod, ssa, $
                    aerh, aert, residue, ai
    nxy = n_elements(lon)
    lon = reform(lon,nxy)
    lat = reform(lat,nxy)
    ler388 = reform(ler388,nxy)
    ref388 = reform(ref388,nxy)
    aod = reform(aod,nxy)
    ssa = reform(ssa,nxy)
    aert = reform(aert,nxy)
    aerh = reform(aerh,nxy)
    residue = reform(residue,nxy)
    ai = reform(ai,nxy)

   endif else begin
    print, file[ifile]
    read_retrieval, file[ifile], lon_, lat_, $
                    ler388_, ref388_, aod_, ssa_, $
                    aerh_, aert_, residue_, ai_
    nxy_ = n_elements(lon_)
    lon_ = reform(lon_,nxy_)
    lat_ = reform(lat_,nxy_)
    ler388_ = reform(ler388_,nxy_)
    ref388_ = reform(ref388_,nxy_)
    aod_ = reform(aod_,nxy_)
    ssa_ = reform(ssa_,nxy_)
    aert_ = reform(aert_,nxy_)
    aerh_ = reform(aerh_,nxy_)
    residue_ = reform(residue_,nxy_)
    ai_ = reform(ai_,nxy_)
    lon = [lon,lon_]
    lat = [lat,lat_]
    ler388 = [ler388,ler388_]
    ref388 = [ref388,ref388_]
    aod = [aod,aod_]
    ssa = [ssa,ssa_]
    aerh = [aerh,aerh_]
    aert = [aert,aert_]
    residue = [residue,residue_]
    ai = [ai,ai_]
   endelse

   endfor

   grid_retrieval, fileout, tdef, lon, lat, $
                   ler388, ref388, aod, ssa, $
                   aerh, aert, residue, ai, $
                   resolution=resolution, /aerht



   endfor

  end
