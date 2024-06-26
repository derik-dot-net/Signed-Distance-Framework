#region Camera Update

// Angle
var cam_angle = current_time / 100;

// Position
cam_x = target_x + lengthdir_x(cam_dist, cam_angle);
cam_y = target_y + lengthdir_y(cam_dist, cam_angle);
cam_z = target_z + (cam_dist / 2);
	
// Aspect
aspect = window_get_width() / window_get_height();

// Matrices
view_mat = matrix_build_lookat(cam_x, cam_y, cam_z, target_x, target_y, target_z, xup, yup, zup);
proj_mat = matrix_build_projection_perspective_fov(fov, aspect, znear, zfar);

#endregion
#region Shape Updates

//var test_anim = current_time/2000;
//sphere.position(sin(test_anim) * 40, 0, 10);
//box.position(sin(test_anim) * -40, 0, 10);
//sphere.radius(7.5 + (sin(current_time/500) * 2.5));

#endregion