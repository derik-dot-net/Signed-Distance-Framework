function sdf_cylinder(_x1, _y1, _z1, _x2, _y2, _z2, _radius) {
	return new __sdf_cylinder(_x1, _y1, _z1, _x2, _y2, _z2, _radius);
}
function __sdf_cylinder(_x1, _y1, _z1, _x2, _y2, _z2, _radius) : _sdf_shape() constructor {
	
	#region (Internal)
	
	// Data
	_type = _sdf_cylinder;
	_pos_0 = [_x1, _y1, _z1];
	_pos_1 = [_x2, _y2, _z2];
	_float_0 = _radius;
	_data = [	_sdf_type, _type, 
						_sdf_pos_0, _x1, _y1,  _z1,
						_sdf_pos_1, _x2, _y2,  _z2,
						_sdf_float_0, _radius	];
						
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
		var p = _p;
		var a = _pos_0;
		var b = _pos_1;
		var r = _float_0;
	    var ba = _sub(b, a);
	    var pa = _sub(p, a);
	    var baba = _dot(ba,ba);
	    var paba = _dot(pa,ba);
	    var _x = _length(_sub(_mul(pa, baba), _mul(ba, paba))) - r*baba;
	    var _y = abs(paba-baba*0.5)-baba*0.5;
	    var x2 =_x*_x;
	    var y2 =_y*_y*baba;
	    var d = (max(_x,_y)<0.0)?-min(x2,y2):(((_x>0.0)?x2:0.0)+((_y>0.0)?y2:0.0));
	    return sign(d)*sqrt(abs(d))/baba; 
	}
	 
	#endregion
	#region Functions
	
	position = function(_index, _x, _y, _z,) {
		_set_pos(clamp(_index, 0, 1), _x, _y, _z);
	}
	radius = function(_radius) {
		_set_float(0, _radius);	
	}
	
	#endregion	
	
}