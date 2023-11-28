;read SAGE aerosol extinction and plot teh zonal mean in pressure Vs
;latitude
;reading procedure by Stacey Frith

;months to read
;mo=[  6 ,   8]
;yr=[1991,1991]
mo=[  6 ,   8]
yr=[2000, 2002]

names=['January','February','March','April','May','June','July','August','September','October','November','December']

;vertical grid for interpolation in hPa
hpa=[1000-indgen(18)*50,100-indgen(18)*5,10-indgen(18)*0.5,1-indgen(19)*0.05,0]
;hpa=[1000-indgen(30)*30,100-indgen(30)*3,10-indgen(30)*0.3,1-indgen(31)*0.03,0]
;hpa=[1000-indgen(23)*40,100-indgen(23)*4,10-indgen(23)*0.3,1-indgen(24)*0.04,0]

ext525=mo*0
ext1020=mo*0
;read in SAGE data
ae525vzm=fltarr(n_elements(mo),n_elements(hPa),180)
for i=0,n_elements(mo)-1 do begin
   sage_read_filter_v7,yr[i],mo[i],nobs,nlev,doy,lat,lon,z,p,t,ozone_ppmv,$
                        ozone_ppmv_err,sgtype, ae525, ae1020, ae525err, ae1020err
                                ;the observations are on a 140
                                ;vertical level non uniform grid.  
                                ;doy, lat, lon, sgtype are arrays with
                                ;dimension = number of data per level
                                ;p,t,ozone, ae*** are arrays with dimensions
                                ;(level, number of data per level)
   oo=where(ae525 eq -999,c)
   if c gt 0 then ae525(oo)=!Values.F_NaN
   
                                ;regrid vertically
   ae525v=fltarr(n_elements(hPa),n_elements(lat))
   for ll=0,n_elements(lat)-1 do begin
      for pp=0,n_elements(hpa)-2 do begin
         oo=where(p[*,ll] le hPa[pp] and p[*,ll] gt hPa[pp+1],c)
         if c gt 1 then ae525v[pp,ll]=avg(ae525[oo,ll],0,/nan)
         if c eq 1 then ae525v[pp,ll]=ae525[oo,ll]
      endfor
   endfor
   print, 'max and min ae525v',max(ae525v,/nan),min(ae525v,/nan)
                                ;do zonal means on a 1 degree grid
   for ll=0,178 do begin
      l=-90+ll
      oo=where(lat ge l and lat lt l+1,c)
      if c gt 1 then ae525vzm[i,*,ll]=avg(ae525v[*,oo],1,/nan)
      if c eq 1 then ae525vzm[i,*,ll]=ae525v[*,oo]
   endfor
endfor
print, 'max and min ext 525',max(ae525vzm,/nan),min(ae525vzm,/nan)

;;;PLOT
PSOPEN,/portrait,/letter,xplot=1,yplot=2,CHARSIZE=150,$
       SPACING=1800,SPACE3=400,file='ae525-sage-'+string(yr[0],'(I4)')+string(mo[0],'(I02)')+'-'+string(yr[1],'(I4)')+string(mo[1],'(I02)')+'.ps',yoffset=1000
!p.font=0

xrange=[-70,70]
xminor=[-70,-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60,70]
xvals=[-60,-40,-20,0,20,40,60]
xlabels=['60S','40S','20S','EQ','20N','40N','60N']
yrange=[1000,1]
yvals=[1000,700,500,200,100,70,50,20,10,7,5,2,1]

cvals=['1e-5','2e-5','5e-5','1e-4','2e-4','5e-4','1e-3','2e-3','5e-3','1e-2','2e-2']
CS,SCALE=1,NCOLS=n_elements(cvals)+1
LEVS,MANUAL=cvals,/exact

pos,xpos=1,ypos=2
GSET,xmin=xrange[0],xmax=xrange[1],ymin=yrange[0],ymax=yrange[1],/ylog
latarray=-90+indgen(180)
CON,f=transpose(ae525vzm[0,*,*]),x=latarray,y=hPa $
    ,title=names[mo[0]-1]+string(yr[0],'(I5)'),/nocolbar
AXES,xvals=xvals,yvals=yvals $
     ,xlabels=xlabels,xminor=xminor

pos,xpos=1,ypos=1
GSET,xmin=xrange[0],xmax=xrange[1],ymin=yrange[0],ymax=yrange[1],/ylog
latarray=-90+indgen(180)
CON,f=transpose(ae525vzm[1,*,*]),x=latarray,y=hPa $
    ,title=names[mo[1]-1]+string(yr[1],'(I5)'),/nocolbar
AXES,xvals=xvals,yvals=yvals $
     ,xlabels=xlabels,xminor=xminor

;METCOLBAR,COORDS=[3000,2800,18000,3000],title='SAGE ext. coeff. 525nm [1/km]'

PSCLOSE,/noview



end
