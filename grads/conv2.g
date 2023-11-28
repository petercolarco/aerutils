xdfopen ../ctl/bR_Fortuna-2_5-b1.tavg2d_aer_x.ctl

set gxout shaded
a = 3*ave(bcsv,t=1,t=12)*1e12
b = ave(bcgsv002,t=1,t=12)*1e12
xycomp a b
plotpng cv_bc.2.png

a = 3*ave(ocsv,t=1,t=12)*1e12
b = ave(ocgsv002,t=1,t=12)*1e12
xycomp a b
plotpng cv_oc.2.png


a = 5*ave(sssv,t=1,t=12)*1e12
b = ave(ssgsv001+ssgsv002+ssgsv003+ssgsv004+ssgsv005,t=1,t=12)*1e12
xycomp a b
plotpng cv_ss.2.png


a = 5*ave(dusv,t=1,t=12)*1e12
b = ave(dugsv001+dugsv002+dugsv003+dugsv004+dugsv005,t=1,t=12)*1e12
xycomp a b
plotpng cv_du.2.png


