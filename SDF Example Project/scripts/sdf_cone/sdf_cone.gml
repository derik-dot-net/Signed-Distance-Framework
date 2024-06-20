function sdf_cone(_x, _y, _z, _angle_degrees, _height) {
	return new __sdf_sdf_cone(_x, _y, _z, _angle_degrees, _height);
}
function __sdf_sdf_cone(_x, _y, _z, _angle_degrees, _height) : _sdf_shape() constructor {

	#region (Internal)
	
	// Data
	_type = _sdf_cone;
	_pos_0 = [_x, _y, _z];
	_float_0 = degtorad(clamp(_angle_degrees, -89, 89));
	_float_1 = _height;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, degtorad(clamp(_angle_degrees, -89, 89)),		
						_sdf_float_1, _height	];
						
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
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	angle_degrees = function(_angle_degrees) {
		_set_float(0, degtorad(clamp(_angle_degrees, -89, 89)));	
	}
	height = function(_height) {
		_set_float(1, _height);	
	}
	
	#endregion	
	
}