function sdf_triangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) {
	return new __sdf_triangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3);
}
function __sdf_triangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_triangle;
	_pos_0 = [_x1, _y1, _z1];
	_pos_1 = [_x2, _y2, _z2];
	_pos_2 = [_x3, _y3, _z3];
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x1, _y1, _z1,
						_sdf_pos_1, _x2, _y2, _z2,
						_sdf_pos_2, _x3, _y3, _z3	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_pos_1 = 6;
	_li_pos_2 = 10;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_pos_1 = _index_in_batch_data + _li_pos_1 + 1;
		_bi_pos_2 = _index_in_batch_data + _li_pos_2 + 1;	
	}

	// Distance Function
	_get_dist = function(_p) {
		var p = _p;
		var a = _pos_0;
		var b = _pos_1;
		var c = _pos_2;
		var ba = _sub(b, a);
		var pa = _sub(p, a);
		var cb = _sub(c, b);
		var pb = _sub(p, b);
		var ac = _sub(a, c);
		var pc = _sub(p, c);
		var nor = _cross(ba, ac);
		return sqrt(
		(sign(_dot(_cross(ba, nor), pa)) +
		sign(_dot(_cross(cb, nor), pb)) +
		sign(_dot(_cross(ac, nor), pc)) < 2.0) ?
		min(min(
		    _dot2(_sub(_mul(ba, clamp(_dot(ba, pa) / _dot2(ba), 0.0, 1.0)), pa)),
		    _dot2(_sub(_mul(cb, clamp(_dot(cb, pb) / _dot2(cb), 0.0, 1.0)), pb))),
		    _dot2(_sub(_mul(ac, clamp(_dot(ac, pc) / _dot2(ac), 0.0, 1.0)), pc)))
		:
		_dot(nor, pa) * _dot(nor, pa) / _dot2(nor)
		);
	}
	
	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 2), _x, _y, _z);
	}

	#endregion	
	
}