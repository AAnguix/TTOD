filein "Functions.ms"

function RenderableObjects  _RenderableObjects _Path=
(
	local myPath = (RelativePath _Path)
	DoesItExist myPath
	local file = createfile (myPath+"\\RenderableObjects.xml")
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<renderable_objects>\n" to:file
	format "<layer name=\"solid\" default=\"true\"/>\n" to:file
	format "<layer name=\"alpha_objects\"/>\n" to:file
	format "<layer name=\"alpha_blend_objects\"/>\n" to:file
	format "<layer name=\"skybox\"/>\n" to:file
	format "<layer name=\"particles\"/>\n" to:file
	
	
	meshes= _RenderableObjects
	
		for i = 1 to meshes.count  do
		(
			local attname = meshes[i][1].name
			local attcore = meshes[i][2]
			local tform = TranslationToRH meshes[i][1].transform.translation 
			local yaw = GetYaw meshes[i][1].transform
			local pitch = GetPitch meshes[i][1].transform
			local roll = GetRoll meshes[i][1].transform
			local visibility = meshes[i][1].visibility
		
		
			if (getuserprop meshes[i][1] "type" == "animated_model") then
			(
				format "<animated_model name=\"%\" model_name=\"%\" " attname attcore to:file 
			)else(
				format "<mesh_instance name=\"%\" core_name=\"%\" " attname attcore to:file 
			)
			
			if (getuserprop meshes[i][1] "layer" != undefined)then
			(
				local l_layer= getuserprop meshes[i][1] "layer"
				format "layer=\"%\" " l_layer to:file
			)
			
			format "pos=\"% % %\" yaw=\"%\" pitch=\"%\" roll=\"%\" " tform.x tform.y tform.z yaw pitch roll to:file
			
			if (getuserprop meshes[i][1] "visible" == "true") then
			(			
				format "visible=\"true\"/> \n" to:file
			)else(
				format "visible=\"%\"/> \n" visibility to:file 
			)		
		)	

	format "</renderable_objects>\n" to:file
	close file 	
)


