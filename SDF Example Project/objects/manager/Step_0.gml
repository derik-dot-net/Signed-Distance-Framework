#region Camera Update

// Angle
var cam_angle = 180+45//current_time / 100;

// Position
cam_x = target_x + lengthdir_x(cam_dist, cam_angle);
cam_y = target_y + lengthdir_y(cam_dist, cam_angle);
cam_z = target_z + (cam_dist / 2);
	
// Aspect
aspect = window_get_width() / window_get_height();

// Matrices
view_mat = matrix_build_lookat(cam_x, cam_y, cam_z, target_x, target_y, target_z, xup, yup, zup);
proj_mat = matrix_build_projection_perspective_fov(fov, aspect, znear, zfar);
//proj_mat = matrix_build_projection_ortho(120, 80, znear - 1000, zfar);

#endregion
#region Shape Updates

var test_anim = current_time/10;
//sphere.position(sin(test_anim) * 40, 0, 10);
//box.position(sin(test_anim) * -40, 0, 10);
//sphere.radius(7.5 + (sin(current_time/500) * 2.5));
//box.rotation(test_anim, test_anim, test_anim);
/*
var mouse_pointer = sdf_batch.mouse_raycast(cam, 10000, 0.01);
if mouse_pointer != undefined {
	mouse_sphere.position(mouse_pointer[0], mouse_pointer[1], mouse_pointer[2]);
	if mouse_pointer[3] != undefined  and mouse_check_button_released(mb_left) {
		var col = c_rainbow(5, 10);
		var sdf = mouse_pointer[3];
		sdf.color(col[0], col[1], col[2]);
		var bbox_scale = sdf._sub(sdf._max_bbox, sdf._min_bbox);
		bbox_scale = sdf._div(bbox_scale, 2);
		var dividend = 1;
		var frame_pos = sdf._pos_0;
		if sdf._pos_1 != undefined {frame_pos = sdf._add(frame_pos, sdf._pos_1); dividend++;}
		if sdf._pos_2 != undefined {frame_pos = sdf._add(frame_pos, sdf._pos_2); dividend++;}
		if sdf._pos_3 != undefined {frame_pos = sdf._add(frame_pos, sdf._pos_3); dividend++;}
		frame_pos = sdf._div(frame_pos, dividend);
		bbox_frame.scale(bbox_scale[0], bbox_scale[1], bbox_scale[2]);
		bbox_frame.position(frame_pos[0], frame_pos[1], frame_pos[2]);
		bbox_min.position(sdf._min_bbox[0], sdf._min_bbox[1], sdf._min_bbox[2]);
		bbox_max.position(sdf._max_bbox[0], sdf._max_bbox[1], sdf._max_bbox[2]);
	}
}
*/
#endregion
