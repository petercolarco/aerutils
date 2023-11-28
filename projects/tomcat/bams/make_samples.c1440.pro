  reg = ['beij']
  sat = ['iss1','iss2','iss3','iss4','issall']
  swt = ['450km','nadir']

  for isat = 0, 4 do begin
   for iswt = 0, 0 do begin
    for ireg = 0, 0 do begin

     filetag = reg[ireg]
     orbit   = sat[isat]+'.c1440_NR_0.5000.'+swt[iswt]

     get_sample_pblh, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                 fullhrs, fullhrmn, fullhrmx, /tcld, /taod, /force, /day
     save, /variables, file=orbit+'.day.'+filetag+'.tcld.taod.hist.sav'

    endfor
   endfor
  endfor
stop
  for isat = 0, 4 do begin
   for iswt = 0, 1 do begin
    for ireg = 0, 0 do begin

     filetag = reg[ireg]
     orbit   = sat[isat]+'.c1440_NR_0.5000.'+swt[iswt]

     get_sample_pblh, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                 fullhrs, fullhrmn, fullhrmx, /tcld, /taod, /force
     save, /variables, file=orbit+'.'+filetag+'.tcld.taod.hist.sav'

    endfor
   endfor
  endfor

jump:
  orbit = 'full.c1440_NR_0.5000'
  for ireg = 0, 0 do begin
   filetag = reg[ireg]
    get_sample_pblh, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                fullhrs, fullhrmn, fullhrmx, /force
    save, /variables, file=orbit+'.'+filetag+'.hist.sav'
    get_sample_pblh, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                fullhrs, fullhrmn, fullhrmx, /taod, /tcld, /force
    save, /variables, file=orbit+'.'+filetag+'.tcld.taod.hist.sav'
  endfor

end
