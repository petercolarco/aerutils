foreach ver (tomcat1 tomcat2 tomcat3 tomcat4 tomcata)

reinit
sdfopen pm25_annual.$ver.450km.2014.shifted.nc4

foreach tt (1 7 13 19)
c
set lon -180 180
set lat -60 60
set gxout grfill
set grads off
set t $tt
set clevs 1 2 5 10 20 50 100 200 500
d pm25*1e9
cbarn
printim pm25_annual.$ver.450km.$tt.png white

c
set grads off
set clevs 5 10 15 20 25 30 35 40 45
d num
cbarn
printim pm25_annual.$ver.450km.num.$tt.png white

end
end

reinit
sdfopen pm25_annual.tomcata.450km.2014.shifted.nc4
foreach tt (1 7 13 19)
c
set lon -180 180
set lat -60 60
set gxout grfill
set grads off
set clevs 20 40 60 80 100 120 140 160
d num
printim pm25_annual.tomcata.450km.num.$tt.png white
end
