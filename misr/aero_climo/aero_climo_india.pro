;** define input params
    lat0 = 20.0	           ;** center latitude of Mercator grid
    lon0 = 80.		   ;** center longitude
    months = indgen(12)+1  ;** months to analyze
    dirpl='./'             ;** directory of plots
    years = findgen(1)+2009

;** read met data
if n_elements(u_avg) le 10 then begin
    ;** Set up data grids
	u_avg   = fltarr(144,73,17,n_elements(months))
	v_avg   = u_avg
	t_avg   = u_avg
   
    ;** Use 3 stations Decimomannu Air Base, Sardinia, Italy
	stlat=[ 39.354167, 39.354167]
	stlon=[  8.972222,  8.972222]

	nsta=n_elements(stlat)
	;** calculate lat/lons of range rings
	npts = 90
	slat = fltarr(npts+1,nsta)
	slon = fltarr(npts+1,nsta)
        rr = [2195,5267.]
	for i=0,nsta-1 do begin
	  range_ring, stlat(i), stlon(i), rr(i), 90, bearing, latp, lonp
	  slat(*,i) = [latp,latp(0)]
	  slon(*,i) = [lonp,lonp(0)]
	endfor
    
    ;** read data
    for imon=0,n_elements(months)-1 do begin
	month=months(imon)
	grid='GG2%5X2%5'
	dates = strmid( strtrim(years,2) ,2,2) + string(month,'$(i2.2)')+'00'
	dir = '$NMCDAT/'+grid+'/Y'+strmid( strtrim(years,2) ,0,4) + '/M'  $
	     +string(month,'$(i2.2)') + '/'
	for iyr=0,n_elements(years)-1 do begin
	  erru=nmcr3d(dir(iyr),'U___','NMC',dates(iyr),u,badu,ndat, $
	       avespec='H',gridspec='GG2%5X2%5',sequence='E01',spec='REAN2', $
	       dim0_value=lon,dim1_value=lat,dim2_value=p,fname=fname)
	  errv=nmcr3d(dir(iyr),'V___','NMC',dates(iyr),v,badv,ndat, $
	       avespec='H',gridspec='GG2%5X2%5',sequence='E01',spec='REAN2', $
	       dim0_value=lon,dim1_value=lat,dim2_value=p,fname=fname)
	  errt=nmcr3d(dir(iyr),'T___','NMC',dates(iyr),t,badt,ndat, $
	       avespec='H',gridspec='GG2%5X2%5',sequence='E01',spec='REAN2', $
	       dim0_value=lon,dim1_value=lat,dim2_value=p,fname=fname)
	  if iyr eq 0 then begin
	    ua = fltarr(n_elements(lon),n_elements(lat) $
		,n_elements(p),n_elements(years))+badu
	    va = fltarr(n_elements(lon),n_elements(lat) $
		,n_elements(p),n_elements(years))+badv
	    ta = fltarr(n_elements(lon),n_elements(lat) $
		,n_elements(p),n_elements(years))+badt
	  endif
	  if erru(0) eq 0 then ua(0,0,0,iyr)=u
	  if errv(0) eq 0 then va(0,0,0,iyr)=v
	  if errt(0) eq 0 then ta(0,0,0,iyr)=t
	  print,dates(iyr)
	endfor
	i1=ua-ua+1.0
	qq = where(ua eq badu)
	if qq(0) ne -1 then begin & ua(qq)=0.0 & i1(qq)=1.0e-23 & endif
	u_avg(0,0,0,imon)   = avg(ua,3)/avg(i1,3)
	i1=va-va+1.0
	qq = where(va eq badv)
	if qq(0) ne -1 then begin & va(qq)=0.0 & i1(qq)=1.0e-23 & endif
	v_avg(0,0,0,imon)   = avg(va,3)/avg(i1,3)
	i1=ta-ta+1.0
	qq = where(ta eq badt)
	if qq(0) ne -1 then begin & ta(qq)=0.0 & i1(qq)=1.0e-23 & endif
	t_avg(0,0,0,imon)   = avg(ta,3)/avg(i1,3)
    endfor
endif
a = 40000.e3/2./!pi

;** read aerosol data
if n_elements(aodo) le 10 then begin
  read_aerosol,1,x,lona,lata,err
  ss = size(x)
  aodo = fltarr(ss(1),ss(2),n_elements(months))
  for imon=0,n_elements(months)-1 do begin
    month=months(imon)
    read_aerosol,month,x,lona,lata,err
    aodo(0,0,imon)=x
  endfor
endif

;** distance vector
  lon_arr = rebin(lon,n_elements(lon),n_elements(lat))
  lat_arr = transpose( rebin(lat,n_elements(lat),n_elements(lon)) )
  dist = dist_pnt2pnt(lat0,lon0,lat_arr,lon_arr)
  qqdist = where(dist le 3700)
  qqdist = where(lon_arr ge lon0-40 and lon_arr le lon0+40 $
             and lat_arr ge lat0-40 and lat_arr le lat0+40)
  qqdist = where(lon_arr ge lon0-80 and lon_arr le lon0+80 $
             and lat_arr ge lat0-40 and lat_arr le lat0+40)

;** plot data
for ip=2,2 do begin 				;** pressure loop
for imon=0,n_elements(months)-1 do begin	;** month loop
    strf  = stream(u_avg(*,*,ip,imon),v_avg(*,*,ip,imon),lat=lat,lon=lon,bad=badv,velocp=velocp)
    strf  = strf/a
    velocp  = velocp/a
 
    month=months(imon)
    datl0 = 'MISR AOD (550nm) '+ strtrim( monstr(month) ,2)+ ' '+strtrim(min(long(years)),2)+'-' $
	    +strtrim(max(long(years)),2)
    datl1 = strtrim(long(p(ip)),2)+' hPa Streamlines'
    fn =  dirpl+'AOD_' + strmid(strlowcase(strtrim( monstr(month) ,2)),0,3) + '_'  $
		  + strtrim(long(p(ip)),2)+'_india.ps'

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
    map_set,lat0,lon0,/ortho,/noerase,lim=lim,tit=datl0+' '+datl1, charsize=1.5, $
     position=[.05,.1,.95,.9]

    dato = aodo(*,*,imon)    
    dato = [dato,dato(0,*)]
    lonxx = [lona,lona(0)+360]
    dat = dato
;    qq = where(dat ge 1.0)
;    if qq(0) ne -1 then dat(qq)=1.0
    qq = where(dat lt 0.0)
    if qq(0) ne -1 then dat(qq)=0.0
    levelarray = (findgen(103)-2)/100
    colorarray = findgen(103)*2.4
    plotgrid, dat, levelarray, colorarray, lonxx, lata, lonxx[1]-lonxx[0], lata[1]-lata[0], $
              undef=!values.f_nan, /map
    makekey, .1,.05,.8,.03,0,-.025,color=colorarray, label=['0','1'], /noborder, charsize=.75
;    levs = (findgen(103)-2)/100
;    contour,dat,lonxx,lata,/fill,/follow,/over,lev=levs,/cell
;    for i=0,nsta-1 do oplot,slon(*,i),slat(*,i),thick=3
;    symb,12,/fill
;    for i=0,nsta-1 do oplot,[stlon(i),stlon(i)],[stlat(i),stlat(i)],psym=8

    speed = sqrt(u_avg(*,*,ip,imon)^2+v_avg(*,*,ip,imon)^2)
    create_mad_streamlines,lon,lat,u_avg(*,*,ip,imon),v_avg(*,*,ip,imon)  $
       ,xstream,ystream,nstream,sstream=sstream,/sphere,strength=speed,spacing=2.0 $
       ,thick=20.0,threshold=2.0,color=253,acolor=253

    plot_mad_streamlines,xstream,ystream,nstream,thick=20,strength=sstream $
    	,color=253,acolor=253

    map_continents,thick=1  ,color=maxcol
    map_continents,thick=1,/countries ,color=maxcol
    map_grid,lats=-80+findgen(19)*10.,lons=findgen(37)*10.  $
	  ,glinethick=1,glinest=1,color=maxcol
    device,/close
    print,fn(0)

endfor
endfor

end
