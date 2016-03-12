filein "Functions.ms"
function ExportLights  _Path=
(
	local myPath = (RelativePath _Path)
	DoesItExist myPath
	local file = createfile (myPath+"\\Lights.xml")
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<lights ambient = \"0.1 0.1 0.1 0.1\" fog_color = \"0.1 0.1 0.2 0.0\" fog_start = \"15.0\" fog_end = \"70.0\" fog_density = \"0.05\">\n" to:file
	
	myLights= GetCores()
	for i=1 to myLights.count do
	(
		if getUserProp myLights[i] "export_light" == true do
		(
			local LightState = true
			if getUserProp myLights[i] "light_state" == false do
				(
					LightState = false
				)
			
			local attname = myLights[i].name
			local Lighttype = myLights[i].type
			local tform = TranslationToRH myLights[i].transform.translation
			local Lightcolor = myLights[i].rgb
			local attstart = myLights[i].farAttenStart
			local attend = myLights[i].farAttenEnd
			local intensity = myLights[i].multiplier		
			case  of
			(
				(Lighttype == #targetDirect or Lighttype == #freeDirect): 
					(
						if Lighttype== #freeDirect then
						(
							local basedir=TranslationToRH (myLights[i].pos+((point3 0 0 -1) * myLights[i].transform.rotation))
							local dir = basedir - tform
							dir = normalize dir
							
						)else(
							local dir=(myLights[i].target.pos-myLights[i].pos)
							dir = normalize dir
						)
						
						if (getuserprop myLights[i] "generate_shadow_map" == true)then
							(
								format "\t<light name=\"%\" active =\"%\" type=\"Directional\" pos=\"% % %\" dir=\"% % % \" color=\"% % %\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\" generate_shadow_map=\"true\" shadow_map_width=\"1024\" shadow_map_height=\"1024\" shadow_texture_mask=\"./data/textures/shadow_mask.tga\" ortho_shadow_map_size=\"30.0 40.0\"> \n" 	attname LightState tform.x tform.y tform.z dir.x dir.y dir.z (Lightcolor.r/255) (Lightcolor.g/255) (Lightcolor.b/255) attstart attend intensity to:file
									if (getuserprop myLights[i] "Layer" != undefined)then
									(
										local l_layer= getuserprop myLights[i] "Layer"
										format "\t\t<layer layer=\"%\"/>\n" l_layer to:file
									)
							)else
							(
								format "\t<light name=\"%\" active =\"%\" type=\"Directional\" pos=\"% % %\" dir=\"% % % \" color=\"% % %\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\"> \n" 	attname LightState tform.x tform.y tform.z dir.x dir.y dir.z (Lightcolor.r/255) (Lightcolor.g/255) (Lightcolor.b/255) attstart attend intensity to:file
								
							)
							format "\t</light>\n" to:file
						
					)
				(Lighttype == #targetSpot or Lighttype == #freeSpot ): 
					(
						
						local hotspot = myLights[i].hotspot
						local _Falloff = myLights[i].Falloff
						
						if Lighttype== #freeSpot then
						(
							local basedir=TranslationToRH (myLights[i].pos+((point3 0 0 -1) * myLights[i].transform.rotation))
							local dir = basedir - tform
							dir = normalize dir
							--dir = normalize dir
						)else(
							local dir=(myLights[i].target.pos-myLights[i].pos)
							dir = normalize dir
						)
						
						if (getuserprop myLights[i] "generate_shadow_map" == true)then
							(
								format "\t<light name=\"%\" active =\"%\" type=\"Spot\" pos=\"% % %\" dir=\"% % %\" color=\"% % %\" angle=\"%\" fall_off=\"%\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\" generate_shadow_map=\"true\" shadow_map_width=\"1024\" shadow_map_height=\"1024\" shadow_texture_mask=\"./data/textures/shadow_mask.tga\" ortho_shadow_map_size=\"30.0 40.0\"> \n" 	attname LightState tform.x tform.y tform.z dir.x dir.y dir.z (Lightcolor.r/255) (Lightcolor.g/255) (Lightcolor.b/255) hotspot _Falloff attstart attend intensity to:file
									if (getuserprop myLights[i] "Layer" != undefined)then
									(
										local l_layer= getuserprop myLights[i] "Layer"
										format "\t\t<layer layer=\"%\"/>\n" l_layer to:file
									)
							)else
							(
								format "\t<light name=\"%\" active =\"%\" type=\"Spot\" pos=\"% % %\" dir=\"% % %\" color=\"% % %\" angle=\"%\" fall_off=\"%\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\"> \n" 	attname LightState tform.x tform.y tform.z dir.x dir.y dir.z (Lightcolor.r/255) (Lightcolor.g/255) (Lightcolor.b/255) hotspot _Falloff attstart attend intensity to:file
								
							)
							format "\t</light>\n" to:file
					)
				(Lighttype == #omni): 
					(
						
						
						if (getuserprop myLights[i] "generate_shadow_map" == true)then
							(
								format "\t<light name=\"%\" active =\"%\" type=\"Omni\" pos=\"% % %\" color=\"% % %\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\" generate_shadow_map=\"true\" shadow_map_width=\"1024\" shadow_map_height=\"1024\" shadow_texture_mask=\"./data/textures/shadow_mask.tga\" ortho_shadow_map_size=\"30.0 40.0\"> \n"  	attname LightState tform.x tform.y tform.z (Lightcolor.r/255) (Lightcolor.g/255) (Lightcolor.b/255) attstart attend intensity to:file
									if (getuserprop myLights[i] "Layer" != undefined)then
									(
										local l_layer= getuserprop myLights[i] "Layer"
										format "\t\t<layer layer=\"%\"/>\n" l_layer to:file
									)
							)else
							(
								format "\t<light name=\"%\" active =\"%\" type=\"Omni\" pos=\"% % %\" color=\"% % %\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\"> \n" 	attname LightState tform.x tform.y tform.z (Lightcolor.r/255) (Lightcolor.g/255) (Lightcolor.b/255) attstart attend intensity to:file
								
							)
							format "\t</light>\n" to:file
					)
			)
		)
	)
	format "</lights>\n" to:file
	close file 	
	
)


t ="D:\\3DS\\Castillo\\light1"