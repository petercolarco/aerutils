#!/bin/csh

# Setup the environment
  if($?IDL_PATH == 0) setenv IDL_PATH ''
  setenv IDL_PATH ./:+/misc/prc11/colarco/aerutils/lib/idl:/misc/prc11/colarco/aerutils/aeronet:${IDL_PATH}

# Grab any AERONET files that have been received
set inpdir = /app/ftp/incoming/atmos/colarco/
set outdir = /misc/prc10/AERONET/AOT/AOT/LEV15/NRT/
set wrkdir = /misc/prc11/colarco/aerutils/aeronet
cd $inpdir
set lfiles = `\ls -1 ????_??_??_level1.5`
cd $wrkdir
set count = 0
foreach file (`echo $lfiles`)
 @ count  = $count + 1
 set yyyy = `echo $file | cut - -b 1-4`
 set mm   = `echo $file | cut - -b 6-7`
 set dd   = `echo $file | cut - -b 9-10`
 set date = $yyyy$mm$dd

# move file to local dir
\mv -f $inpdir$file $outdir

# Process in IDL
cat > idlscript.aeronet <<EOF
!quiet = 1L
aeronet_nrt2nc, '$date', rc=rc
print, '$date', rc
exit
EOF
idl idlscript.aeronet

end

