fn CoreCheck _obj Cores RenderableObjects =
(
	
	core_result = false
	for j =1 to Cores.count do
			(
				
				core_result = areNodesInstances _obj Cores[j]
				if core_result == true do
				(
					append RenderableObjects #(_obj, Cores[j].name)
					return true
				)
			)
	return core_result
)


fn CoreAndRenderable &l_Cores &l_RenderableObjects = 
(	
	--local l_Cores=#()
	--local l_RenderableObjects=#()


	select geometry
	obj = $selection

	for i=1 to obj.count do
	(
		
		
		local _instance = InstanceMgr.GetInstances Obj[i] &instances
		
		if _instance < 2 then
		(
			append l_Cores obj[i]
			
			append l_RenderableObjects #(obj[i], obj[i].name)
		)
		else(
				local result = CoreCheck obj[i] l_Cores l_RenderableObjects
				if result == false do
				(
					append l_Cores obj[i]
					append l_RenderableObjects #(obj[i], obj[i].name)
				)
			
		)
	)
	
)
