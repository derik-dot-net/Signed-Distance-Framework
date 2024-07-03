function sdf_box(_x, _y, _z, _x_scale, _y_scale, _z_scale) {
	return new __sdf_box(_x, _y, _z, _x_scale, _y_scale, _z_scale);
}
function __sdf_box(_x, _y, _z, _x_scale, _y_scale, _z_scale) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_box;
	_pos_0 = [_x, _y, _z];
	_scale_0 = [_x_scale, _y_scale, _z_scale];
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_scale_0, _x_scale, _y_scale, _z_scale	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_scale_0 = 6;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_scale_0 = _index_in_batch_data + _li_scale_0 + 1;	
	}
	
	// Distance Function
	_get_dist = function(_p) {
		var _q = _sub(_abs(_sub(_p, _pos_0)), _scale_0);
		return _length(_max(_q, 0.0)) +  min(max(_q[0], max(_q[1], _q[2])), 0.0);
	}
	
	//shape_dist = sdf_box(shape_p - pos_0, scale_0);
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	scale = function(_x, _y, _z) {
		_set_scale(_x, _y, _z);	
	}
	
	#endregion	
	
}