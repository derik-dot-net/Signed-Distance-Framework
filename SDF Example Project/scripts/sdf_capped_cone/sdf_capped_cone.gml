function sdf_capped_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2) {
	return new __sdf_capped_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2);
}
function __sdf_capped_cone(_x1, _y1, _z1, _x2, _y2, _z2, _radius_1, _radius_2) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_capped_cone;
	_pos_0 = [_x1, _y1, _z1];
	_pos_1 = [_x2, _y2, _z2];
	_float_0 = _radius_1;
	_float_1 = _radius_2;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x1, _y1,  _z1,
						_sdf_pos_1, _x2, _y2,  _z2,
						_sdf_float_0, _radius_1,		
						_sdf_float_1, _radius_2	];
						
	// Local Indexes
	_li_type =  0;
	_li_pos_0 = 2;
	_li_pos_1 = 6;
	_li_float_0 = 10;
	_li_float_1 = 12;
	
	// Batch Index Updater
	_update_batch_indices = function() {
		_bi_type = _index_in_batch_data + _li_type + 1;
		_bi_pos_0 = _index_in_batch_data + _li_pos_0 + 1;
		_bi_pos_1 = _index_in_batch_data + _li_pos_1 + 1;
		_bi_float_0 = _index_in_batch_data + _li_float_0 + 1;	
		_bi_float_1 = _index_in_batch_data + _li_float_1 + 1;	
	}

	// Distance Function
	_get_dist = function(_p) {
		var p = _p;
		var a = _pos_0;
		var b = _pos_1;
		var ra = _float_0;
		var rb = _float_1;
		var rba  = rb-ra;
		var baba = _dot(_sub(b,a),_sub(b,a));
		var papa = _dot(_sub(p,a),_sub(p,a));
		var paba = _dot(_sub(p,a),_sub(b,a)) / baba;
		var _x = sqrt( papa - paba*paba*baba );
		var cax = max(0.0,_x-((paba<0.5)?ra:rb));
		var cay = abs(paba-0.5)-0.5;
		var k = rba*rba + baba;
		var f = clamp( (rba*(_x-ra)+paba*baba)/k, 0.0, 1.0 );
		var cbx = _x-ra - f*rba;
		var cby = paba - f;
		var s = (cbx < 0.0 && cay < 0.0) ? -1.0 : 1.0;
		return s*sqrt( min(cax*cax + cay*cay*baba,
		                    cbx*cbx + cby*cby*baba) );
	}
	
	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 1), _x, _y, _z);
	}
	radius = function(_index, _radius) {
		_set_float(clamp(_index, 0, 1), _radius);	
	}
	
	#endregion	
	
}