fileIn "Functions.ms"
if $selection.count <2 then (DialogName = $.name as string) else (DialogName = ($.count as string)+" objetos selecccionados")
--Global DialogName = $.name as string


rollout SetProperties DialogName width:250 height:400
(
	
	GroupBox RenderGroupBox "Render" pos:[8,5] width:235 height:120
	checkbox ExportCheckBox "Export" pos:[20,25] width:60 height:20
	checkbox VisibleCheckBox "Visible" pos:[20,45] width:60 height:20
	checkbox LayerCheckBox "Layer" pos:[20,65] width:60 height:20
	dropdownList RenderExportListBox "" pos:[90,25] width:140 height:21
	dropdownList RenderLayerListBox "" pos:[90,64] width:140 height:21
	label AnimModelLabel "Anim. model" pos:[20,98] width:60 height:17
	edittext AnimModelText "" pos:[90,97] width:140 height:21 readOnly:true
	
	
	GroupBox PhysicsGroupBox "Physics" pos:[8,136] width:235 height:70
	checkbox GeneratePhysicsCheckBox "Generate" pos:[20,152] width:70 height:20
	checkbox LayerCheckBox2 "Layer" pos:[20,175] width:60 height:20
	dropdownList PhysicsGenerateListBox "" pos:[88,152] width:140 height:21
	listbox PhysicsLayerListBox "" pos:[88,176] width:140 height:1
	
	GroupBox LogicGroupBox "Logic" pos:[8,210] width:235 height:53
	checkbox GenerateLogicCheckBox "Generate" pos:[20,228] width:70 height:20
	listbox LogicGenerateListBox "" pos:[90,227] width:140 height:1
	
	GroupBox LightsGroupBox "Lights" pos:[8,272] width:235 height:53
	checkbox LightExportCheckBox "Export" pos:[17,293] width:60 height:20	
	
	button GetButton "Get" pos:[10,370] width:80 height:20
	button SetButton "Set" pos:[158,370] width:80 height:20
	
	on SetProperties open do
	(
		
		local GenerateList =# ("malla triangular", "forma convexa", "forma caja", "forma esfera", "forma plano", "forma cápsula")
		PhysicsGenerateListBox.items=GenerateList
		local LayerList=#("solid", "alpha_objects","alpha_blend_objects", "particles")
		RenderLayerListBox.items=LayerList
		local _Lights = isLight()
		if ( _Lights ==2 or _Lights ==4) do
			(
				LightsGroupBox.visible = false
				LightExportCheckBox.visible = false
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