xdfopen ../ctl/dRA_arctas.inst2d_hwl_x.ctl

set time 0z5apr2008 0z15apr2008

set gxout shaded

set dir = aod_floop

! /bin/rm -rf $dir
! /bin/cp -r www_aod $dir 

set lon 120 240
set lat 20 80
set mproj latlon
set mpdset hires
set xlopts 1 8 .18
set ylopts 1 8 .18
set xlint 15
set ylint 15
set grid on 1 1



set dir = aod_floop

   foreach q ( tot du bc oc su ss )

       aaod $q boreal $dir/anim 212 64 80 Bonanza_Creek

   end

