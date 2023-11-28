foreach lev (100 50 30 20 10)
reinit
xdfopen c180R_pI33p7strat.tavg3d_aer_p.ddf
set lon 180
set gxout shaded
set t 1 12
set lev $lev
d ocs*1e12
cbarn
draw title OCS [pptv] $lev hPa
printim c180R.ocs.$lev.png white

c
d so2*1e12
cbarn
draw title SO2 [pptm] $lev hPa
printim c180R.so2.$lev.png white

c
d pso2_ocs*1e18
cbarn
draw title pSO2_OCSx1e18 [??] $lev hPa
printim c180R.pso2_ocs.$lev.png white

end
