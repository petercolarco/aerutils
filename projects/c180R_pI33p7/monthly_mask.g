xdfopen mask.calipso.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.png white
reinit

xdfopen mask.calipso.sza.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.sza.png white
reinit

xdfopen mask.calipso.offset+10deg.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.offset+10deg.png white
reinit

xdfopen mask.calipso.offset-10deg.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.offset-10deg.png white
reinit

xdfopen mask.calipso.offset+1hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.offset+1hr.png white
reinit

xdfopen mask.calipso.offset-1hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.offset-1hr.png white
reinit

xdfopen mask.calipso.offset+4hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.offset+4hr.png white
reinit

xdfopen mask.calipso.offset-4hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.offset-4hr.png white
reinit

xdfopen mask.calipso.sza+1hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.sza+1hr.png white
reinit

xdfopen mask.calipso.sza-1hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.sza-1hr.png white
reinit

xdfopen mask.calipso.sza+4hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.sza+4hr.png white
reinit

xdfopen mask.calipso.sza-4hr.ddf
set grads off
set gxout grfill
set lon -180 180
d ave(mask,t=4369,t=4392)
printim mask.calipso.sza-4hr.png white
reinit

