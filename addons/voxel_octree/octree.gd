tool
extends MeshInstance

var OctreeNode = load("res://addons/voxel_octree/octree_node.gd")

export(String, FILE, "*.json") var source setget set_source
export(float, 0.0, 100.0) var resolution = 1.0 setget set_resolution

var _size = 16
var _shapes = Array()
var _voxels = Array()
var _octree = OctreeNode.new()

func _ready():
	_read_source()

func set_source(new_source):
	source = new_source
	_read_source()

func set_resolution(new_resolution):
	resolution = new_resolution
	_octree_to_mesh()

func _read_source():
	if source == null: return

	var file = File.new()
	file.open(source, File.READ)
	
	var p = JSON.parse(file.get_as_text())
	if p.error != OK || typeof(p.result) != TYPE_DICTIONARY:
		return
	
	var struct = p.result
	
	_size   = struct["size"]
	_shapes = struct["shapes"]
	
	_voxels.clear()
	for z in range(_size):
		var y_array = Array()
		for y in range(_size):
			var x_array = Array()
			for x in range(_size):
				x_array.append(0)
			y_array.append(x_array)
		_voxels.append(y_array)
	
	for shape in _shapes:
		if shape.type == "cube":
			_draw_cube(shape)
	
	_voxels_to_octree()

func _set_voxel(position, value):
	if position.x < 0 || position.y < 0 || position.z < 0:
		return
	if position.x >= _size || position.y >= _size || position.z >= _size:
		return
	_voxels[position.z][position.y][position.x] = value

func _draw_cube(shape):
	for x in range(shape.position[0], shape.position[0] + shape.extent[0]):
		for y in range(shape.position[1], shape.position[1] + shape.extent[1]):
			for z in range(shape.position[2], shape.position[2] + shape.extent[2]):
				if shape.has("invert") && shape.invert:
					_set_voxel(Vector3(x, y, z), 0)
				else:
					_set_voxel(Vector3(x, y, z), 1)

func _voxels_to_octree():
	_octree.clear()
	_octree.set_size(_size)
	_octree.set_voxels(_voxels)
	
	_octree_to_mesh()

func _octree_to_mesh():
	mesh = ArrayMesh.new()
	var surf_tool = SurfaceTool.new()
	
	surf_tool.begin(ArrayMesh.PRIMITIVE_TRIANGLES)
	
	_octree_to_mesh_recurse(surf_tool, _octree)
	
	surf_tool.generate_normals()
	surf_tool.index()

	surf_tool.commit(mesh)

func _octree_to_mesh_recurse(surf_tool, node):
	if !node.is_filled():
		return
	
	if !node.has_children():
		var x_origin = node.get_origin().x*resolution
		var y_origin = node.get_origin().y*resolution
		var z_origin = node.get_origin().z*resolution
		var x_corner = x_origin + node.get_size()*resolution
		var y_corner = y_origin + node.get_size()*resolution
		var z_corner = z_origin + node.get_size()*resolution
		# Front Face
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_corner))
		# Back Face
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_origin))
		#Top Face
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_origin))
		#Bottom Face
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_corner))
		#Right Face
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_corner, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_corner, y_origin, z_corner))
		#Left Face
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_origin))
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_corner))
		surf_tool.add_vertex(Vector3(x_origin, y_origin, z_corner))
		surf_tool.add_vertex(Vector3(x_origin, y_corner, z_origin))
	else:
		for child in node._children:
			_octree_to_mesh_recurse(surf_tool, child)