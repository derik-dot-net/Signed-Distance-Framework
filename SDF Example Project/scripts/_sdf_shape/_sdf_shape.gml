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
	
	// Trying to set a data type using an internal function in a way that isn't applicable
	_not_applicable_error = function() {
		var _error_str = "You're trying to set a data type that the shape does not use or contain, and/or does not have as an applicable modifier.";
		show_debug_message(_sdf_error_tag_str + _error_str);
	}
	
	// Modifer Local and Batch Indices
	_create_modifer_index = function(_mode) {
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
		}
	}	
	_update_modifer_indices = function() {
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
	}	
	
	// Data Setters (Handles Local and Batch Updates)
	_set_pos = function(_index, _x, _y, _z) {
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
	_set_rotation = function(_x, _y, _z, _w) {
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
	_set_float = function(_index, _f) {
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
	_set_color = function(_r, _g, _b, _linear) {
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
	_set_blend_str = function(_f) {
		if _blend_str = undefined {_create_modifer_index(_sdf_blend_str);}
		if _batch != undefined {_batch._data[_bi_blend_str + 1] = _f;}
		_blend_str = _f;	
		_data[_li_blend_str + 1] = _f;
	}
	_set_blending_type = function(_f) {
		if _blending = undefined {_create_modifer_index(_sdf_blending);}
		if _batch != undefined {_batch._data[_bi_blending + 1] = _f;}
		_blending = 	_f;
		_data[_li_blending + 1] = _f;
	}
	_set_scale = function(_x, _y, _z) {
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
	_set_pattern = function(_type, _scale, _alpha) {
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
	
	#endregion
	#region Common Functions
	
	// Set a custom color for your shape
	color = function(_r, _g, _b, _linear) {
		_set_color(_r, _g, _b, _linear);
	}
		
	// Set Blending Settings
	blending = function(_type, _strength = 0) {
		_set_blending_type(_type);	
		_set_blend_str(_strength);
	}	
	
	// Set a pattern for your shape 
	pattern = function(_type, _scale, _alpha) {
		_set_pattern(_type, _scale, _alpha);
	}
	
	#endregion 
	
}