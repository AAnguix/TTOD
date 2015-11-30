utility Exporter "Exporter" width:180 height:316
(
	button SetPathButton "Set Path" pos:[5,16] width:160 height:25 enabled:true
	checkbox ExportMeshCheckBox "Export Mesh" pos:[5,85] width:93 height:20
	checkbox CopyTexturesCheckBox "Copy textures" pos:[4,105] width:93 height:20
	dropdownList LevelsDropDownList "" pos:[2,126] width:150 height:21 enabled:true selection:1
	GroupBox ExportGroupBox "Export" pos:[5,155] width:150 height:130
	button LightsButton "Lights" pos:[15,170] width:60 height:20
	button MeshButton "Mesh" pos:[80,170] width:60 height:20
	button CameraButton "Camera" pos:[15,195] width:60 height:20
	button StaticMeshManagerButton "Static Mesh Manager" pos:[15,220] width:130 height:20
	button CloseButton "Close" pos:[50,292] width:60 height:20
	button SceneButton "Scene" pos:[15,245] width:130 height:20
	edittext PathText "" pos:[3,49] width:160 height:25 readOnly:true
	
	on Exporter open do
	(
		PathText.text ="D:Game\\Data\\Level"
		
		local levels=#("","level1","level2","main menu","select player")
		LevelsDropDownList.items=levels
	)
	
	on SetPathButton pressed do
	(
		local data_path=getSavePath caption:"Data path" initialDir:PathText.text 
		
		if data_path!=undefined then 
		(
			PathText.text=data_path
		)
	)
	
	on CloseButton pressed do
	(   
	
	)
)
