filein "Functions.ms"

function ExportStaticMeshes =
(
	local file = createfile ((GetLevelName())+"StaticMeshes.xml") 
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<static_meshes>\n" to:file 
	meshes= GetCores()
	
	for i=1 to meshes.count do
	(
		format "\t<static_mesh name=\"%\" filename=\"%%\">\n" (meshes[i].name) (RelativePath()) (FileName meshes[i].material.diffuseMap.filename) to:file	
	)
	format "</static_meshes>\n" to:file	
	close file
)

ExportStaticMeshes()
	
