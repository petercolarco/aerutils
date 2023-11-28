#!/bin/tcsh
# Colarco, January 2010
# Grab and regrid Arlindo's NNR MODIS retrievals

  foreach res (b c d e)

  foreach satid (MOD04 MYD04)

   set regridstr = ""
   if( $res == "a" ) set regridstr = "-geos4x5a"
   if( $res == "b" ) set regridstr = "-geos2x25a"
   if( $res == "c" ) set regridstr = "-geos1x125a"
   if( $res == "d" ) set regridstr = "-geos0.5a"
   if( $res == "e" ) set regridstr = "-geos0.25a"

  foreach yyyy (2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 )
   foreach mm (01 02 03 04 05 06 07 08 09 10 11 12)

    set inpdir = /fvol/calculon6/NNR/051/Level3/$satid/Y$yyyy/M$mm
    set outdir = /misc/prc10/MODIS/NNR/051/Level3/$satid/$res/Y$yyyy/M$mm

    \mkdir -p $outdir
 
#   land
    set fileo = `\ls -1 $inpdir/nnr_001.*.land.*z.nc4`
    foreach file (`echo $fileo`)
     lats4d.sh -i $file -o tmp $regridstr -shave
     \mv -f tmp.nc4 $outdir/$file:t
     chmod g+s,g+w $outdir/$file:t
    end

#   ocean
    set fileo = `\ls -1 $inpdir/nnr_001.*.ocean.*z.nc4`
    foreach file (`echo $fileo`)
     lats4d.sh -i $file -o tmp $regridstr -shave
     \mv -f tmp.nc4 $outdir/$file:t
     chmod g+s,g+w $outdir/$file:t
    end

   end
  end

  end
  end
