function _sdf_shape() constructor {
		
	#region (Internal)
	
	// Data for this SDF
	_data = undefined;	
	
	// Shape Data
	_type = undefined;
	_blending = undefined;
	_pos_0 = undefined;
	_pos_1 = undefined;
	_pos_2 = undefined;
	_pos_3 = undefined;
	_scale_0 = undefined;
	_rotation = undefined;
	_float_0 = undefined;
	_float_1 = undefined;
	_float_2 = undefined;
	_float_3 = undefined;
	_color_0 = undefined;
	_blend_str = undefined;
	_pattern = undefined;
	_batch = undefined;
	_index_in_batch = undefined;
	_index_in_batch_data = undefined;
	
	
	// Local Index for Shape Data
	_li_type = undefined;
	_li_blending = undefined;
	_li_pos_0 = undefined;
	_li_pos_1 = undefined;
	_li_pos_2 = undefined;
	_li_pos_3 = undefined;
	_li_scale_0 = undefined;
	_li_rotation = undefined;
	_li_float_0 = undefined;
	_li_float_1 = undefined;
	_li_float_2 = undefined;
	_li_float_3 = undefined;
	_li_color_0 = undefined;
	_li_blend_str = undefined;
	_li_pattern = undefined;
	
	// Batch Indexes for Shape Data
	_bi_type = undefined;
	_bi_blending = undefined;
	_bi_pos_0 = undefined;
	_bi_pos_1 = undefined;
	_bi_pos_2 = undefined;
	_bi_pos_3 = undefined;
	_bi_scale_0 = undefined;
	_bi_rotation = undefined;
	_bi_float_0 = undefined;
	_bi_float_1 = undefined;
	_bi_float_2 = undefined;
	_bi_float_3 = undefined;
	_bi_color_0 = undefined;
	_bi_blend_str = undefined;
	_bi_pattern = undefined;
	
	// Bounding Box
	_min_bbox = undefined;
	_max_bbox = undefined;
	_building_bbox = false;
	_bbox_cushion = 10;
	_ray = undefined;
	
	// Trying to set a data type using an internal function in a way that isn't applicable
	static _not_applicable_error = function() {
		var _error_str = "You're trying to set a data type that the shape does not use or contain, and/or does not have as an applicable modifier.";
		show_debug_message(_sdf_error_tag_str + _error_str);
	}
	
	// Modifer Local and Batch Indices
	static _create_modifer_index = function(_mode) {
		var _new_index = array_length(_data);
		switch(_mode) {
			case _sdf_color_0:
				array_push(_data, _sdf_color_0)
				_li_color_0 = _new_index;
				if _batch != undefined {
					_bi_color_0 =  _index_in_batch_data + _li_color_0 + 1;
					array_insert(_batch._data, _bi_color_0, _sdf_color_0, 0, 0, 0); 
					_batch._build_data_array();
				}
			break;	
			case _sdf_blending:
				array_push(_data, _sdf_blending)
				_li_blending = _new_index;
				if _batch != undefined {
					_bi_blending = _index_in_batch_data + _li_blending + 1;
					array_insert(_batch._data, _bi_blending, _sdf_blending, 0);
					_batch._build_data_array();
				}
			break;	
			case _sdf_blend_str:
				array_push(_data, _sdf_blend_str)
				_li_blend_str = _new_index;
				if _batch != undefined {
					_bi_blend_str = _index_in_batch_data + _li_blend_str + 1;
					array_insert(_batch._data, _bi_blend_str, _sdf_blend_str, 0);
					_batch._build_data_array();
				}
			break;	
			case _sdf_pattern:
				array_push(_data, _sdf_pattern)
				_li_pattern = _new_index;
				if _batch != undefined {
					_bi_pattern = _index_in_batch_data + _li_pattern + 1;
					array_insert(_batch._data, _bi_pattern, _sdf_pattern, 0, 0, 0);
					_batch._build_data_array();
				}
			break;	
			case _sdf_rotation:
			array_push(_data, _sdf_rotation)
				_li_rotation = _new_index;
				if _batch != undefined {
				_bi_rotation = _index_in_batch_data + _li_rotation + 1;
				array_insert(_batch._data, _bi_rotation, _sdf_rotation, 0, 0, 0, 0);
				_batch._build_data_array();
			}
			break;	
		}
	}	
	static _update_modifer_indices = function() {
		if _li_color_0 != undefined {
			_bi_color_0 =  _index_in_batch_data + _li_color_0 + 1;
		}
		if _li_blending != undefined {
			_bi_blending = _index_in_batch_data + _li_blending + 1;
		}
		if _li_blend_str != undefined {
			_bi_blend_str = _index_in_batch_data + _li_blend_str + 1;
		}
		if _li_pattern != undefined {
			_bi_pattern = _index_in_batch_data + _li_pattern + 1;
		}
		if _li_rotation != undefined {
			_bi_rotation = _index_in_batch_data + _li_rotation + 1;
		}
	}	
	
	// Data Setters (Handles Local and Batch Updates)
	static _set_pos = function(_index, _x, _y, _z) {
		switch(_index) {
			case 0:
				if _pos_0 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {
					_batch._data[_bi_pos_0 + 1] = _x;
					_batch._data[_bi_pos_0 + 2] = _y;
					_batch._data[_bi_pos_0 + 3] = _z;
				}
				_pos_0 = [_x, _y, _z];
				_data[_li_pos_0 + 1] = _x;
				_data[_li_pos_0 + 2] = _y;
				_data[_li_pos_0 + 3] = _z;
			break;
			case 1:
				if _pos_1 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {
					_batch._data[_bi_pos_1 + 1] = _x;
					_batch._data[_bi_pos_1 + 2] = _y;
					_batch._data[_bi_pos_1 + 3] = _z;
				}
				_pos_1 = [_x, _y, _z];
				_data[_li_pos_1 + 1] = _x;
				_data[_li_pos_1 + 2] = _y;
				_data[_li_pos_1 + 3] = _z;
			break;
			case 2:
				if _pos_2 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {
					_batch._data[_bi_pos_2 + 1] = _x;
					_batch._data[_bi_pos_2 + 2] = _y;
					_batch._data[_bi_pos_2 + 3] = _z;
				}
				_pos_2 = [_x, _y, _z];
				_data[_li_pos_2 + 1] = _x;
				_data[_li_pos_2 + 2] = _y;
				_data[_li_pos_2 + 3] = _z;
			break;
			case 3:
				if _pos_3 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {
					_batch._data[_bi_pos_3 + 1] = _x;
					_batch._data[_bi_pos_3 + 2] = _y;
					_batch._data[_bi_pos_3 + 3] = _z;
				}
				_pos_3 = [_x, _y, _z];
				_data[_li_pos_3 + 1] = _x;
				_data[_li_pos_3 + 2] = _y;
				_data[_li_pos_3 + 3] = _z;
			break;
		}
	}
	static _set_rotation = function(_x, _y, _z, _w) {
		if _rotation = undefined {_create_modifer_index(_sdf_rotation);}
		if _batch != undefined {
			_batch._data[_bi_rotation + 1] = _x;
			_batch._data[_bi_rotation + 2] = _y;
			_batch._data[_bi_rotation + 3] = _z;
			_batch._data[_bi_rotation + 3] = _w;
		}
		_rotation = [_x, _y, _z, _w];		
		_data[_li_rotation + 1] = _x;
		_data[_li_rotation + 2] = _y;
		_data[_li_rotation + 3] = _z;
		_data[_li_rotation + 4] = _w;
	}
	static _set_float = function(_index, _f) {
		switch(_index) {
			case 0:
				if _float_0 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {_batch._data[_bi_float_0 + 1] = _f;}
				_float_0 = _f;
				_data[_li_float_0 + 1] = _f;
			break;
			case 1:
				if _float_1 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {_batch._data[_bi_float_1 + 1] = _f;}
				_float_1 = _f;
				_data[_li_float_1+ 1] = _f;
			break;
			case 2:
				if _float_2 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {_batch._data[_bi_float_2 + 1] = _f;}
				_float_2 = _f;
				_data[_li_float_2+ 1] = _f;
			break;
			case 3:
				if _float_3 = undefined {_not_applicable_error(); break;}
				if _batch != undefined {_batch._data[_bi_float_3 + 1] = _f;}
				_float_3 = _f;
				_data[_li_float_3+ 1] = _f;
			break;
		}
	}
	static _set_color = function(_r, _g, _b, _linear) {
		if _color_0 = undefined {_create_modifer_index(_sdf_color_0);}
		_color_0 = _linear ? [_r, _g, _b] : [_r / 255, _g / 255, _b / 255];
		if _batch != undefined {
			_batch._data[_bi_color_0 + 1] = _color_0[0];
			_batch._data[_bi_color_0 + 2] = _color_0[1];
			_batch._data[_bi_color_0 + 3] = _color_0[2];
		}
		_data[_li_color_0 + 1] = _color_0[0];
		_data[_li_color_0 + 2] = _color_0[1];
		_data[_li_color_0 + 3] = _color_0[2];
	}
	static _set_blend_str = function(_f) {
		if _blend_str = undefined {_create_modifer_index(_sdf_blend_str);}
		if _batch != undefined {_batch._data[_bi_blend_str + 1] = _f;}
		_blend_str = _f;	
		_data[_li_blend_str + 1] = _f;
	}
	static _set_blending_type = function(_f) {
		if _blending = undefined {_create_modifer_index(_sdf_blending);}
		if _batch != undefined {_batch._data[_bi_blending + 1] = _f;}
		_blending = 	_f;
		_data[_li_blending + 1] = _f;
	}
	static _set_scale = function(_x, _y, _z) {
		if _scale_0 = undefined {_not_applicable_error(); exit;}
		_scale_0 = [_x, _y, _z];
		if _batch != undefined {
			_batch._data[_bi_scale_0 + 1] = _scale_0[0];
			_batch._data[_bi_scale_0 + 2] = _scale_0[1];
			_batch._data[_bi_scale_0 + 3] = _scale_0[2];
		}
		_data[_li_scale_0 + 1] = _scale_0[0];
		_data[_li_scale_0 + 2] = _scale_0[1];
		_data[_li_scale_0 + 3] = _scale_0[2];
	}
	static _set_pattern = function(_type, _scale, _alpha) {
		if _pattern = undefined {_create_modifer_index(_sdf_pattern);}
		_pattern = _type;
		if _batch != undefined {
			_batch._data[_bi_pattern + 1] = _type;
			_batch._data[_bi_pattern + 2] = _scale;
			_batch._data[_bi_pattern + 3] = _alpha;
			}
		_data[_li_pattern + 1] = _type;	
		_data[_li_pattern + 2] = _scale;
		_data[_li_pattern + 3] = _alpha;
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
	static _rotate_quaternion = function(_p, _q) {
		var _qxyz = [_q[0], _q[1], _q[2]];
		var _p_qw = _mul(_p, _q[3]);
		return _add(_p, _mul(_cross(_add(_cross(_p, _qxyz), _p_qw), _qxyz), 2.0));
	}
	static _transform_vertex = function(_p, _o, _q, _s) {
		var _v = _rotate_quaternion(_mul(_p, _s), _q);
		return _add(_v, _o);
	}
	static _abs = function(_v) {
	    return [abs(_v[0]), abs(_v[1]), abs(_v[2])];
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
	static _div = function(_v, _s) {
		if is_array(_s) {
			return [_v[0] / _s[0], _v[1] / _s[1], _v[2] / _s[2]];	
		} else {
			return [_v[0] / _s, _v[1] / _s, _v[2] / _s];
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
	static _length = function(_v) {
		switch(array_length(_v)) {
			case 2:
				return sqrt(_v[0] * _v[0] + _v[1] * _v[1]);
			break;
			case 3:
				return sqrt(_v[0] * _v[0] + _v[1] * _v[1] + _v[2] * _v[2]);
			break;
		}
	}
	static _min_component = function(_v) {
	    var _min_c = _v[0];
	    for (var i = 0; i < 3; i++) {
	        if (abs(_v[i]) < abs(_min_c)) {
	            _min_c = _v[i];
	        }
	    }
	    return _min_c;
	}
	static _dot = function(_v, _s) {
		switch (array_length(_v)) {
			case 2:
				return dot_product(_v[0], _v[1], _s[0], _s[1]);
			break;
			case 3:
				return dot_product_3d(_v[0], _v[1], _v[2], _s[0], _s[1], _s[2]);
			break;
		}
	}
	static _dot2 = function(_v) {
		return _dot(_v, _v);	
	}
	static _ndot = function(_v, _s) {
		return _v[0] *_s[0] - _v[1] *_s[1];
	}
	static _magnitude = function(_v) {
		var _in = _v[0] * _v[0] + _v[1] * _v[1] + _v[2] * _v[2];
		if _in = 0 or is_nan(_in) {return 0;}
		return sqrt(_in);
	}
	static _cross = function(_v, _s) {
		return [_v[1] *_s[2] - _v[2] *_s[1], _v[2] *_s[0] - _v[0]*_s[2], _v[0] *_s[1] - _v[1] *_s[0]];
	}
	static _clamp = function(_v, _a, _b) {
		return [clamp(_v[0], _a[0], _b[0]), clamp(_v[1], _a[1], _b[1]), clamp(_v[2], _a[2], _b[2])];
	}
	static _op_revolution = function(_pos, _revolve_amt) {
		return [_length([_pos[0], _pos[2]]) - _revolve_amt, _pos[1]];
	}
	
	// Bounding Box Generation
	static _build_bbox = function() {
		
		// Grab Infinite Macro
		var _inf = _sdf_inf;
		
		// Check for Special Cases
		var _special_case = undefined;
		
		// Detect Special Cases
		if _type = _sdf_plane {_special_case = _type;}
		
		// Apply Special Cases
		if _special_case != undefined {
			
			// Shape-Dependent BBox Case
			switch(_special_case) {
				case _sdf_plane:
					// Infinite Planes get Max Size Box
					_min_bbox = [-_inf, -_inf, -_inf];
					_max_bbox = [_inf, _inf, _inf];
					// Could be optimized for planes that are axis aligned
				break;
				// Other shapes may also need special cases
			}
			
		// End Function Early
		return undefined;
		
		}
		
		// Flag to let Other Functions know we're generating the bbox
		_building_bbox = true;
		
		// Store the Amount of Average Positions
		var _dividend = 1;
		
		// All Shapes use _pos_0
		var _center_pos = _get_centre()
		
		// Offset Vectors for Distance Tests
		var _d0_offset = [_inf, 0.0, 0.0];
		var _d1_offset = [0.0, _inf, 0.0];
		var _d2_offset = [0.0, 0.0, _inf];
		var _d3_offset = [-_inf, 0.0, 0.0];
		var _d4_offset = [0.0, -_inf, 0.0];
		var _d5_offset = [0.0, 0.0, -_inf];
		
		// Positions offset from the Averaged Center of the SHape
		var _d_pos_0 = _add(_center_pos, _d0_offset);
		var _d_pos_1 = _add(_center_pos, _d1_offset);
		var _d_pos_2 = _add(_center_pos, _d2_offset);
		var _d_pos_3 = _add(_center_pos, _d3_offset);
		var _d_pos_4 = _add(_center_pos, _d4_offset);
		var _d_pos_5 = _add(_center_pos, _d5_offset);
		
		// Distance Checks with the Offset Distance Subtracted for Accurate Shape Size
		var _d0 = _inf - distance(_d_pos_0, _normalize(_d3_offset));
		var _d1 = _inf - distance(_d_pos_1, _normalize(_d4_offset));
		var _d2 = _inf - distance(_d_pos_2, _normalize(_d5_offset));
		var _d3 = _inf - distance(_d_pos_3, _normalize(_d0_offset));
		var _d4 = _inf - distance(_d_pos_4, _normalize(_d1_offset));
		var _d5 = _inf - distance(_d_pos_5, _normalize(_d2_offset));
		
		// Calculate bbox
		_min_bbox = _sub(_center_pos, [_d0, _d1, _d2]);
		_max_bbox = _add(_center_pos, [_d3, _d4, _d5]);
		
		// Add Cushion to bbox 
		var _half_cushion = _div([_bbox_cushion, _bbox_cushion, _bbox_cushion], 2);
		_min_bbox = _sub(_min_bbox, _half_cushion);
		_max_bbox = _add(_max_bbox, _half_cushion);
		
		// Let other Functions know we're down building the bbox
		_building_bbox = false;
		
	}
		
	// Bounding Box Distance
	static _bbox_dist = function(_v, _inv_dir){
		global.bboxes_checked++;
		
		// Check if Bounding Box Exists
		if _min_bbox = undefined or _max_bbox = undefined {
			
			// Build Bounding Box for next time if not already
			if !_building_bbox {
				
				// Run Build Function
				_build_bbox();
				
				// If this worked we should just be able to do the test now
				return _in_bbox_range(_v, _inv_dir);
			
			}
			
			// Force Distance Check
			return -1;
			
		} else { // Bounding Box Test
			
			// Calculate Min/Max bbox relative to Ray Origin
			var t_min = _mul(_sub(_min_bbox, _v), _inv_dir);
			var t_max = _mul(_sub(_max_bbox, _v), _inv_dir);
			var t1 = _min(t_min, t_max);
			var t2 = _max(t_min, t_max);
			
			// Farthest Entry and Nearest Exit
			var dist_far = min(min(t2[0], t2[1]), t2[2]);
			var dist_near = max(max(t1[0], t1[1]), t1[2]);
		
			// Hit Detected
			var did_hit = dist_far >= dist_near && dist_far > 0
			
			// Return Distance of bbox if intersected or Infinite if completely Missed
			return did_hit ? dist_near : _sdf_inf;
			
		}
		
		// Force Distance Check if all else fails 
		return -1;
		
	}
	
	// Get Shape Average Center
	static _get_centre = function() {
		
		// Number of Positions used in the Average
		var _dividend = 1;
		
		// All Shapes use _pos_0
		var _center_pos = _pos_0;
		
		// Grab other position values if defined
		if _pos_1 != undefined {
			_center_pos = _add(_center_pos, _pos_1);	
			_dividend++;
		}
		if _pos_2 != undefined {
			_center_pos = _add(_center_pos, _pos_2);	
			_dividend++;
		}
		if _pos_3 != undefined {
			_center_pos = _add(_center_pos, _pos_3);	
			_dividend++;
		}	
			
		// Divide by number of Position values used for Average
		_center_pos = _div(_center_pos, _dividend);
		
		return _center_pos;
	}

	#endregion
	#region Common Functions
	
	// Set a custom color for your shape
	static color = function(_r, _g, _b, _linear) {
		_set_color(_r, _g, _b, _linear);
	}
		
	// Set Blending Settings
	static blending = function(_type, _strength = 0) {
		_set_blending_type(_type);	
		_set_blend_str(_strength);
	}	
	
	// Set a pattern for your shape 
	static pattern = function(_type, _scale, _alpha) {
		_set_pattern(_type, _scale, _alpha);
	}
	
	// Set Rotation for your Shape
	static rotation = function(_x_angle, _y_angle, _z_angle) {
	    var cr = dcos(_x_angle * 0.5);
	    var sr = dsin(_x_angle * 0.5);
	    var cp = dcos(_y_angle * 0.5);
	    var sp = dsin(_y_angle * 0.5);
	    var cy = dcos(_z_angle * 0.5);
	    var sy = dsin(_z_angle* 0.5);
	    var qx = sr * cp * cy - cr * sp * sy;
	    var qy = cr * sp * cy + sr * cp * sy;
	    var qz = cr * cp * sy - sr * sp * cy;
	    var qw = cr * cp * cy + sr * sp * sy;
		_set_rotation(qx, qy, qz, qw);
	}
	
	// Get Distance to Shape from a Point 
	static distance = function(_x, _y, _z, _inv_dir) {
		var _res;
		var _p;
		var inv_dir = _inv_dir;
		if is_array(_x) {
			_p = _x;
			inv_dir = _y;
		} else {
			var _p = [_x, _y, _z];
			inv_dir = _inv_dir;
		}
		if _min_bbox = undefined or _max_bbox = undefined {
			if !_building_bbox{_build_bbox();}
			_res = _get_dist(_p);
		} else {		
			var bb_dist = _bbox_dist(_p, inv_dir);
			if bb_dist < 0 {	// Inside the Bounding Box
				global.bbox_successes++;
					if _rotation != undefined {
					var _q = _normalize(_rotation);
					_p = _transform_vertex(_sub(_p, _pos_0), _pos_0, _q, [1, 1, 1]);
					}
				global.distances_checked++;
				_res = _get_dist(_p);
			} else {_res = bb_dist;}
		}
		return _res;
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
		var _inv_dir = _mul(_dir, -1);
		while(true) {
			var p = _add(_start, _mul(_dir, _d));
			var  _dist = distance(p, _inv_dir);
			_d += _dist;
			if (_dist < _sd) {
				hit = true;
				var _res = p;
				array_push(_res, self);
				return _res;
			}
			if (_d > _md) {			
				hit = false;
				return p;
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

	#endregion 
	
}