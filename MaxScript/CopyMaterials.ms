filein "Functions.ms"

function CopyMaterial MaterialsExported _Material _Path =
(
	format "\n % \n" _Path
	if (MaterialsExported.ContainsKey (_Material.name))==false then
	(
		
		local localpath = (openBitMap _Material.diffuseMap.bitmap.filename).fileName
		local localfile = filenameFromPath localpath
		local remotepath = (_Path+localfile)
		copyFile  localpath remotepath
		MaterialsExported.Add _Material.name MaterialsExported.count
	)
)	

function CopyMaterials  obj _Path=
(
	local myPath = (RelativePath _Path+"\\meshes\\")
	DoesItExist myPath
	format "\n % \n" myPath

	local l_MaterialsExported=dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	
	
	meshes = obj
	
	for i=1 to meshes.count do
	(
			if classof(meshes[i].material) == Multimaterial then
			(
				for j=1 to meshes[i].material.count do
				(
					
					CopyMaterial l_MaterialsExported meshes[i].material[j] myPath 
				)
			)
			else
			(
				CopyMaterial l_MaterialsExported meshes[i].material myPath
			)
	)

)

fn CopySceneMaterials _Path =
(
	select geometry
		CopyMaterials $ _Path
	
)