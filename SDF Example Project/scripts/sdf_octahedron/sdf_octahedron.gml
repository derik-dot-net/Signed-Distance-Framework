function sdf_octahedron(_x, _y, _z, _radius) {
	return new __sdf_octahedron(_x, _y, _z, _radius);
}
function __sdf_octahedron(_x, _y, _z, _radius) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_octahedron;
	_pos_0 = [_x, _y, _z];
	_float_0 = _radius;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _radius		];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_float_0 = 6;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	radius = function(_radius) {
		_set_float(0, _radius);	
	}
	
	#endregion	
	
}