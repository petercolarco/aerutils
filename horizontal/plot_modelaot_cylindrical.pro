; Colarco, Oct. 2010
; Plot AOT from model hwl files

  date = '2009070100'
  for i = 0, 247 do begin

  varwant = ['duexttau','ssexttau','suexttau','bcexttau','ocexttau']
  nc4readvar, 'model.ctl', date, varwant, varval, /sum, $
              lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[2] - lon[1]
  dy = lat[2] - lat[1]
  plot_png, alog10(varval), lon, lat, image='GEOS5_YOTC_'+date, $
   colortable=0, levelarray=findgen(100)*.024-1.7, colorarray=findgen(100)*2.5
  date = incstrdate(date,3)

  endfor

end
