extends Reference

var _size = 0
var _origin = Vector3(0, 0, 0)
var _children = []
var _is_filled = true

func set_size(size):
	_size = size

func get_size():
	return _size

func set_origin(origin):
	_origin = origin

func get_origin():
	return _origin

func has_children():
	return _children.size() > 0

func add_child(node):
	_children.append(node)

func clear():
	_children.clear()

func is_filled():
	return _is_filled

func set_voxels(voxels):
	if voxels.size() != _size:
		printerr("Invalid number of voxel depth: given %.2f expect %.2f" % [voxels.size(), _size.z])
		return
	
	var first_voxel = voxels[0][0][0]
	for z in voxels:
		if z.size() != _size:
			printerr("Invalid number of voxel row: given %.2f expect %.2f" % [z.size(), _size.y])
			return
		for y in z:
			if y.size() != _size:
				printerr("Invalid number of voxel column given %.2f expect %.2f" % [y.size(), _size.x])
				return
			for x in y:
				if x != first_voxel && _size != 1:
					_split(voxels)
					return
	# If come to this point and the first voxel was 0 then it means this node contains no voxel
	if first_voxel == 0:
		_is_filled = false

func _split(voxels):
	for ox in range(2):
		for oy in range(2):
			for oz in range(2):
				var octant = get_script().new()
				var half_size = _size/2
				var origin = Vector3(half_size*ox, half_size*oy, half_size*oz)
				octant.set_size(half_size)
				octant.set_origin(_origin+origin)
				var octant_voxels = Array()
				var cz = 0
				for vxz in range(origin.z, origin.z+half_size):
					octant_voxels.append(Array())
					var cy = 0
					for vxy in range(origin.y, origin.y+half_size):
						octant_voxels[cz].append(Array())
						for vxx in range(origin.x, origin.x+half_size):
							octant_voxels[cz][cy].append(voxels[vxz][vxy][vxx])
						cy += 1
					cz += 1
				octant.set_voxels(octant_voxels)
				add_child(octant)
