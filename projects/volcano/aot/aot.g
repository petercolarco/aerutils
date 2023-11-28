* plot the NHL eruptions

  xdfopen VMNHLjan01.tavg2d_carma_x.ddf
  xdfopen VMNHLjan02.tavg2d_carma_x.ddf
  xdfopen VMNHLjan03.tavg2d_carma_x.ddf
  xdfopen VMNHLjan04.tavg2d_carma_x.ddf
  xdfopen VMNHLjan05.tavg2d_carma_x.ddf

  c
  set grads off

  set vrange -0.01 0.15

  set t 1 60
  set x 1
  set y 1

  g5 = aave(suexttau.1+suexttau.2+suexttau.3+suexttau.4+suexttau.5,g)/5.

  d g5

  sdfopen /misc/prc20/colarco/volcano/GISS/VolK_ctrl/taijVolK_ctrl.series.nc
  sdfopen /misc/prc20/colarco/volcano/GISS/VolK_NHh_Win_anl/taijVolK_NHh_Win_anl.series.nc

  set dfile 6
  set t 1 60
  set x 1
  set y 1

  gi = aave(aot.7-aot.6,g)
  d gi

  draw title NHLjan

  plotpng NHLjan.png

