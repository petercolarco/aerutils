   nbin = 12
   rmrat = (100.d/.1d)^(3.d/nbin)
   rmin = 0.1d*((1.+rmrat)/2.d)^(1.d/3.)
   carmabins, nbin, rmrat, rmin, 2650., $
              rmass, rmassup, r, rup, dr, rlow
   nc4readvar, 'dR_G40b10.inst3d_carma_v.20070701_2100z.nc4', 'du0', du, /temp, lon=lon, lat=lat
   nc4readvar, 'dR_G40b10.inst3d_carma_v.20070701_2100z.nc4', 'delp', delp, lon=lon, lat=lat
   lat2=1
   lon2=1
   area, lon, lat, nx, ny, dx, dy, area, lat2=lat2, lon2=lon2, grid='d'
   du = reform(du,nx*ny*1L,72,12)
;plot, r*1e, du[300,211,70,*]*r/dr, /xlog, /ylog, thick=6
;oplot, r*1e, du[300,211,60,*]*r/dr, thick=6
;oplot, r*1e, du[300,211,50,*]*r/dr, thick=6
;oplot, r*1e, du[300,211,40,*]*r/dr, thick=6


   nbin = 24
   rmrat = (100.d/.1d)^(3.d/nbin)
   rmin = 0.1d*((1.+rmrat)/2.d)^(1.d/3.)
   carmabins, nbin, rmrat, rmin, 2650., $
              rmass, rmassup, r24, rup, dr24, rlow
   nc4readvar, 'dR_G40b10-24.inst3d_carma_v.20070701_2100z.nc4', 'du0', du24, /temp, lon=lon, lat=lat
   nc4readvar, 'dR_G40b10-24.inst3d_carma_v.20070701_2100z.nc4', 'delp', delp, lon=lon, lat=lat
   du24 = reform(du24,nx*ny*1L,72,24)
;oplot, r*1e, du[300,211,70,*]*r/dr, color=100
;oplot, r*1e, du[300,211,60,*]*r/dr, color=100
;oplot, r*1e, du[300,211,50,*]*r/dr, color=100
;oplot, r*1e, du[300,211,40,*]*r/dr, color=100


!p.multi=[0,5,1]
a = where(lon2 gt -50 and lon2 le -40 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,*],1)*n_elements(a)*r/dr, /xlog, /ylog, thick=6
oplot, r24, total(du24[a,70,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,60,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,60,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,50,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,50,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,40,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,40,*],1)*n_elements(a)*r24/dr24, color=100

a = where(lon2 gt -40 and lon2 le -30 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,*],1)*n_elements(a)*r/dr, /xlog, /ylog, thick=6
oplot, r24, total(du24[a,70,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,60,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,60,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,50,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,50,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,40,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,40,*],1)*n_elements(a)*r24/dr24, color=100

a = where(lon2 gt -30 and lon2 le -20 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,*],1)*n_elements(a)*r/dr, /xlog, /ylog, thick=6
oplot, r24, total(du24[a,70,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,60,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,60,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,50,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,50,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,40,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,40,*],1)*n_elements(a)*r24/dr24, color=100

a = where(lon2 gt -20 and lon2 le -10 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,*],1)*n_elements(a)*r/dr, /xlog, /ylog, thick=6
oplot, r24, total(du24[a,70,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,60,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,60,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,50,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,50,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,40,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,40,*],1)*n_elements(a)*r24/dr24, color=100

a = where(lon2 gt -10 and lon2 le 0 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,*],1)*n_elements(a)*r/dr, /xlog, /ylog, thick=6
oplot, r24, total(du24[a,70,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,60,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,60,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,50,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,50,*],1)*n_elements(a)*r24/dr24, color=100
oplot, r, total(du[a,40,*],1)*n_elements(a)*r/dr, thick=6
oplot, r24, total(du24[a,40,*],1)*n_elements(a)*r24/dr24, color=100



end

