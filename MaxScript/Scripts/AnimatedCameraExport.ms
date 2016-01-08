filein "Functions.ms"


function AnimatedCameraExport  _Path=
(
	AnimatedCamera= GetCores()
	for i=1 to AnimatedCamera.count do
	(
		if getUserProp AnimatedCamera[i] "Animated_Camera" == true do
		(
			local myPath = (RelativePath _Path+"\\Cameras\\")
			DoesItExist myPath
			local file = createfile (myPath+AnimatedCamera[i].name+".xml")
			format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
			format "<camera_key_controller name=\"%\"> \n" AnimatedCamera[i].name to:file
			keys = AnimatedCamera[i].position.controller.keys.count
	
			for j =1 to keys do
			(
				key_time = AnimatedCamera[i].position.controller.keys[j].time
				at time key_time current_pos = TranslationToRH AnimatedCamera[i].pos
				at time key_time current_lookat = TranslationToRH AnimatedCamera[i].Target.pos
				at time key_time current_fov = AnimatedCamera[i].fov
				at time key_time current_near = AnimatedCamera[i].nearrange
				at time key_time current_far = AnimatedCamera[i].farrange
				format "<key time=\"%\" pos=\"% % %\" look_at=\"% % %\" fov=\"%\" near_plane=\"%\" far_plane=\"%\"/> \n" key_time current_pos.x current_pos.y current_pos.z current_lookat.x current_lookat.y current_lookat.z  current_fov current_near current_far to: file
			)
			format "</camera_key_controller> \n" to:file
			close file 
		)
	)		
)



