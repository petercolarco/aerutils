#!/bin/csh

foreach collection (tavg24_3d_aer_Np)

foreach YYYY (2022 2023 2024 2025)
foreach MM (01 02 03 04 05 06 07 08 09 10 11 12)

ncra -v SUEXTCOEF,SO4,SO2 C90c_HTerup*.$YYYY$MM.nc4 C90c_HTerup_clim.tavg24_3d_aer_Np.monthly.$YYYY$MM.nc4

echo $YYYY$MM
end

end

end
