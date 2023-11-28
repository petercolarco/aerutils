;** define input params
    lat0 = 40.0	           ;** center latitude of Mercator grid
    lon0 = 80.		   ;** center longitude
    months = indgen(12)+1  ;** months to analyze
    months = [7]
    dirpl='./'             ;** directory of plots
    years = findgen(7)+2003

;** read aerosol data
if n_elements(aodo) le 10 then begin
  read_aerosol,1,x,y,lona,lata,err
  ss = size(x)
  aodo = fltarr(ss(1),ss(2),n_elements(months))
  aodl = aodo
  aodb = aodo
  for imon=0,n_elements(months)-1 do begin
    month=months(imon)
    read_aerosol,month,x,y,z,lona,lata,err
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
    fn =  dirpl+'AOD_' + strmid(strlowcase(strtrim( monstr(month) ,2)),0,3) +'_russia.ps'

    tvpinit,/color,fname=fn(0)
    !p.charsize=1.8
    !p.font=0
    device,/helvetica,/bold
    !p.charsize=1.8
    z=tgquery(x)
    maxcol=x(0)
    dcol=maxcol
    !color=0
    !p.color = 0
    imgin    = maxcol
    latcol   = maxcol
    tgcoltab,'spectrum_sm'

    levs = findgen(101)/50.-0.2

    lim=[lat0-50,lon0-50,lat0+50,lon0+50]
    lim=[lat0-30,lon0-30,lat0+30,lon0+30]
    lim=[lat0-50,lon0-50,lat0+50,lon0+50]
    map_set,lat0,lon0,/ortho,/noerase,lim=lim,tit=datl0, charsize=1.25, $
     position=[.05,.1,.95,.9]

    datb = aodb(*,*,imon)    
    datb = [datb,datb(0,*)]
    dato = aodo(*,*,imon)    
    dato = [dato,dato(0,*)]
    datl = aodl(*,*,imon)    
    datl = [datl,datl(0,*)]
    a = where(finite(datb) eq 1)
    datl[a] = datb[a]
    lonxx = [lona,lona(0)+360]
    dat = [[[dato]],[[datl]]]
    dat = avg(dat,2,/nan)
;    qq = where(dat ge 1.0)
;    if qq(0) ne -1 then dat(qq)=1.0
    qq = where(dat lt 0.0)
    if qq(0) ne -1 then dat(qq)=0.0
    levelarray = (findgen(103)-2)/100
    colorarray = findgen(103)*2.4
;    levs = (findgen(103)-2)/100
;    contour,dat,lonxx,lata,/fill,/follow,/over,lev=levs,/cell
    plotgrid, dat, levelarray, colorarray, lonxx, lata, lonxx[1]-lonxx[0], lata[1]-lata[0], $
              undef=!values.f_nan, /map
    makekey, .1,.05,.8,.03,0,-.025,color=colorarray, label=['0','1'], /noborder, charsize=.75

    map_continents,thick=8  ,color=maxcol
    map_continents,thick=1,/countries ,color=maxcol
    map_grid,lats=-80+findgen(19)*10.,lons=findgen(37)*10.  $
	  ,glinethick=1,glinest=1,color=maxcol
    device,/close
    print,fn(0)

endfor

end
