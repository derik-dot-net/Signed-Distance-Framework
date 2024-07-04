To-do (not in order of priority):
- Additional Collision Functionality
  - Bounding Box tests as an alternative to raw distance tests
    - An optimized alternative to distance calculations
    - Test bbox overlap against specific shape or entire batch `.bbox_collision(_shape = undefined)`
      - Returns `bool: true/false`
    - Fetch Min & Max Bounding Box Position from a specific shape `.get_bbox_min()` and `.get_bbox_max()`
      - Returns result as an array `[_x, _y, _z]`
- Secondary Scaling
  - Example: `sdf_batch.scale(_x_scale, _y_scale, _z_scale);`
  - Could be passed in as part of the batch header.
- Remove Shapes from Batch
  - Will require shapes located later in the batch to have their batch indexes and local indexes reset. 
- Render Shapes without Batch
- vBuffer Parser (Mesh to SDF Triangles)
  - Example: `mesh = sdf_mesh(_vbuffer, _vformat);`
- Filtered versions of the Procedural Patterns.
- Anti Aliasing
- Bounding Volumes
- Cone-Marching Pre-pass
- 3D SDF Text
  - This is just a loose idea, but I imagine this is likely possible, though I'm unsure exactly how easy it would be to do. 
- Make the Github page look nice
  - Asset logo Idea: The Gamemaker logo made from SDFs using smooth union, alongside the text "Signed Distance Framework".
  - Add documentation for all functionality, each shapes available properties, and photo examples of what they look like.
- Re-arrange Batch Header to make it less messy
- Add Additional Rotation Functionality
  - Currently the quaternion is normalized inside of the shader.
  - Add an XYZ version of: `.rotate_x(_angle_degrees, _is_local);` which respects the previously defined rotation.
  - Perhaps add a `.rotate_around(_x_origin, _y_origin, _z_origin);` for people who want to manually set the rotation origin. 
  - For advanced users add: `.quaternion(_x, _y, _z, _w);` for manually handling rotation. 
- Make Render Settings Dynamic
  - Currently they only work when set in the create event prior to a shape being added, just need to make them write to the array.
    
Editor Idea
- Nommin's Dear ImGUI 
- ColMesh with bounding box selection
- Can use my GM File Association to export a custom file, or alternatively just a buffer or set of array values for copy and paste.
- Can be loaded using something like: `loaded_file = sdf_load(_file_path);`
