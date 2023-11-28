; Colarco, April 2011
; Read in the daily files and return daily averages (or sums for num
; and aotpdf)

  pro read_sample, filename, nbin, $
                   lon, lat, aot, aotpdf, num, std, minval, maxval

nbin = 51
  nc4readvar, filename, 'aot', aot, lon=lon, lat=lat
  a = where(aot ge 1.e15)
  if(a[0] ne -1) then aot[a] = !values.f_nan
  saot = size(aot)
  ave = 0
  if(saot[0] eq 3) then ave = 1
  if(ave) then aot = mean(aot,dimension=3,/nan)

  nc4readvar, filename, 'num', num
  a = where(num ge 1.e15 or num lt 1.)
  if(a[0] ne -1) then num[a] = !values.f_nan
  if(ave) then num = total(num,3,/nan)

  nc4readvar, filename, 'stddev', std
  a = where(std ge 1.e15)
  if(a[0] ne -1) then std[a] = !values.f_nan
  if(ave) then std = mean(std,dimension=3,/nan)

  nc4readvar, filename, 'aotmin', minval
  a = where(minval ge 1.e15)
  if(a[0] ne -1) then minval[a] = !values.f_nan
  if(ave) then minval = mean(minval,dimension=3,/nan)

  nc4readvar, filename, 'aotmax', maxval
  a = where(maxval ge 1.e15)
  if(a[0] ne -1) then maxval[a] = !values.f_nan
  if(ave) then maxval = mean(maxval,dimension=3,/nan)


  sizearr = size(num)
  nx = sizearr[1]
  ny = sizearr[2]
  aotpdf = make_array(nx,ny,nbin)
  for ibin = 1, nbin do begin
   varname = 'aotpdf'+strpad(ibin,10)
   nc4readvar, filename, varname, inp
   a = where(inp ge 1.e15)
   if(a[0] ne -1) then inp[a] = !values.f_nan
   if(ave) then inp = total(inp,3,/nan)
   aotpdf[*,*,ibin-1] = inp
  endfor


end
