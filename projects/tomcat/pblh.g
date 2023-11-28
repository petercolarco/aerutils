xdfopen iss2.pblh.ddf

set lon -17 37
set lat   7 27
set gxout grfill
set grads off
set mpdset hires

set t = 1

while ($t <337)

set tt = $t
if ($t < 10) set tt = '0'$tt
if ($t < 100) set tt = '0'$tt

set t $t

c
set clevs 100 500 1000 1500 2000 2500 3000 3500 4000
d pblh
draw title $t
cbarn

printim iss2.pblh.$tt.png white

@ t = $t + 1

end
