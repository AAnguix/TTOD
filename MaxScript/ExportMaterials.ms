filein "Functions.ms"

function ExportMaterial MaterialsExported _Material _File =
(
	if (MaterialsExported.ContainsKey (_Material.name))==false then
	(
		format "\t<material name=\"%\">\n" _Material.name to:_File
		format "\t\t<texture filename=\"%\"/>\n" (_Material.diffuseMap.filename) to:_File
		format "\t</material>\n" to:_File
		MaterialsExported.Add _Material.name MaterialsExported.count
	)
)	

function ExportMaterials =
(
	local file = createfile "D:\Game\Data\Level\materials.xml"
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<materials>\n" to:file 
	local l_MaterialsExported=dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	
	meshes = GetCores()
	
	for i=1 to meshes.count do
	(
			if classof(meshes[i].material) == Multimaterial then
			(
				for j=1 to meshes[i].material.count do
				(
					--format "\t<material name=\"%\" filename=\"%\">\n" (meshes[i].material[z].name) (meshes[i].material[z].diffuseMap.filename) to:file
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

ExportMaterials()

