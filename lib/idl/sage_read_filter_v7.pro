pro sage_read_filter_v7,yr,mo,nobs,nlev,doy,lat,lon,z,p,t,ozone_ppmv,$
               ozone_ppmv_err,sgtype, ae525, ae1020, ae525err, ae1020err

nlev=140L

sageDirectory='/misc/smh02/data/SAGE_v7/'
sage_prefix='SAGE_II_INDEX_'
sage_suffix='.7.00'
if (yr lt 1900) then yr=yr+1900
yy=strcompress(string(yr),/remove_all)
mm=strcompress(string(mo, format='(I2.2)'),/remove_all)
sageyymm=strcompress(yy+mm)
sagefname=sagedirectory+sage_prefix+sageyymm+sage_suffix
bad=0
read_sg2data, sagefname, sageIndex, bad=bad
if (bad eq 9999.) then begin
   nobs=0
   goto, over
endif

lat=sageindex.lat
lon=sageindex.lon
z=sageindex.alt_grid(0:139)
doy=sageindex.day_frac
sgtype=sageindex.type_sat
dropped=sageindex.dropped
nobs=n_elements(lat)

specFile= sageDirectory+STRTRIM(sageIndex.SPEC_FILE_NAME,2)
read_sg2data, specFile, sage

p=sage.nmc_pres
t=sage.nmc_temp
ae525=p*0.+9999. & ae1020=p*0.+9999. & ae525err=p*0.+9999. & ae1020err=p*0.+9999.
ae525(0:79,*)=sage.ext525
ae1020(0:79,*)=sage.ext1020
ae525err(0:79,*)=sage.ext525_err/100.
ae1020err(0:79,*)=sage.ext1020_err/100.
q=where(ae525err lt 0.,nq)
if (nq ne 0) then ae525err(q)=0.
q=where(ae1020err lt 0.,nq)
if (nq ne 0) then ae1020err(q)=0.


; ERRORS ARE IN % * 100
; TO GET FRACTIONAL ERRORS USED IN CALCULATION OF THE MIXING RATIO ERROR,
;    TAKE THE ERRORS AND DIVIDE BY 100*100=10000.
sage_o3=sage.o3
sage_nmc_dens=sage.nmc_dens
ozone_ppmv=(sage_o3/sage_nmc_dens)*1.E6
o3_err_vmr=sqrt((sage.o3_err/10000.)^2 + $
	        (sage.nmc_dens_err/10000.)^2)

; o3_err_vmr is the fractional error in the ozone mixing ratio
ozone_ppmv_err=o3_err_vmr*ozone_ppmv

; FILTER DATA

; COMPUTE MAX FRACTIONAL OZONE ERROR FOR FILTER BETWEEN 35 AND 50KM
maxerr=fltarr(nobs)
for i=0, nobs-1 do maxerr(i)=max(o3_err_vmr(69:99,i))

; FILTER PROFILES
good=where(abs(lat) lt 90. and $
           dropped eq 0 and $
	   maxerr lt .1, ngood)
nobs=ngood
lat=reform(lat(good))
lon=reform(lon(good))
doy=reform(doy(good))
sgtype=reform(sgtype(good))
ozone_ppmv=reform(ozone_ppmv(*,good))
ozone_ppmv_err=reform(ozone_ppmv_err(*,good))
o3_err_vmr=reform(o3_err_vmr(*,good))
p=reform(p(*,good))
t=reform(t(*,good))
ae525=reform(ae525(*,good))
ae1020=reform(ae1020(*,good))
ae525err=reform(ae525err(*,good))
ae1020err=reform(ae1020err(*,good))

; FILTER PARTIAL PROFILES
zarr=rebin(reform(z,140,1),140,nobs)

; FILTER FOR 300% OZONE (200% OZONE ERROR BELOW 35KM) OR 300% AEROSOL ERROR BELOW 30KM
wt1=( ae525 eq 9999. or zarr ge 30 or (zarr lt 30 and  ae525 ne 9999. and  ae525err ne 0. and  ae525err lt 299.))
wt2=(ae1020 eq 9999. or zarr ge 30 or (zarr lt 30 and ae1020 ne 9999. and ae1020err ne 0. and ae1020err lt 299.))
wt3=(o3_err_vmr lt 2.99)
wt4=((zarr ge 35) or (zarr lt 35 and o3_err_vmr lt 1.99))
wt=wt1*wt2*wt3*wt4 ;wt=0 is bad
ozone_ppmv=ozone_ppmv*wt+9999.*(1-wt)

; AEROSOL FILTER
for i=0, nobs-1 do begin
   wt=(ae525(*,i) lt 6.e-3 and ae1020(*,i) lt 6.e-3);wt=0 is bad
   q=where(wt eq 0 and z lt 30., nq)
   if (nq ne 0) then ozone_ppmv(0:max(q),i)=9999.

   wt=((ae525(*,i) lt 1.e-3) or (ae525(*,i) gt 1.e-3 and ae525(*,i)/ae1020(*,i) gt 1.4 ));wt=0 is bad
   q=where(wt eq 0 and z lt 30, nq)
   if (nq ne 0) then ozone_ppmv(0:max(q),i)=9999.
endfor

over:
return
END

