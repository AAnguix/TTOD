filein "Functions.ms"
	
function RenderableObjects  _Path=
(
	local file = createfile (_Path+"\\RenderableObjects.xml")
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<renderable_objects>\n" to:file
	select geometry
	meshes= $
	
	for i = 1 to meshes.count  do
	(
		local attname = meshes[i].name
		local tform = TranslationToRH meshes[i].transform.translation 
		local yaw = GetYaw meshes[i].transform
		local pitch = GetPitch meshes[i].transform
		local roll = GetRoll meshes[i].transform
		local visibility = meshes[i].visibility
		format "<mesh_instance name=\"%\" core_name=\"%\" pos=\"% % %\" yaw=\"%\"pitch=\"%\" roll=\"%\" visible=\"%\"/> \n" 	attname attname tform.x tform.y tform.z yaw pitch roll visibility to:file
	)
	format "</renderable_objects>\n" to:file
	close file 	
)


