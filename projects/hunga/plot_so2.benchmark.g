xdfopen c180R_v10p23p0_sc.tavg2d_aer_x.ctl
set x 1
set y 1
set t 1 48
so2 = aave(so2cmass,g)*5.1e5
d so2
draw title GOCART2G Benchmark SO2 [Tg]
printim so2_load.benchmark.png white
