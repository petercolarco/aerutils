; Grid the native OMI L2 files to daily files
  yyyy = '2016'

  expid = ['gsfun', 'low', 'nobc', 'nobrc', 'nodu', 'nosu', 'asoc']
  expid = ['t6p0_phil_bb2', 't6p0_phil_bb']
  expid = ['c360R_era5_v10p22p2_aura_baseline_gaas']

  for iexp = 0, n_elements(expid)-1 do begin

;  filed = '/misc/prc18/colarco/c180R_v10p21p1_aura_'+expid[iexp]+'/OMAERUV/'
  filed = '/misc/prc18/colarco/'+expid[iexp]+'/OMAERUV/'
print, filed
  file  = file_search(filed,'*'+yyyy+'m09*he5')

; Find indices of files with uniq dates
  a = strpos(file[0],yyyy+'m')
  fileday = strmid(file,0,a+9)
  unq = uniq(fileday)
  nd = n_elements(uniq(fileday))

  mon = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

  for id = 0, nd-1 do begin
   if(id eq 0) then sd = 0 else sd = unq[id-1]+1
   ed = unq[id]
   for ifile = sd, ed do begin
print, id, ifile
;  Get the information write a grads template
   x = strpos(file[ifile],yyyy+'m')+5
   mm = strmid(file[ifile],x,2)
   dd = strmid(file[ifile],x+2,2)
   fileout = strmid(file[ifile],0,x+4)+'.he5'

   tdef = 'tdef time 1 linear 12z'+dd+mon[fix(mm)-1]+yyyy+' 24hr'

   if(ifile eq sd) then begin
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
                    rad354, rad388, maod500=maod500, mssa500=mssa500, $
                    maod388=maod388, mssa388=mssa388, maod354=maod354, mssa354=mssa354, $
                    aod388=aod388, ssa388=ssa388, aod354=aod354, ssa354=ssa354

    nxy = n_elements(lon)
    lon = reform(lon,nxy)
    lat = reform(lat,nxy)
    ler388 = reform(ler388,nxy)
    rad354 = reform(rad354,nxy)
    rad388 = reform(rad388,nxy)
    aod = reform(aod,nxy)
    ssa = reform(ssa,nxy)
    residue = reform(residue,nxy)
    ai = reform(ai,nxy)
    prs = reform(prs,nxy)
    maod500 = reform(maod500,nxy)
    mssa500 = reform(mssa500,nxy)
    maod388 = reform(maod388,nxy)
    mssa388 = reform(mssa388,nxy)
    maod354 = reform(maod354,nxy)
    mssa354 = reform(mssa354,nxy)
    aod388 = reform(aod388,nxy)
    ssa388 = reform(ssa388,nxy)
    aod354 = reform(aod354,nxy)
    ssa354 = reform(ssa354,nxy)

   endif else begin
    maod500_ = 1.
    mssa500_ = 1.
    maod388_ = 1.
    mssa388_ = 1.
    maod354_ = 1.
    mssa354_ = 1.
    aod388_ = 1.
    ssa388_ = 1.
    aod354_ = 1.
    ssa354_ = 1.
    read_retrieval, file(ifile), lon_, lat_, $
                    ler388_, aod_, ssa_, $
                    residue_, ai_, prs_, $
                    rad354_, rad388_, maod500=maod500_, mssa500=mssa500_, $
                    maod388=maod388_, mssa388=mssa388_, maod354=maod354_, mssa354=mssa354_, $
                    aod388=aod388_, ssa388=ssa388_, aod354=aod354_, ssa354=ssa354_
    nxy_ = n_elements(lon_)
    lon_ = reform(lon_,nxy_)
    lat_ = reform(lat_,nxy_)
    ler388_ = reform(ler388_,nxy_)
    rad354_ = reform(rad354_,nxy_)
    rad388_ = reform(rad388_,nxy_)
    aod_ = reform(aod_,nxy_)
    ssa_ = reform(ssa_,nxy_)
    prs_ = reform(prs_,nxy_)
    residue_ = reform(residue_,nxy_)
    maod500_ = reform(maod500_,nxy_)
    mssa500_ = reform(mssa500_,nxy_)
    maod388_ = reform(maod388_,nxy_)
    mssa388_ = reform(mssa388_,nxy_)
    maod354_ = reform(maod354_,nxy_)
    mssa354_ = reform(mssa354_,nxy_)
    aod388_ = reform(aod388_,nxy_)
    ssa388_ = reform(ssa388_,nxy_)
    aod354_ = reform(aod354_,nxy_)
    ssa354_ = reform(ssa354_,nxy_)
    ai_ = reform(ai_,nxy_)
    lon = [lon,lon_]
    lat = [lat,lat_]
    ler388 = [ler388,ler388_]
    rad354 = [rad354,rad354_]
    rad388 = [rad388,rad388_]
    aod = [aod,aod_]
    ssa = [ssa,ssa_]
    prs = [prs,prs_]
    maod500 = [maod500,maod500_]
    mssa500 = [mssa500,mssa500_]
    maod354 = [maod354,maod354_]
    mssa354 = [mssa354,mssa354_]
    maod388 = [maod388,maod388_]
    mssa388 = [mssa388,mssa388_]
    aod354 = [aod354,aod354_]
    ssa354 = [ssa354,ssa354_]
    aod388 = [aod388,aod388_]
    ssa388 = [ssa388,ssa388_]
    residue = [residue,residue_]
    ai = [ai,ai_]
   endelse

   endfor

   grid_retrieval, fileout, tdef, lon, lat, $
                   ler388, aod, ssa, $
                   residue, ai, prs, $
                   rad354, rad388, $
                   resolution='e', maod500=maod500, mssa500=mssa500, $
                   maod388=maod388, mssa388=mssa388, maod354=maod354, mssa354=mssa354, $
                   aod388=aod388, ssa388=ssa388, aod354=aod354, ssa354=ssa354


   endfor

  endfor

  end
