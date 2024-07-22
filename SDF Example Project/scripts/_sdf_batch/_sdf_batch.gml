function _sdf_batch(shading_type = sdf_default_shading) constructor {
	
	#region (Internal)
	
	// SDFs to Pull Data From
	_shape_list = [];

	// Shading Style
	_shading = shading_type;
	
	// Light Direction
	_light_vector = [-0.25, -0.25, -1];
	
	// Shadows
	_shadows_enabled = false;
	_shadow_alpha = 0.5;
	
	// Ambient Occlusion
	_ambient_occlusion_enabled = false;
	_ao_alpha = 0.5;
	
	// Fog
	_fog_enabled = false;
	_fog_color = [0, 0, 0];
	_fog_distance = 1000;
	
	// Specular Reflections
	_specular_enabled = false;
	
	// Debug Mode
	_debug_enabled = false;
	
	// Render Target
	_vbuff_target = undefined;
	
	// Store Batch Data as a 1D Array
	_data = [];
								
	// Bouding Volume Hierarchy
	_bvh = undefined;
	
	// Store a Batch for Rendering Bounding Boxes
	_bbox_batch = undefined;
	_bbox_batch_thickness = undefined;
	
	// Build Data Array
	static _build_data_array =  function() {
			
		// Clear Array and Pass in Render Settings
		_data = [	_shading, 
							_light_vector[0], _light_vector[1], _light_vector[2], 
							_shadows_enabled, 
							_ambient_occlusion_enabled, 
							_fog_enabled,
							_fog_color[0], _fog_color[1], _fog_color[2], 
							_fog_distance, 
							_debug_enabled, 
							_specular_enabled, 
							_shadow_alpha, 
							_ao_alpha	];
								
		// Loop Through SDFs
		for (var i = 0; i < array_length(_shape_list); i++) {
				
			// Grab SDF
			var _sdf = _shape_list[i];
				
			var _sdf_data = _sdf._data;
				
			// Combine Arrays
			_sdf._index_in_batch = array_length(_shape_list);
			_sdf._index_in_batch_data = array_length(_data);
			array_push(_data, array_length(_sdf_data));
			_sdf._batch = self;
			_sdf._update_batch_indices();
			_sdf._update_modifer_indices();
			_data = array_concat(_data, _sdf_data);	
			
		}
			
	}

	// Generate Render Target
	static _build_target_vbuffer = function() {
		
		// Create Buffer
		_vbuff_target = vertex_create_buffer();
		
		// Begin vBuffer Creation 
		vertex_begin(_vbuff_target, global._sdf_vformat);
		
		// Add Vertices
		vertex_position(_vbuff_target, 1, -1);
		vertex_position(_vbuff_target, -1, -1);
		vertex_position(_vbuff_target, 1, 1);
		vertex_position(_vbuff_target, -1, 1);
		
		// End vBuffer Creation
		vertex_end(_vbuff_target);
		vertex_freeze(_vbuff_target);
		
	}
	
	// Shader & Math Functions
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
	static _div = function(_v, _s) {
		if is_array(_s) {
			return [_v[0] / _s[0], _v[1] / _s[1], _v[2] / _s[2]];	
		} else {
			return [_v[0] / _s, _v[1] / _s, _v[2] / _s];
		}
	}
	static _max = function(_v, _s) {
		if is_array(_s) {
			switch(array_length(_s)) {	
				case 2:
					return [max(_v[0], _s[0]), max(_v[1], _s[1])];
				break;
				case 3:
					return [max(_v[0], _s[0]), max(_v[1], _s[1]), max(_v[2], _s[2])];
				break;
			}
		} else {
			switch(array_length(_v)) {	
				case 2:
					return [max(_v[0], _s), max(_v[1], _s)];
				break;
				case 3:
					return [max(_v[0], _s), max(_v[1], _s), max(_v[2], _s)];
				break;
			}
		}
	}
	static _min = function(_v, _s) {
		if is_array(_s) {
			return [min(_v[0], _s[0]), min(_v[1], _s[1]), min(_v[2], _s[2])];
		} else {
			return [min(_v[0], _s), min(_v[1], _s), min(_v[2], _s)];
		}
	}
	
	// Raycasting Functions
	static _raycast = function(_origin, _dir) {
		
		// Store Sum of Distance Traveled
		var _dist_sum = 0;
		
		// Create Ray to Cast
		var _ray = new _sdf_ray();
		_ray._origin = _origin;
		_ray._dir = _dir;
		_ray._inv_dir = [1 / _dir[0], 1 / _dir[1], 1 / _dir[2]];
		
		// Detect Hit
		var _hit = _raycast_bvh(_ray, _sdf_inf + 1); // My infinity is bigger than yours
		// TODO: Re-implement raymarching alternative without BVH
		
		// Return Result
		return _hit;
		
	}
	static _raycast_bvh = function(_ray, _ray_length) {
		
		// Store Result
		var _result = new _sdf_shape_hit_info();
		_result._dist = _ray_length;
		_result._shape_index = -1;
		
		// Store Traversal Stack
		var _stack[32];
		var _stack_index = 0;
		_stack[_stack_index++] = 0;

		// Grab Node List Reference
		var _nodes = _bvh._node_list._nodes;
		
		// Traverse BVH
		while (_stack_index > 0) {

			// Grab Current Node
			var _node = _nodes[_stack[--_stack_index]];
			var _is_leaf = _node._shape_count > 0;
		
			// Node is Leaf
			if (_is_leaf) {

				// Loop Through Shapes in Node
				for (var i = 0; i < _node._shape_count; i++) {
						
					// Grab Shape
					var _shape = _shape_list[_node._start_index + i];
					
					// Store a Copy of the Ray
					var _local_ray = variable_clone(_ray);

					// Get Distance From Shape
					var _shape_dist = _shape.distance(_local_ray._origin);
					
					// March
					var _did_hit_shape = undefined;
					while(_did_hit_shape = undefined) {
						_local_ray._origin = _add(_local_ray._origin, _mul(_local_ray._dir, _shape_dist));
						// Succesful Hit
						if ( _shape_dist < 0.01 and _shape_dist < _result._dist) {
							_result._hit_point = _local_ray._origin;
							_result._shape_index = _shape;
							_result._dist = _shape_dist;
							_did_hit_shape = true;
						} else { 
							var _new_shape_dist = _shape.distance(_local_ray._origin);
							if _new_shape_dist > _shape_dist {
								_did_hit_shape = false;
							} else {
								_shape_dist = _new_shape_dist;	
							}
						}	
					}
					
				}	
						
			} else {
					
				// Define Child Indexes
				var _child_index_a = _node._start_index + 0;
				var _child_index_b = _node._start_index + 1;
					
				// Grab Children Nodes 
				var _child_a	= _nodes[_child_index_a];
				var _child_b	= _nodes[_child_index_b];
					
				// Grab Distances
				var _dist_a	= _ray_bbox_dist(_ray, _child_a._bounds_min, _child_a._bounds_max);
				var _dist_b	= _ray_bbox_dist(_ray, _child_b._bounds_min, _child_b._bounds_max);
					
				// Push Closest Child First
				var _is_nearest_a			= _dist_a <= _dist_b;
				var _dist_near					= _is_nearest_a ? _dist_a				: _dist_b;
				var _dist_far						= _is_nearest_a ? _dist_b				: _dist_a;
				var _child_index_near	= _is_nearest_a ? _child_index_a	: _child_index_b;
				var _child_index_far		= _is_nearest_a ? _child_index_b	: _child_index_a;
					
				if (_dist_far < _result._dist) {_stack[_stack_index++] = _child_index_far;}
				if (_dist_near < _result._dist) {_stack[_stack_index++] = _child_index_near;}
				
				// Fail Safe
				if _stack_index > _bvh._max_depth {break;}
				
			}
			
		}	
		
		// Return Result
		return _result;
		
	}
	static _ray_bbox_dist = function(_ray, _bbox_min, _bbox_max) {
		var tMin = _mul(_sub(_bbox_min, _ray._origin), _ray._inv_dir);
		var tMax = _mul(_sub(_bbox_min, _ray._origin), _ray._inv_dir);
		var t1 = _min(tMin, tMax);
		var t2 = _max(tMin, tMax);
		var tNear = max(max(t1[0], t1[1]), t1[2]);
		var tFar = min(min(t2[0], t2[1]), t2[2]);
		var hit = tFar >= tNear && tFar > 0;
		var dst = hit ? (tNear > 0 ? tNear : 0) : _sdf_inf;
		return dst;
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
		
		// Pass in Shape Input Array
		shader_set_uniform_f_array(global._u_sdf_input_array, _data);
		
		// Pass in BVH Array if Applicable
		if _bvh != undefined {
			shader_set_uniform_f_array(global._u_bvh_input_array, _bvh._data);
		}
		
		// Remove Flag From End of Array
		array_pop(_data);
		
		// Pass in Toon Shading Ramp Texture
		if _shading = sdf_toon_shading { 
			texture_set_stage(global._u_toonramp, global._sdf_tex_toonramp);
		}
		
		// Render to Target
		if _vbuff_target = undefined {
			_build_target_vbuffer();
		}
		vertex_submit(_vbuff_target, pr_trianglestrip, -1);
		
		// Reset Shader 
		shader_reset();
		
	}	
	
	// Render Bounding Volume Hieararchy as SDF Box Frames
	static draw_bvh =  function (_thickness = 0.1, _view_mat = matrix_get(matrix_view), _proj_mat = matrix_get(matrix_projection)) {
		
		// Check if BVH Exists
		if _bvh = undefined {
			
			// BVH doesn't Exists. Throw Debug Message
			show_debug_message(_sdf_error_tag_str + "Attempting to draw a BVH for a batch that does not have one.")
			
		} else { // BVH Exists
			
			// Render BVH
			_bvh._draw(_thickness, _view_mat, _proj_mat);
			
		}
			
	}
	
	// Render Shape Bounding Boxes
	static draw_bboxes = function( _thickness = 0.1, _view_mat = matrix_get(matrix_view), _proj_mat = matrix_get(matrix_projection)) {
		
		// Check if bbox Batch Exists
		if _bbox_batch = undefined or _bbox_batch_thickness != 0.1 {
			
			// Create Batch
			_bbox_batch = sdf_create_batch(sdf_default_shading);
			
				// Loop Through all Shapes
				for (var i = 0; i < array_length(_shape_list); i++) {
					var _shape = _shape_list[i];
					var _bbox_size = _shape._bbox._size();
					var _bbox_center = _shape._bbox._center();
					var _bbox_frame = sdf_box_frame(_bbox_center[0], _bbox_center[1], _bbox_center[2], 
																					_bbox_size[0] / 2, _bbox_size[1] / 2, _bbox_size[2] / 2,
																					_thickness);
					_bbox_frame.color(1, 1, 1, true);
					_bbox_batch.add(_bbox_frame);
				}
			
			//Render Batch as Normal (Batch Generation Complete)
			_bbox_batch.draw(_view_mat, _proj_mat);
				
			} else { // Batch Exists
			
				// Render bbox Batch
				_bbox_batch.draw(_view_mat, _proj_mat);
			
			}
	}
	
	// Add SDF to Batch
	static add = function(_sdf) {
		_sdf._index_in_batch = array_length(_shape_list);
		_sdf._index_in_batch_data = array_length(_data);
		array_push(_shape_list, _sdf);
		_sdf._batch = self;
		_sdf._update_batch_indices();
		_sdf._update_modifer_indices();
		_sdf._build_bbox();
		_build_data_array();
	}
	
	// Shadows
	static shadows = function(_enabled, _alpha = 0.5) {
		_shadows_enabled = _enabled;
		_shadow_alpha = _alpha;
	}
		
	// Ambient Occlusion
	static ambient_occlusion = function(_enabled, _alpha = 0.5) {
		_ambient_occlusion_enabled = _enabled;
		_ao_alpha = _alpha;
	}
	
	// Fog
	static fog = function(_enabled, _dist, _r, _g, _b, _linear = false) {
		_fog_enabled = _enabled;
		_fog_color = _linear ? [_r, _g, _b] : [_r / 255, _g / 255, _b / 255];
		_fog_distance = _dist;
	}
	
	// Specular Reflection
	static specular = function(_enabled) {
		_specular_enabled	= _enabled;
	}
	
	// Light Vector
	static light_direction = function(_x, _y, _z) {
		_light_vector = [_x, _y, _z];	
	}
	
	// Debug
	static debug = function(_enabled) {
		_debug_enabled = _enabled;	
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
		for (var i = 0; i < array_length(_shape_list); i++) {
			var _sdf = _shape_list[i];
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
		var _result = _raycast(_start, _dir);
		if is_array(_result._hit_point) {
			return [_result._hit_point[0], _result._hit_point[1], _result._hit_point[2], _result._shape_index];
		} else {
			return undefined;
		}
	}
	
	// Generate BVH
	static bvh = function(_max_depth = 12, _split_tests_per_node_axis = 5) {
		
		// Grab BVH Start TIme
		var _bvh_start_time = get_timer();
		
		// Create BVH Struct
		_bvh = new _sdf_bvh(self, _max_depth, _split_tests_per_node_axis);
		
		// Build BVH
		_bvh._build();
		
		// Grab BVH End Time
		var _bvh_end_time = get_timer();
		
		// Store Calculated Generation Time as String
		var _bvh_total_time = string((_bvh_end_time - _bvh_start_time) / 1000000);
		
		// Output Generation Time as Debug Message
		show_debug_message(_sdf_message_tag_str + "BVH generated in " + _bvh_total_time + " milliseconds" );
		
	}
	
	#endregion
	
}