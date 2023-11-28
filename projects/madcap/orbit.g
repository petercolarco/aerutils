xdfopen c180R_pI33p7.ddf
set t 1
set grads off
set gxout grfill
rr= ave(maskout(tle_mask(const(totexttau,1),iss.tle,50,50,1),const(totexttau,1)),t=1,t=24)
d rr
d rr
printim iss.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),iss.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim iss.day.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),iss.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim iss.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),gpm.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim gpm.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),icesat2.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim icesat2.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),pace.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim pace.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),harp_30_may.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim harp_30_may.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),ins1a.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim ins1a.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),aqua.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim aqua.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),cosmos2503.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim cosmos2503.day.nodrag.track.png white

c
rr= ave(maskout(tle_mask(const(totexttau,1),tiantuo2.nodrag.tle,50,50,1),if(cosz(totexttau,h)>0,1,-1)),t=1,t=24)
d rr
d rr
printim tiantuo2.day.nodrag.track.png white
