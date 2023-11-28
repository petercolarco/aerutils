#!/bin/csh

set inpdir = /science/gmao/geosccm/data/Hunga-Tonga

foreach EXPID (C90c_HTcntl C90c_HTcntl_b C90c_HTcntl_c C90c_HTcntl_d)

foreach collection (tavg24_3d_aer_Np)

foreach YYYY (2022 2023 2024 2025)
foreach MM (01 02 03 04 05 06 07 08 09 10 11 12)

set file = $EXPID.$collection.monthly.$YYYY$MM.nc4

if( -f $inpdir/$EXPID/Y$YYYY/M$MM/$file) then
 ln -s $inpdir/$EXPID/Y$YYYY/M$MM/$file $file
else if( -f $inpdir/C90c_HTcntl/Y$YYYY/M$MM/C90c_HTcntl.$collection.monthly.$YYYY$MM.nc4) then
 ln -s $inpdir/C90c_HTcntl/Y$YYYY/M$MM/C90c_HTcntl.$collection.monthly.$YYYY$MM.nc4 $file
endif

end
end

end

end
