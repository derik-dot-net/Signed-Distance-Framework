function sdf_box_frame(_x, _y, _z, _x_scale, _y_scale, _z_scale, _thickness) {
	return new __sdf_box_frame(_x, _y, _z, _x_scale, _y_scale, _z_scale, _thickness);
}
function __sdf_box_frame(_x, _y, _z, _x_scale, _y_scale, _z_scale, _thickness) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_box_frame;
	_pos_0 = [_x, _y, _z];
	_scale_0 = [_x_scale, _y_scale, _z_scale];
	_float_0 = _thickness;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_scale_0, _x_scale, _y_scale, _z_scale,	
						_sdf_float_0, _thickness];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_scale_0 = 6;
	_li_float_0 = 10;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_scale_0 = _index_in_batch_data + _li_scale_0 + 1;	
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	scale = function(_x, _y, _z) {
		_set_scale(_x, _y, _z);	
	}
	rounding = function(_amount) {
		_set_float(0, _amount);	
	}
	
	#endregion	
	
}