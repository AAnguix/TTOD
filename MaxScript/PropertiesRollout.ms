fileIn "Functions.ms"
if $selection.count <2 then (DialogName = $.name as string) else (DialogName = ($.count as string)+" objetos selecccionados")
--Global DialogName = $.name as string


rollout SetProperties "Box001" width:510 height:474
(
	
	GroupBox RenderGroupBox "Render" pos:[8,5] width:235 height:120
	checkbox ExportCheckBox "Export" pos:[20,25] width:60 height:20
	checkbox VisibleCheckBox "Visible" pos:[20,45] width:60 height:20
	checkbox LayerCheckBox "Layer" pos:[20,65] width:60 height:20
	dropdownList RenderExportListBox "" pos:[90,25] width:140 height:21
	dropdownList RenderLayerListBox "" pos:[90,64] width:140 height:21
	label AnimModelLabel "Anim. model" pos:[20,98] width:60 height:17
	edittext AnimModelText "" pos:[90,97] width:140 height:21 readOnly:true
	
	
	GroupBox PhysicsGroupBox "Physics" pos:[8,136] width:235 height:110
	checkbox GeneratePhysicsCheckBox "Generate" pos:[20,152] width:70 height:20
	checkbox PhysicsLayerCheckBox "Layer" pos:[20,216] width:60 height:20
	dropdownList PhysicsGenerateListBox "" pos:[88,152] width:140 height:21
	dropdownList PhysicsActorTypeBox "" pos:[88,180] width:140 height:21
	listbox PhysicsLayerListBox "" pos:[88,216] width:140 height:1
	
	GroupBox LogicGroupBox "Logic" pos:[8,250] width:235 height:53
	checkbox GenerateLogicCheckBox "Generate" pos:[20,278] width:70 height:20
	listbox LogicGenerateListBox "" pos:[90,278] width:140 height:1
	
	GroupBox LightsGroupBox "Lights" pos:[8,322] width:235 height:53
	checkbox LightExportCheckBox "Export" pos:[17,343] width:60 height:20
	checkbox ShadowMapCheckBox "Gen. ShadowMap" pos:[72,343] width:102 height:20
	checkbox LightStateCheckBox "Off State" pos:[178,343] width:61 height:20
	
	
	
	
	GroupBox CameraGroupBox "Camera" pos:[263,272] width:235 height:53
	radiobuttons CameraRadioButtons "CameraType" pos:[274,293] width:130 height:30 labels:#("cycle", "reverse") default:0 columns:2
	checkbox CameraAnimCheck "Anim" pos:[410,293] width:60 height:20
	
	button GetButton "Get" pos:[10,450] width:80 height:20
	button SetButton "Set" pos:[158,450] width:80 height:20
	
	GroupBox AnimatedModelGroupBox "Animated Model" pos:[263,8] width:235 height:53
	checkbox AnimatedModelCheck "Animated" pos:[276,33] width:120 height:20
	dropdownList AnimatedModelTypeList "Model Type" pos:[374,17] width:120 height:40 selection:1
	
	
	
	
	on SetProperties open do
	(
		
		--local GenerateList =# ("malla triangular", "forma convexa", "forma caja", "forma esfera", "forma plano", "forma cápsula")
		local GenerateList =# ("Box", "Sphere", "Capsule", "Plane")
		local ActorTypeList =# ("Static", "Dynamic", "Kinematic")
		local AnimatedModelList =# ("Basic", "Has Normal", "Has Enviroment", "Has N+E")
		AnimatedModelTypeList.items = AnimatedModelList
		PhysicsGenerateListBox.items=GenerateList
		PhysicsActorTypeBox.items= ActorTypeList
		local LayerList=#("solid", "alpha_objects","alpha_blend_objects", "particles")
		RenderLayerListBox.items=LayerList
		local _Lights = isLight()
		if ( _Lights ==2 or _Lights ==4) do
			(
				LightsGroupBox.visible = false
				LightExportCheckBox.visible = false
				ShadowMapCheckBox.visible = false
				LightStateCheckBox.visible = false
			)
		local _Camera = isCamera()
		if ( _Camera ==2 or _Camera ==4) do
			(
				CameraGroupBox.visible = false
				CameraRadioButtons.visible = false
				CameraAnimCheck.visible = false
			)
		local _Animated = isAnimatedGeometry()
		if ( _Animated ==2 or _Animated ==4) do
			(
				AnimatedModelGroupBox.visible = false
				AnimatedModelCheck.visible = false
				AnimatedModelTypeList.visble = false 
			)
			
		AnimModelText.text = classof $ as string
		

	)
	on GetButton pressed do
	(
		
		AnimModelText.text = classof $ as string
		local qty = $selection.count
		for i=1 to  qty do
		(
			if qty<2 do 
			(
				case of 
				(		
				(superclassof $ == GeometryClass):
					(
						if (getUserProp $ "Render_Visibility" != true) then( VisibleCheckBox.checked = false) 
						else (VisibleCheckBox.checked = true)
					)
				(superclassof $ == light):
					(
						if (getUserProp $ "export_light" != true) then( LightExportCheckBox.checked = false) 
						else (LightExportCheckBox.checked = true)
					)
				)	
			)
			

		)
	)
	on SetButton pressed do
	(
		
		if LayerCheckBox.checked do
			(
				Local Obj = $selection.count
				if Obj <2 then
				(
					setUserProp $ "layer" RenderLayerListBox.selected
				)else
				(
					for x= 1 to Obj do
					(
						setUserProp $[x] "layer" RenderLayerListBox.selected
					)
				)
				
				messagebox "Selected Object(s) Layer has been set" title:"ATTENTION"
			)
		if AnimatedModelCheck.checked do
			(
				Local Obj = $selection.count
				if Obj <2 then
				(
					setUserProp $ "Animated_Object" true
					setUserProp $ "Animated_Object_Type" AnimatedModelTypeList.selected
				)else
				(
					for x= 1 to Obj do
					(
						setUserProp $[x] "Animated_Object" true
						setUserProp $[x] "Animated_Object_Type" AnimatedModelTypeList.selected
					)
				)
				
				messagebox "Selected Object(s) set to Animated" title:"ATTENTION"
			)
		
		if CameraRadioButtons.state == 1 do
			(
				Local Obj = $selection.count
				if Obj <2 then
				(
					setUserProp $ "camera_type" "cycle"
				)else
				(
					for x= 1 to Obj do
					(
						setUserProp $[x] "camera_type" "cycle"
					)
				)
				messagebox "Selected Camera(s) set to cycle" title:"ATTENTION"
			)
			
		if CameraRadioButtons.state == 2 do
			(
				Local Obj = $selection.count
				if Obj <2 then
				(
					setUserProp $ "camera_type" "reverse"
				)else
				(
					for x= 1 to Obj do
					(
						setUserProp $[x] "camera_type" "reverse"
					)
				)
				messagebox "Selected Camera(s) set to reverse" title:"ATTENTION"
			)
			
		if CameraAnimCheck.checked do
			(
				Local Obj = $selection.count
				if Obj <2 then
				(
					setUserProp $ "Animated_Camera" true
				)else
				(
					for x= 1 to Obj do
					(
						setUserProp $[x] "Animated_Camera" true
					)
				)
				
				messagebox "Selected Camera(s) set to Animated" title:"ATTENTION"
			)
			
		if LightExportCheckBox.checked do
		(
			local _Lights = isLight()
			if ( _Lights ==1 or _Lights ==3) then
				(
					setUserProp $ "export_light" true
					messagebox "Selected Lights are going to be exported" title:"ATTENTION"
				)else
				(
					messagebox "Some selected objects are not lights" title:"ATTENTION"
				)
		)
		
		if LightStateCheckBox.checked do
		(
			local _Lights = isLight()
			if ( _Lights ==1 or _Lights ==3) then
				(
					setUserProp $ "light_state" false
					messagebox "Selected Lights are going to be set to OFF state" title:"ATTENTION"
				)else
				(
					messagebox "Some selected objects are not lights" title:"ATTENTION"
				)
		)
		
		
		if ShadowMapCheckBox.checked do
		(
			local _Lights = isLight()
			if ( _Lights ==1 or _Lights ==3) then
				(
					setUserProp $ "generate_shadow_map" true
					messagebox "Selected Lights are going to be exported" title:"ATTENTION"
				)else
				(
					messagebox "Some selected objects are not lights" title:"ATTENTION"
				)
		)
		
		
		if VisibleCheckBox.checked do 
		(
			local _Geometry = isGeometry()
			if ( _Geometry ==1 or _Geometry ==3) then
				(
					setUserProp $ "Render_Visibility" true
					messagebox "Visibility set to true" title:"ATTENTION"
				)else
				(
					messagebox "Some selected objects are not Geometry" title:"ATTENTION"
				)
		) 
		--Para verificar si se le ha quitado el check
		if (LightExportCheckBox.checked=false) do
		(
			local _Lights = isLight()
			if ( _Lights ==1 or _Lights ==3) then
				(
					setUserProp $ "export_light" false
					messagebox "Selected Lights are not to be exported" title:"ATTENTION"
				)else
				(
					messagebox "Some selected objects are not lights" title:"ATTENTION"
				)
		)
		
		if (VisibleCheckBox.checked=false) do 
		(
			local _Geometry = isGeometry()
			if ( _Geometry ==1 or _Geometry ==3) then
				(
					setUserProp $ "Render_Visibility" false
					messagebox "Visibility set to false" title:"ATTENTION"
				)else
				(
					messagebox "Some selected objects are not Geometry" title:"ATTENTION"
				)
		) 
		
		
	)
)
createDialog SetProperties