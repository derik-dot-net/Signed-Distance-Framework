function sdf_hex_prism(_x, _y, _z, _width, _height) {
	return new __sdf_hex_prism(_x, _y, _z, _width, _height);
}
function __sdf_hex_prism(_x, _y, _z, _width, _height) : _sdf_shape() constructor {

	#region (Internal)
	
	// Data
	_type = _sdf_hex_prism;
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

	// Distance Function
	_get_dist = function(_p) {
		var p = _sub(_p, _pos_0);
		var h = [_float_0, _float_1];
		var k = [-0.8660254, 0.5, 0.57735];
		p = _abs(p);
		var pxy = _mul([k[0], k[1]], 2.0*min(_dot([k[0], k[1]], [p[0], p[1]]), 0.0));
		p[0] -= pxy[0];
		p[1] -= pxy[1];
		var d = [_length(_sub([p[0], p[1]], [clamp(p[0],-k[2]*h[0],k[2]*h[0]), h[0]])) * sign(p[1] - h[0]), p[2] - h[1]];
		return min(max(d[0], d[1]), 0.0) + _length(_max(d, 0.0));
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