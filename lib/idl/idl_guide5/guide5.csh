#!/bin/csh 
#Setup file for idl_guide5

#Modify the next line to point to where you installed the idl_guide5 directory
set base_dir = "/home/colarco/sandbox/aerutils/lib/idl/idl_guide5"

#
#No modifications should be needed below this line
#

setenv IDL_PATH ${IDL_PATH}:+$base_dir
setenv GUIDE_LIB $base_dir/lib
setenv GUIDE_EX ${base_dir}/examples
setenv GUIDE_DATA ${base_dir}/data

alias gex 'cd $GUIDE_EX'
alias glib 'cd $GUIDE_LIB'
alias gdata 'cd $GUIDE_DATA'

