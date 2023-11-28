#!/bin/tcsh
foreach file (`\ls -1 pm25.nadir*nc`) #065*nc pm25.full*nc pm25.wide*nc`)
sed 's/FILE/'$file'/g' dat.ddf > use.ddf
lats4d.sh -i use.ddf -o $file:r -shave
end

