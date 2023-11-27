; Colarco, July 2006
; get_ctl.pro
; Function looks first in local directory for requested control file.
; If not found, looks in a central location
; Modify:
;  first look in local directory
;  then see if "ctl" directory is in present location and check
;  then see if "../ctl" directory is present and check

  function get_ctl, ctlfileIn

  ctlFileOut = ctlFileIn
  if(file_search(ctlFileOut) ne '') then return, ctlFileOut
  ctlFileOut = './'+ctlFileIn
  if(file_search(ctlFileOut) ne '') then return, ctlFileOut
  ctlFileOut = './ctl/'+ctlFileIn
  if(file_search(ctlFileOut) ne '') then return, ctlFileOut
  ctlFileOut = '../ctl/'+ctlFileIn
  if(file_search(ctlFileOut) ne '') then return, ctlFileOut

  print, 'Cannot find requested ctl file in ./, ./ctl, or ../ctl/; exit'
  print, ctlfilein
  stop

end

   
