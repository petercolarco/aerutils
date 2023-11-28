#!/bin/tcsh

set varsdu = "dust001 dust002 dust003 dust004 dust005 dust006 dust007 dust008 "
set varsco = "dubc001 dubc002 dubc003 dubc004 dubc005 dubc006 dubc007 dubc008 "
set varsss1 = "seasalt001 seasalt002 seasalt003 seasalt004 "
set varsss2 = "seasalt005 seasalt006 seasalt007 seasalt008 "
set varsbc1 = "blackcarbon001 blackcarbon002 blackcarbon003 blackcarbon004 "
set varsbc2 = "blackcarbon005 blackcarbon006 blackcarbon007 blackcarbon008 "
set vars = $varsdu$varsco$varsss1$varsss2$varsbc1$varsbc2
echo $vars
lats4d.sh -i test.inst3d_carma_v.20090531_2100z.nc4 \
          -o tmp -vars $varsdu$varsco$varsss1$varsss2$varsbc1
