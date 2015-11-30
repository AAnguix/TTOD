rollout SetProperties "Properties" width:250 height:400
(
	GroupBox RenderGroupBox "Render" pos:[8,5] width:235 height:120
	checkbox ExportCheckBox "Export" pos:[20,25] width:60 height:20
	checkbox VisibleCheckBox "Visible" pos:[20,45] width:60 height:20
	checkbox LayerCheckBox "Layer" pos:[20,65] width:60 height:20
	listbox RenderExportListBox "" pos:[90,25] width:140 height:1
	listbox RenderLayerListBox "" pos:[90,64] width:140 height:1
	label AnimModelLabel "Anim. model" pos:[20,98] width:60 height:17
	
	GroupBox PhysicsGroupBox "Physics" pos:[8,136] width:235 height:70
	GroupBox LogicGroupBox "Logic" pos:[8,210] width:235 height:70
	checkbox GeneratePhysicsCheckBox "Generate" pos:[20,152] width:70 height:20
	checkbox LayerCheckBox2 "Layer" pos:[20,175] width:60 height:20
	listbox PhysicsGenerateListBox "" pos:[88,152] width:140 height:1
	listbox PhysicsLayerListBox "" pos:[88,176] width:140 height:1
	
	checkbox GenerateLogicCheckBox "Generate" pos:[20,228] width:70 height:20
	listbox LogicGenerateListBox "" pos:[90,227] width:140 height:1
	
	button GetButton "Get" pos:[10,370] width:80 height:20
	button SetButton "Set" pos:[158,370] width:80 height:20
	
	on GetButton pressed do
	(
		
	)
)

createDialog SetProperties

