filein "Functions.ms"

Fn SphereBundle =
(
	local lMax = GlobalToLocals $ $.max
	print lMax
	local lCenter = GlobalToLocals $ $.center
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
		Tcenter = lCenter.x)
		local Radio = Tmax - Tcenter
	Format "esto es Tmax % \n esto es tcenter % \n este es el radio % \n" Tmax Tcenter Radio
	
	)
	
	SphereBundle()