filein "Functions.ms"

Fn SphereBundle obj _file =
(
	local lMax = GlobalToLocals obj obj.max
	local lCenter = GlobalToLocals obj obj.center
	local Tmax = 0
	local Tcenter = 0
	
	if lMax.x > lMax.y then
	(Tmax = lMax.x
	    Tcenter = lCenter.x )
	else(
	Tmax = lMax.y
	    Tcenter = lCenter.y 
		)
	if lMax.z > Tmax do
	(Tmax = lMax.z 
		Tcenter = lCenter.x
	)
	local Radio = Tmax - Tcenter
	WriteFloat _file Tcenter
	WriteFloat _file Radio
	)

fn BoundingBox obj _file =
(	
_min = obj.min
_max = obj.max

v1 = TranslationToRH (GlobalToLocals obj [_min.x,_min.y,_min.z])
WriteFloat _file v1.x
WriteFloat _file v1.y
WriteFloat _file v1.z
v2 = TranslationToRH (GlobalToLocals obj [_min.x,_min.y,_max.z])
WriteFloat _file v2.x
WriteFloat _file v2.y
WriteFloat _file v2.z
v3 = TranslationToRH (GlobalToLocals obj [_min.x,_max.y,_min.z])
WriteFloat _file v3.x
WriteFloat _file v3.y
WriteFloat _file v3.z
v4 = TranslationToRH (GlobalToLocals obj [_min.x,_max.y,_max.z])
WriteFloat _file v4.x
WriteFloat _file v4.y
WriteFloat _file v4.z
v5 = TranslationToRH (GlobalToLocals obj [_max.x,_min.y,_min.z])
WriteFloat _file v5.x
WriteFloat _file v5.y
WriteFloat _file v5.z
v6 = TranslationToRH (GlobalToLocals obj [_max.x,_min.y,_max.z])
WriteFloat _file v6.x
WriteFloat _file v6.y
WriteFloat _file v6.z
v7 = TranslationToRH (GlobalToLocals obj [_max.x,_max.y,_min.z])
WriteFloat _file v7.x
WriteFloat _file v7.y
WriteFloat _file v7.z
v8 = TranslationToRH (GlobalToLocals obj [_max.x,_max.y,_max.z])
WriteFloat _file v8.x
WriteFloat _file v8.y
WriteFloat _file v8.z
)	
	