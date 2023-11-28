sdfopen /misc/prc18/colarco/c180F_J10p17p1new_uphl0_fs/tavg3d_aer_p/c180F_J10p17p1new_uphl0_fs.tavg3d_aer_p.monthly.201112.nc4
set grads off
set x 1
set lev 1000 10
set zlog on
set gxout shaded
nii = ave(ni,lon=-180,lon=180)*1e9
set clevs .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1.1 1.2
d nii
cbarn
draw title uphl0_fs 2011
printim uphl0_fs.2011.png white
