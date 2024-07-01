function _sdf_batch(shading_type = sdf_default_shading) constructor {
	
	#region (Internal)
	
	// SDFs to Pull Data From
	sdf_array = [];

	// Shading Style
	shading = shading_type;
	
	// Light Direction
	light_vector = [-0.25, -0.25, -1];
	
	// Shadows
	shadows_enabled = false;
	shadow_alpha = 0.5;
	
	// Ambient Occlusion
	ambient_occlusion_enabled = false;
	ao_alpha = 0.5;
	
	// Fog
	fog_enabled = false;
	fog_color = [0, 0, 0];
	fog_distance = 1000;
	
	// Specular Reflections
	specular_enabled = false;
	
	// Debug Mode
	debug_enabled = false;
	
	// Render Target
	vbuff_target = undefined;
	
	// Insert Header Data
	_data =			[	shading, light_vector[0], light_vector[1], light_vector[2], 
								shadows_enabled, ambient_occlusion_enabled, fog_enabled,
								fog_color[0], fog_color[1], fog_color[2], fog_distance, 
								debug_enabled, specular_enabled, shadow_alpha, ao_alpha	];	
								
	// Build Data Array
	static _build_data_array =  function() {
			
		// Clear Array 
		_data = [	shading, light_vector[0], light_vector[1], light_vector[2], 
							shadows_enabled, ambient_occlusion_enabled, fog_enabled,
							fog_color[0], fog_color[1], fog_color[2], fog_distance, 
							debug_enabled, specular_enabled, shadow_alpha, ao_alpha	];				
							
		//show_debug_message("updating array" + string(get_timer()))
			
		// Loop Through SDFs
		for (var i = 0; i < array_length(sdf_array); i++) {
				
			// Grab SDF
			var _sdf = sdf_array[i];
				
			var _sdf_data = _sdf._data;
				
			// Combine Arrays
			array_push(_data, array_length(_sdf_data));
			_data = array_concat(_data, _sdf_data);	
				
		}
			
	}

	// Generate Render Target
	static _build_target_vbuffer = function() {
		
		// Create Buffer
		vbuff_target = vertex_create_buffer();
		
		// Begin vBuffer Creation 
		vertex_begin(vbuff_target, global._sdf_vformat);
		
		// Add Vertices
		vertex_position(vbuff_target, 1, -1);
		vertex_position(vbuff_target, -1, -1);
		vertex_position(vbuff_target, 1, 1);
		vertex_position(vbuff_target, -1, 1);
		
		// End vBuffer Creation
		vertex_end(vbuff_target);
		vertex_freeze(vbuff_target);
		
	}
	
	#endregion
	#region Common Functions
	
	// Render SDF Batch
	static draw = function(_view_mat = matrix_get(matrix_view), _proj_mat = matrix_get(matrix_projection)) {
			
		// Set Shader
		shader_set(shd_sdf);
		
		// Pass in Camera Matrices
		shader_set_uniform_f_array(global._u_sdf_view_mat, _view_mat);
		shader_set_uniform_f_array(global._u_sdf_proj_mat, _proj_mat);
		
		// Add Flag to End of Array
		array_push(_data, _sdf_array_end_flag);
		
		// Pass in Input Arrays
		shader_set_uniform_f_array(global._u_sdf_input_array, _data);
		
		// Remove Flag From End of Array
		array_pop(_data);
		
		// Pass in Toon Shading Ramp Texture
		if shading = sdf_toon_shading { 
			texture_set_stage(global._u_toonramp, global._sdf_tex_toonramp);
		}
		
		// Render to Target
		if vbuff_target = undefined {
			_build_target_vbuffer();
		}
		vertex_submit(vbuff_target, pr_trianglestrip, -1);
		
		// Reset Shader 
		shader_reset();
		
	}	

	// Add SDF to Batch
	static add = function(_sdf) {
		_sdf._index_in_batch = array_length(sdf_array);
		_sdf._index_in_batch_data = array_length(_data);
		array_push(sdf_array, _sdf);
		_sdf._batch = self;
		_sdf._update_batch_indices();
		_sdf._update_modifer_indices();
		_build_data_array();
	}
	
	// Shadows
	static shadows = function(_enabled, _alpha = 0.5) {
		shadows_enabled = _enabled;
		shadow_alpha = _alpha;
	}
		
	// Ambient Occlusion
	static ambient_occlusion = function(_enabled, _alpha = 0.5) {
		ambient_occlusion_enabled = _enabled;
		ao_alpha = _alpha;
	}
	
	// Fog
	static fog = function(_enabled, _dist, _r, _g, _b, _linear = false) {
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
		
	#endregion
	
}