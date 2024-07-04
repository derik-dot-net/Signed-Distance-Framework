function sdf_pyramid(_x, _y, _z, _x_scale, _y_scale, _z_scale) {
	return new __sdf_pyramid(_x, _y, _z, _x_scale, _y_scale, _z_scale);
}
function __sdf_pyramid(_x, _y, _z, _x_scale, _y_scale, _z_scale) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_pyramid;
	_pos_0 = [_x, _y, _z];
	_scale_0 = [_x_scale, _y_scale, _z_scale];
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x, _y,  _z,
						_sdf_scale_0, _x_scale, _y_scale, _z_scale	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_scale_0 = 6;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_scale_0 = _index_in_batch_data + _li_scale_0 + 1;	
	}

	// Distance Function
	_get_dist = function(_p) {
		var position = _sub(_p, _pos_0);
		var halfWidth = _scale_0[0] / 2;
		var halfDepth = _scale_0[1] / 2;
		var halfHeight = _scale_0[2] / 2;
	    position[1] += halfHeight;
		position[0] = abs(position[0]);
		position[2] = abs(position[2]);
	    var d1 = [max(position[0] - halfWidth, 0.0), position[1], max(position[2] - halfDepth, 0.0)];
	    var n1 = [0.0, halfDepth, 2.0 * halfHeight];
	    var k1 = _dot(n1, n1);
	    var h1 = _dot(_sub(position, [halfWidth, 0.0, halfDepth]), n1) / k1;
	    var n2 = [k1, 2.0 * halfHeight * halfWidth, -halfDepth * halfWidth];
	    var m1 = _dot(_sub(position, [halfWidth, 0.0, halfDepth]), n2) / _dot(n2, n2);
	    var d2 = _sub(position, _clamp(_sub(_sub(position, _mul(n1, h1)), _mul(n2, max(m1, 0.0))), [0.0, 0.0, 0.0], [halfWidth, 2.0 * halfHeight, halfDepth]));
	    var n3 = [2.0 * halfHeight, halfWidth, 0.0];
	    var k2 = _dot(n3, n3);
	    var h2 = _dot(_sub(position, [halfWidth, 0.0, halfDepth]), n3) / k2;
	    var n4 = [-halfWidth * halfDepth, 2.0 * halfHeight * halfDepth, k2];
	    var m2 = _dot(_sub(position, [halfWidth, 0.0, halfDepth]), n4) / _dot(n4, n4);    
	    var d3 = _sub(position, _clamp(_sub(position, _mul(_sub(_mul(n3, h2), n4), max(m2, 0.0))), [0.0, 0.0, 0.0], [halfWidth, 2.0 * halfHeight, halfDepth]));
	    var d = sqrt(min(min(_dot(d1, d1), _dot(d2, d2)), _dot(d3, d3)));
	    return max(max(h1, h2), -position[1]) < 0.0 ? -d : d;
	}
	
	#endregion
	#region Functions
	
	position = function(_x, _y, _z) {
		_set_pos(0, _x, _y, _z);
	}
	scale = function(_x, _y, _z) {
		_set_scale(_x, _y, _z);	
	}
	
	#endregion	
	
}