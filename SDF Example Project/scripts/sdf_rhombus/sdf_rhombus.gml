function sdf_rhombus(_x, _y, _z, _x_scale, _y_scale, _z_scale, _rounding) {
	return new __sdf_rhombus(_x, _y, _z, _x_scale, _y_scale, _z_scale, _rounding);
}
function __sdf_rhombus(_x, _y, _z, _x_scale, _y_scale, _z_scale, _rounding) : _sdf_shape() constructor {

	#region (Internal)
	
	// Data
	_type = _sdf_rhombus;
	_pos_0 = [_x, _y, _z];
	_scale_0 = [_x_scale, _y_scale, _z_scale];
	_float_0 = _rounding;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_scale_0, _x_scale, _y_scale, _z_scale,	
						_sdf_float_0, _rounding];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_scale_0 = 6;
	_li_float_0 = 10;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_scale_0 = _index_in_batch_data + _li_scale_0 + 1;	
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
	}
	
	// Distance Function
	_get_dist = function(_p) {
		var p = _abs(_sub(_p, _pos_0));
		var la = _scale_0[0];
		var lb = _scale_0[1];
		var h = _scale_0[2];
		var ra = _float_0;
		var b = [la,lb];
		var f = clamp( (_ndot(b,_sub(b, _mul([p[0], p[2]], 2.0))))/_dot(b,b), -1.0, 1.0 );
		var q = [_length(_sub([p[0], p[2]],_mul(_mul(b, 0.5), [1.0-f,1.0+f])))*sign(p[0]*b[1]+p[2]*b[0]-b[0]*b[1])-ra, p[1]-h];
		return min(max(q[0],q[1]),0.0) + _length(_max(q,0.0));
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	scale = function(_x, _y, _z) {
		_set_scale(_x, _y, _z);	
	}
	rounding = function(_amount) {
		_set_float(0, _amount);	
	}
	
	#endregion	
	
}