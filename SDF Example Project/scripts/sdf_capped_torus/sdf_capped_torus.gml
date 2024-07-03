function sdf_capped_torus(_x, _y, _z, _angle_degrees, _radius, _thickness) {
	return new __sdf_capped_torus(_x, _y, _z, _angle_degrees, _radius, _thickness);
}
function __sdf_capped_torus(_x, _y, _z, _angle_degrees, _radius, _thickness) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_capped_torus;
	_pos_0 = [_x, _y, _z];
	_float_0 = degtorad(_angle_degrees);
	_float_1 = _radius;
	_float_2 = _thickness;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, degtorad(_angle_degrees),		
						_sdf_float_1, _radius,
						_sdf_float_2, _thickness	];
						
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
		var sc = [sin(_float_0), cos(_float_0)];
		var ra = _float_1;
		var rb = _float_2;
		p[0] = abs(p[0]);
		var k = (sc[1] * p[0] > sc[0] * p[1]) ? _dot([p[0], p[1]], sc) : _length([p[0], p[1]]);
		return sqrt( _dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	angle_degrees = function(_angle_degrees) {
		_set_float(0, degtorad(_angle_degrees));	
	}
	radius = function(_radius) {
		_set_float(1, _radius);	
	}
	thickness = function(_thickness) {
		_set_float(2, _thickness);	
	}
	
	#endregion	
	
}