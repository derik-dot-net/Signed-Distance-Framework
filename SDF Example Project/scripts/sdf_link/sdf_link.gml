function sdf_link(_x, _y, _z, _length, _radius, _thickness) {
	return new __sdf_link(_x, _y, _z, _length, _radius, _thickness);
}
function __sdf_link(_x, _y, _z, _length, _radius, _thickness) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_link;
	_pos_0 = [_x, _y, _z];
	_float_0 = _length;
	_float_1 = _radius;
	_float_2 = _thickness;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _length,		
						_sdf_float_1, _radius,
						_sdf_float_2, _thickness	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_float_0 = 6;
	_li_float_1 = 8;
	_li_float_2 = 10;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
		_bi_float_1 = _index_in_batch_data + _li_float_1 + 1;	
		_bi_float_2 = _index_in_batch_data + _li_float_2 + 1;	
	}
	
	// Distance Function
	_get_dist = function(_p) {
		var p = _sub(_p, _pos_0);
		var le = _float_0;
		var r1 = _float_1;
		var r2 = _float_2;
		var q = [p[0], max(abs(p[1]) - le, 0.0), p[2]];
		return _length([_length([q[0], q[1]]) - r1, q[2]]) - r2;
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	length = function(_length) {
		_set_float(0, _length);	
	}
	radius = function(_radius) {
		_set_float(1, _radius);	
	}
	thickness = function(_thickness) {
		_set_float(2, _thickness);	
	}
	
	#endregion	
	
}