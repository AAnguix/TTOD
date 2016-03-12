function GetLevelName =
(
	return "D:\\Game\\Data\\Level\\"
)

fn RelativePath _Path=
(
	local RelativePath = (_Path+"\\Data\\Level")
	return RelativePath
)

fn FileName file =
(
	return filenameFromPath file
)

fn FilePath file =
(
	return getFilenamePath file
)
	
function GetCores =
(
	return $*
)

function GetInstances =
(
	return $*
)

fn GetYaw transform =
(
	return degtorad(-(transform as eulerangles).z)
)

fn GetPitch transform =
(
	return degtorad(-(transform as eulerangles).y)
)

fn GetRoll transform =
(
	return degtorad((transform as eulerangles).x)
)

fn TranslationToRH translation =
(
	return point3 -translation.x translation.z translation.y
)

fn GlobalToLocals Obj vertex= 
(
	local world_transform=inverse (Obj.transform)
	local local_vertex=vertex*world_transform
	return local_vertex
)

fn DoesItExist _Path=
(
	if (not (doesfileexist _Path))then
	(
		makeDir _Path all:true
		return false
	)
	else(
		return true	
	)
)

fn GSG =
(
	--for o in geometry where (isKindOf o GeometryClass and canConvertTo o Editable_Mesh) collect o
	select geometry
	return $*
	
	
)

fn isLight =
(
	Local Obj = $selection.count
		if Obj <2 then
		(
			if superclassof $ == light then
			(
				return 1
			)
			else
			( 
				return 2
			)
		)
		else 
		(
			o =0
			for i=1 to Obj do
			( 
				Format "entramos % veces\n" i
				if superclassof $[i] == light do
				(o = o +1)
				Format "esto es o %\n" o
				Format "esto es obj %\n" obj
			)
			if o == Obj then(return 3)else(return 4)
		)
)


fn isGeometry =
(
	Local Obj = $selection.count
		if Obj <2 then
		(
			if superclassof $ == GeometryClass then
			(
				return 1
			)
			else
			( 
				return 2
			)
		)
		else 
		(
			o =0
			for i=1 to Obj do
			( 
				Format "entramos % veces\n" i
				if superclassof $[i] == GeometryClass do
				(o = o +1)
				Format "esto es o %\n" o
				Format "esto es obj %\n" obj
			)
			if o == Obj then(return 3)else(return 4)
		)
)

fn isCamera =
(
	Local Obj = $selection.count
		if Obj <2 then
		(
			if superclassof $ == camera then
			(
				return 1
			)
			else
			( 
				return 2
			)
		)
		else 
		(
			o =0
			for i=1 to Obj do
			( 
				
				if superclassof $[i] == camera do
				(o = o +1)
				Format "esto es o %\n" o
				Format "esto es obj %\n" obj
			)
			if o == Obj then(return 3)else(return 4)
		)
)

	fn isAnimatedGeometry =
(
	Local Obj = $selection.count
		if Obj <2 then
		(
			local key = $.position.controller.keys.count
			if superclassof $ == GeometryClass and key != 0 then
			(
				return 1
			)
			else
			( 
				return 2
			)
		)
		else 
		(
			o =0
			for i=1 to Obj do
			( 
				local key = $[i].position.controller.keys.count
				if superclassof $[i] == GeometryClass and key != 0 do
				(o = o +1)
				
			)
			if o == Obj then(return 3)else(return 4)
		)
)