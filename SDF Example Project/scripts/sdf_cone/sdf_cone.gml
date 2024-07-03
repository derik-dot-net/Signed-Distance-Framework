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
		
	// Distance Function
	_get_dist = function(_p) {
		var p = _sub(_p, _pos_0);
		var c = [sin(_float_0), cos(_float_0)];
		var h = _float_1;
		var q = _mul([c[0]/c[1], -1], h);
		var w = [_length([p[0], p[2]]), p[1]];
		var a = _sub(w, _mul(q, clamp(_dot(w, q) / _dot(q, q), 0.0, 1.0)));
		var b = _sub(w, _mul(q, [clamp(w[0]/q[0], 0.0, 1.0), 1.0]));
		var k = sign(q[1]);
		var d = min(_dot(a, a), _dot(b, b));
		var s = max(k * (w[0] * q[1] - w[1] * q[0]), k * (w[1] - q[1]));
		return sqrt(d) * sign(s);
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