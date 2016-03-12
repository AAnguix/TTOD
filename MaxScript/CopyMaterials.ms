filein "Functions.ms"

function CopyMaterial MaterialsExported _Material _Path =
(
	
	if (MaterialsExported.ContainsKey (_Material.name))==false then
	(
		
		if (_Material.diffuseMapEnable == true)do
		(
			local localpath = (openBitMap _Material.diffuseMap.bitmap.filename).fileName
			local localfile = filenameFromPath localpath
			local remotepath = (_Path+localfile)
			copyFile  localpath remotepath			
		)
		if (_Material.selfIllumMapEnable == true) do
		(
			local localpath = (openBitMap _Material.selfIllumMap.bitmap.filename).fileName
			local localfile = filenameFromPath localpath
			local remotepath = (_Path+localfile)
			copyFile  localpath remotepath			
		)
		if (_Material.specularLevelMapEnable == true) do
		(
			local localpath = (openBitMap _Material.specularLevelMap.bitmap.filename).fileName
			local localfile = filenameFromPath localpath
			local remotepath = (_Path+localfile)
			copyFile  localpath remotepath
		)
		if (_Material.bumpMapEnable  == true) do
		(
			local localpath = (openBitMap _Material.bumpmap.normal_map.bitmap.filename).fileName  --ASI SE EXPORTA PARA LAS ARTISTAS
			--local localpath = (openBitMap _Material.bumpmap.bitmap.filename).fileName			
			local localfile = filenameFromPath localpath
			local remotepath = (_Path+localfile)
			copyFile  localpath remotepath
		)	
		if (_Material.ReflectionMapEnable == true) do
		(
			local localpath = (openBitMap _Material.ReflectionMap.bitmap.filename).fileName
			local localfile = filenameFromPath localpath
			local remotepath = (_Path+localfile)
			copyFile  localpath remotepath
		)
		MaterialsExported.Add _Material.name MaterialsExported.count
	)


)	

function CopyMaterials  obj _Path=
(
	local myPath = (RelativePath _Path+"\\meshes\\")
	DoesItExist myPath
	format "\n % \n" myPath

	local l_MaterialsExported=dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	
	
	--meshes = obj
	meshes = $selection
	
	
		
	if  meshes == 1 then 
	(
		if (getuserprop meshes "type" != "animated_model") do
		(
			if classof(meshes.material) == Multimaterial then
				(
					for j=1 to meshes.material.count do
					(
						
						CopyMaterial l_MaterialsExported meshes.material[j] myPath 
					)
				)
				else
				(
					CopyMaterial l_MaterialsExported meshes.material myPath
				)
		)
			
	)else(
		
		for i=1 to meshes.count do
		(
			
			if (getuserprop meshes[i] "type" != "animated_model") do
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
	)
	
	

)

fn CopySceneMaterials _Path =
(
	select geometry
		CopyMaterials $ _Path
	
)