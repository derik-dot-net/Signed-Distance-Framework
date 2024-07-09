#region Render Scene

//surface_resize(application_surface, 240, 160);

// Set Camera Matrices
camera_set_view_mat(cam, view_mat);
camera_set_proj_mat(cam, proj_mat);

// Apply Camera
camera_apply(cam);
 
// Clear Frame
draw_clear_alpha(0, 0);

// Draw SDF System
sdf_batch.draw();
bvh_node_batch.draw();
shape_bbox_batch.draw();
//point_batch.draw();
/*
show_debug_message("BBoxes: " + string(global.bboxes_checked) + " Distance Functions: " + string(global.distances_checked) + " BBox Successes: " + string(global.bbox_successes))
global.bboxes_checked = 0;
global.distances_checked = 0;
global.bbox_successes = 0;
show_debug_message([tri_prism._min_bbox, tri_prism._max_bbox])

#endregion