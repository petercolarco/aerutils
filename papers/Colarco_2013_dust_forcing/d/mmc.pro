; Need to source
;   source /misc/prc10/crandles/aerutils_022513/setup.csh


;;; SCRIPT TO CALCULATE MMC
;DELTA = '!9'+SCROP(BYTE(68))+'!X'
DELTA = 'd'

;; OPEN THE FILES AND READ IN U, V
exppath      = '/misc/prc14/colarco/'
nodust       = 'd_F25b9-base-v1'
opac_spheres = 'dF_F25b9-base-v1'
OBS_spheres  = 'dF_F25b9-base-v1'
noaerosol    = nodust
dust         = OPAC_spheres
coll         = 'geosgcm_prog'
coll2        = 'tavg3d_carma_p';; duconc 10-7 isoline 

f1  = exppath+noaerosol+'/'+coll+'/'+noaerosol+'.'+coll+'.monthly.clim.JJA.nc4'
f2  = exppath+dust+'/'+coll+'/'+dust+'.'+coll+'.monthly.clim.JJA.nc4'
f3  = exppath+dust+'/'+coll2+'/'+dust+'.'+coll2+'.monthly.clim.JJA.nc4'
fid1 = ncdf_open(f1)
fid2 = ncdf_open(f2)
fid3 = ncdf_open(f3)

;; DIMENSIONS
lonid = ncdf_dimid(fid1, 'lon')
latid = ncdf_dimid(fid1, 'lat')
levid = ncdf_dimid(fid1, 'lev')
ncdf_varget, fid1, lonid, lon
ncdf_varget, fid1, latid, lat
ncdf_varget, fid1, levid, lev
lon[72] = 0
nx = n_elements(lon)
ny = n_elements(lat)
nlev = n_elements(lev)

;; U, V
nouid = ncdf_varid(fid1, 'U')
novid = ncdf_varid(fid1, 'V')
duuid = ncdf_varid(fid2, 'U')
duvid = ncdf_varid(fid2, 'V')
covid = ncdf_varid(fid3, 'DUCONC')
ncdf_varget, fid1, nouid, NO_U
ncdf_varget, fid1, novid, NO_V
ncdf_varget, fid2, duuid, DU_U
ncdf_varget, fid2, duvid, DU_V
ncdf_varget, fid3, covid, DU_CONC

a = where(NO_U ge 1e10)
if (a[0] ne -1) then NO_U(a) = !VALUES.F_NAN
a = where(NO_V ge 1e10)
if (a[0] ne -1) then NO_V(a) = !VALUES.F_NAN

a = where(DU_U ge 1e10)
if (a[0] ne -1) then DU_U(a) = !VALUES.F_NAN
a = where(DU_V ge 1e10)
if (a[0] ne -1) then DU_V(a) = !VALUES.F_NAN

a = where(DU_CONC ge 1e10)
if (a[0] ne -1) then DU_CONC(a) = !VALUES.F_NAN

print, max(NO_U,/NAN), max(NO_V,/NAN), max(DU_U,/NAN), max(DU_V,/NAN)

;;; REVERSE EVERYTHING TOP DOWN
NO_U = reverse(NO_U, 3)
NO_V = reverse(NO_V, 3)
DU_U = reverse(DU_U, 3)
DU_V = reverse(DU_V, 3)
DU_CONC = reverse(DU_CONC, 3)
dp = lev(0:nlev-2)-lev(1:nlev-1); hPa
dp = reverse(dp)
lev = reverse(lev)


;; CALCULATE ZONAL MEANS
NO_U_zonal = reform(total(NO_U, 1, /NAN))/total(finite(NO_U),1)
NO_V_zonal = reform(total(NO_V, 1, /NAN))/total(finite(NO_V),1)
DU_U_zonal = reform(total(DU_U, 1, /NAN))/total(finite(DU_U),1)
DU_V_zonal = reform(total(DU_V, 1, /NAN))/total(finite(DU_V),1)
DIFF_U_zonal = reform(total(DU_U-NO_U, 1, /NAN))/total(finite(DU_U-NO_U),1)
DIFF_V_zonal = reform(total(DU_V-NO_V, 1, /NAN))/total(finite(DU_V-NO_V),1)
DU_CONC_zonal = reform(total(DU_CONC,1,/NAN))/total(finite(DU_CONC),1)
print, max(NO_U_zonal,/NAN), max(NO_V_zonal,/NAN), max(DU_U_zonal,/NAN),max(DU_V_zonal,/NAN)
print, max(DIFF_U_zonal,/NAN), max(DIFF_V_zonal,/NAN)


;;;; CALCULATE GLOBAL MMC FROM SARAH KANG
;;; so oddly things are flipped.  both ways of calculating MMC work the same
pi  = 3.14159265
rad = pi/180.0
Re  = 6376.e3
wt  = cos(lat*rad)
g  = 9.8
mmc_no = fltarr(ny,nlev)
mmc_du = fltarr(ny,nlev)
mmc_diff = fltarr(ny,nlev)


for iy = 0,ny-1 do begin
   for ilev = 1,nlev-2 do begin

      print, iy, ilev
      mmc_no(iy,ilev)   = mmc_no(iy,ilev-1) + $
                          2*100*pi*Re*wt(iy)*dp(ilev)*reform(NO_V_zonal(iy,ilev))/g
      mmc_du(iy,ilev)   = mmc_du(iy,ilev-1)+ $
                          2*100*pi*Re*wt(iy)*dp(ilev)*reform(DU_V_zonal(iy,ilev))/g
      mmc_diff(iy,ilev) = mmc_diff(iy,ilev-1)+ $
                          2*100*pi*Re*wt(iy)*reverse(dp(ilev))*reform(DIFF_v_zonal(iy,ilev))/g
  endfor
endfor


;;;;; PLOT MMC CHANGES
PSOPEN, FILE='Pete_mmc_obs-no_JJA.ps', $
           /PORTRAIT, XPLOTS=1,YPLOTS=2,SPACE1=100
         
CS, SCALE=1, NCOLS=20, WHITE=[10,11]
POS, XPOS=1, YPOS=2
GSET, XMIN=-90, XMAX=90, YMIN=1000, YMAX=25;, /YLOG
LEVS, MANUAL=[-3,-2,-1.5,-1,-0.8,-0.4,-0.2,-0.1,0,$
              0.1,0.2,0.3,0.4,0.8,1,1.5,2,3], NDECS=1
CON, F=DIFF_U_zonal, X=lat, Y=lev,/NOLINES,$
        TITLE='JJA '+DELTA+'U: OPAC-Spheres - NOAERO', $
        CB_TITLE=DELTA+textoidl('U [m s^{-2}]'), /CB_ALT
LEVS, MANUAL = [-15, -10, -5, -2.5, 0, 2.5, 5, 10, 15, 20, 25, 30, 35], NDECS=1
CON, F=NO_U_zonal, X=lat, Y=lev,/NOFILL,NEGATIVE_STYLE=1,$
        ZERO_STYLE=2
CS, SCALE=28
LEVS, MANUAL = [0, 2]
CON, F=DU_CONC_zonal*1e8, X=lat, Y=lev, /NOFILL, COL=8
AXES, XSTEP=30, YVALS=[1000, 850, 700, 500, 300, 200, 100, 25], $
        XTITLE='LATITUDE', YTITLE='Pressure [hPa]'

CS, SCALE=1, NCOLS=20, WHITE=[10,11]
POS,XPOS=1,YPOS=1
GSET, XMIN=-90, XMAX=90, YMIN=1000, YMAX=25;, /YLOG
LEVS, MANUAL=[-2.5,-1,-0.75,-0.5,-0.25,-0.1,-0.05,-0.025,0,$
               0.025,0.05,0.1,0.25,0.5,0.75,1,2.5], NDECS=3
CON, F=mmc_diff*1e-10, X=lat, Y=lev,/NOLINES,$
        TITLE='JJA '+DELTA+'MMC: OPAC-Spheres - NOAERO', $
        CB_TITLE=DELTA+textoidl('MMC [10^{10} kg s^{-1}]'), /CB_ALT
LEVS, MANUAL = [-18, -14, -10, -6, -1, 0, 1, 2, 3]
CON, F=mmc_no*1.e-10, X=lat, Y=lev,/NOFILL,NEGATIVE_STYLE=1,$
        ZERO_STYLE=2
CS, SCALE=28
LEVS, MANUAL = [0, 2]
CON, F=DU_CONC_zonal*1e8, X=lat, Y=lev, /NOFILL, COL=8
AXES, XSTEP=30, YVALS=[1000, 850, 700, 500, 300, 200, 100, 25], $
        XTITLE='LATITUDE', YTITLE='Pressure [hPa]'
PSCLOSE;,/NOVIEW


END; of script
