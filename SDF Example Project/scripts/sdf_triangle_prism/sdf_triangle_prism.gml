function sdf_triangle_prism(_x, _y, _z, _width, _height) {
	return new __sdf_triangle_prism(_x, _y, _z, _width, _height);
}
function __sdf_triangle_prism(_x, _y, _z, _width, _height) : _sdf_shape() constructor {

	#region (Internal)
	
	// Data
	_type = _sdf_tri_prism;
	_pos_0 = [_x, _y, _z];
	_float_0 = _width;
	_float_1 = _height;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _width,		
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
	width = function(_width) {
		_set_float(0, _width);	
	}
	height = function(_height) {
		_set_float(1, _height);	
	}
	
	#endregion	
	
}