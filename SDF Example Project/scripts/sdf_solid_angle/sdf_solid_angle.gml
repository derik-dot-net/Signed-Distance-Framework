function sdf_solid_angle(_x, _y, _z, _angle_degrees, _radius) {
	return new __sdf_solid_angle(_x, _y, _z, _angle_degrees, _radius);
}
function __sdf_solid_angle(_x, _y, _z, _angle_degrees, _radius) : _sdf_shape() constructor {

	#region (Internal)
	
	// Data
	_type = _sdf_solid_angle;
	_pos_0 = [_x, _y, _z];
	_float_0 = degtorad(clamp(_angle_degrees, -89, 89));
	_float_1 = _radius;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, degtorad(clamp(_angle_degrees, -89, 89)),		
						_sdf_float_1, _radius	];
						
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
	radius = function(_radius) {
		_set_float(1, _radius);	
	}
	
	#endregion	
	
}