reinit
sdfopen /misc/prc18/colarco/c180F_J10p17p1new_uphl0_fs/tavg3d_aer_p/c180F_J10p17p1new_uphl0_fs.tavg3d_aer_p.monthly.201112.nc4
set grads off
set x 1
set lev 1000 10
set zlog on
set gxout shaded
nii = ave(nipnh4aq3d,lon=-180,lon=180)*1e12
d nii
cbarn
draw title uphl0_fs nipnh4aq3d 2011
printim uphl0_fs.nipnh4aq3d.2011.png white
