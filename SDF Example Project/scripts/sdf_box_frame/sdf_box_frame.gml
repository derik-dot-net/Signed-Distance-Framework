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
	
	// Distance Function
	_get_dist = function(_p) {
		var p = _sub(_abs(_sub(_p, _pos_0)), _scale_0);
		var q = _sub(_abs(_add(p, _float_0)), _float_0);
		return min(min(
		_length(_max([p[0], q[1], q[2]], 0.0)) + min(max(p[0], max(q[1], q[2])), 0.0),
		_length(_max([q[0], p[1], q[2]], 0.0)) + min(max(q[0], max(p[1], q[2])), 0.0)),
		_length(_max([q[0], q[1], p[2]], 0.0)) + min(max(q[0], max(q[1], p[2])), 0.0));
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