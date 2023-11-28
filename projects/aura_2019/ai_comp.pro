;  expid = 'c360R_era5_v10p22p2_aura_loss_bb3_low3'
;  experimentstr = '(b) GEOS+OA_loss+updated_optics'
;  expid = 'c360R_era5_v10p22p2_aura_loss_bb3'
;  experimentstr = '(b) GEOS+OA_loss'
  expid = 'c360R_era5_v10p22p2_aura_baseline'
  experimentstr = '(a) GEOS Baseline'


; Get a model field
  filen1 = expid+'.monthly.201609.nc4'
  nc4readvar, filen1, 'ai', aim, lon=lon, lat=lat

; Get the OMAERUV field
  filen2 = 'omaeruv.monthly.201609.nc4'
  nc4readvar, filen2, 'ai', ai, lon=lon, lat=lat

  a = where(ai gt 100)
  ai[a] = !values.f_nan
  aim[a] = !values.f_nan

  colors=[208,200,16,64,230,128,112,254]
  levels=[-100,-0.5,0,0.5,1,1.5,2,2.5]
  labels=[' ','-0.5','0','0.5','1','1.5','2','2.5']
  dlevels=[-2.5,-2,-1.5,-1,-.5,-.1,.1,.5]
  dcolors=[255,224,192,176,160,128,80,16]

  set_plot, 'ps'
  device, file='ai.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=20, ysize=36
  !p.font=0

  b = where(lat ge -25 and lat le 0)
  a = where(lon ge 0 and lon le 20)
  ai_ = ai[a,*]
  ai_ = ai_[*,b]
  aim_= aim[a,*]
  aim_=aim_[*,b]
  a = where(finite(ai_) ne 1 or aim_ gt 1e14)
  ai_[a] = !values.f_nan
  aim_[a] = !values.f_nan
  bias = mean(aim_-ai_,/nan)
print, bias
stop
  comp, aim, ai, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors, $
        experimentstr2=experimentstr

  device, /close

end
