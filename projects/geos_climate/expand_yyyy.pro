  pro expand_yyyy, yyyyIn, yyyyOut, ny, ndaysmonOut
  ny = n_elements(yyyyIn)
  ndaysmon = [31,28,31,30,31,30,31,31,30,31,30,31]
  if(ny eq 2) then begin
   if(yyyyIn[0] ne yyyyIn[1]) then begin
    ny = fix(yyyyIn[1])-fix(yyyyIn[0]) + 1
    yyyyOut = strpad(fix(yyyyIn[0])+indgen(ny),1000L)
   endif
  endif
  if(ny eq 1) then begin
   yyyyOut = [yyyyIn[0],yyyyIn[0]]
   ny = 2
  endif
  ndaysmon_ = intarr(13,ny)
  for iy = 0, ny-1 do begin
   ndaysmon_[0:11,iy] = ndaysmon
   if( fix(yyyyout[iy]/4) eq (yyyyOut[iy]/4.)) then ndaysmon_[1,iy] = 29.
   ndaysmon_[12,iy] = total(ndaysmon_[0:11,iy])
  endfor

  ndaysmonOut = ndaysmon_

end
