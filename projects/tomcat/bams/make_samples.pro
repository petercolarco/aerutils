  reg = ['natl','euro','asia','sasi']
  sat = ['tomcat1','tomcat2','tomcat3','tomcat4','tomcatall']
  swt = ['450km','nadir']
goto, jump
  for isat = 4, 4 do begin
   for iswt = 0, 1 do begin
    for ireg = 0, 3 do begin

     filetag = reg[ireg]
     orbit   = sat[isat]+'.'+swt[iswt]

     get_sample, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                 fullhrs, fullhrmn, fullhrmx, /tcld, /taod
     save, /variables, file=orbit+'.'+filetag+'.tcld.taod.hist.sav'

    endfor
   endfor
  endfor
jump:
  orbit = 'full'
  for ireg = 0, 3 do begin
   filetag = reg[ireg]
    get_sample, orbit, filetag, full, fullhr, fullhrn, fullhrhst, $
                fullhrs, fullhrmn, fullhrmx, /force
    save, /variables, file=orbit+'.'+filetag+'.hist.sav'
  endfor

end
