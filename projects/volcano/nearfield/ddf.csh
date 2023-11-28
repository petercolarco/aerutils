#!/bin/tcsh
foreach expid (NHL NML SHL SML STR TRO)
foreach mon (apr jan jul oct)
foreach cc  ("02" "03" "04" "05")
set filein = VM$expid${mon}01.tavg2d_carma_x.ddf
set fileout = VM$expid${mon}${cc}.tavg2d_carma_x.ddf
sed 's/01\//'$cc'\//g;s/01\./'$cc'\./g' $filein > $fileout
end
end
end
