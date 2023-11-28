#!/bin/csh
# This is the master control script for making the plots for the Mission
# Support web site.
# This script is called by a cron job that checks to see if it has already
# been run for the latest date.  If not, run it; if so, exit gracefully.
# Can also be called from the command line as either:
#  ./make_plots latest         (this does what the cron job does)
#  ./make_plots YYYY MM DD HH  (run over a retrospective date)

# Usage and date information
#
# If no arguments present, report usage
  if ( $#argv < 1 ) then
      echo "Usage:  $0  yyyy mm dd hh"
      /bin/rm -f easter_egg
      exit 1
  endif

  setenv DISPLAY ""

# Where is the base directory for the web pages
  setenv GRADSBIN grads
  umask 002

################################################################
#
  set months = (JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC)
#
# If <4 arguments present assume you want the latest plots
  if ( $#argv < 4 ) then
#  Run script to capture latest date from the dods server
   gsh latestdate.g
   set yyyy = `awk '{print substr($6,9,4)}' date_latest`
   set dd   = `awk '{print substr($6,4,2)}' date_latest`
   set hh   = `awk '{print substr($6,1,2)}' date_latest`
   set mon  = `awk '{print substr($6,6,3)}' date_latest`
   set ntim = `awk '{print $12}' times_latest`
   set ndmons = (31 28 31 30 31 30 31 31 30 31 30 31)
   if($yyyy == 2000 || $yyyy == 2004 || $yyyy == 2008 || $yyyy == 2012) set ndmons[2] = 29
   set i = 1
   set imon = 0
   while($i < 13)
    if($months[$i] == $mon) then
     set mm = $i
     set ndmon = $ndmons[$i]
    endif
    @ i = $i + 1
   end

   set hhsfc = $hh
   set ddsfc = $dd
   set mmsfc = $mm
   set monsfc = $mon
   set yyyysfc = $yyyy

#  Handle the dates on the DODS server: for some reason the 0Z forecast initial time
#  on tavg2d_aer_x is 22:30Z and the 12Z forecast initial time is 10:30Z.  This is
#  unsatisfying, so we will fake it out.
   set dd_ = $dd
   set mm_ = $mm
   if($mm_ < 10) set mm = '0'$mm
   if($hh >= 22) then     # advance to next day
    /home/colarco/bin/caladvance 1 $yyyy $mm $dd 1
    set yyyy = ` cat newdate | awk '{ print $1 }'`
    set mm   = ` cat newdate | awk '{ print $2 }'`
    set dd   = ` cat newdate | awk '{ print $3 }'`
    set mon  = $months[$mm]
    set hh = '00'
#    setenv timeidxsfc '3 21 45 69 93 117'
    setenv timeidxsfc '1 9 17 25 33 41'
    setenv timeidxprs '1 9 17 25 33 41'
   else
    set hhsfc = '10'
    set hh = '12'
#    setenv timeidxsfc '3 9 33 57 81 105'
    setenv timeidxsfc '1 5 13 21 29 37'
    setenv timeidxprs '1 5 13 21 29 37'
   endif
   echo $yyyy $mon $hh $dd $imon $ndmon

   echo $yyyy $mon $hh $dd
   setenv fnamesfc_    "http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/glopac/fcast/inst1_2d_hwl_Nx.latest"
   setenv fnameprsasm_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/inst3_3d_asm_Cp.latest"
   setenv fnameetaasm_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/inst3_3d_asm_Nv.latest"
   setenv fnameprschm_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/tavg3_3d_chm_Cp.latest"
   setenv fnameprstag_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/tavg3_3d_tag_Cp.latest"
   setenv fnameprsaer_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/tavg3_3d_aer_Cp.latest"
   setenv fnamesfcmet_ "http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/fp/0.5_deg/fcast/tavg2d_met_x.latest"
   setenv fnameprsmet_ "http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/fp/0.5_deg/fcast/inst3d_met_p.latest"
   set latest = 1
  else
#  Else we do a requested date
   set yyyy = $1
   set mm   = $2
   set dd   = $3
   set hh   = $4
   set mon = $months[$mm]

   set hhsfc = $hh
   set ddsfc = $dd
   set mmsfc = $mm
   set monsfc = $mon
   set yyyysfc = $yyyy

   if($hh < 6) then
    set hh = '00'
#    setenv timeidxsfc '3 21 45 69 93 117'
    setenv timeidxsfc '1 9 17 25 33 41'
    setenv timeidxprs '1 9 17 25 33 41'
   else
    set hh = '12'
#    setenv timeidxsfc '3 9 33 57 81 105'
    setenv timeidxsfc '1 5 13 21 29 37'
    setenv timeidxprs '1 5 13 21 29 37'
   endif
   setenv fnamesfc_    "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/inst1_2d_hwl_Nx/inst1_2d_hwl_Nx.$yyyy$mm${dd}_${hh}z"
   setenv fnameetaasm_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/inst3_3d_asm_Nv/inst3_3d_asm_Nv.$yyyy$mm${dd}_${hh}z"
   setenv fnameprsasm_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/inst3_3d_asm_Cp/inst3_3d_asm_Cp.$yyyy$mm${dd}_${hh}z"
   setenv fnameprschm_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/tavg3_3d_chm_Cp/tavg3_3d_chm_Cp.$yyyy$mm${dd}_${hh}z"
   setenv fnameprstag_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/tavg3_3d_tag_Cp/tavg3_3d_tag_Cp.$yyyy$mm${dd}_${hh}z"
   setenv fnameprsaer_ "http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/glopac/fcast/tavg3_3d_aer_Cp/tavg3_3d_aer_Cp.$yyyy$mm${dd}_${hh}z"
   setenv fnamesfcmet_ "http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/fp/0.5_deg/fcast/tavg2d_met_x/tavg2d_met_x.$yyyy$mm${dd}_${hh}z"
   setenv fnameprsmet_ "http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/fp/0.5_deg/fcast/inst3d_met_p/inst3d_met_p.$yyyy$mm${dd}_${hh}z"
   set latest = 0
  endif

# Create the local DDF files
# The need for this is to handle the longitudes of the input files so that they
# allow a smoother wrap around the grid
  set tdefstrsfc = "${hhsfc}z$ddsfc$monsfc$yyyysfc"
  /home/colarco/bin/caladvance 5 $yyyy $mm $dd 1
  set newyyyy = ` cat newdate | awk '{ print $1 }'`
  set newmm   = ` cat newdate | awk '{ print $2 }'`
  set newdd   = ` cat newdate | awk '{ print $3 }'`
  set newmon  = $months[$newmm]
  set tdefstrprs = "${hh}z$dd$mon$yyyy"
  setenv tdefstrlats "${hh}z$dd$mon$yyyy ${hh}z$newdd$newmon$newyyyy"
  setenv fnamesfc "./sfc.ddf"
  setenv fnamesfcchm "./sfcchm.ddf"
  setenv fnamesfcmet "./sfcmet.ddf"
  setenv fnameetaasm "./etaasm.ddf"
  setenv fnameprsasm "./prsasm.ddf"
  setenv fnameprschm "./prschm.ddf"
  setenv fnameprsaer "./prsaer.ddf"
  setenv fnameprstag "./prstag.ddf"
  setenv fnameprsmet "./prsmet.ddf"
cat > $fnamesfc << EOF
dset $fnamesfc_
xdef lon 1152 linear -180 0.3125
tdef time 123 linear $tdefstrsfc 1hr
EOF
cat > $fnamesfcmet << EOF
dset $fnamesfcmet_
xdef lon 1152 linear -180 0.3125
tdef time 41 linear $tdefstrsfc 1hr
EOF
cat > $fnameprsaer << EOF
dset $fnameprsaer_
xdef lon 540 linear -180 0.6666667
ydef lat 361 linear -90  0.5
tdef time 41 linear $tdefstrprs 3hr
EOF
cat > $fnameetaasm << EOF
dset $fnameetaasm_
xdef lon 1152 linear -180 0.3125
tdef time 41 linear $tdefstrprs 3hr
EOF
cat > $fnameprsasm << EOF
dset $fnameprsasm_
xdef lon 540 linear -180 0.6666667
ydef lat 361 linear -90  0.5
tdef time 41 linear $tdefstrprs 3hr
EOF
cat > $fnameprschm << EOF
dset $fnameprschm_
xdef lon 540 linear -180 0.6666667
ydef lat 361 linear -90  0.5
tdef time 41 linear $tdefstrprs 3hr
EOF
cat > $fnameprstag << EOF
dset $fnameprstag_
xdef lon 540 linear -180 0.6666667
ydef lat 361 linear -90  0.5
tdef time 41 linear $tdefstrprs 3hr
EOF
cat > $fnameprsmet << EOF
dset $fnameprsmet_
xdef lon 540 linear -180 0.6666667
ydef lat 361 linear -90  0.5
tdef time 41 linear $tdefstrprs 3hr
EOF

exit 0
