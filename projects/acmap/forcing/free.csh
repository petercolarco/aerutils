#!/bin/csh
mkdir -p free
foreach file ( `\ls -1 *all*pro` )
sed 's/R_G40/F_G40/g' $file > tmp
sed 's/dR_F25b18/c180R_G40b11/g;s/cR_F25b18/c90R_G40b11/g;s/F25b18/c48R_G40b11/g' tmp > free/$file
rm -f tmp
end
