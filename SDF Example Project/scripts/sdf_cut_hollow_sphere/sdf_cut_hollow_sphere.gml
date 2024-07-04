function sdf_cut_hollow_sphere(_x, _y, _z, _radius, _cut_off_amt, _thickness) {
	return new __sdf_cut_hollow_sphere(_x, _y, _z, _radius, _cut_off_amt, _thickness);
}
function __sdf_cut_hollow_sphere(_x, _y, _z, _radius, _cut_off_amt, _thickness) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_cut_hollow_sphere;
	_pos_0 = [_x, _y, _z];
	_float_0 = _radius;
	_float_1 = _cut_off_amt;
	_float_2 = _thickness;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_float_0, _radius,		
						_sdf_float_1, _cut_off_amt,
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
		var r = _float_0;
		var h = _float_1;
		var t = _float_2;
		var w = sqrt(r*r-h*h);
		var q = [_length([p[0], p[2]]), p[1] ];
		return ((h*q[0]<w*q[1]) ? _length(_sub(q, [w,h])) : 
		                        abs(_length(q)-r) ) - t;
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	radius = function(_radius) {
		_set_float(0, _radius);	
	}
	cut_off_amount = function(_cut_off_amount) {
		_set_float(1, _cut_off_amount);	
	}
	thickness = function(_thickness) {
		_set_float(2, _thickness);	
	}
	
	#endregion	
	
}