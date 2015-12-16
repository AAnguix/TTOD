fileIn "Functions.ms"
fileIn "ExportMeshes.ms"
filein "ExportStaticMeshes.ms"
fileIn "ExportRenderableObjetcs.ms"
fileIn "ExportMaterials.ms"
fileIn "CopyMaterials.ms"
fileIn "ExportLights.ms"

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
	button MaterialsButton "Materials" pos:[80,195] width:60 height:20
	button StaticMeshManagerButton "Static Mesh Manager" pos:[15,220] width:130 height:20
	button SceneButton "Scene" pos:[15,245] width:130 height:20
	edittext PathText "" pos:[3,49] width:160 height:25 readOnly:true
	
	
	on Exporter open do
	(
		PathText.text ="D:\\Game\\Data\\Level"
		
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
	
	on LightsButton pressed do
	(   
		ExportLights PathText.text
	)
	
	on MeshButton pressed do
	(   
		local _Geometry = isGeometry()
			if ( _Geometry ==1 or _Geometry ==3) then
				(	
					case of
					(
						( _Geometry ==1):
						(
							ExportMesh $ PathText.text
							messagebox "Mesh Exported" title:"ATTENTION"
						)
						( _Geometry ==3):
						(
							for i=1 to $.count do
							(
								ExportMesh $[i] PathText.text
							)
							messagebox "Meshes Exported" title:"ATTENTION"
						)
					)
					
				)else
				(
					messagebox "Some selected objects are not Geometry" title:"ATTENTION"
				)
		
	)
	
	on CameraButton pressed do
	(   
		RenderableObjects PathText.text
	)
	
	on MaterialsButton pressed do
	(   
		ExportMaterials PathText.text
	)
	
	on StaticMeshManagerButton pressed do
	(   
		
		ExportStaticMeshes PathText.text
	)
	
	on SceneButton pressed do
	(   
		ExportSceneMeshes PathText.text
		ExportLights PathText.text
		RenderableObjects PathText.text
		ExportStaticMeshes PathText.text
		ExportMaterials PathText.text
		CopySceneMaterials PathText.text
	)
	
)


fn VerifyExportMeshCheck =
(
	if ExportMeshCheckBox.checked do
	(
		local _Geometry = isGeometry()
			if ( _Geometry ==1 or _Geometry ==3) then
				(	
					case of
					(
						( _Geometry ==1):
						(
							ExportMesh $ PathText.text
							messagebox "Mesh Exported" title:"ATTENTION"
						)
						( _Geometry ==3):
						(
							for i=1 to $.count do
							(
								ExportMesh $[i] PathText.text
							)
							messagebox "Meshes Exported" title:"ATTENTION"
						)
					)
					
				)else
				(
					messagebox "Some selected objects are not Geometry" title:"ATTENTION"
				)
	)
)

fn VerifyCopyTexturesCheck =
(
	if ExportMeshCheckBox.checked do
	(
		CopyMaterials  $selection PathText.text
		messagebox "Materials copied" title:"ATTENTION"
	)
)