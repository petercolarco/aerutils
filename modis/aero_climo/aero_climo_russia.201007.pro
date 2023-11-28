;** define input params
    lat0 = 40.0	           ;** center latitude of Mercator grid
    lon0 = 80.		   ;** center longitude
    months = indgen(12)+1  ;** months to analyze
    months = [7]
    dirpl='./'             ;** directory of plots
    years = 'clim'

;** read aerosol data
if n_elements(aodo) le 10 then begin
  read_aerosol,months[0],x,y,lona,lata,err;,yyyy=years
  ss = size(x)
  aodo = fltarr(ss(1),ss(2),n_elements(months))
  aodl = aodo
  aodb = aodo
  for imon=0,n_elements(months)-1 do begin
    month=months(imon)
    read_aerosol,month,x,y,z,lona,lata,err;,yyyy=years
    aodo(0,0,imon)=x
    aodl(0,0,imon)=y
    aodb(0,0,imon)=z
  endfor
endif

;** plot data
for imon=0,n_elements(months)-1 do begin	;** month loop
 
    month=months(imon)
    datl0 = 'MODIS Aqua AOD (550nm) '+ strtrim( monstr(month) ,2)+ ' '+strtrim(min(long(years)),2)+'-' $
	    +strtrim(max(long(years)),2)
    fn =  dirpl+'AOD_' + strmid(strlowcase(strtrim( monstr(month) ,2)),0,3) +years+'_russia.ps'

    levs = findgen(101)/50.-0.2

    datb = aodb(*,*,imon)    
    dato = aodo(*,*,imon)    
    datl = aodl(*,*,imon)    
    a = where(finite(datb) eq 1)
    datl[a] = datb[a]
    dat = [[[dato]],[[datl]]]
    dat = avg(dat,2,/nan)
;    qq = where(dat ge 1.0)
;    if qq(0) ne -1 then dat(qq)=1.0
    qq = where(dat lt 0.0)
    if qq(0) ne -1 then dat(qq)=0.0
    levelarray = (findgen(103)-2)/100
    colorarray = findgen(103)*2.4

    kml_make, dat, lona, lata, ['2010-07-15 12 Z'], 'russian_fires_julclim', $
              levelarray=levelarray, colorarray=colorarray


endfor

end
