  pro stitch, rc, rc_, var, var_, varout, rcstitch

  rcstitch = 1
  if(rc and rc_) then varOut = [var, var_]
  if((rc eq 0) and rc_) then varout = var_
  if(rc and (rc_ eq 0)) then varout = var
  if((rc eq 0) and (rc_ eq 0)) then rcStitch=0

end
