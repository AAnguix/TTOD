filein "Functions.ms"

function AnimatedObjectExport _Path=
(
	local myPath = (RelativePath _Path)
	DoesItExist myPath
	local file = createfile (myPath+"\\CinematicObjects.xml")
	local duration = animationrange.end/framerate
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<cinematic name=\"windmillmove\" duration=\"%\"> \n" duration to:file
	AnimatedObjects= GetCores()
	for i=1 to AnimatedObjects.count do
	(
		if getUserProp AnimatedObjects[i] "Animated_Object" == true do
		(
			local attname = AnimatedObjects[i].name
			format "<cinematic_object resource=\"%\" renderable_objects_manager=\"solid\">\n" attname to:file
			--j = 1
			local _time = 0 as float
			at time 0 tform = TranslationToRH AnimatedObjects[i].transform.translation 
			at time 0 yaw = GetYaw AnimatedObjects[i].transform
			at time 0 pitch = GetPitch AnimatedObjects[i].transform
			at time 0 roll = GetRoll AnimatedObjects[i].transform
			at time 0 _scale = TranslationToRH AnimatedObjects[i].scale
				
				format "<cinematic_object_key_frame time=\"%\" pos=\"% % %\" yaw=\"%\" pitch=\"%\" roll=\"%\" scale=\"% % %\"/>\n" _time tform.x tform.y tform.z yaw pitch roll _scale.x _scale.y _scale.z to:file
				
			
			key_frame=at time 0 trackbar.getNextKeyTime()	
			
			 while key_frame != 0f do
			(
				
				local _time = key_frame/framerate
				at time key_frame tform = TranslationToRH AnimatedObjects[i].transform.translation 
				at time key_frame yaw = GetYaw AnimatedObjects[i].transform
				at time key_frame pitch = GetPitch AnimatedObjects[i].transform
				at time key_frame roll = GetRoll AnimatedObjects[i].transform
				at time key_frame _scale = TranslationToRH AnimatedObjects[i].scale
				
				format "<cinematic_object_key_frame time=\"%\" pos=\"% % %\" yaw=\"%\" pitch=\"%\" roll=\"%\" scale=\"% % %\"/>\n" _time tform.x tform.y tform.z yaw pitch roll _scale.x _scale.y _scale.z to:file
				j = key_frame
				key_frame=at time j trackbar.getNextKeyTime()
			)
			format "</cinematic_object>\n" to:file
		)
	)
	
	format "</cinematic>" to:file
	close file 
)