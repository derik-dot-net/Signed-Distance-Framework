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
	
	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 3), _x, _y, _z);
	}

	#endregion	
	
}