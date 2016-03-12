fn EffectMaterials _File=
(	
format "\n\n<!-- 	EFFECTS MATERIALS -->\n" to:_File
format "<material name=\"DeferredFogMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
	format "</material>\n" to:_File
	
	format "<material name=\"NoiseAndVignettingMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"NoisePct\" value=\"0.25\" description=\"min=0.0 max=1.0 step=0.01\"/>\n" to:_File
		format "\t<parameter type=\"float\" name=\"VignettingPct\" value=\"0.7\" description=\"min=0.0 max=1.0 step=0.01\"/>\n" to:_File
		format "\t<parameter type=\"float\" name=\"NoiseAmount\" value=\"0.25\" description=\"min=0.0 max=1.0 step=0.01\"/>\n" to:_File
	format "</material>\n" to:_File
	
	format "<material name=\"HDAOMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"HDAOActive\" value=\"1.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"HDAOShowNormals\" value=\"0.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"HDAOShowAO\" value=\"0.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"HDAOUseNormals\" value=\"1.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"vect2f\" name=\"RTSize\" value=\"1280.0 720.0\" description=\"\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"AcceptAngle\" value=\"0.5\" description=\"min=0.0 max=1.5 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"HDAOIntensity\" value=\"2.14\" description=\"min=0.0 max=5.0 step=0.05\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"NormalScale\" value=\"0.4\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"HDAORejectRadius\" value=\"0.43\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"HDAOAcceptRadius\" value=\"0.00312\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
	format "</material>\n" to:_File
	
	format "<material name=\"GUIMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File
	format "</material>\n" to:_File
	
	format "<material name=\"GaussianFilterMaterial\" renderable_object_technique=\"gaussian_filter_renderable_object_technique\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"TextureSize\" value=\"512\" description=\"min=256.0 max=512.0 step=256\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"BlurScale\" value=\"1.0\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
	format "</material>\n" to:_File
	
	format "<material name=\"ThresholdMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"Threshold\" value=\"0.5\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
	format "</material>\n" to:_File
	
	format "<material name=\"BloomMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"BloomActive\" value=\"1.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"BloomIntensity\" value=\"0.75\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"OriginalIntensity\" value=\"0.9\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"BloomSaturation\" value=\"0.7\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"OriginalSaturation\" value=\"1.0\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
	format "</material>\n" to:_File
	
	format "<material name=\"ZBlurMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"ZBlurActive\" value=\"1.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"ZBlurShowDepths\" value=\"1.0\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"ZBlurConstantBlur\" value=\"0.4\" description=\"min=0.0 max=1.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"ZBlurFocalStart\" value=\"1.0\" description=\"min=0.0 max=20.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"ZBlurFocalEnd\" value=\"12.0\" description=\"min=5.0 max=100.0 step=0.01\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"ZBlurEnd\" value=\"15.0\" description=\"min=5.0 max=150.0 step=0.01\" />\n" to:_File
	format "</material>\n" to:_File

	format "<material name=\"ColorGradingMaterial\" renderable_object_technique=\"MV_POSITION4_COLOR_TEXTURE_VERTEX\">\n" to:_File 
		format "\t<parameter type=\"float\" name=\"ColorGradingActive\" value=\"1.0\" description=\"min=0.0 max=1.0 step=1.0\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"ColorColorGrading\" value=\"1.0\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"BrownSepiaColorGrading\" value=\"0.5\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"GreenSepiaColorGrading\" value=\"0.3\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"BlueSepiaColorGrading\" value=\"0.3\" description=\"min=0.0 max=1.0 step=0.001\" />\n" to:_File
		format "\t<parameter type=\"float\" name=\"MonochromeColorGrading\" value=\"0.5\" description=\"min=0.0 max=1.0 step=0.001\"/>\n" to:_File
		format "\t<parameter type=\"float\" name=\"ContrastColorGrading\" value=\"0.4\" description=\"min=0.0 max=1.0 step=0.001\"/>\n" to:_File
		format "\t<parameter type=\"float\" name=\"BrightnessColorGrading\" value=\"0.05\" description=\"min=0.0 max=1.0 step=0.001\"/>\n" to:_File
	format "</material>\n" to:_File
)