filein "Functions.ms"

function ExportStaticMeshes Cores _Path=
(
	local myPath = (RelativePath _Path)
	DoesItExist myPath
	local file = createfile (myPath+"\\StaticMeshes.xml")
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<static_meshes>\n" to:file 
	
	meshes= Cores
	local somepath = "Data\\Level\\meshes\\"
	for i=1 to meshes.count do
	(
		if (getuserprop meshes[i] "type" != "animated_model") then
		(
			format "\t<static_mesh name=\"%\" filename=\"%%.mesh\"/>\n" (meshes[i].name) somepath (meshes[i].name) to:file	
		)
	)
	format "</static_meshes>\n" to:file	
	close file
)

	
