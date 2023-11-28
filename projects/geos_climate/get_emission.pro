  pro get_emission, filename, varn, varval, lat=lat, lon=lon, $
                    sum=sum, template=template, ave=ave, global=global
  print, varn
  nc4readvar, filename, varn, varval, lat=lat, lon=lon, $
              sum=sum, template=template
  area, lon, lat, nx, ny, dx, dy, area
  if(keyword_set(ave)) then varval=mean(varval,dimension=3)
  if(keyword_set(global)) then varval = aave(varval,area,/nan)

  end
