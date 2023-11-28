; Colarco, Sept. 2006
; Plot AOT from model diag files

  scalefac = 0.2

  dates = '201004'+['17']

  for idates = 0, n_elements(dates)-1 do begin

  dir = 'output/plots'
;  wantlat = ['10','85']
;  wantlon = ['-180','-100']
  wantlat = ['45','70']
  wantlon = ['-30','30']
  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'


  urlo = '/misc/prc10/GEOS5.0/volcano_ash_e/volcano_ash_e.tavg2d_carma_x.'+dates[idates]+'_1030z.nc4'
  varwant = ['ashexttau']
  title   = 'GEOS-5 Ash AOT [550 nm] valid '+dates[idates]
  ga_getvar, urlo, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlon=wantlon, wantlat=wantlat, /noprint
  hplot, varout*scalefac, lon, lat, title=title, dir=dir, image='GEOS.volcano_ash_e.'+dates[idates], $
         levelarray=levelarray, formatstr='(f4.2)', /countries

  endfor

end
