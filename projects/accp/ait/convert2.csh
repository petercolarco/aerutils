#!/bin/tcsh
foreach file (`\ls -1 prec*nc`)
sed 's/FILE/'$file'/g' dat.ddf > use2.ddf
lats4d.sh -i use2.ddf -o $file:r -shave
end

