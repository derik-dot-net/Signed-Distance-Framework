function sdf_quad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _x4, _y4, _z4) {
	return new __sdf_quad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _x4, _y4, _z4);
}
function __sdf_quad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _x4, _y4, _z4) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_quad;
	_pos_0 = [_x1, _y1, _z1];
	_pos_1 = [_x2, _y2, _z2];
	_pos_2 = [_x3, _y3, _z3];
	_pos_3 = [_x4, _y4, _z4];
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x1, _y1, _z1,
						_sdf_pos_1, _x2, _y2, _z2,
						_sdf_pos_2, _x3, _y3, _z3,
						_sdf_pos_3, _x4, _y4, _z4	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_pos_1 = 6;
	_li_pos_2 = 10;
	_li_pos_3 = 14;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_pos_1 = _index_in_batch_data + _li_pos_1 + 1;
		_bi_pos_2 = _index_in_batch_data + _li_pos_2 + 1;	
		_bi_pos_3 = _index_in_batch_data + _li_pos_3 + 1;	
	}

	// Distance Function
	_get_dist = function(_p) {
		var p = _p;
		var a = _pos_0;
		var b = _pos_1;
		var c = _pos_2;
		var d = _pos_3;
		var ba = _sub(b, a);
		var pa = _sub(p, a);
		var cb = _sub(c, b);
		var pb = _sub(p, b);
		var dc = _sub(d, c);
		var pc = _sub(p, c);
		var ad = _sub(a, d);
		var pd = _sub(p, d);
		var nor = _cross(ba, ad);
		return sqrt(
		    (sign(_dot(_cross(ba, nor), pa)) +
		    sign(_dot(_cross(cb, nor), pb)) +
		    sign(_dot(_cross(dc, nor), pc)) +
		    sign(_dot(_cross(ad, nor), pd)) < 3.0) ?
		    min(min(min(
		        _dot2(_sub(_mul(ba, clamp(_dot(ba, pa) / _dot2(ba), 0.0, 1.0)), pa)),
		        _dot2(_sub(_mul(cb, clamp(_dot(cb, pb) / _dot2(cb), 0.0, 1.0)), pb))),
		        _dot2(_sub(_mul(dc, clamp(_dot(dc, pc) / _dot2(dc), 0.0, 1.0)), pc))),
		        _dot2(_sub(_mul(ad, clamp(_dot(ad, pd) / _dot2(ad), 0.0, 1.0)), pd)))
		    :
		    _dot(nor, pa) * _dot(nor, pa) / _dot2(nor)
		);
	}
	
	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 3), _x, _y, _z);
	}

	#endregion	
	
}