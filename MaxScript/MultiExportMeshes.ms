filein "Functions.ms"
filein "NormalsCorrector.ms"
filein "sphereB.ms"

function VertexType _int _MaterialCount obj =
(
	VertexValue = 37
	if _MaterialCount >1 then
	(
				if obj.material[_int].bumpMapEnable then
				(
					VertexValue = VertexValue + 768
				) 
				else if obj.material[_int].selfIllumMapEnable then
				(
					VertexValue = VertexValue + 64
				)
	)else
	(
		if obj.material.bumpMapEnable then
				(
					VertexValue = VertexValue + 768
				) 
				else if obj.material.selfIllumMapEnable then
				(
					VertexValue = VertexValue + 64
				)
	)
	return VertexValue	
)

function  WriteHeader _file =
(
	WriteShort _file 0xfe55 #unsigned
)

function  WriteFooter _file =
(
	WriteShort _file 0x55fe #unsigned
)

function ExportMeshMaterial _Material file =
(
	WriteShort file _Material.name.count #unsigned
	WriteString file _Material.name
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

function CreateFullVertexSimple Vtx Normal TUV = 
(
	local l_FullVertex=#()
	
	append l_FullVertex Vtx.x
	append l_FullVertex Vtx.y
	append l_FullVertex Vtx.z
	
	append l_FullVertex Normal.x
	append l_FullVertex Normal.y
	append l_FullVertex Normal.z
	
	UV2 = 1 - TUV.y 
	append l_FullVertex TUV.x
	append l_FullVertex UV2
	
	return l_FullVertex
)

function CreateFullVertexBump Vtx Normal TUV = 
(
	local l_FullVertex=#()
	
	append l_FullVertex Vtx.x
	append l_FullVertex Vtx.y
	append l_FullVertex Vtx.z
	
	append l_FullVertex Normal.x
	append l_FullVertex Normal.y
	append l_FullVertex Normal.z
	
	append l_FullVertex 0.0
	append l_FullVertex 0.0
	append l_FullVertex 0.0
	append l_FullVertex 0.0
	
	append l_FullVertex 0.0
	append l_FullVertex 0.0
	append l_FullVertex 0.0
	append l_FullVertex 0.0
	
	UV2 = 1 - TUV.y 
	append l_FullVertex TUV.x
	append l_FullVertex UV2
	
	
	return l_FullVertex
)


function ConvertVtx Vtx =
(
	local l_Text = stringstream ""
	local l_Value=""
	for i=1 to Vtx.count do
	( 
		format "%," Vtx[i] to:l_Text
	)
	return (l_Text as string)
)

function DotNetAddVertex Vtxs FullVtx VtxMap =
(
	local l_VtxString=ConvertVtx FullVtx
	local l_Idx=1
		if (VtxMap.ContainsKey (l_VtxString))==false then
	(
	append vtxs FullVtx
	l_Idx=vtxs.count-1
	VtxMap.Add l_VtxString l_Idx
	)
	else
	l_Idx=VtxMap.Item[l_VtxString]
	return l_Idx
)

function GetIndex Vertexs Vertex _MaterialId Dictionary =
(
	local l_Index=-1
	
	local l_VertexAsString=ConvertVtx Vertex
	
	if (Dictionary.ContainsKey (l_VertexAsString))==false then
	(
		l_Index = Vertexs[_MaterialId].count
		Dictionary.Add l_VertexAsString l_Index
		append Vertexs[_MaterialId] Vertex
	)
	else
	(
		
		l_Index=Dictionary.Item[l_VertexAsString]
	)
	
	return l_Index
)

function ExportSubMeshes Obj _file =
(
	local l_Vertexs=#()
	local l_Indexs=#()
	local l_VertexsDictionary=#()
	local l_VtxsMap=dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]"
	local l_MaterialsVertexType =#()
	
	local l_ConvertToTriangleMesh=(classof Obj!=Editable_mesh)
	local l_Obj=Obj
	if l_ConvertToTriangleMesh then
	(
		l_Obj=copy Obj
		convertToMesh l_Obj
	)
	
	UABCalcVertexsNormals l_Obj
	
	--Agregar la BoundingBox y la SphereBox
	BoundingBox l_Obj _file
	SphereBundle l_Obj _file
	
	local l_HasMultiMaterial=classof l_Obj.material==Multimaterial
	local l_MaterialCount=1
	if l_HasMultiMaterial then 
		l_MaterialCount=l_Obj.material.count
	
	for i=1 to l_MaterialCount do
	(
		append l_Vertexs #()
		append l_Indexs #()
		append l_VertexsDictionary (dotnetobject "System.Collections.Generic.Dictionary`2[System.String,System.Int16]")
		local _vertextype = VertexType i l_MaterialCount l_Obj
		append l_MaterialsVertexType _vertextype
	)	
	
	
	for i=1 to getNumFaces l_Obj do
	(
		local IdxsFace=getFace l_Obj i
		
		local l_MaterialId=getFaceMatID l_Obj i
		
		HasNormal = false
		HasLightMap = false
		
		if l_HasMultiMaterial ==true then
		(
			if l_Obj.material[l_MaterialId].bumpMapEnable then
			(
				HasNormal = true
			) 
			else if l_Obj.material[l_MaterialId].selfIllumMapEnable then
			(
				HasLightMap = true
			)	
		)
		else
		(
			l_MaterialId=1
			if l_Obj.material.bumpMapEnable then
			(
				HasNormal = true
			) 
			else if l_Obj.material.selfIllumMapEnable then
			(
				HasLightMap = true
			)
		)
	
		--GetMaterialInfo l_MaterialId &HasNormal &HasLightMap
		
		--Vértices de la cara
		local Vtx11=getVert l_Obj IdxsFace.x
		Vtx1 = GlobalToLocals l_Obj Vtx11
		Vtx1 = TranslationToRH Vtx1
		local Vtx21=getVert l_Obj IdxsFace.y
		Vtx2 = GlobalToLocals l_Obj Vtx21
		Vtx2 = TranslationToRH Vtx2
		local Vtx31=getVert l_Obj IdxsFace.z
		Vtx3 = GlobalToLocals l_Obj Vtx31
		Vtx3 = TranslationToRH Vtx3
		
		
		--Normales nuevas
		local FaceNormal=getFaceNormal l_Obj i
		local SmoothValue=getFaceSmoothGroup l_Obj i
		local Normal1=TranslationToRH(normalize (UABGetVertexNormal l_Obj IdxsFace.x SmoothValue FaceNormal)) 
		local Normal2=TranslationToRH(normalize (UABGetVertexNormal l_Obj IdxsFace.y SmoothValue FaceNormal)) 
		local Normal3=TranslationToRH(normalize (UABGetVertexNormal l_Obj IdxsFace.z SmoothValue FaceNormal)) 
			
		--Índices de las coordenadas de textura
		local IdxsMap=meshop.getMapFace l_Obj 1 i
		
		--Coordenadas de los vertices de la primera cara
		local TUVMap1= meshop.getMapVert l_Obj 1 IdxsMap.x
		local TUVMap2= meshop.getMapVert l_Obj 1 IdxsMap.y
		local TUVMap3= meshop.getMapVert l_Obj 1 IdxsMap.z
		
		if (HasNormal == true) then
		(
			local l_Vertex1=CreateFullVertexBump Vtx1 Normal1 TUVMap1
			local l_Vertex2=CreateFullVertexBump Vtx2 Normal2 TUVMap2
			local l_Vertex3=CreateFullVertexBump Vtx3 Normal3 TUVMap3
			
			--local l_Id1=DotNetAddVertex l_Vertexs[l_MaterialId] l_Vertex1 l_VtxsMap
			--local l_Id2=DotNetAddVertex l_Vertexs[l_MaterialId] l_Vertex2 l_VtxsMap
			--local l_Id3=DotNetAddVertex l_Vertexs[l_MaterialId] l_Vertex3 l_VtxsMap
			
			local l_Id1=GetIndex l_Vertexs l_Vertex1 l_MaterialId l_VertexsDictionary[l_MaterialId]
			local l_Id2=GetIndex l_Vertexs l_Vertex2 l_MaterialId l_VertexsDictionary[l_MaterialId]
			local l_Id3=GetIndex l_Vertexs l_Vertex3 l_MaterialId l_VertexsDictionary[l_MaterialId]
		)
		else
		(
			local l_Vertex1=CreateFullVertexSimple Vtx1 Normal1 TUVMap1
			local l_Vertex2=CreateFullVertexSimple Vtx2 Normal2 TUVMap2
			local l_Vertex3=CreateFullVertexSimple Vtx3 Normal3 TUVMap3		
		
			local l_Id1=GetIndex l_Vertexs l_Vertex1 l_MaterialId l_VertexsDictionary[l_MaterialId]
			local l_Id2=GetIndex l_Vertexs l_Vertex2 l_MaterialId l_VertexsDictionary[l_MaterialId]
			local l_Id3=GetIndex l_Vertexs l_Vertex3 l_MaterialId l_VertexsDictionary[l_MaterialId]
		)
		
		append l_Indexs[l_MaterialId] l_Id1
		append l_Indexs[l_MaterialId] l_Id2
		append l_Indexs[l_MaterialId] l_Id3
		
		
	)
	for i=1 to l_Vertexs.count do
	(
		format "vertex: % \n indices: % \n materiales: % \n" l_Vertexs.count l_indexs.count l_MaterialCount
		
		WriteShort _file l_MaterialsVertexType[i] #unsigend --Vertex type
		
		
		WriteShort _file l_Vertexs[i].count #unsigend
		
		for j=1 to l_Vertexs[i].count do
		(
			for k=1 to l_Vertexs[i][j].count do
			(
				WriteFloat _file l_Vertexs[i][j][k]
			)
		)
		
		WriteShort _file 16 #unsigend
		WriteShort _file l_Indexs[i].count #unsigend
		for z=1 to l_Indexs[i].count do
		(
			WriteShort _file l_Indexs[i][z] #unsigned
		)
	)
	if l_ConvertToTriangleMesh then
	(
		delete l_Obj
	)
)

--MAIN
function ExportMesh Obj _Path=
(
	format "Este es el obj: % \n" Obj.name
	local myPath = (RelativePath _Path+"\\meshes\\")
	DoesItExist myPath	
	local file=fopen (myPath+Obj.name+".mesh") "wb"

	WriteHeader file
	
	ExportMeshMaterials Obj file
	
	ExportSubMeshes Obj file
	
	WriteFooter file
	
	fclose file
)

--funcion para exportar toda la geometria
fn ExportSceneMeshes Cores _Path=
(
	for i=1 to Cores.count do
	(
		if (getuserprop Cores[i] "type" != "animated_model") then
		(
						
			ExportMesh Cores[i] _Path
		)
	)	

	
	)
	
fn GetMaterialInfo l_MaterialID &HasNormal &HasLightMap =
(
	
	
	
)