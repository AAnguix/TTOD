filein "Functions.ms"

function ExportMaterial MaterialsExported _Material _File obj=
(
	if (MaterialsExported.ContainsKey (_Material.name))==false then
	(
		format "\t<material name=\"%\">\n" _Material.name to:_File
		format "\t\t<texture filename=\"%\"/>\n" (_Material.diffuseMap.filename) to:_File
		--format "\t\t<texture filename=\"%\"/>\n" (openBitMap obj.material.diffuseMap.bitmap.filename).fileName to:_File
		format "\t</material>\n" to:_File
		MaterialsExported.Add _Material.name MaterialsExported.count
	)
)	

function ExportMaterials _Path=
(
	DoesItExist _Path	
	local file = createfile (_Path+"\\Materials.xml")
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
					
					ExportMaterial l_MaterialsExported meshes[i].material[j] file meshes[i]
				)
			)
			else
			(
				ExportMaterial l_MaterialsExported meshes[i].material file meshes[i]
			)
	)
	
	format "</materials>\n" to:file
	
	close file
)

