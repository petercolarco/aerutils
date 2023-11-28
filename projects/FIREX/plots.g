sdfopen https://opendap.nccs.nasa.gov/dods/GEOS-5/fp/0.25_deg/assim/inst1_2d_hwl_Nx
set lat 0 90
set gxout shaded
set mproj nps
set grads off

set t = 14353

while ($t < 14641)

set t $t

run paod totexttau

printim test.$t.png white

@ t = $t + 1

end

