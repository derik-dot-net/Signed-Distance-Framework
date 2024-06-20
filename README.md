To-do (not in order of priority):
1. Update all shapes to the new shape struct
3. Quaternion Rotation
4. Post-Shape Creation Scaling
   - Need to think about this.
   - Option 1 is update the original radius, scale, etc.
   - Option 2 is to have a secondary scaling that affects the whole shape.
   - Option 3 is both i guess.
5. vBuffer Parser + Mesh to SDF Triangles
   - ex: mesh =  sdf_mesh(_vbuffer, _vformat);
   - Surely I dont need to figure this out from scratch, I feel like I've seen scripts that do this before.
   - All I need is to loop through the buffer, based on the spacing derived from the provided format, and just create triangles from that.
   - Won't support textures but will be fine to play with.
6. Procedural Patterns
7. Optimize Shader
   - Add Support for Orthographic projections
   - Bounding Volumes (need to be a struct that itself can be stored in a batch? or maybe the batch can do this behind the scenes)
   - Test for most optimal configurations of conditional branching nests.
   - For debug mode use a steps counter that includes steps taking in the effect functions.
8. Anti-Aliasing
9. Editor
   - Nommin's Dear ImGUI 
   - ColMesh with bounding box selection
   - Can use my GM File Association to export a custom file, or alternatively just a buffer or set of array values for copy and paste.
   - Can be loaded using something like var loaded_file = sdf_load(_file_Path);
9. Make the github page look nice
