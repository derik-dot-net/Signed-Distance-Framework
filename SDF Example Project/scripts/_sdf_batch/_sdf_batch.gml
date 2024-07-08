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
	// Bouding Volume Hierarchy
	_bvh = undefined;
	
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
	
	// Functions
	static _normalize = function(_q) {
		switch(array_length(_q)) {
			case 3:
				var mag = _magnitude(_q);
				if (mag == 0) {
					return self;
				}
				var l = 1.0 / mag;
				if is_numeric(l){
					return [_q[0] * l, _q[1] * l, _q[2] * l];
				} else {
					return [0, 0, 0];	
				}
			break;
			case 4:
				var _l = sqrt(_q[0] * _q[0] + _q[1] * _q[1] + _q[2] * _q[2] + _q[3] * _q[3]);
				if (_l > 0.0) {
				    return [_q[0] / _l, _q[1] / _l, _q[2] / _l, _q[3] / _l];
				} else {
				    return [0.0, 0.0, 0.0, 0.0];
				}
			break;
		}
	}
	static _magnitude = function(_v) {
		var _in = _v[0] * _v[0] + _v[1] * _v[1] + _v[2] * _v[2];
		if _in = 0 or is_nan(_in) {return 0;}
		return sqrt(_in);
	}
	static _mul = function(_v, _s) {
		if is_array(_s) {
			switch(array_length(_s)) {
				case 2:
					return [_v[0] * _s[0], _v[1] * _s[1]];	
				break;
				case 3:
					return [_v[0] * _s[0], _v[1] * _s[1], _v[2] * _s[2]];	
				break;
			}
		} else {
			switch(array_length(_v)) {
				case 2: 
					return [_v[0] * _s, _v[1] * _s];
				break;
				case 3: 
					return [_v[0] * _s, _v[1] * _s, _v[2] * _s];
				break;
			}
		}
	}
	static _add = function(_v, _s) {
		if is_array(_s) {
			switch (array_length(_s)) {
				case 2:
					return [_v[0] + _s[0], _v[1] + _s[1]];	
				break;
				case 3:
					return [_v[0] + _s[0], _v[1] + _s[1], _v[2] + _s[2]];	
				break;
			}
		} else {
			return [_v[0] + _s, _v[1] + _s, _v[2] + _s];
		}
	}
	static _sub = function(_v, _s) {
		if is_array(_s) {
			switch (array_length(_s)) {
				case 2:
					return [_v[0] - _s[0], _v[1] - _s[1]];		
				break;
				case 3:
					return [_v[0] - _s[0], _v[1] - _s[1], _v[2] - _s[2]];	
				break;
			}
		} else {
			switch(array_length(_v)) {
				case 2:
					return [_v[0] - _s, _v[1] - _s];
				break;
				case 3:
					return [_v[0] - _s, _v[1] - _s, _v[2] - _s];
				break;
			}
		}
	}
	
	// Ray Marching & BVH Functions
	static _ray_march = function(_origin, _ray_dir, rng_state = 0) {
		/*
		// Set Up Ray
		var _ray = new _sdf_ray();
		_ray._origin = _origin;
		_ray._dir = _ray_dir;
		_ray._inv_dir = [1 / _ray.dir[0], 1 / _ray.dir[1], 1 / _ray.dir[2]];
		// Friendly reminder:
		// Here, the term "inverse"  refers to component-wise reciprocal, not the negation. 
		
		// Store Results
		var _result = new _sdf_ray_hit_info();
		_result._dist = _sdf_inf;
		
		// Loop Through Array
		for (var i = 0; i < array_length(sdf_array); i++) {
			
			//Grab Shape
			var _sdf = sdf_array[i];
			
			// Traverse BVH to find closest intersection with current shape
			var _hit = _ray_shape_bvh(_ray, _result._dist, _sdf);
			
			// Record Closest Hit
			if (_hit.dist < _result.dist) {
				_result._did_hit = true;
				_result._dist = hit.dist;
				_result._hit_point = _add(_ray._origin, _mul(_ray._dir, _hit._dist));
			}
		}
		
		// Return Result
		return _result;
		*/
	}
	static _ray_shape_bvh = function(_ray, _ray_length, _shape) {
		/*
		// Store Results
		var _result = new _sdf_shape_hit_info();
		_result.dist = _ray_length;
		_result.shape_index = -1;
		
		// Store BVH
		var _stack = array_create(32, 0);
		var _stack_index = 0;
		
		while (_stack_index > 0) {
			
		}
		*/
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
		_sdf._build_bbox();
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

	// Get Distance to Shape from a point 
	static distance = function(_x, _y, _z, _max_dist = 10000) {
		var _min_dist = _max_dist;
		var _min_dist_shape = undefined;
		var _p, _res;
		if is_array(_x) {
			var _p = [_x[0], _x[1], _x[2]];
		} else {
			var _p = [_x, _y, _z];
		}
		for (var i = 0; i < array_length(sdf_array); i++) {
			var _sdf = sdf_array[i];
			_res = _sdf.distance(_p);
			if _res < _min_dist {
				_min_dist = _res;
				_min_dist_shape = _sdf;
			}
		}
		return [_min_dist, _min_dist_shape];
	}
	
	// Cast a Ray
	static raycast = function(_x1, _y1, _z1, _x2, _y2, _z2, _max_dist  = 10000, _surf_dist = 0.1) {
		var _d = 0.0;
		var _hit = false;
		var _start, _end, _dir, _md, _sd;
		if is_array(_x1) {
			_start = _x1;
			_end = _y1;
			_dir = _z1;
			_md = _x2;
			_sd = _y2;
		} else {
			_start = [_x1, _y1, _z1];
			_end = [_x2, _y2, _z2];
			_dir = _normalize(_sub(_start, _end));
			_md = _max_dist;
			_sd = _surf_dist;
		}
		var loop_amt = 0;
		while(true) {
			var p = _add(_start, _mul(_dir, _d));
			var  _dist = self.distance(p, _max_dist);
			var _travel_dist = _dist[0];
			loop_amt++;
			if _travel_dist = undefined {_travel_dist = _max_dist;}
			_d += _travel_dist;
			if (_travel_dist < _sd) {
				hit = true;
				array_push(p, _dist[1]);
				return p;
				break;
			}
			if (_d > _md) {
				hit = false;
				array_push(p, undefined);
				return p;
				break;
			}
		}
		return undefined
	}
	
	// Cast a Ray from the Mouse
	static mouse_raycast = function(_camera, _max_dist = 10000, _surf_dist = 0.01) {
		var _2dto3d = _sdf_2d_to_3d(camera_get_view_mat(_camera), camera_get_proj_mat(_camera), mouse_x, mouse_y);
		var _start = [_2dto3d[3],  _2dto3d[4],  _2dto3d[5]];
		var _dir = _normalize([_2dto3d[0], _2dto3d[1], _2dto3d[2]]);
		var _end = _add(_start, _mul(_dir, _max_dist));
		var _ray = raycast(_start, _end, _dir, _max_dist, _surf_dist);
		return _ray;
	}
	
	// Generate the BVH
	static bvh = function(_depth = 12) {
		_bvh = new _sdf_bvh(self);
		_bvh._build();
	}
	
	#endregion
	
}