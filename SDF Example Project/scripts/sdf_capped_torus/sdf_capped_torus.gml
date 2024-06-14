function sdf_capped_torus(_x, _y, _z, _angle_degrees, _radius, _thickness) {
	var _data = [_sdf_type, _sdf_capped_torus, _sdf_pos_0, _x, _y, _z, _sdf_float_0, degtorad(_angle_degrees), _sdf_float_1, _radius, _sdf_float_2, _thickness];
	return new _sdf_shape(_data);
}