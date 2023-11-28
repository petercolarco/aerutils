#!/bin/csh -f
#
#  Runs the older, single PE, Aod_3d calculator.
#  Produces output for 532 and 1064nm.

if ( $#argv < 1 ) then
    echo Usage $0": aer_Nv_file(s)"
    exit 1
endif

foreach aer ( $argv )

    foreach channel ( 532 1064 )

        set rcfile = Aod3d_${channel}nm.rc
        set coll   = ext${channel}_Nv

        set ext = `echo $aer | sed -e s/aer_Nv/$coll/ `

        if ( -e $ext ) then
	     echo "[] Skipping $ext --- file exists"
                                  
        else

             echo "[] Processing $ext"
             ./Chem_Aod3d.x  -t $rcfile -o $ext $aer

        endif

    end

end
