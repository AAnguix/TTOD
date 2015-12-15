filein "Functions.ms"

function  WriteHeader _file =
(
	WriteShort _file 0xfe55 #unsigned
)

function  WriteFooter _file =
(
	WriteShort _file 0x55fe #unsigned
)


function ExportMesh Obj _Path=
(
	
	local myPath = (_Path+"\\meshes\\")
	DoesItExist myPath	
	local file=fopen (myPath+Obj.name+".mesh") "wb"

	WriteHeader file
	
	ExportMeshMaterials Obj file
	
	ExportSubMeshes Obj file
	
	WriteFooter file
	
	fclose file
)


function ExportMeshMaterials Obj file =
(
	if classof(Obj.material) == Standardmaterial then
	(
		WriteShort file 1 #unsigned 
		
		ExportMeshMaterial Obj.material file
	)
	else
	(
		WriteShort file Obj.material.count #unsigned 
		
		for i=1 to Obj.material.count do
		(
			ExportMeshMaterial Obj.material[i] file	
		)
	)
)

function ExportMeshMaterial _Material file =
(
	WriteShort file _Material.name.count #unsigned
	WriteString file _Material.name
)

function CreateFullVertex Vtx Normal TUV = 
(
	local l_FullVertex=#()
	
	append l_FullVertex Vtx.x
	append l_FullVertex Vtx.y
	append l_FullVertex Vtx.z
	
	append l_FullVertex Normal.x
	append l_FullVertex Normal.y
	append l_FullVertex Normal.z
	
	append l_FullVertex TUV.x
	append l_FullVertex TUV.y
	
	return l_FullVertex
)

function AreVertexsEqual Vertex1 Vertex2 =
(
	local l_Equal=false
	
	if Vertex1.count==Vertex2.count then
	(
		l_Equal=true
		for i=1 to Vertex1.count do
		(
			if Vertex1[i]!=Vertex2[i] then
				l_Equal=false
		)
	)
	return l_Equal
)

function GetIndex Vertexs Vertex _MaterialId =
(
	local l_Index=-1
	for i=1 to Vertexs[_MaterialId].count do
	(
		if AreVertexsEqual Vertex Vertexs[_MaterialId][i] then
		(
			l_Index=i-1
		)
	)
	if l_Index==-1 then
	(
		l_Index=Vertexs[_MaterialId].count
		append Vertexs[_MaterialId] Vertex
	)
	
	return l_Index
)	

function ExportSubMeshes Obj _file =
(
	local l_Vertexs=#()
	local l_Indexs=#()
		
	local l_ConvertToTriangleMesh=(classof Obj!=Editable_mesh)
	local l_Obj=Obj
	if l_ConvertToTriangleMesh then
	(
		l_Obj=copy Obj
		convertToMesh l_Obj
	)
	
	local l_HasMultiMaterial=classof l_Obj.material==Multimaterial
	local l_MaterialCount=1
	if l_HasMultiMaterial then 
		l_MaterialCount=l_Obj.material.count
	
	for i=1 to l_MaterialCount do
	(
		append l_Vertexs #()
		append l_Indexs #()
	)	
	for i=1 to getNumFaces l_Obj do
	(
		local IdxsFace=getFace l_Obj i
		
		local l_MaterialId=getFaceMatID l_Obj i
		
		if l_HasMultiMaterial==false then
			l_MaterialId=1
		
		--Vértices de la cara
		local Vtx11=getVert l_Obj IdxsFace.x
		Vtx1 = GlobalToLocals l_Obj Vtx11
		local Vtx21=getVert l_Obj IdxsFace.y
		Vtx2 = GlobalToLocals l_Obj Vtx21
		local Vtx31=getVert l_Obj IdxsFace.z
		Vtx3 = GlobalToLocals l_Obj Vtx31
		
		--Normales
		local Normal1=getNormal  l_Obj IdxsFace.x
		local Normal2=getNormal  l_Obj IdxsFace.y
		local Normal3=getNormal  l_Obj IdxsFace.z
		
		--Índices de las coordenadas de textura
		local IdxsMap=meshop.getMapFace l_Obj 1 i
		
		--Coordenadas de los vertices de la primera cara
		local TUVMap1= meshop.getMapVert l_Obj 1 IdxsMap.x
		local TUVMap2= meshop.getMapVert l_Obj 1 IdxsMap.y
		local TUVMap3= meshop.getMapVert l_Obj 1 IdxsMap.z
		
		local l_Vertex1=CreateFullVertex Vtx1 Normal1 TUVMap1
		local l_Vertex2=CreateFullVertex Vtx2 Normal2 TUVMap2
		local l_Vertex3=CreateFullVertex Vtx3 Normal3 TUVMap3
		
		local l_Id1=GetIndex l_Vertexs l_Vertex1 l_MaterialId
		local l_Id2=GetIndex l_Vertexs l_Vertex2 l_MaterialId
		local l_Id3=GetIndex l_Vertexs l_Vertex3 l_MaterialId
		
		append l_Indexs[l_MaterialId] l_Id1
		append l_Indexs[l_MaterialId] l_Id2
		append l_Indexs[l_MaterialId] l_Id3
	)
	for i=1 to l_Vertexs.count do
	(
		WriteShort _file 37 #unsigend --Vertex type
		WriteShort _file l_Vertexs[i].count #unsigend
		
		for j=1 to l_Vertexs[i].count do
		(
			for k=1 to l_Vertexs[i][j].count do
			(
				WriteFloat _file l_Vertexs[i][j][k]
			)
		)
	)
	for i=1 to l_Indexs.count do
	(	
		WriteShort _file 16 #unsigend
		WriteShort _file l_Indexs[i].count #unsigend
		for j=1 to l_Indexs[i].count do
		(
			WriteShort _file l_Indexs[i][j] #unsigned
		)
	)
	if l_ConvertToTriangleMesh then
	(
		delete l_Obj
	)
)

--funcion para exportar toda la geometria
fn ExportSceneMeshes _Path=
(
	select geometry
	for i=1 to $.count do
	(
		ExportMesh $[i] _Path
	)
	)	
	