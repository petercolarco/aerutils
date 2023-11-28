; Need to source
;   source /misc/prc10/crandles/aerutils_022513/setup.csh


;;; SCRIPT TO CALCULATE MMC
;DELTA = '!9'+SCROP(BYTE(68))+'!X'
DELTA = 'd'

;; OPEN THE FILES AND READ IN U, V
exppath      = '/misc/prc14/colarco/'
nodust       = 'dR_MERRA-AA-r2'
opac_spheres = 'F25b18'
noaerosol    = nodust
dust         = OPAC_spheres
coll         = 'geosgcm_prog'

f1  = exppath+noaerosol+'/'+coll+'/'+noaerosol+'.'+coll+'.monthly.clim.ANN.b.nc4'
f2  = exppath+dust+'/'+coll+'/'+dust+'.'+coll+'.monthly.clim.ANN.nc4'
fid1 = ncdf_open(f1)
fid2 = ncdf_open(f2)

;; DIMENSIONS
lonid = ncdf_dimid(fid1, 'longitude')
latid = ncdf_dimid(fid1, 'latitude')
levid = ncdf_dimid(fid1, 'levels')
ncdf_varget, fid1, lonid, lon
ncdf_varget, fid1, latid, lat
ncdf_varget, fid1, levid, lev
lon[72] = 0
nx = n_elements(lon)
ny = n_elements(lat)
nlev = n_elements(lev)

;; U, V
nouid = ncdf_varid(fid1, 'u')
novid = ncdf_varid(fid1, 'v')
duuid = ncdf_varid(fid2, 'U')
duvid = ncdf_varid(fid2, 'V')
ncdf_varget, fid1, nouid, NO_U
ncdf_varget, fid1, novid, NO_V
ncdf_varget, fid2, duuid, DU_U
ncdf_varget, fid2, duvid, DU_V

ncdf_close, fid1
ncdf_close, fid2

a = where(NO_U ge 1e10)
if (a[0] ne -1) then NO_U(a) = !VALUES.F_NAN
a = where(NO_V ge 1e10)
if (a[0] ne -1) then NO_V(a) = !VALUES.F_NAN

a = where(DU_U ge 1e10)
if (a[0] ne -1) then DU_U(a) = !VALUES.F_NAN
a = where(DU_V ge 1e10)
if (a[0] ne -1) then DU_V(a) = !VALUES.F_NAN

print, max(NO_U,/NAN), max(NO_V,/NAN), max(DU_U,/NAN), max(DU_V,/NAN)

;;; REVERSE EVERYTHING TOP DOWN
NO_U = reverse(NO_U, 3)
NO_V = reverse(NO_V, 3)
DU_U = reverse(DU_U, 3)
DU_V = reverse(DU_V, 3)
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

  red =   [8,8,33,66,107,158,198,222,255,254,253,253,253,241,217,177,127,  0]
  green = [48,81,113,146,174,202,219,235,255,230,208,174,141,105,72,54,39, 0]
  blue =  [107,156,181,198,214,225,239,247,255,206,162,107,60,19,1,3,4,    0]
  tvlct, red, green, blue
  iblack = n_elements(red)-1


;;;;; PLOT MMC CHANGES
  set_plot, 'ps'
  device, file = 'F25b18.ps', /helvetica, font_size=16, /color, $
          xsize=18, ysize=24, xoff=.5, yoff=.5
  !p.font=0

; Plot the u wind
  levels = [-3000,-2,-1.5,-1,-0.8,-0.4,-0.2,-0.1,0,$
              0.1,0.2,0.3,0.4,0.8,1,1.5,2]
  loadct, 0
  label = string(levels,format='(f4.1)')
  label[0] = ' '
  makekey, .15, .525, .8, .025, 0, -.02, align=.5, color=make_array(n_elements(levels),val=0), $
           label=label, charsize=.6
  tvlct, red, green, blue
  makekey, .15, .525, .8, .025, 0, -.02, align=.5, color=indgen(n_elements(levels)), $
           label=make_array(n_elements(levels),val=' '), charsize=.6
  contour, diff_u_zonal, lat, lev, /nodata, /noerase, color=iblack, $
           position=[.15,.6,.95,.95], yrange=[1000,25], $
           ytickv=[1000,850,700,500,300,200,100,25], $
           ystyle=1,xstyle=1, yticks=7, xticks=6, charsize=.6
  contour, diff_u_zonal, lat, lev, /overplot, levels=levels, c_colors=indgen(n_elements(levels)), /cell
  levels=[-15, -10, -5, -2.5, 0, 2.5, 5, 10, 15, 20, 25, 30, 35]
  contour, no_u_zonal, lat, lev, /over, levels=levels, color=iblack, $
           c_linestyle=[2,2,2,2,0,0,0,0,0,0,0,0,0], $
           c_label=make_array(n_elements(levels),val=1), c_charsize=.5
  contour, diff_u_zonal, lat, lev, /nodata, color=iblack, /noerase, $
           position=[.15,.6,.95,.95], yrange=[1000,25], $
           ytickv=[1000,850,700,500,300,200,100,25], $
           ystyle=1,xstyle=1, yticks=7, xticks=6, charsize=.6, $
           ytitle='Pressure [hPa]', xtitle='Latitude', $
           title='U-Wind (Fortuna!U2!S!Eo!N - Fortuna!U1/2!S!Eo!N)'



; Plot the MMC
  levels = [-3000,-1,-0.75,-0.5,-0.2,-0.1,-0.05,-0.02,0,$
               0.02,0.05,0.1,0.2,0.5,0.75,1,2.5]
  loadct, 0
  labels = string(levels,format='(f5.2)')
  labels[0] = ' '
  labels = [' ','-1','-0.75','-0.5','-0.2','-0.1','-0.05','-0.02','0', $
            '0.02','0.05','0.1','0.2','0.5','0.75','1','2.5']
  makekey, .15, .025, .8, .025, 0, -.02, align=.5, color=make_array(17,val=0), $
           label=labels, charsize=.6
  tvlct, red, green, blue
  makekey, .15, .025, .8, .025, 0, -.02, align=.5, color=indgen(n_elements(levels)), $
           label=make_array(n_elements(levels),val=' '), charsize=.6
  contour, mmc_diff*1e-10, lat, lev, /nodata, /noerase, color=iblack, $
           position=[.15,.1,.95,.45], yrange=[1000,25], $
           ytickv=[1000,850,700,500,300,200,100,25], $
           ystyle=1,xstyle=1, yticks=7, xticks=6, charsize=.6
  contour, mmc_diff*1e-10, lat, lev, /overplot, levels=levels, c_colors=indgen(n_elements(levels)), /cell
  levels=[-18, -14, -10, -6, -1, 0, 1, 2, 3]
  contour, mmc_no*1.e-10, lat, lev, /over, levels=levels, color=iblack, $
           c_linestyle=[2,2,2,2,2,0,0,0,0,0,0,0,0], $
           c_label=make_array(n_elements(levels),val=1), c_charsize=.5
  contour, mmc_diff*1e-10, lat, lev, /nodata, color=iblack, /noerase, $
           position=[.15,.1,.95,.45], yrange=[1000,25], $
           ytickv=[1000,850,700,500,300,200,100,25], $
           ystyle=1,xstyle=1, yticks=7, xticks=6, charsize=.6, $
           ytitle='Pressure [hPa]', xtitle='Latitude', $
           title='Mean Meridional Circulation (Fortuna!U2!S!Eo!N - Fortuna!U1/2!S!Eo!N)'

  device, /close


END; of script
