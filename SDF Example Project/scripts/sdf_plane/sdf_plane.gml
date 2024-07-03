function sdf_plane(_x, _y, _z, _nx, _ny, _nz, _thickness) {
	return new __sdf_plane(_x, _y, _z, _nx, _ny, _nz, _thickness);
}
function __sdf_plane(_x, _y, _z, _nx, _ny, _nz, _thickness) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_plane;
	_pos_0 = [_x, _y, _z];
	_pos_1 = [_nx, _ny, _nz];
	_float_0 = _thickness;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_pos_1, _nx, _ny,  _nz,
						_sdf_float_0, _thickness	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_pos_1 = 6;
	_li_float_0 = 10;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_pos_1 = _index_in_batch_data + _li_pos_1 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
	}
		
	// Distance Function
	_get_dist = function(_p) {
		return _dot(_sub(_p, _pos_0), _normalize(_pos_1)) + _float_0;
	}

	#endregion
	#region Functions
	
	position = function(_x, _y, _z,) {
		_set_pos(0, _x, _y, _z);
	}
	normal = function(_nx, _ny, _nz) {
		_set_pos(1, _nx, _ny, _nz);
	}
	thickness = function(_thickness) {
		_set_float(0, _thickness);	
	}
	
	#endregion	
	
}