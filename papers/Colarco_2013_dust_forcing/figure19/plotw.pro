pro plotw, x, y, thick, color
nx = 8
for i = 0, 6 do begin
plots, x[i]+[-1.5,1.5], y[i], thick=thick, color=color
plots, x[i]+1.5, [y[i],y[i+1]], thick=thick, color=color
endfor
i = 7
plots, x[i]+[-1.5,1.5], y[i], thick=thick, color=color

end

