function GetLevelName =
(
	return "D:\\Game\\Data\\Level\\"
)

function GetStaticMeshesPath =
(
	return GetLevelName()+"\\meshes\\"
)

fn RelativePath =
(
	return "Game\\Data\\Level\\"
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
	return -(transform as eulerangles).z
)

fn GetPitch transform =
(
	return -(transform as eulerangles).y
)

fn GetRoll transform =
(
	return (transform as eulerangles).x
)

fn TranslationToRH translation =
(
	return point3 -translation.x translation.z translation.y
)