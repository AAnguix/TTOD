filein "Functions.ms"
filein "EFFECTS_MATERIALS.ms"

function ExportMaterial MaterialsExported _Material _File =
(
	if (MaterialsExported.ContainsKey (_Material.name))==false then
	(
		
		local ObjTechnique = "MV_POSITION_NORMAL_TEXTURE_VERTEX"
		_Path = "Data\\Level\\meshes\\"
		
		if(_Material.bumpMapEnable  == true) do
		(ObjTechnique = "MV_POSITION_NORMAL_TEXTURE_BINORMAL_TANGENT_VERTEX")
		
		
		if(_Material.ReflectionMapEnable  == true AND _Material.diffuseMapEnable == false) do
		(ObjTechnique = "skybox_renderable_object_technique")
		
		if(_Material.ReflectionMapEnable  == true AND _Material.diffuseMapEnable == true) do
		(ObjTechnique = "enviroment_renderable_object_technique")
		
		format "\t<material name=\"%\" renderable_object_technique=\"%\">\n" _Material.name ObjTechnique to:_File
		
		if (_Material.diffuseMapEnable == true) do
		(
			Filename = filenameFromPath (openBitMap _Material.diffuseMap.bitmap.filename).fileName		
			format "\t\t<texture filename=\"%%\"/>\n"  _Path Filename to:_File
		)
		
		if (_Material.selfIllumMapEnable == true) do
		(
			SelfIlumFile =  filenameFromPath (openBitMap _Material.selfIllumMap.bitmap.filename).fileName
			format "\t\t<texture filename=\"%%\"/>\n"  _Path SelfIlumFile to:_File	
		)
		
		if (_Material.bumpMapEnable  == true) do
		(
			BumpFile =  filenameFromPath (openBitMap _Material.bumpmap.normal_map.bitmap.filename).fileName --ASI ES COMO SE EXPORTA PARA LAS ARISTAS
			--BumpFile =  filenameFromPath (openBitMap _Material.bumpmap.bitmap.filename).fileName  --ASI ES COMO SE EXPORTA PARA ESCENA JORDI		
			format "\t\t<texture filename=\"%%\"/>\n"  _Path BumpFile to:_File	
		)
		
		if (_Material.ReflectionMapEnable == true) do
		(
			ReflectionFile =  filenameFromPath (openBitMap _Material.ReflectionMap.bitmap.filename).fileName
			format "\t\t<texture filename=\"%%\"/>\n"  _Path ReflectionFile to:_File	
		)
		
		format "\t\t<parameter type=\"float\" name=\"specular\" value=\"60.0\" description=\"min=0.0\" max=\"100.0\" step=\"0.05\"/>\n" to:_File
		format "\t\t<parameter type=\"float\" name=\"gloss\" value=\"60.0\" description=\"min=0.0\" max=\"100.0\" step=\"0.05\"/>\n" to:_File
		format "\t\t<parameter type=\"float\" name=\"bump\" value=\"2.5\"/>\n" to:_File
		format "\t\t<parameter type=\"float\" name=\"environment_factor\" value=\"0.0\"/>\n" to:_File
		format "\t\t<parameter type=\"float\" name=\"cutout_factor\" value=\"1.0\"/>\n" to:_File		
		format "\t</material>\n" to:_File
		MaterialsExported.Add _Material.name MaterialsExported.count
		
	)
)	


function ExportMaterials _Path=
(
	local myPath = RelativePath _Path
	DoesItExist myPath
	local file = createfile (myPath+"\\Materials.xml")
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<materials>\n" to:file 
	local l_MaterialsExported=dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	
	select geometry
	meshes = $selection
	
	for i=1 to meshes.count do
	(
		format "este es el objeto: % \n" meshes[i].name
		
		if (getuserprop meshes[i] "type" != "animated_model") then
		(
			if classof(meshes[i].material) == Multimaterial then
			(
				for j=1 to meshes[i].material.count do
				(
					--if meshes[i].material[j].diffuseMapEnable == true do
						ExportMaterial l_MaterialsExported meshes[i].material[j] file 
				)
			)
			else
			(
				--if meshes[i].material.diffuseMapEnable == true do
					ExportMaterial l_MaterialsExported meshes[i].material file 
			)		
		)
	)
	EffectMaterials _File
	format "</materials>\n" to:file
	
	close file
)
