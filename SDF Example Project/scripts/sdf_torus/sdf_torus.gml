function sdf_torus(_x, _y, _z, _radius, _thickness) {
	return new __sdf_torus(_x, _y, _z, _radius, _thickness);
}
function __sdf_torus(_x, _y, _z, _radius, _thickness) : _sdf_shape() constructor {

	#region (Internal)
	
	// Data
	_type = _sdf_torus;
	_pos_0 = [_x, _y, _z];
	_float_0 = _radius;
	_float_1 = _thickness;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _radius,		
						_sdf_float_1, _thickness	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_float_0 = 6;
	_li_float_1 = 8;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
		_bi_float_1 = _index_in_batch_data + _li_float_1 + 1;	
	}
		
	// Distance Function
	_get_dist = function(_p) {
		var p = _sub(_p, _pos_0);
		return _length([_length([p[0], p[2]]) - _float_0, p[1]]) - _float_1; 
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	radius = function(_radius) {
		_set_float(0, _radius);	
	}
	thickness = function(_thickness) {
		_set_float(1, _thickness);	
	}
	
	#endregion	
	
}