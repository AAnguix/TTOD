filein "Functions.ms"

function ExportCameras _Path=
(
	local myPath = (RelativePath _Path)
	DoesItExist myPath
	local file = createfile (myPath+"\\Cameras.xml")
	
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<cameras> \n"  to:file
	select (for i in cameras where superclassof i == camera collect i)
	Local Obj = $selection.count
		if Obj <2 then
		(
			if getUserProp $ "Animated_Camera" == true then
			(
				format "<key_camera name=\"%\" filename=\"data/level/Cameras/%.xml\"/>\n" $.name $.name to:file
			)
		)
		else 
		(
			for j=1 to $selection.count do
			(
				if getUserProp $[j] "Animated_Camera" == true then
				(
					
					format "<key_camera name=\"%\" filename=\"data/level/Cameras/%.xml\"/>\n" $[j].name $[j].name to:file
				)else
				(
					local _pos = TranslationToRH $[j].pos
					local _lookat = TranslationToRH $[j].Target.pos
					local _fov = $[j].fov
					local _asp=(renderWidth as float)/renderHeight
					local _near = $[j].nearrange
					local _far = $[j].farrange
					format "<fixed_camera name=\"%\" position=\"% % %\" look_at=\"% % %\" fov=\"%\" aspect=\"%\" near=\"%\" far=\"%\"/>\n" $[j].name _pos.x _pos.y _pos.z _lookat.x _lookat.y _lookat.z _fov _asp _near _far to:file
						
				)
			)
		)
	format "</cameras>" to:file
	close file 
)