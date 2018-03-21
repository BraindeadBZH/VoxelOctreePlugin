# Voxel Octree
Voxel Octree is an easy to use Godot Engine plugin to create voxel based meshes.
The plugin use an octree to optimize the rendering and a procedural language, based on JSON, to quickly create shapes.

## How to use
After installing the plugin, through the AssetLib or manually, just search for the 'VoxelOctree' node under Spatial/VisualInstance/GeometryInstance/MeshInstance.
Once the node is added to your scene, you can select your shape file with the source parameter and the shape will appear in the editor.
The second parameter called 'Resolution' is to give the size of a voxel in Godot's 3D unit.

## How to write shape
Here is an example of shape to draw a chair:
``` json
{
  "size" : 16,
  "shapes": [
    {"type": "cube", "position": [0,  0, 0], "extent": [1, 16, 1]},
    {"type": "cube", "position": [7,  0, 0], "extent": [1, 16, 1]},
    {"type": "cube", "position": [7,  0, 7], "extent": [1,  6, 1]},
    {"type": "cube", "position": [0,  0, 7], "extent": [1,  6, 1]},
    {"type": "cube", "position": [0,  6, 0], "extent": [8,  1, 8]},
    {"type": "cube", "position": [0, 15, 0], "extent": [8,  1, 1]},
    {"type": "cube", "position": [0, 11, 0], "extent": [8,  1, 1]},
  ]
}
```
Here is another example of shape to draw a sphere:
``` json
{
  "size" : 32,
  "shapes": [
    {"type": "sphere", "position": [0, 0, 0], "radius": 16}
  ]
}
```
Here is another example of shape to draw a cylindre:
``` json
{
  "size" : 32,
  "shapes": [
    {"type": "cylindre", "position": [0, 0, 0], "radius": 16, "length": 32, "orientation": "z"},
  ]
}
```
Here is another example of shape to make cylindrical holes in a cube:
``` json
{
  "size" : 32,
  "shapes": [
    {"type": "cube", "position": [0, 0, 0], "extent": [32, 32, 32]},
    {"type": "cylindre", "position": [0, 8, 8], "radius": 8, "length": 32, "orientation": "x", "invert": true},
    {"type": "cylindre", "position": [8, 0, 8], "radius": 8, "length": 32, "orientation": "y", "invert": true},
    {"type": "cylindre", "position": [8, 8, 0], "radius": 8, "length": 32, "orientation": "z", "invert": true},
  ]
}
```
As said the format is based on JSON, and the root is an object containing the following properties:
* size: this is the size of your voxel canvas in number of voxel on the three axis. Due to using Octree, the canvas has to be a cube and the size has to be a _power of 2_.
* shapes: this is an array of shapes describing how to build your final shape.
  * type: can be "cube", "cylindre" or "sphere".
  * position: three dimensional position of the shape's origin in the canvas.
  * extent (cube only): dimension of the cube in all three dimensions.
  * radius (sphere or cylindre): dimension of the radius.
  * length (cylindre only): dimension of the cylindre along the orientation axis.
  * orientation (cylindre only): axis along which the cylindre will be extended.
  * invert (optional, default: false): if true, voxels inside the shape will be removed, otherwise voxels are added.

License
----

MIT
