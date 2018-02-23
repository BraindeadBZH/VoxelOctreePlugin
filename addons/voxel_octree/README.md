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
As said the format is based on JSON, and the root is an object containing the following properties:
* size: this is the size of your voxel canvas in number of voxel on the three axis. Due to using Octree, the canvas has to be a cube and the size has to be a _power of 2_
* shapes: this is an array of shapes describing how to build your final shape. At the moment only type `cube` is supported. The properties position and extent are expressed in voxel unit.

License
----

MIT
