To-do (not in order of priority):
- Quaternion Rotation
  - Once a shape has a rotation fuction called on it, only then does it take up extra slots in the array for that data.
  - This means that all shapes will have a default orientation determined by the output of its distance function.
  - Example: ```box.rotate(_x_angle, _y_angle, _z_angle);```
  - Will use quaternions behind the scenes. 
- Secondary Scaling
  - Example: ```sdf_batch.scale(_x_scale, _y_scale, _z_scale);```
  - Could be passed in as part of the batch header.
- Remove Shapes from Batch
  - Will require shapes located later in the batch to have their batch indexes and local indexes reset. 
- Render Shapes without Batch
- vBuffer Parser (Mesh to SDF Triangles)
  - Example: ```mesh = sdf_mesh(_vbuffer, _vformat);```
- Orthographic Support
- Optimize Secondary Distance Passes for Effects
  - The distance loop can probably be minimalized for shadows, ao, and normal calculation.
  - Avoiding re-runing the distance loop as it is currently would ensure the color is only being determined once.
- Antialising
- Bounding Volumes
- Pre-pass Optimization
- 3D SDF Text
  - This is just a loose idea, but I imagine this is likely possible, though I'm unsure exactly how easiy it would be to do. 
- Make the Github page look nice
  - Asset logo Idea: The Gamemaker logo made from SDFs using smooth union, alongside the text "Signed Distance Framework".
  - Add documentation for all functionality, each shapes available properties, and photo examples of what they look like.
Editor Idea
- Nommin's Dear ImGUI 
- ColMesh with bounding box selection
- Can use my GM File Association to export a custom file, or alternatively just a buffer or set of array values for copy and paste.
- Can be loaded using something like: ```loaded_file = sdf_load(_file_Path);```
