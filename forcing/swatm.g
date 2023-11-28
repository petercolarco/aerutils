* baseline is acma_oc        -- allsoatooc
* new is I10pa3-acma         -- new
* perturb is I10pa3-acma_brc -- perturb, all to BRC except SOA that goes to OC
sdfopen /misc/prc18/colarco/c48F_I10pa3-acma_brc/geosgcm_surf/c48F_I10pa3-acma_brc.geosgcm_surf.monthly.200808.nc4 
sdfopen /misc/prc18/colarco/c48F_a3pI10-acma_oc/geosgcm_surf/c48F_a3pI10-acma_oc.geosgcm_surf.monthly.200808.nc4 

set gxout shaded
set lon -120 60
set lat -40 60

define toa1 = swtnet-swtnetna
define toa2 = swtnet.2-swtnetna.2
define sfc1 = swgnet-swgnetna
define sfc2 = swgnet.2-swgnetna.2

xycomp toa1 toa2
printim swtnet.perturb.png

xycomp sfc1 sfc2
printim swgnet.perturb.png


define atm1 = toa1-sfc1
define atm2 = toa2-sfc2
xycomp atm1 atm2
printim swatm.perturb.png
