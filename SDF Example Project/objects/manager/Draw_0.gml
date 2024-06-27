#region Render Scene

surface_resize(application_surface, 240, 160);

// Set Camera Matrices
camera_set_view_mat(cam, view_mat);
camera_set_proj_mat(cam, proj_mat);

// Apply Camera
camera_apply(cam);
 
// Clear Frame
draw_clear_alpha(0, 0);

// Draw SDF System
sdf_batch.draw();

#endregion