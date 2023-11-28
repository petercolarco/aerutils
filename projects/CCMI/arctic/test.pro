; Make some plots of global statistics based on annual mean (decadal)
; values

  ddf = 'CCMI_REF_C2.ann.ddf'

  area, lon, lat, nx, ny, dx, dy, area, grid='b'
; discard area for latitude < 60 N
  a = where(lat lt 60)
  area[*,a] = 0.

  yyyy = strpad(1960+findgen(141),1000)

; Global AOT
  nc4readvar, ddf, ['sudp003','sudp003volc','suwt003','suwt003volc','susv003','susv003volc'], sudp, /sum
;  nc4readvar, ddf, ['sudp','suwt','susv'], sudp, /sum, /template
stop
  sudp = aave(sudp,area)

end
