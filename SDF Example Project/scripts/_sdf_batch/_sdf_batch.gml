function _sdf_batch(shading_type = sdf_smooth_shading) constructor {
	
	// SDFs to Pull Data From
	sdf_array = [];
	
	// Shading Style
	shading = shading_type;
	
	// Light Direction
	light_vector = [-0.25, -0.25, -1];
	
	// Shadows Enabled
	shadows_enabled = true;
	
	// Ambient Occlusion
	ambient_occlusion_enabled = true;
	
	// Anti Aliasing
	anti_aliasing = 8;
	
	// Target Size
	var target_surf = surface_get_target()
	target_width = surface_get_width(target_surf);
	target_height = surface_get_height(target_surf);
	
	// Insert Header Data
	data_array = [	shading, light_vector[0], light_vector[1], light_vector[2], 
								shadows_enabled, ambient_occlusion_enabled, anti_aliasing,
								target_width, target_height];
	
	// Render SDF Batch
	static draw = function (_view_mat = matrix_get(matrix_view), _proj_mat = matrix_get(matrix_projection)) {
		
		// Checks SDFs in Batch for Updates
		var _rebuild_data_array = false;
		for (var i = 0; i < array_length(sdf_array); i++) {
			
			// Grab SDF
			var _sdf = sdf_array[i];
			
			// Check if its Data was Updated
			if _sdf.updated = true {
					_rebuild_data_array = true;
					_sdf.updated = false;
			}
			
		}
		
		// Rebuild Data Array
		if _rebuild_data_array {
			
			// Target Size
			var target_surf = surface_get_target()
			target_width = surface_get_width(target_surf);
			target_height = surface_get_height(target_surf);
	
			// Clear Array 
			data_array = [	shading, light_vector[0], light_vector[1], light_vector[2], 
										shadows_enabled, ambient_occlusion_enabled];
										
			show_debug_message("updating array" + string(get_timer()))
			
			// Loop Through SDFs
			for (var i = 0; i < array_length(sdf_array); i++) {
				
				// Grab SDF
				var _sdf = sdf_array[i];
				
				// Combine Arrays
				array_push(data_array, array_length(_sdf.data));
				data_array = array_concat(data_array, _sdf.data);	
				
			}
			
		}
		
		// Set Shader
		shader_set(shd_sdf);
		
		// Pass in Camera Matrices
		shader_set_uniform_f_array(global._u_sdf_view_mat, _view_mat);
		shader_set_uniform_f_array(global._u_sdf_proj_mat, _proj_mat);
		
		// Add Flag to End of Array
		array_push(data_array, _sdf_array_end_flag);
		
		// Pass in Input Array
		shader_set_uniform_f_array(global._u_sdf_input_array, data_array);
		
		// Remove Flag From End of Array
		array_pop(data_array);
		
		// Pass in Toon Shading Ramp Texture
		if shading = sdf_toon_shading { 
			texture_set_stage(global._u_toonramp, global._sdf_tex_toonramp);
		}
		
		// Draw Basic Primitive Covering the Screen
		draw_primitive_begin(pr_trianglestrip);
		draw_vertex(1, -1);
		draw_vertex(-1, -1);
		draw_vertex(1, 1);
		draw_vertex(-1, 1);
		draw_primitive_end();
		
		// Reset Shader 
		shader_reset();
		
	}
	
	// Add SDF to Batch
	static add = function (_sdf) {
		array_push(sdf_array, _sdf);
	}
	
}