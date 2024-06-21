function sdf_death_star(_x, _y, _z, _radius_1, _radius_2, _dist) {
	return new __sdf_death_star(_x, _y, _z, _radius_1, _radius_2, _dist);
}
function __sdf_death_star(_x, _y, _z, _radius_1, _radius_2, _dist) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_death_star;
	_pos_0 = [_x, _y, _z];
	_float_0 = _radius_1;
	_float_1 = _radius_2;
	_float_2 = _dist;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _radius_1,		
						_sdf_float_1, _radius_2,
						_sdf_float_2, _dist	];
						
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
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	radius = function(_index, _radius) {
		_set_float(clamp(_index, 0, 1), _radius);	
	}
	spacing = function(_spacing) {
		_set_float(2, _spacing);	
	}
	
	#endregion	
	
}