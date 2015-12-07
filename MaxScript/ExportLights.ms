filein "Functions.ms"

function ExportLights  _Path=
(
	DoesItExist _Path	
	local file = createfile (_Path+"\\Lights.xml")
	format "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" to:file
	format "<lights>\n" to:file
	--Para exportar todas las luces
	--select (for i in lights where superclassof i == light collect i)
	
	--Para exportar solo las luces seleccionadas con el menu propiedades
	select (for i in lights where getUserProp i "export_light" == true collect i)
	myLights= $
	
	for i = 1 to myLights.count  do
	(
		local attname = myLights[i].name
		local Lighttype = myLights[i].type
		local tform = TranslationToRH myLights[i].transform.translation
		local Lightcolor = myLights[i].rgb
		local attstart = myLights[i].farAttenStart
		local attend = myLights[i].farAttenEnd
		local intensity = myLights[i].multiplier		
		case  of
		(
			(Lighttype == #targetDirect): 
				(
					local dir=(myLights[i].target.pos-myLights[i].pos)
					format "<light name=\"%\" type=\"%\" pos=\"% % %\" dir=\"% % %\" color=\"% % %\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\"/> \n" 	attname Lighttype tform.x tform.y tform.z dir.x dir.y dir.z Lightcolor.r Lightcolor.g Lightcolor.b attstart attend intensity to:file
				)
			(Lighttype == #targetSpot): 
				(
					local dir=(myLights[i].target.pos-myLights[i].pos)
					local hotspot = myLights[i].hotspot
					local _Falloff = myLights[i].Falloff
					format "<light name=\"%\" type=\"%\" pos=\"% % %\" dir=\"% % %\" color=\"% % %\" angle=\"%\" fall_off=\"%\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\"/> \n" 	attname Lighttype tform.x tform.y tform.z dir.x dir.y dir.z Lightcolor.r Lightcolor.g Lightcolor.b hotspot _Falloff attstart attend intensity to:file
				)
			(Lighttype == #omni or Lighttype == #freeSpot or Lighttype == #freeDirect): 
				(
					format "<light name=\"%\" type=\"%\" pos=\"% % %\" color=\"% % %\" att_start_range=\"%\" att_end_range=\"%\" intensity=\"%\"/> \n" 	attname Lighttype tform.x tform.y tform.z Lightcolor.r Lightcolor.g Lightcolor.b attstart attend intensity to:file
				)
		)
	)
	format "</lights>\n" to:file
	close file 	
)


