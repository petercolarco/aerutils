  pro   plotit, a, models, tau, tau2, tau3, tau4, tau5, tau_pre, $
                           ssa, ssa2, ssa3, ssa4, ssa5, ssa_pre, $
                           frc, frc2, frc3, frc4, frc5, frc_pre


  loadct, 39
  plot, tau[a], /nodata, $
   xrange=[-1,7], yrange=[0.5,2], $
   xstyle=1, ystyle=9, xticks=8, yticks=6, $
   ytitle='AOD', $
   position=[.05,.25,.3,.95], xtickname=make_array(9,val=' ')
  xyouts, .055, .89, /normal, '(a)', charsize=1.5
  xyouts, .405, .89, /normal, '(b)', charsize=1.5
  xyouts, .730, .89, /normal, '(c)', charsize=1.5

  xyouts, indgen(8)-0.1, .45, models[a], $
   orientation=-90, align=0
  xyouts, -0.85, .45, 'NAAPS', orientation=-90, align=0
  oplot, tau2[a], thick=12, color=84
  plots, indgen(8), tau2[a], psym=sym(1), color=84, symsize=1.5
  oplot, tau3[a], thick=12, color=148
  plots, indgen(8), tau3[a], psym=sym(1), color=148, symsize=1.5
  xyouts, 0.1, 1.85, 'D!IV!N = 2.5 !9m!3m', color=84, /data
  xyouts, 0.1, 1.71, 'D!IV!N = 4.5 !9m!3m', color=148, /data
  loadct, 0
  oplot, tau_pre[a,0], thick=12, color=100
  plots, indgen(8), tau_pre[a,0], psym=sym(1), color=100, symsize=1.5
  oplot, tau[a], thick=12, color=160
  plots, indgen(8), tau[a], psym=sym(1), color=160, symsize=1.5
  oplot, tau4[a], thick=12, color=160, lin=1
  oplot, tau5[a], thick=12, color=160, lin=2
  xyouts, 0.1, 1.78, 'D!IV!N = 3.5 !9m!3m', color=160, /data
  xyouts, 1, 1.41, '!4OPAC!3', color=100, /data
  plots, 0.425, 1.4275, psym=sym(1), color=100, symsize=1.25
;  xyouts, 5.75, 1.71, '!4NAAPS!3', /data
;  plots, 5.55, 1.7375, psym=sym(5), symsize=1.25
  plots, [.1,0.75], 1.64, thick=12, color=160, lin=1
  plots, [.1,0.75], 1.57, thick=12, color=160, lin=0
  plots, [.1,0.75], 1.50, thick=12, color=160, lin=2
  xyouts, 1., 1.63, '!9s!3 = ln(1.7)', color=160, /data
  xyouts, 1., 1.56, '!9s!3 = ln(2.0)', color=160, /data
  xyouts, 1., 1.49, '!9s!3 = ln(2.3)', color=160, /data
;  plots, [0,7], 1, thick=6
  plots, -0.75, 1, psym=sym(5), symsize=1.5
  axis, yaxis=1, yrange=[.3,1.2], yticks=3, /save, $
   ytitle='MEE [m!E2!N g!E-1!N]', ystyle=1

; Co-Albedo
  loadct, 39
  plot, 1-ssa[a], /nodata, /noerase, $
   xrange=[-1,7], yrange=[0,0.2], $
   xstyle=1, ystyle=1, xticks=8, yticks=4, $
   ytitle='Co-Albedo', $
   position=[.4,.25,.65,.95], xtickname=make_array(9,val=' ')
  xyouts, indgen(8)-0.1, -0.0064, models[a], $
   orientation=-90, align=0
  xyouts, -0.85, -0.0064, 'NAAPS', orientation=-90, align=0
  oplot, 1-ssa2[a], thick=12, color=84
  plots, indgen(8), 1-ssa2[a], psym=sym(1), color=84, symsize=1.5
  oplot, 1-ssa3[a], thick=12, color=148
  plots, indgen(8), 1-ssa3[a], psym=sym(1), color=148, symsize=1.5
  loadct, 0
  oplot, 1-ssa_pre[a,0], thick=12, color=100
  plots, indgen(8), 1-ssa_pre[a,0], psym=sym(1), color=100, symsize=1.5
  oplot, 1-ssa[a], thick=12, color=160
  plots, indgen(8), 1-ssa[a], psym=sym(1), color=160, symsize=1.5
  oplot, 1-ssa4[a], thick=12, color=160, lin=1
  oplot, 1-ssa5[a], thick=12, color=160, lin=2
;  plots, [0,7], .12, thick=6
  plots, -.75, .12, symsize=1.5, psym=sym(5)

; Forcing
  loadct, 39
  plot, frc[a], /nodata, /noerase, $
   xrange=[-1,7], yrange=[-1.1,-0.1], $
   xstyle=1, ystyle=1, xticks=8, yticks=5, $
   ytitle='Forcing [W m!E-2!N M!E-1!N]', $
   position=[.725,.25,.975,.95], xtickname=make_array(9,val=' ')
  xyouts, indgen(8)-0.1, -1.133, models[a], $
   orientation=-90, align=0
  xyouts, -1.1, -1.133, 'NAAPS', orientation=-90, align=0
  oplot, frc2[a], thick=12, color=84
  plots, indgen(8), frc2[a], psym=sym(1), color=84, symsize=1.5
  oplot, frc3[a], thick=12, color=148
  plots, indgen(8), frc3[a], psym=sym(1), color=148, symsize=1.5
  loadct, 0
  oplot, frc_pre[a,0], thick=12, color=100
  plots, indgen(8), frc_pre[a,0], psym=sym(1), color=100, symsize=1.5
  oplot, frc[a], thick=12, color=160
  plots, indgen(8), frc[a], psym=sym(1), color=160, symsize=1.5
  oplot, frc4[a], thick=12, color=160, lin=1
  oplot, frc5[a], thick=12, color=160, lin=2
;  plots, [0,7], -.457, thick=6
  plots, -.75, -.457, symsize=1.5, psym=sym(5)
end



