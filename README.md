To-do (not in order of priority):
- Quaternion Rotation
- Secondary Scaling
- Remove Shapes from Batch
  - Will require shapes located afterwards in the batch to have there batch indexes and local indexes reset. 
- Render Shapes without Batch
- vBuffer Parser (Mesh to SDF Triangles)
  - Example: ```mesh = sdf_mesh(_vbuffer, _vformat);```
- Orthographic Support
- Optimize Secondary Distance Passes for Effects
  - The shape distance loop can probably be minimalized for shadows, ao, and normal calculation.
- Antialising
- Make the Github page look nice
- Bounding Volumes
- Pre-pass Optimization
  
Editor Idea
- Nommin's Dear ImGUI 
- ColMesh with bounding box selection
- Can use my GM File Association to export a custom file, or alternatively just a buffer or set of array values for copy and paste.
- Can be loaded using something like: ```loaded_file = sdf_load(_file_Path)```;
