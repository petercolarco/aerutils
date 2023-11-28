   nbin = 12
   rmrat = (100.d/.1d)^(3.d/nbin)
   rmin = 0.1d*((1.+rmrat)/2.d)^(1.d/3.)
   carmabins, nbin, rmrat, rmin, 2650., $
              rmass, rmassup, r, rup, dr, rlow
   nc4readvar, 'dR_G40b10.inst3d_carma_v.diurnal.200706.nc4', 'du0', du, /temp, lon=lon, lat=lat
   nc4readvar, 'dR_G40b10-reorder.inst3d_carma_v.diurnal.200706.nc4', 'du0', dur, /temp, lon=lon, lat=lat
   nc4readvar, 'dR_G40b10-layer.inst3d_carma_v.diurnal.200706.nc4', 'du0', dul, /temp, lon=lon, lat=lat
   lat2=1
   lon2=1
   area, lon, lat, nx, ny, dx, dy, area, lat2=lat2, lon2=lon2, grid='d'
   du = reform(du,nx*ny*1L,72,8,12)
   dul = reform(dul,nx*ny*1L,72,8,12)
   dur = reform(dur,nx*ny*1L,72,8,12)

set_plot, 'ps'
device, file='plot_size_12bin.ps', /helvetica, font_size=12, /color, $
 xoff=.5, yoff=.5, xsize=24, ysize=64
!p.font=0

!p.multi=[0,5,8]
loadct, 39
for j = 0, 7 do begin
for i = 0, 4 do begin
a = where(lon2 gt -50+i*10 and lon2 le -40+i*10 and lat2 gt 5 and lat2 lt 25)
plot, r, total(du[a,70,j,*],1)*n_elements(a)*r/dr, $
 xrange=[.1,100], xtitle='radius [um]', yrange=[1.e-5,10], ystyle=9, xstyle=9, /xlog, /ylog, thick=6
oplot, r, total(dul[a,70,j,*],1)*n_elements(a)*r/dr, lin=2, thick=6
oplot, r, total(dur[a,70,j,*],1)*n_elements(a)*r/dr, lin=1, thick=6
oplot, r, total(du[a,60,j,*],1)*n_elements(a)*r/dr, thick=6, color=84
oplot, r, total(dul[a,60,j,*],1)*n_elements(a)*r/dr, color=84, lin=2, thick=6
oplot, r, total(dur[a,60,j,*],1)*n_elements(a)*r/dr, color=84, lin=1, thick=6
oplot, r, total(du[a,50,j,*],1)*n_elements(a)*r/dr, thick=6, color=208
oplot, r, total(dul[a,50,j,*],1)*n_elements(a)*r/dr, color=208, lin=2, thick=6
oplot, r, total(dur[a,50,j,*],1)*n_elements(a)*r/dr, color=208, lin=1, thick=6
oplot, r, total(du[a,40,j,*],1)*n_elements(a)*r/dr, thick=6, color=254
oplot, r, total(dul[a,40,j,*],1)*n_elements(a)*r/dr, color=254, lin=2, thick=6
oplot, r, total(dur[a,40,j,*],1)*n_elements(a)*r/dr, color=254, lin=1, thick=6
endfor
endfor

device, /close
end
