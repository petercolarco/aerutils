; Make some plots of smoke AOD based on model run
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa, nz=72
  for iz = 0, 71 do begin
   print, iz, z[iz]/1000.
  endfor
  wantz = [39,35,31,41,37,33]-2
  altst = ['14.5','18.5','22.5','12.5','16.5','20.5']
  position = [ [.025,.2,.325,.5], $
               [.35,.2,.65,.5], $
               [.675,.2,.975,.5], $
               [.025,.55,.325,.85], $
               [.35,.55,.65,.85], $
               [.675,.55,.975,.85]]


  filetemplate = 'c90F_pI32_fires.tavg3d_aerdiag_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  nymd = nymd[0:19]
  nhms = nhms[0:19]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)

  for i = 0, nf-1 do begin
print, i
   set_plot, 'ps'
   device, file='brcextcoef.c90F_pI32_fires.'+nymd[i]+'.ps', /color, $
    /helvetica, font_size=14, xoff=.5, yoff=.5, xsize=18, ysize=16
   !p.font=0

   nc4readvar, filename[i], 'brcextcoef', ext, lon=lon, lat=lat

   for iz = 0, 5 do begin

   noerase = 0
   if(iz eq 0) then noerase=1

   loadct, 0
   MAP_SET, /LAMBERT, 90, 0, -105, /ISOTROPIC, /grid, limit=[40,-180,90,180], $
    position=position[*,iz], title=altst[iz]+' km', /noerase
   makekey, .1, .1, .8, .05, 0, -.035, colors=make_array(6,val=255), $
    labels=['1','2','3','5','7','10'], align=0
   loadct, 56
   levels = [1,2,3,5,7,10]
   colors = findgen(6)*40+40
   contour, ext[*,*,wantz[iz]]*1e6, lon, lat, /overplot, $
    levels=levels, c_color=colors, /cell
print, altst[iz], max(ext[*,*,wantz[iz]])*1e6
   makekey, .1, .1, .8, .05, 0, -.035, colors=colors, $
    labels=make_array(6,val=' ')
   loadct, 0
   map_continents, /hires
   map_continents, /countries, /usa

   endfor
   xyouts, .5, .95, /normal, nymd[i], align=.5
   device, /close
  endfor

end
