To-do (not in order of priority):
1. Optimize Shape Updating
   - Currently updates the entire batch array anytime any shape is updated.
   - Also need to add more functions to shape struct to be able to change more.
   - Currently can only change color lol.
   - Shapes need to be more than an array, they need to rebuild themselves from variables when updated.
   - ^ We know this cause rewriting the color has issues if the color flag matches another value in the shapes data.
   - Also all shapes are the same shape struct, I'd prefer to keep it that way, rather than having a unique struct for all of them.
2. Quaternion Rotation
3. Post-Shape Creation Scaling
   - Need to think about this.
   - Option 1 is update the original radius, scale, etc.
   - Option 2 is to have a secondary scaling that affects the whole shape.
   - Option 3 is both i guess.
4. vBuffer Parser + Mesh to SDF Triangles
   - ex: mesh =  sdf_mesh(_vbuffer, _vformat);
   - Surely I dont need to figure this out from scratch, I feel like I've seen scripts that do this before.
   - All I need is to loop through the buffer, based on the spacing derived from the provided format, and just create triangles from that.
   - Won't support textures but will be fine to play with.
5. Procedural Patterns
6. Optimize Shader
   - Add Support for Orthographic projections
   - Bounding Volumes (need to be a struct that itself can be stored in a batch? or maybe the batch can do this behind the scenes)
   - Test for most optimal configurations of conditional branching nests.
   - For debug mode use a steps counter that includes steps taking in the effect functions.
8. Anti-Aliasing
