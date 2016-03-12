filein "Functions.ms"

Fn SphereBundle obj _file =
(
	local lMax = GlobalToLocals obj obj.max
			lMax = TranslationToRH lMax
	local lCenter = GlobalToLocals obj obj.center
			lCenter = TranslationToRH lCenter
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
	--WriteFloat _file Tcenter
	WriteFloat _file lCenter.x
	WriteFloat _file lCenter.y
	WriteFloat _file lCenter.z
	WriteFloat _file Radio
	)

fn BoundingBox obj _file=
(	
_min = TranslationToRH obj.min
_max = TranslationToRH obj.max

WriteFloat _file _min.x
WriteFloat _file _min.y
WriteFloat _file _min.z
WriteFloat _file _max.x
WriteFloat _file _max.y
WriteFloat _file _max.z	

)	
	