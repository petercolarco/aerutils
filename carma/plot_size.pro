;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

  pro plot_size, rmin, rmax, dvdr, thick=thick, color=color, lin=lin

  nbin = n_elements(rmin)

  plots, rmin[0], [0,dvdr[0]], thick=thick, color=color, lin=lin

  for ibin = 0, nbin-2 do begin
   plots, [rmin[ibin],rmax[ibin]], dvdr[ibin], thick=thick, color=color, lin=lin
   plots, rmax[ibin], [dvdr[ibin],dvdr[ibin+1]], thick=thick, color=color, lin=lin
  endfor
  ibin = nbin-1
  plots, [rmin[ibin],rmax[ibin]], dvdr[ibin], thick=thick, color=color, lin=lin
  plots, rmax[ibin], [dvdr[ibin],0], thick=thick, color=color, lin=lin

end
