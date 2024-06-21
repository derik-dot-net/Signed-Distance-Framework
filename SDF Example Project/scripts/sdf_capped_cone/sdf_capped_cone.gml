function sdf_capped_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2) {
	return new __sdf_capped_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2);
}
function __sdf_capped_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_capped_cone;
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