function missdata,var,missing,invert=invert
missval=where(var eq missing,c)
if c lt 1 then missval=-1
if keyword_set(invert) then begin
missval=where(var ne missing,c)
if c lt 1 then missval=-1
endif
return, missval
end

