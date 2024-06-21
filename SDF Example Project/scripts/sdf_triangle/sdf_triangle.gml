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
	
	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 2), _x, _y, _z);
	}

	#endregion	
	
}