xdfopen c90Fc_pin.ddf
xdfopen c90Fc_pin_ash02.ddf
xdfopen c90Fc_pin_ash10.ddf

set t 1 16
set x 1
set y 1
set grads off
set vrange 0 50

du1 = aave(ducmass,g)*5.1e5
du2 = aave(ducmass.2,g)*5.1e5
du3 = aave(ducmass.3,g)*5.1e5

d du1
d du2
d du3


gxprint ashload.png white
