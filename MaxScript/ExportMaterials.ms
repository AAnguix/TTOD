filein "Functions.ms"

function ExportMaterial MaterialsExported _Material _File =
(
	if (MaterialsExported.ContainsKey (_Material.name))==false then
	(
		_Path = "Data\\Level\\meshes\\"
		Filename = filenameFromPath (openBitMap _Material.diffuseMap.bitmap.filename).fileName
		format "\t<material name=\"%\" effect_technique=\"diffuse_technique\">\n" _Material.name to:_File
		format "\t\t<texture filename=\"%%\"/>\n"  _Path Filename to:_File
		
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
	meshes = $
	
	for i=1 to meshes.count do
	(
			if classof(meshes[i].material) == Multimaterial then
			(
				for j=1 to meshes[i].material.count do
				(
					
					ExportMaterial l_MaterialsExported meshes[i].material[j] file 
				)
			)
			else
			(
				ExportMaterial l_MaterialsExported meshes[i].material file 
			)
	)
	
	format "</materials>\n" to:file
	
	close file
)
