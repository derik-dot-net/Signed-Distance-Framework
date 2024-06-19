function _sdf_batch(shading_type = sdf_smooth_shading) constructor {
	
	// SDFs to Pull Data From
	sdf_array = [];
	
	// Shading Style
	shading = shading_type;
	
	// Light Direction
	light_vector = [-0.25, -0.25, -1];
	
	// Shadows Enabled
	shadows_enabled = false;
	
	// Ambient Occlusion
	ambient_occlusion_enabled = false;
	
	// Fog
	fog_enabled = false;
	fog_color = [0, 0, 0];
	fog_distance = 1000;
	
	// Specular Reflections
	specular_enabled = false;
	
	// Debug Mode
	debug_enabled = false;
	
	// Insert Header Data
	data_array = [	shading, light_vector[0], light_vector[1], light_vector[2], 
								shadows_enabled, ambient_occlusion_enabled, fog_enabled,
								fog_color[0], fog_color[1], fog_color[2], fog_distance, 
								debug_enabled, specular_enabled];
	
	// Render SDF Batch
	static draw = function(_view_mat = matrix_get(matrix_view), _proj_mat = matrix_get(matrix_projection)) {
		
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
										shadows_enabled, ambient_occlusion_enabled, fog_enabled,
										fog_color[0], fog_color[1], fog_color[2], fog_distance, 
										debug_enabled, specular_enabled];
										
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
	static add = function(_sdf) {
		array_push(sdf_array, _sdf);
	}
	
	// Shadows
	static shadows = function(_enabled) {
		shadows_enabled = _enabled;
	}
		
	// Ambient Occlusion
	static ambient_occlusion = function(_enabled) {
		ambient_occlusion_enabled = _enabled;
	}
	
	// Fog
	static fog = function(_enabled, _dist, _r, _g, _b, _linear) {
		fog_enabled = _enabled;
		fog_color = _linear ? [_r, _g, _b] : [_r / 255, _g / 255, _b / 255];
		fog_distance = _dist;
	}
	
	// Specular Reflection
	static specular = function(_enabled) {
		specular_enabled	= _enabled;
	}
	
	// Light Vector
	static light_direction = function(_x, _y, _z) {
		light_vector = [_x, _y, _z];	
	}
	
	// Debug
	static debug = function(_enabled) {
		debug_enabled = _enabled;	
	}
	
}