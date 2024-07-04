function sdf_egg(_x, _y, _z, _radius, _height, _roundness) {
	return new __sdf_egg(_x, _y, _z, _radius, _height, _roundness);
}
function __sdf_egg(_x, _y, _z, _radius, _height, _roundness) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_egg;
	_pos_0 = [_x, _y, _z];
	_float_0 = _radius;
	_float_1 = _roundness;
	_float_2 = _height;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _radius,		
						_sdf_float_1, _roundness,
						_sdf_float_2, _height	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_float_0 = 6;
	_li_float_1 = 8;
	_li_float_2 = 10;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
		_bi_float_1 = _index_in_batch_data + _li_float_1 + 1;	
		_bi_float_2 = _index_in_batch_data + _li_float_2 + 1;	
	}

	// Distance Function
	_get_dist = function(_p) {
		var p = _sub(_p, _pos_0);
		var a = _float_0;
		var b = _float_1;
		var h = _float_2;
		var p2 = p; 
		p2[2] = p[1]; 
		p2[1] = p[2];
		var _pp = _op_revolution(p2, 0.0);
		_pp[0] = abs(_pp[0]);
		var r = (a - b);
		h += r;
		var l = (h * h - r * r) / (2.0 * r);
		var ext =   ((_pp[1]-h)*l > _pp[0]*h)
		          ?  _length(_sub(_pp, [0.,h])) - ((a+l)-_length([h,l])) : 
		           _length(_add(_pp,[l,0.])) - (a+l);
		return (_pp[1] <= 0.0) ? _length(_pp) - a : ext;
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	radius = function(_radius) {
		_set_float(0, _radius);	
	}
	roundness = function(_roundness) {
		_set_float(1, _roundness);	
	}
	height = function(_height) {
		_set_float(2, _height);	
	}
		
	#endregion	
	
}