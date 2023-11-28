xdfopen ../ctl/bR_control.tavg3d_aer_p.ctl
c
set grads off
set x 1
set y 1
set lev 1000 20
set zlog on
set t 1 312
set clevs 1 2 4 8 16 32 64 128
set clevs 1 2 5 10 20 40 60 80
set gxout shaded
define bcc = aave(bc,g)*1e12
d bcc
cbarn
plotpng bcvmass.bR_control.png
