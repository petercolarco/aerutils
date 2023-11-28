#!/bin/tcsh
set alt = 0

while ($alt < 61)

set z = $alt
if($alt < 10) set z = '0'$z
@ alt = $alt + 1
sed "s/XXXX/$z/g" psg_cfg.usatm_iss.tmp > psg_cfg.usatm_iss.${z}km.txt
curl --data-urlencode file@psg_cfg.usatm_iss.${z}km.txt https://psg.gsfc.nasa.gov/api.php -o psg_rad.usatm_iss.${z}km.txt
end
