reinit
clear
sdfopen /output/colarco/t003_c32/tau/t003_c32.tau2d.GSFC.2000.nc

set t 1 1464
set z 4
du870 = du001 + du002 + du003 + du004 + du005
ss870 = ss001 + ss002 + ss003 + ss004 + ss005
su870 = so4
oc870 = ocphilic + ocphobic
bc870 = bcphilic + bcphobic
cc870 = bc870 + oc870

set z 7
du470 = du001 + du002 + du003 + du004 + du005
ss470 = ss001 + ss002 + ss003 + ss004 + ss005
su470 = so4
oc470 = ocphilic + ocphobic
bc470 = bcphilic + bcphobic
cc470 = bc470 + oc470

set z 6
du550 = du001 + du002 + du003 + du004 + du005
ss550 = ss001 + ss002 + ss003 + ss004 + ss005
su550 = so4
oc550 = ocphilic + ocphobic
bc550 = bcphilic + bcphobic
cc550 = bc550 + oc550

suang = -log(su470/su870) / log(470./865.)
duang = -log(du470/du870) / log(470./865.)
ssang = -log(ss470/ss870) / log(470./865.)
ccang = -log(cc470/cc870) / log(470./865.)

tot470 = su470+cc470
tot870 = su870+cc870
totang = -log(tot470/tot870)/log(470./865.)

set t 1
aveang = ave(suang*su550 + duang*du550 + ccang*cc550 + ssang*ss550,t=1,t=1464)
aveaot = ave(su550 + du550 + cc550 + ss550,t=1,t=1464)
