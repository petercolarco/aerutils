;  Bryon Baumstarck
;  6/29/2009

;  This file is the MAIN file for creating graphs of model data.
pro modelplot, vVarFilename, vPlotFilename, varName
	CASE varName OF
		"bs": modelplot_bs, vVarFilename, vPlotFilename
		"ex": modelplot_ex, vVarFilename, vPlotFilename
		"od": modelplot_tau, vVarFilename, vPlotFilename
		ELSE: print, 'Invalid input. Please enter bs, ex, or od.'
	ENDCASE
end
