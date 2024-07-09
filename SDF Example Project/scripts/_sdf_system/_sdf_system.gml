// INTERNAL //
#region Macros 

// Shapes
#macro _sdf_sphere							0
#macro _sdf_box								1
#macro	_sdf_round_box					2
#macro _sdf_box_frame					3
#macro _sdf_torus							4
#macro _sdf_capped_torus				5
#macro _sdf_link								6
#macro _sdf_cone								7
#macro _sdf_round_cone				8
#macro _sdf_plane							9
#macro _sdf_hex_prism					10
#macro _sdf_tri_prism						11
#macro _sdf_capsule						12
#macro _sdf_cylinder						13
#macro _sdf_capped_cone				14
#macro _sdf_solid_angle					15
#macro _sdf_cut_sphere					16
#macro _sdf_cut_hollow_sphere	17
#macro _sdf_death_star					18
#macro _sdf_ellipsoid						19
#macro _sdf_rhombus						20
#macro _sdf_octahedron				21
#macro _sdf_pyramid						22
#macro _sdf_triangle						23						
#macro _sdf_quad								24
#macro _sdf_egg								25

// Shading Types
#macro sdf_default_shading		0
#macro sdf_toon_shading			1

// Blending Operations
#macro op_union							0
#macro op_sub								1
#macro op_int								2
#macro op_xor								3
#macro op_smooth_union			4
#macro op_smooth_sub				5
#macro op_smooth_int				6

// Array Flags
#macro _sdf_array_end_flag		-1

// Data Type Flags
#macro _sdf_entry_len					-2
#macro _sdf_type							-3
#macro _sdf_blending					-4
#macro _sdf_pos_0						-5
#macro _sdf_pos_1						-6
#macro _sdf_pos_2						-7
#macro _sdf_pos_3						-8
#macro _sdf_scale_0						-9
#macro _sdf_rotation					-10
#macro _sdf_float_0						-11
#macro _sdf_float_1						-12
#macro _sdf_float_2						-13
#macro _sdf_float_3						-14
#macro _sdf_color_0						-15
#macro _sdf_blend_str					-16
#macro _sdf_pattern					-17

#macro _sdf_error_tag_str	"SDF ERROR: "
#macro _sdf_inf 99999

// Pattern Flags
#macro sdf_pattern_none								0
#macro sdf_pattern_checkered						1
//#macro sdf_pattern_checkered_filtered	2
#macro sdf_pattern_xor									3
//#macro sdf_pattern_xor_filtered				4
#macro sdf_pattern_grid									5
//#macro sdf_pattern_grid_filtered				6

#endregion 
#region Uniforms

// Textures
global._sdf_tex_toonramp	= sprite_get_texture(spr_sdf_toonramp, 0);

// Uniforms
global._u_sdf_view_mat		= shader_get_uniform(shd_sdf, "view_mat");
global._u_sdf_proj_mat			= shader_get_uniform(shd_sdf, "proj_mat");
global._u_sdf_input_array	= shader_get_uniform(shd_sdf, "sdf_input_array");
global._u_toonramp				= shader_get_sampler_index(shd_sdf, "tex_toonramp");

#endregion
#region vBuffer Format

// Vertex Buffer Format
vertex_format_begin();
vertex_format_add_position();
global._sdf_vformat = vertex_format_end();

#endregion
#region Functions & Structs

// Functions
function _sdf_2d_to_3d(V, P, _x, _y) {
	var mx = -(2 * (_x / window_get_width() - .5) / P[0]);
	var my = (2 * (_y / window_get_height() - .5) / P[5]);
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);
	if (P[15] == 0) {
	    return [V[2]  + mx * V[0] + my * V[1],
	            V[6]  + mx * V[4] + my * V[5],
	            V[10] + mx * V[8] + my * V[9],
	            camX,
	            camY,
	            camZ];
	} else {  
	    return [V[2],
	            V[6],
	            V[10],
	            camX + mx * V[0] + my * V[1],
	            camY + mx * V[4] + my * V[5],
	            camZ + mx * V[8] + my * V[9]];
	}
}
function print() {
    var _str = "";
    for (var i = 0; i < argument_count; i ++) {
        _str += string(argument[i]);
    }
    show_debug_message(_str);
}

// Structs
function _sdf_bvh(_batch, __max_depth) constructor {
	_node_array = new _sdf_bvh_node_list();
	_shape_array = variable_clone(_batch.sdf_array);
	_max_depth = __max_depth;
	static _build = function() {
		var _bounds = new _sdf_bbox();
		for (var i = 0; i < array_length(_shape_array); i++) {
			var _shape = _shape_array[i];
			_bounds._grow_to_include(_shape._bbox._min, _shape._bbox._max);
		}
		_node_array._add(new _sdf_bvh_node(_bounds));
		_split(0, _shape_array, 0, array_length(_shape_array), 0);
	}
	static _split = function(_parent_index, _shapes, _global_start, _shape_number, _depth = 0) {
		var _parent = _node_array._nodes[_parent_index];
		var _size = _parent._calculate_bounds_size();
		var _parent_cost = _node_cost(_size, _shape_number);
		var _split_choice = _choose_split(_parent, _global_start, _shape_number);
		var _split_axis = _split_choice[0];
		var _split_pos = _split_choice[1];
		var _cost = _split_choice[2];
		if (_cost < _parent_cost && _depth < _max_depth) {
			var _bounds_left = new _sdf_bbox();
			var _bounds_right = new _sdf_bbox();
			var _num_on_left = 0;
			for (var i = _global_start; i < _global_start + _shape_number; i++) {
				var _sdf = _shape_array[i];
				if (_sdf._get_centre()[_split_axis] < _split_pos) {
					_bounds_left._grow_to_include(_sdf._bbox._min, _sdf._bbox._max);
					var _swap = _shapes[_global_start + _num_on_left];
					_shapes[_global_start + _num_on_left] = _sdf;
					_shapes[i] = _swap;
					_num_on_left++;
				} else {
					_bounds_right._grow_to_include(_sdf._bbox._min, _sdf._bbox._max);
				}	
			}
			var _num_on_right = _shape_number - _num_on_left;
			var _shape_start_left = _global_start + 0;
			var _shape_start_right = _global_start + _num_on_left;
			
			// Split Parent into two children
			var _child_index_left = _node_array._add(new _sdf_bvh_node(_bounds_left, _shape_start_left, 0));
			var _child_index_right = _node_array._add(new _sdf_bvh_node(_bounds_right, _shape_start_right, 0));
			
			_parent._start_index = _child_index_left;
			_node_array._nodes[_parent_index] = _parent;
			
			// Recursively split children
            _split(_child_index_left, _shapes, _global_start, _num_on_left, _depth + 1);
            _split(_child_index_right, _shapes, _global_start + _num_on_left, _num_on_right, _depth + 1);
			
		} else {
            // Parent is actually Leaf, assign all Shapes to it
            _parent._start_index = _global_start;
            _parent._shape_number = _shape_number;
            _node_array._nodes[_parent_index] = _parent;
		}
	}
	static _choose_split = function(_node, _start, _count) {
		if (_count <= 1) return [0, 0, _sdf_inf];
        var _best_split_pos = 0;
        var  _best_split_axis = 0;
        var _num_split_tests = 5;
        var _best_cost = _sdf_inf;
        for (var _axis = 0; _axis < 3; _axis++) {
            for (var i = 0; i < _num_split_tests; i++) {
                var _split_t = (i + 1) / (_num_split_tests + 1);
                var _split_pos = lerp(_node._bounds_min[_axis], _node._bounds_max[_axis], _split_t);		
                var _cost = _evaluate_split(_axis, _split_pos, _start, _count);
                if (_cost < _best_cost) {
                    _best_cost = _cost;
                    _best_split_pos = _split_pos;
                    _best_split_axis = _axis;
                }
            }
        }
		return [_best_split_axis, _best_split_pos, _best_cost];
	}
	static _evaluate_split = function(_split_axis, _split_pos, _start, _count) {
		var _bounds_left = new _sdf_bbox();
		var _bounds_right = new _sdf_bbox();
		var _num_on_left = 0;
		var _num_on_right = 0;
		for (var i = _start; i < _start + _count; i++) {
		    var _sdf = _shape_array[i];
			var _sdf_centre = _sdf._get_centre();
		    if (_sdf_centre[_split_axis] < _split_pos) {
		        _bounds_left._grow_to_include(_sdf._bbox._min, _sdf._bbox._max);
		        _num_on_left++;
		    } else {
		        _bounds_right._grow_to_include(_sdf._bbox._min, _sdf._bbox._max);
		        _num_on_right++;
		    }
		}
		var _cost_a = _node_cost(_bounds_left._size(), _num_on_left);
		var _cost_b = _node_cost(_bounds_right._size(), _num_on_right);
		return _cost_a + _cost_b;
	}
	static _node_cost = function(_size, _shape_number) {
		var _half_area = _size[0] * _size[1] + _size[0] * _size[2] + _size[1] * _size[2];
		print("_half_area *_shape_number: ", _half_area *_shape_number);
        return _half_area *_shape_number;	
	}
}
function _sdf_bbox(_min_new  = [0, 0, 0], _max_new = [0, 0, 0]) constructor {
	_min = variable_clone(_min_new);
	_max = variable_clone(_max_new);
	_has_point = false;
	static _grow_to_include = function(_min_new, _max_new) {
		if (_has_point) {
			_min[0] = min(_min_new[0], _min[0]);
			_min[1] = min(_min_new[1], _min[1]);
			_min[2] = min(_min_new[2], _min[2]);
			_max[0] = max(_max_new[0], _max[0]);
			_max[1] = max(_max_new[1], _max[1]);
			_max[2] = max(_max_new[2], _max[2]);
		} else {
			_has_point = true;
			_min = variable_clone(_min_new);
			_max = variable_clone(_max_new);
		}
	}
	static _centre = function() {	
		return [	(_min[0] + _max[0]) / 2,
						(_min[1] + _max[1]) / 2,
						(_min[2] + _max[2]) / 2	];
	}
	static _size = function() {
		return [	_max[0] - _min[0],
						_max[1] - _min[1], 
						_max[2] - _min[2]	];
	}
}
function _sdf_bvh_node(_bounds, __start_index = -1, __shape_count = -1) constructor {
	_bounds_min = variable_clone(_bounds._min);
	_bounds_max = variable_clone(_bounds._max);
	_start_index = __start_index;
	_shape_count = __shape_count;
	static _calculate_bounds_size = function() {
		return [	_bounds_max[0] - _bounds_min[0],
						_bounds_max[1] - _bounds_min[1], 
						_bounds_max[2] - _bounds_min[2]	];
	}
	static _calculate_bounds_centre = function() {
		return [	(_bounds_min[0] + _bounds_max[0]) / 2, 
						(_bounds_min[1] + _bounds_max[1]) / 2, 
						(_bounds_min[2] + _bounds_max[2]) / 2	];
	}
}
function _sdf_bvh_node_list() constructor {
	_nodes = [];
	_index = 0;	
	static _add = function(_node) {
		var _node_array_len = array_length(_nodes);
		if (_index >= _node_array_len) {
			array_resize(_nodes, _node_array_len * 2);
		}
		var _node_index = _index;
		_nodes[_index++] = _node;
		return _node_index;
	}
	static _node_count = function() {
		return _index;	
	}	
}
	
#endregion