
   thisDevice = !D.Name
   Set_Plot, 'Z', /Copy
   Device, Set_Resolution=[500, 350]
   Erase, Color=0

map_set
map_continents, /fill, color=1

snap = tvrd()
mask = (snap eq 0)
sea = mask * 255

tv, sea
map_continents, /fill, color=1
contourimage = tvrd()

thesea = where(sea gt 0, count)
finalimage = contourimage
if(count gt 0) then finalimage[theSea] = sea[theSea]

set_plot, thisDevice
tv, finalimage

end

