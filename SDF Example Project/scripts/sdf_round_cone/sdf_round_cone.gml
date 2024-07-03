function sdf_round_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2) {
	return new __sdf_round_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2);
}
function __sdf_round_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_round_cone;
	_pos_0 = [_x1, _y1, _z1];
	_pos_1 = [_x2, _y2, _z2];
	_float_0 = _radius_1;
	_float_1 = _radius_2;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x1, _y1,  _z1,
						_sdf_pos_1, _x2, _y2,  _z2,
						_sdf_float_0, _radius_1,		
						_sdf_float_1, _radius_2	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_pos_1 = 6;
	_li_float_0 = 10;
	_li_float_1 = 12;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_pos_1 = _index_in_batch_data + _li_pos_1 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
		_bi_float_1 = _index_in_batch_data + _li_float_1 + 1;	
	}
	
	// Distance Function
	_get_dist = function(_p) {
		var p = _p;
		var a = _pos_0;
		var b = _pos_1;
		var r1 = _float_0;
		var r2 = _float_1;
		
		var ba = _sub(b, a);
		var l2 = _dot(ba,ba);
		var rr = r1 - r2;
		var a2 = l2 - rr*rr;
		var il2 = 1.0/l2;
		var pa = _sub(p, a);
		var _y = _dot(pa,ba);
		var z = _y - l2;
		var x2 = _dot2( _sub(_mul(pa, l2), _mul(ba, _y)));
		var y2 = _y*_y*l2;
		var z2 = z*z*l2;
		var k = sign(rr)*rr*rr*x2;
		if( sign(z)*a2*z2>k ) return  (sqrt(x2 + z2)        *il2 - r2);
		if( sign(_y)*a2*y2<k ) return  (sqrt(x2 + y2)        *il2 - r1);
		                    return (sqrt(x2*a2*il2)+_y*rr)*il2 - r1;
	}

	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 1), _x, _y, _z);
	}
	radius = function(_index, _radius) {
		_set_float(clamp(_index, 0, 1), _radius);	
	}
	
	#endregion	
	
}